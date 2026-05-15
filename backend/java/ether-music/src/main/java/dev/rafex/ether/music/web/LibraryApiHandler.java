package dev.rafex.ether.music.web;

import java.util.List;
import java.util.Set;

import dev.rafex.ether.http.core.HttpExchange;
import dev.rafex.ether.http.core.Route;
import dev.rafex.ether.http.jetty12.JsonCodec;
import dev.rafex.ether.http.jetty12.ResourceHandler;
import dev.rafex.ether.music.ondemand.MusicLibraryService;

public final class LibraryApiHandler extends ResourceHandler {

    private final MusicLibraryService library;

    public LibraryApiHandler(final JsonCodec jsonCodec, final MusicLibraryService library) {
        super(jsonCodec);
        this.library = library;
    }

    @Override
    protected String basePath() {
        return "/api/library";
    }

    @Override
    protected List<Route> routes() {
        return List.of(Route.of("/songs", supportedMethods()));
    }

    @Override
    public boolean get(final HttpExchange x) {
        final String limitParam = x.queryFirst("limit");
        int limit = 1000;
        if (limitParam != null && !limitParam.isBlank()) {
            try {
                limit = Math.max(1, Math.min(5000, Integer.parseInt(limitParam)));
            } catch (final NumberFormatException ignored) {
                limit = 1000;
            }
        }
        x.json(200, library.listTracks(limit));
        return true;
    }

    @Override
    public Set<String> supportedMethods() {
        return Set.of("GET");
    }
}
