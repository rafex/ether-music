package dev.rafex.ether.music.web;

import dev.rafex.ether.http.jetty12.JettyModule;
import dev.rafex.ether.http.jetty12.JettyModuleContext;
import dev.rafex.ether.http.jetty12.JettyRouteRegistry;
import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.melody.MelodyGenerator;

public final class MusicModule implements JettyModule {

    private final FrontendRenderer renderer;
    private final MelodyGenerator melodyGenerator;
    private final SongRepository repository;

    public MusicModule(final FrontendRenderer renderer, final MelodyGenerator melodyGenerator) {
        this(renderer, melodyGenerator, null);
    }

    public MusicModule(final FrontendRenderer renderer, final MelodyGenerator melodyGenerator,
            final SongRepository repository) {
        this.renderer = renderer;
        this.melodyGenerator = melodyGenerator;
        this.repository = repository;
    }

    @Override
    public void registerRoutes(final JettyRouteRegistry routes, final JettyModuleContext context) {
        routes.add("/", new HomePageHandler(renderer));
        routes.add("/api/melodies/*", new MelodyApiHandler(context.jsonCodec(), melodyGenerator, repository));
        routes.add("/api/express/*", new ExpressApiHandler(context.jsonCodec(), melodyGenerator, repository));
        routes.add("/api/data/*", new DataApiHandler(context.jsonCodec(), melodyGenerator, repository));

        if (repository != null) {
            final var songsHandler = new SongsApiHandler(context.jsonCodec(), repository);
            routes.add("/api/songs", songsHandler);
            routes.add("/api/songs/*", songsHandler);
        }
    }
}
