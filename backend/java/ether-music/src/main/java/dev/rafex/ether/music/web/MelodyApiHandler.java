package dev.rafex.ether.music.web;

import java.util.List;
import java.util.Set;

import dev.rafex.ether.http.core.HttpExchange;
import dev.rafex.ether.http.core.Route;
import dev.rafex.ether.http.jetty12.JsonCodec;
import dev.rafex.ether.http.jetty12.ResourceHandler;
import dev.rafex.ether.music.melody.MelodyGenerator;
import dev.rafex.ether.music.melody.MelodyRequest;

public final class MelodyApiHandler extends ResourceHandler {

    private final MelodyGenerator melodyGenerator;

    public MelodyApiHandler(final JsonCodec jsonCodec, final MelodyGenerator melodyGenerator) {
        super(jsonCodec);
        this.melodyGenerator = melodyGenerator;
    }

    @Override
    protected String basePath() {
        return "/api/melodies";
    }

    @Override
    protected List<Route> routes() {
        return List.of(Route.of("/generate", supportedMethods()));
    }

    @Override
    public boolean get(final HttpExchange x) {
        final var request = new MelodyRequest(
                valueOrDefault(x.queryFirst("root"), "C"),
                valueOrDefault(x.queryFirst("scale"), "minor"),
                parseInt(x.queryFirst("octave"), 4),
                parseInt(x.queryFirst("steps"), 16));
        x.json(200, melodyGenerator.generate(request));
        return true;
    }

    @Override
    public Set<String> supportedMethods() {
        return Set.of("GET");
    }

    private static String valueOrDefault(final String value, final String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }

    private static int parseInt(final String value, final int fallback) {
        if (value == null || value.isBlank()) {
            return fallback;
        }
        try {
            return Integer.parseInt(value);
        } catch (final NumberFormatException ignored) {
            return fallback;
        }
    }
}
