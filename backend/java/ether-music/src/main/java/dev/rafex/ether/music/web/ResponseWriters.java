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

    static void js(final Response response, final Callback callback, final int status, final String body) {
        write(response, callback, status, "text/javascript; charset=utf-8", body);
    }

    static void plainJson(final Response response, final Callback callback, final int status, final String body) {
        write(response, callback, status, "application/json; charset=utf-8", body);
    }

    static void svgIcon(final Response response, final Callback callback, final int status, final String body) {
        response.getHeaders().put("cache-control", "public, max-age=86400");
        write(response, callback, status, "image/svg+xml", body);
    }

    static void bytes(final Response response, final Callback callback, final int status,
            final String contentType, final byte[] body) {
        response.setStatus(status);
        response.getHeaders().put("content-type", contentType);
        response.getHeaders().put("cache-control", "public, max-age=86400");
        response.write(true, ByteBuffer.wrap(body == null ? new byte[0] : body), callback);
    }

    private static void write(final Response response, final Callback callback, final int status,
            final String contentType, final String body) {
        response.setStatus(status);
        response.getHeaders().put("content-type", contentType);
        final var bytes = (body == null ? "" : body).getBytes(StandardCharsets.UTF_8);
        response.write(true, ByteBuffer.wrap(bytes), callback);
    }
}
