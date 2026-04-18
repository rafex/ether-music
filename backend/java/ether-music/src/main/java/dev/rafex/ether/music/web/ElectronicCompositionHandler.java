package dev.rafex.ether.music.web;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.eclipse.jetty.io.Content;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.music.ai.ElectronicCompositionService;
import dev.rafex.ether.music.melody.ComposedResponse;

public final class ElectronicCompositionHandler extends Handler.Abstract {

    private final ElectronicCompositionService service;
    private final ObjectMapper mapper;

    public ElectronicCompositionHandler(final ElectronicCompositionService service) {
        this.service = service;
        this.mapper = new ObjectMapper();
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) throws Exception {
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            return false;
        }

        final String path = request.getHttpURI().getPath();
        final String sourceType;
        if (path.endsWith("/code")) {
            sourceType = "code";
        } else if (path.endsWith("/text")) {
            sourceType = "text";
        } else if (path.endsWith("/words")) {
            sourceType = "words";
        } else {
            return false;
        }

        final String body = Content.Source.asString(request, StandardCharsets.UTF_8);
        if (body == null || body.isBlank()) {
            ResponseWriters.plainJson(response, callback, 400, "{\"error\":\"body vacío\"}");
            return true;
        }

        try {
            final ComposedResponse composed = switch (sourceType) {
                case "code" -> service.composeFromCode(body);
                case "words" -> service.composeFromWords(body);
                default -> service.composeFromText(body);
            };
            ResponseWriters.plainJson(response, callback, 200, mapper.writeValueAsString(composed));
        } catch (final IOException | InterruptedException e) {
            ResponseWriters.plainJson(response, callback, 502,
                    "{\"error\":\"LLM no disponible: " + e.getMessage().replace("\"", "'") + "\"}");
        } catch (final Exception e) {
            ResponseWriters.plainJson(response, callback, 500,
                    "{\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
        return true;
    }
}
