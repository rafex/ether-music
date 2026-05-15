package dev.rafex.ether.music.web;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.frontend.HomePageModel;
import dev.rafex.ether.music.ondemand.MusicLibraryService;

public final class PlayerPageHandler extends Handler.Abstract {

    private final FrontendRenderer renderer;
    private final MusicLibraryService library;

    public PlayerPageHandler(final FrontendRenderer renderer, final MusicLibraryService library) {
        this.renderer = renderer;
        this.library = library;
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            return false;
        }
        final var model = new HomePageModel("Ether Music - Player", library.rootDirectoryText());
        ResponseWriters.html(response, callback, 200, renderer.renderPlayer(model));
        return true;
    }
}
