package dev.rafex.ether.music.radio;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public final class MpdClient {

    private static final String OK_PREFIX = "OK MPD";
    private final String host;
    private final int port;
    private final Duration connectTimeout;

    public MpdClient(final String host, final int port, final Duration connectTimeout) {
        this.host = host;
        this.port = port;
        this.connectTimeout = connectTimeout;
    }

    public RadioState readState(final int playlistLimit) {
        try {
            final var status = executeSingleMap("status");
            final var current = executeSingleMap("currentsong");
            final var playlist = executePlaylist("playlistinfo");
            final var nowPlaying = toTrack(current);
            final var cappedPlaylist = capPlaylist(playlist, playlistLimit);
            return new RadioState(
                    true,
                    "MPD conectado",
                    status.getOrDefault("state", "stop"),
                    parseInt(status.get("volume"), 0),
                    formatSeconds(status.get("elapsed")),
                    formatDuration(status.get("duration"), current.get("Time")),
                    nowPlaying,
                    cappedPlaylist);
        } catch (final Exception e) {
            return new RadioState(
                    false,
                    "MPD no disponible: " + e.getMessage(),
                    "stop",
                    0,
                    "00:00",
                    "00:00",
                    new RadioTrack("Sin conexión", "MPD", "", "", "00:00"),
                    List.of());
        }
    }

    public void play() throws IOException {
        executeNoContent("play");
    }

    public void pauseToggle() throws IOException {
        executeNoContent("pause");
    }

    public void next() throws IOException {
        executeNoContent("next");
    }

    public void previous() throws IOException {
        executeNoContent("previous");
    }

    public void setVolume(final int value) throws IOException {
        final int volume = Math.max(0, Math.min(100, value));
        executeNoContent("setvol " + volume);
    }

    private Map<String, String> executeSingleMap(final String command) throws IOException {
        try (var conn = connect()) {
            writeCommand(conn.writer(), command);
            return readKeyValues(conn.reader());
        }
    }

    private List<RadioTrack> executePlaylist(final String command) throws IOException {
        try (var conn = connect()) {
            writeCommand(conn.writer(), command);
            return readPlaylist(conn.reader());
        }
    }

    private void executeNoContent(final String command) throws IOException {
        try (var conn = connect()) {
            writeCommand(conn.writer(), command);
            readUntilOk(conn.reader());
        }
    }

    private Connection connect() throws IOException {
        final var socket = new Socket();
        socket.connect(new InetSocketAddress(host, port), (int) connectTimeout.toMillis());
        socket.setSoTimeout((int) connectTimeout.toMillis());
        final var reader = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));
        final var writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), StandardCharsets.UTF_8));
        final var hello = reader.readLine();
        if (hello == null || !hello.startsWith(OK_PREFIX)) {
            socket.close();
            throw new IOException("handshake MPD inválido");
        }
        return new Connection(socket, reader, writer);
    }

    private static void writeCommand(final BufferedWriter writer, final String command) throws IOException {
        writer.write(command);
        writer.write('\n');
        writer.flush();
    }

    private static Map<String, String> readKeyValues(final BufferedReader reader) throws IOException {
        final var result = new HashMap<String, String>();
        String line;
        while ((line = reader.readLine()) != null) {
            if ("OK".equals(line)) {
                break;
            }
            if (line.startsWith("ACK")) {
                throw new IOException(line);
            }
            final int idx = line.indexOf(':');
            if (idx > 0 && idx < line.length() - 1) {
                result.put(line.substring(0, idx).trim(), line.substring(idx + 1).trim());
            }
        }
        return result;
    }

    private static List<RadioTrack> readPlaylist(final BufferedReader reader) throws IOException {
        final var tracks = new ArrayList<RadioTrack>();
        final var current = new HashMap<String, String>();
        String line;
        while ((line = reader.readLine()) != null) {
            if ("OK".equals(line)) {
                if (!current.isEmpty()) {
                    tracks.add(toTrack(current));
                }
                break;
            }
            if (line.startsWith("ACK")) {
                throw new IOException(line);
            }
            final int idx = line.indexOf(':');
            if (idx <= 0 || idx >= line.length() - 1) {
                continue;
            }
            final String key = line.substring(0, idx).trim();
            final String value = line.substring(idx + 1).trim();
            if ("file".equals(key) && !current.isEmpty()) {
                tracks.add(toTrack(current));
                current.clear();
            }
            current.put(key, value);
        }
        return tracks;
    }

    private static void readUntilOk(final BufferedReader reader) throws IOException {
        String line;
        while ((line = reader.readLine()) != null) {
            if ("OK".equals(line)) {
                return;
            }
            if (line.startsWith("ACK")) {
                throw new IOException(line);
            }
        }
    }

    private static List<RadioTrack> capPlaylist(final List<RadioTrack> source, final int limit) {
        if (source.size() <= limit) {
            return source;
        }
        return source.subList(0, limit);
    }

    private static RadioTrack toTrack(final Map<String, String> raw) {
        final String fallbackFile = raw.getOrDefault("file", "desconocido");
        final String fallbackTitle = fallbackFile.contains("/")
                ? fallbackFile.substring(fallbackFile.lastIndexOf('/') + 1)
                : fallbackFile;
        return new RadioTrack(
                raw.getOrDefault("Title", fallbackTitle),
                raw.getOrDefault("Artist", "Unknown Artist"),
                raw.getOrDefault("Album", ""),
                fallbackFile,
                formatDuration(raw.get("duration"), raw.get("Time")));
    }

    private static String formatDuration(final String duration, final String fallbackSeconds) {
        if (duration != null && !duration.isBlank()) {
            return formatSeconds(duration);
        }
        if (fallbackSeconds != null && !fallbackSeconds.isBlank()) {
            return formatSeconds(fallbackSeconds);
        }
        return "00:00";
    }

    private static String formatSeconds(final String raw) {
        if (raw == null || raw.isBlank()) {
            return "00:00";
        }
        final double parsed = Double.parseDouble(raw);
        final int total = (int) Math.max(0, Math.round(parsed));
        final int minutes = total / 60;
        final int seconds = total % 60;
        return String.format(Locale.ROOT, "%02d:%02d", minutes, seconds);
    }

    private static int parseInt(final String raw, final int fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        return Integer.parseInt(raw);
    }

    private record Connection(Socket socket, BufferedReader reader, BufferedWriter writer) implements AutoCloseable {
        @Override
        public void close() throws IOException {
            socket.close();
        }
    }
}
