package dev.rafex.ether.music.web;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.frontend.HomePageModel;

public final class FeedbackPageHandler extends Handler.Abstract {

    private final FrontendRenderer renderer;

    public FeedbackPageHandler(final FrontendRenderer renderer) {
        this.renderer = renderer;
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) {
        if (!"GET".equalsIgnoreCase(request.getMethod())) return false;
        final var model = new HomePageModel("Ether Music — Feedback en Vivo", "");
        ResponseWriters.html(response, callback, 200, renderer.renderFeedback(model));
        return true;
    }
}
