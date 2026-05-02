package dev.rafex.ether.music.web;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.eclipse.jetty.io.Content;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.melody.CodeMapper;
import dev.rafex.ether.music.melody.CodeSessionRequest;
import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.melody.MelodyGenerator;

public final class FeedbackApiHandler extends Handler.Abstract {

    private final MelodyGenerator generator;
    private final SongRepository repository;
    private final CodeMapper codeMapper = new CodeMapper();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public FeedbackApiHandler(final MelodyGenerator generator, final SongRepository repository) {
        this.generator = generator;
        this.repository = repository;
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) throws Exception {
        if (!"POST".equalsIgnoreCase(request.getMethod())) return false;

        final String body = Content.Source.asString(request, StandardCharsets.UTF_8);

        final CodeSessionRequest req;
        try {
            req = (body == null || body.isBlank())
                    ? new CodeSessionRequest(60, 0, 10, 0)
                    : objectMapper.readValue(body, CodeSessionRequest.class);
        } catch (final IOException e) {
            ResponseWriters.plainJson(response, callback, 400,
                    "{\"error\":\"JSON inválido: " + e.getMessage().replace("\"", "'") + "\"}");
            return true;
        }

        final var mapping = codeMapper.map(req);
        final var melody = generator.generate(mapping.request());
        final var composed = ComposedResponse.from("feedback", mapping.interpretation(), mapping.bpm(), melody);

        ResponseWriters.plainJson(response, callback, 200, objectMapper.writeValueAsString(composed));
        return true;
    }
}
