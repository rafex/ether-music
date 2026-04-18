package dev.rafex.ether.music.web;

import java.nio.charset.StandardCharsets;

import org.eclipse.jetty.io.Content;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.music.synth.ServerSynthesizer;
import dev.rafex.ether.music.synth.SynthRequest;

public final class SynthesizeHandler extends Handler.Abstract {

    private final ObjectMapper mapper;

    public SynthesizeHandler() {
        this.mapper = new ObjectMapper();
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) throws Exception {
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            return false;
        }

        final String body = Content.Source.asString(request, StandardCharsets.UTF_8);
        if (body == null || body.isBlank()) {
            ResponseWriters.plainJson(response, callback, 400, "{\"error\":\"body vacío\"}");
            return true;
        }

        try {
            final SynthRequest synthRequest = mapper.readValue(body, SynthRequest.class);
            final byte[] wav = ServerSynthesizer.synthesize(synthRequest);
            response.getHeaders().put("content-disposition", "attachment; filename=\"ether-music.wav\"");
            ResponseWriters.bytes(response, callback, 200, "audio/wav", wav);
        } catch (final Exception e) {
            ResponseWriters.plainJson(response, callback, 500,
                    "{\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
        return true;
    }
}
