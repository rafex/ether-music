package dev.rafex.ether.music.web;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.frontend.HomePageModel;
import dev.rafex.ether.music.radio.RadioService;

public final class RadioPageHandler extends Handler.Abstract {

    private final FrontendRenderer renderer;
    private final RadioService radioService;

    public RadioPageHandler(final FrontendRenderer renderer, final RadioService radioService) {
        this.renderer = renderer;
        this.radioService = radioService;
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            return false;
        }
        final var model = new HomePageModel("Ether Music - Radio", radioService.icecastStreamUrl());
        ResponseWriters.html(response, callback, 200, renderer.renderRadio(model));
        return true;
    }
}
