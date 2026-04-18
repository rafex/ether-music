package dev.rafex.ether.music.web;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.synth.ServerSynthesizer;
import dev.rafex.ether.music.synth.SynthRequest;

public final class SongWavHandler extends Handler.Abstract {

    private final SongRepository repository;

    public SongWavHandler(final SongRepository repository) {
        this.repository = repository;
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) throws Exception {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            return false;
        }

        final String path = request.getHttpURI().getPath();
        // Extraer id de /api/songs-wav/{id}
        final String[] parts = path.split("/");
        if (parts.length < 4) {
            ResponseWriters.plainJson(response, callback, 400, "{\"error\":\"id requerido\"}");
            return true;
        }

        final long id;
        try {
            id = Long.parseLong(parts[3]);
        } catch (final NumberFormatException e) {
            ResponseWriters.plainJson(response, callback, 400, "{\"error\":\"id inválido\"}");
            return true;
        }

        final var result = repository.findById(id);
        if (result.isEmpty()) {
            ResponseWriters.plainJson(response, callback, 404, "{\"error\":\"canción no encontrada\"}");
            return true;
        }

        final ComposedResponse song = result.get();
        final var synthReq = new SynthRequest(
                song.melody(),
                song.bpm(),
                "fm",
                0.35,
                0.25,
                0.8);

        final byte[] wav = ServerSynthesizer.synthesize(synthReq);
        final String filename = "ether-" + id + ".wav";
        response.getHeaders().put("content-disposition", "attachment; filename=\"" + filename + "\"");
        ResponseWriters.bytes(response, callback, 200, "audio/wav", wav);
        return true;
    }
}
