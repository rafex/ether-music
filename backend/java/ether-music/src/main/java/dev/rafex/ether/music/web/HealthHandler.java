package dev.rafex.ether.music.web;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

public final class HealthHandler extends Handler.Abstract {

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            return false;
        }
        ResponseWriters.plainJson(response, callback, 200, "{\"status\":\"ok\"}");
        return true;
    }
}
