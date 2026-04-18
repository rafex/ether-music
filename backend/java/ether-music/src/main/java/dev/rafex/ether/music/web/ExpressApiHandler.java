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
import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.melody.ExpressMapper;
import dev.rafex.ether.music.melody.ExpressRequest;
import dev.rafex.ether.music.melody.MelodyGenerator;

public final class ExpressApiHandler extends ResourceHandler {

    private final MelodyGenerator generator;
    private final SongRepository repository;
    private final ExpressMapper mapper = new ExpressMapper();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public ExpressApiHandler(final JsonCodec jsonCodec, final MelodyGenerator generator,
            final SongRepository repository) {
        super(jsonCodec);
        this.generator = generator;
        this.repository = repository;
    }

    @Override
    protected String basePath() {
        return "/api/express";
    }

    @Override
    protected List<Route> routes() {
        return List.of(Route.of("/create", supportedMethods()));
    }

    @Override
    public boolean post(final HttpExchange x) throws Exception {
        final String body = readBody(x);
        final ExpressRequest req;
        try {
            req = body.isBlank()
                    ? new ExpressRequest(null, null, null, null)
                    : objectMapper.readValue(body, ExpressRequest.class);
        } catch (final IOException e) {
            x.text(400, "JSON inválido: " + e.getMessage());
            return true;
        }
        final var mapping = mapper.map(req);
        final var melody = generator.generate(mapping.request());
        final var response = ComposedResponse.from("express", mapping.interpretation(), mapping.bpm(), melody);
        if (repository != null) {
            repository.save(response);
        }
        x.json(200, response);
        return true;
    }

    @Override
    public Set<String> supportedMethods() {
        return Set.of("POST");
    }

    private static String readBody(final HttpExchange x) throws IOException {
        if (x instanceof final JettyHttpExchange jex) {
            return Content.Source.asString(jex.request(), StandardCharsets.UTF_8);
        }
        return "";
    }
}
