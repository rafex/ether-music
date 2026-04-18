package dev.rafex.ether.music.web;

import java.util.List;
import java.util.Set;

import dev.rafex.ether.http.core.HttpExchange;
import dev.rafex.ether.http.core.Route;
import dev.rafex.ether.http.jetty12.JsonCodec;
import dev.rafex.ether.http.jetty12.ResourceHandler;
import dev.rafex.ether.music.db.SongRepository;

public final class SongsApiHandler extends ResourceHandler {

    private final SongRepository repository;

    public SongsApiHandler(final JsonCodec jsonCodec, final SongRepository repository) {
        super(jsonCodec);
        this.repository = repository;
    }

    @Override
    protected String basePath() {
        return "/api/songs";
    }

    @Override
    protected List<Route> routes() {
        return List.of(
                Route.of("", supportedMethods()),
                Route.of("/{id}", supportedMethods()));
    }

    @Override
    public boolean get(final HttpExchange x) {
        final var path = x.path();
        if (path.equals("/api/songs") || path.equals("/api/songs/")) {
            x.json(200, repository.findAll());
            return true;
        }
        final var idParam = x.pathParam("id");
        if (idParam == null || idParam.isBlank()) {
            x.text(400, "id requerido");
            return true;
        }
        final long id;
        try {
            id = Long.parseLong(idParam);
        } catch (final NumberFormatException e) {
            x.text(400, "id inválido");
            return true;
        }
        final var result = repository.findById(id);
        if (result.isEmpty()) {
            x.text(404, "canción no encontrada");
            return true;
        }
        x.json(200, result.get());
        return true;
    }

    @Override
    public boolean delete(final HttpExchange x) {
        final var idParam = x.pathParam("id");
        if (idParam == null || idParam.isBlank()) {
            x.text(400, "id requerido");
            return true;
        }
        final long id;
        try {
            id = Long.parseLong(idParam);
        } catch (final NumberFormatException e) {
            x.text(400, "id inválido");
            return true;
        }
        final boolean deleted = repository.delete(id);
        x.text(deleted ? 204 : 404, deleted ? "" : "canción no encontrada");
        return true;
    }

    @Override
    public Set<String> supportedMethods() {
        return Set.of("GET", "DELETE");
    }
}
