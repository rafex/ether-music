package dev.rafex.ether.music.web;

import dev.rafex.ether.http.jetty12.JettyModule;
import dev.rafex.ether.http.jetty12.JettyModuleContext;
import dev.rafex.ether.http.jetty12.JettyRouteRegistry;
import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.melody.MelodyGenerator;

public final class MusicModule implements JettyModule {

    private final FrontendRenderer renderer;
    private final MelodyGenerator melodyGenerator;

    public MusicModule(final FrontendRenderer renderer, final MelodyGenerator melodyGenerator) {
        this.renderer = renderer;
        this.melodyGenerator = melodyGenerator;
    }

    @Override
    public void registerRoutes(final JettyRouteRegistry routes, final JettyModuleContext context) {
        routes.add("/", new HomePageHandler(renderer));
        routes.add("/api/melodies/*", new MelodyApiHandler(context.jsonCodec(), melodyGenerator));
    }
}
