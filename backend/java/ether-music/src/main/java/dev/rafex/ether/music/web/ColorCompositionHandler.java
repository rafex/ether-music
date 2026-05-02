package dev.rafex.ether.music.web;

import java.nio.charset.StandardCharsets;

import org.eclipse.jetty.io.Content;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.melody.ColorMusicMapper;
import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.melody.MelodyGenerator;

public final class ColorCompositionHandler extends Handler.Abstract {

    private final MelodyGenerator generator;
    private final SongRepository repository;
    private final ColorMusicMapper mapper = new ColorMusicMapper();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public ColorCompositionHandler(final MelodyGenerator generator, final SongRepository repository) {
        this.generator = generator;
        this.repository = repository;
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) throws Exception {
        if (!"POST".equalsIgnoreCase(request.getMethod())) return false;

        final String body = Content.Source.asString(request, StandardCharsets.UTF_8);
        if (body == null || body.isBlank()) {
            ResponseWriters.plainJson(response, callback, 400, "{\"error\":\"body vacío\"}");
            return true;
        }

        final var mapping = mapper.map(body.trim());
        final var melody = generator.generate(mapping.request());
        final var composed = ComposedResponse.from("color", mapping.interpretation(), mapping.bpm(), melody);

        if (repository != null) {
            try { repository.save(composed); } catch (Exception ignored) { }
        }

        ResponseWriters.plainJson(response, callback, 200, objectMapper.writeValueAsString(composed));
        return true;
    }
}
