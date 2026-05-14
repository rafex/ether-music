package dev.rafex.ether.music.web;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.jetty.io.Content;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import dev.rafex.ether.music.radio.RadioHtmlRenderer;
import dev.rafex.ether.music.radio.RadioService;

public final class RadioApiHandler extends Handler.Abstract {

    private final RadioService radioService;
    private final RadioHtmlRenderer htmlRenderer;

    public RadioApiHandler(final RadioService radioService) {
        this.radioService = radioService;
        this.htmlRenderer = new RadioHtmlRenderer();
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) throws Exception {
        final var path = request.getHttpURI().getPath();
        final var method = request.getMethod();

        if ("GET".equalsIgnoreCase(method) && path.endsWith("/status")) {
            final var state = radioService.readState();
            ResponseWriters.html(response, callback, 200, htmlRenderer.renderStatusFragment(state));
            return true;
        }
        if ("GET".equalsIgnoreCase(method) && path.endsWith("/playlist")) {
            final var state = radioService.readState();
            ResponseWriters.html(response, callback, 200, htmlRenderer.renderPlaylistFragment(state));
            return true;
        }
        if ("POST".equalsIgnoreCase(method) && path.endsWith("/control")) {
            final var params = parseForm(Content.Source.asString(request, StandardCharsets.UTF_8));
            final var action = params.getOrDefault("action", "");
            try {
                executeAction(action, params);
                final var state = radioService.readState();
                ResponseWriters.html(response, callback, 200, htmlRenderer.renderStatusFragment(state));
            } catch (final Exception e) {
                ResponseWriters.html(response, callback, 500,
                        "<section id=\"radio-status\" class=\"player-shell\"><p>Control error: "
                                + escape(e.getMessage())
                                + "</p></section>");
            }
            return true;
        }

        return false;
    }

    private void executeAction(final String action, final Map<String, String> params) throws Exception {
        switch (action) {
            case "play" -> radioService.play();
            case "pause" -> radioService.pauseToggle();
            case "next" -> radioService.next();
            case "prev" -> radioService.previous();
            case "volume" -> {
                final int value = Integer.parseInt(params.getOrDefault("value", "50"));
                radioService.setVolume(value);
            }
            default -> throw new IllegalArgumentException("accion no soportada");
        }
    }

    private static Map<String, String> parseForm(final String body) {
        final var result = new HashMap<String, String>();
        if (body == null || body.isBlank()) {
            return result;
        }
        final var parts = body.split("&");
        for (final var pair : parts) {
            final int idx = pair.indexOf('=');
            if (idx <= 0) {
                continue;
            }
            final var key = decode(pair.substring(0, idx));
            final var value = decode(pair.substring(idx + 1));
            result.put(key, value);
        }
        return result;
    }

    private static String decode(final String value) {
        return URLDecoder.decode(value, StandardCharsets.UTF_8);
    }

    private static String escape(final String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
