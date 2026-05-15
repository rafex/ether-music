package dev.rafex.ether.music.web;

import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.file.Path;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Response;
import org.eclipse.jetty.util.Callback;

import dev.rafex.ether.music.ondemand.MusicLibraryService;

public final class OnDemandStreamHandler extends Handler.Abstract {

    private final MusicLibraryService library;

    public OnDemandStreamHandler(final MusicLibraryService library) {
        this.library = library;
    }

    @Override
    public boolean handle(final Request request, final Response response, final Callback callback) throws Exception {
        if (!"GET".equalsIgnoreCase(request.getMethod()) && !"HEAD".equalsIgnoreCase(request.getMethod())) {
            return false;
        }

        final String path = request.getHttpURI().getPath();
        final String prefix = "/api/stream/";
        if (!path.startsWith(prefix) || path.length() <= prefix.length()) {
            ResponseWriters.plainJson(response, callback, 400, "{\"error\":\"id requerido\"}");
            return true;
        }

        final String encodedId = path.substring(prefix.length());
        final var resolved = library.resolveById(encodedId);
        if (resolved.isEmpty()) {
            ResponseWriters.plainJson(response, callback, 404, "{\"error\":\"track no encontrado\"}");
            return true;
        }

        final Path track = resolved.get();
        final long fileSize = java.nio.file.Files.size(track);
        if (fileSize <= 0) {
            ResponseWriters.plainJson(response, callback, 404, "{\"error\":\"archivo vacio\"}");
            return true;
        }

        final String extension = extension(track.toString());
        final String mimeType = mime(extension);
        response.getHeaders().put("accept-ranges", "bytes");
        response.getHeaders().put("content-type", mimeType);
        response.getHeaders().put("cache-control", "no-cache");

        final String range = request.getHeaders().get("range");
        long start = 0;
        long end = fileSize - 1;
        int status = 200;

        if (range != null && range.startsWith("bytes=")) {
            try {
                final String spec = range.substring("bytes=".length()).trim();
                final int dash = spec.indexOf('-');
                if (dash > -1) {
                    final String rawStart = spec.substring(0, dash).trim();
                    final String rawEnd = spec.substring(dash + 1).trim();
                    if (!rawStart.isEmpty()) {
                        start = Long.parseLong(rawStart);
                    }
                    if (!rawEnd.isEmpty()) {
                        end = Long.parseLong(rawEnd);
                    }
                    if (rawStart.isEmpty() && !rawEnd.isEmpty()) {
                        final long suffix = Long.parseLong(rawEnd);
                        start = Math.max(0, fileSize - suffix);
                        end = fileSize - 1;
                    }
                }
            } catch (final NumberFormatException ex) {
                response.setStatus(416);
                response.getHeaders().put("content-range", "bytes */" + fileSize);
                callback.succeeded();
                return true;
            }
            if (start < 0 || end < start || start >= fileSize) {
                response.setStatus(416);
                response.getHeaders().put("content-range", "bytes */" + fileSize);
                callback.succeeded();
                return true;
            }
            end = Math.min(end, fileSize - 1);
            status = 206;
        }

        final long contentLength = end - start + 1;
        response.setStatus(status);
        response.getHeaders().put("content-length", String.valueOf(contentLength));
        if (status == 206) {
            response.getHeaders().put("content-range", "bytes " + start + "-" + end + "/" + fileSize);
        }
        if ("HEAD".equalsIgnoreCase(request.getMethod())) {
            callback.succeeded();
            return true;
        }

        if (contentLength > Integer.MAX_VALUE) {
            ResponseWriters.plainJson(response, callback, 413, "{\"error\":\"rango demasiado grande\"}");
            return true;
        }
        final byte[] data = new byte[(int) contentLength];
        try (RandomAccessFile raf = new RandomAccessFile(track.toFile(), "r")) {
            raf.seek(start);
            raf.readFully(data);
        }
        response.write(true, ByteBuffer.wrap(data), callback);
        return true;
    }

    private static String extension(final String name) {
        final int dot = name.lastIndexOf('.');
        if (dot < 0 || dot == name.length() - 1) {
            return "";
        }
        return name.substring(dot + 1).toLowerCase();
    }

    private static String mime(final String ext) {
        return switch (ext) {
            case "mp3" -> "audio/mpeg";
            case "ogg", "oga" -> "audio/ogg";
            case "flac" -> "audio/flac";
            case "wav" -> "audio/wav";
            case "m4a" -> "audio/mp4";
            case "aac" -> "audio/aac";
            default -> "application/octet-stream";
        };
    }
}
