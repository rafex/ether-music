package dev.rafex.ether.music.web;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Set;

import org.eclipse.jetty.io.Content;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.http.core.HttpExchange;
import dev.rafex.ether.http.core.Route;
import dev.rafex.ether.http.jetty12.JettyHttpExchange;
import dev.rafex.ether.http.jetty12.JsonCodec;
import dev.rafex.ether.http.jetty12.ResourceHandler;
import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.melody.CodeMapper;
import dev.rafex.ether.music.melody.CodeSessionRequest;
import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.melody.MelodyGenerator;
import dev.rafex.ether.music.melody.WordsMapper;
import dev.rafex.ether.music.melody.WordsRequest;

public final class DataApiHandler extends ResourceHandler {

    private final MelodyGenerator generator;
    private final SongRepository repository;
    private final WordsMapper wordsMapper = new WordsMapper();
    private final CodeMapper codeMapper = new CodeMapper();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public DataApiHandler(final JsonCodec jsonCodec, final MelodyGenerator generator,
            final SongRepository repository) {
        super(jsonCodec);
        this.generator = generator;
        this.repository = repository;
    }

    @Override
    protected String basePath() {
        return "/api/data";
    }

    @Override
    protected List<Route> routes() {
        return List.of(
                Route.of("/words", supportedMethods()),
                Route.of("/code", supportedMethods()));
    }

    @Override
    public boolean post(final HttpExchange x) throws Exception {
        final String body = readBody(x);
        if (x.path().endsWith("/words")) {
            return handleWords(x, body);
        }
        if (x.path().endsWith("/code")) {
            return handleCode(x, body);
        }
        return false;
    }

    @Override
    public Set<String> supportedMethods() {
        return Set.of("POST");
    }

    private boolean handleWords(final HttpExchange x, final String body) throws IOException {
        final WordsRequest req;
        try {
            req = body.isBlank()
                    ? new WordsRequest(List.of())
                    : objectMapper.readValue(body, WordsRequest.class);
        } catch (final IOException e) {
            x.text(400, "JSON inválido: " + e.getMessage());
            return true;
        }
        final var mapping = wordsMapper.map(req);
        final var melody = generator.generate(mapping.request());
        final var response = ComposedResponse.from("words", mapping.interpretation(), mapping.bpm(), melody);
        if (repository != null) {
            repository.save(response);
        }
        x.json(200, response);
        return true;
    }

    private boolean handleCode(final HttpExchange x, final String body) throws IOException {
        final CodeSessionRequest req;
        try {
            req = body.isBlank()
                    ? new CodeSessionRequest(60, 0, 10, 0)
                    : objectMapper.readValue(body, CodeSessionRequest.class);
        } catch (final IOException e) {
            x.text(400, "JSON inválido: " + e.getMessage());
            return true;
        }
        final var mapping = codeMapper.map(req);
        final var melody = generator.generate(mapping.request());
        final var response = ComposedResponse.from("code", mapping.interpretation(), mapping.bpm(), melody);
        if (repository != null) {
            repository.save(response);
        }
        x.json(200, response);
        return true;
    }

    private static String readBody(final HttpExchange x) throws IOException {
        if (x instanceof final JettyHttpExchange jex) {
            return Content.Source.asString(jex.request(), StandardCharsets.UTF_8);
        }
        return "";
    }
}
