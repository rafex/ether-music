package dev.rafex.ether.music.web;

import java.nio.charset.StandardCharsets;

import org.eclipse.jetty.io.Content;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.melody.GraphicMusicMapper;
import dev.rafex.ether.music.melody.GraphicMusicMapper.GraphicInput;

public final class GraphicCompositionHandler extends Handler.Abstract {

    private final SongRepository repository;
    private final GraphicMusicMapper mapper = new GraphicMusicMapper();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public GraphicCompositionHandler(final SongRepository repository) {
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

        try {
            final var input = objectMapper.readValue(body, GraphicInput.class);
            final var composed = mapper.map(input);

            if (repository != null) {
                try { repository.save(composed); } catch (Exception ignored) { }
            }

            ResponseWriters.plainJson(response, callback, 200, objectMapper.writeValueAsString(composed));
        } catch (final Exception e) {
            ResponseWriters.plainJson(response, callback, 400,
                    "{\"error\":\"JSON inválido: " + e.getMessage().replace("\"", "'") + "\"}");
        }
        return true;
    }
}
