package dev.rafex.ether.music.web;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;

import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

final class ResponseWriters {

    private ResponseWriters() {
    }

    static void html(final Response response, final Callback callback, final int status, final String body) {
        write(response, callback, status, "text/html; charset=utf-8", body);
    }

    private static void write(final Response response, final Callback callback, final int status,
            final String contentType, final String body) {
        response.setStatus(status);
        response.getHeaders().put("content-type", contentType);
        final var bytes = (body == null ? "" : body).getBytes(StandardCharsets.UTF_8);
        response.write(true, ByteBuffer.wrap(bytes), callback);
    }
}
