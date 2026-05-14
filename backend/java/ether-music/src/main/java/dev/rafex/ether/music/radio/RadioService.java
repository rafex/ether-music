package dev.rafex.ether.music.radio;

import java.time.Duration;

public final class RadioService {

    private final MpdClient mpdClient;
    private final String icecastStreamUrl;

    public RadioService(final MpdClient mpdClient, final String icecastStreamUrl) {
        this.mpdClient = mpdClient;
        this.icecastStreamUrl = icecastStreamUrl;
    }

    public RadioState readState() {
        return mpdClient.readState(24);
    }

    public String icecastStreamUrl() {
        return icecastStreamUrl;
    }

    public void play() throws Exception {
        mpdClient.play();
    }

    public void pauseToggle() throws Exception {
        mpdClient.pauseToggle();
    }

    public void next() throws Exception {
        mpdClient.next();
    }

    public void previous() throws Exception {
        mpdClient.previous();
    }

    public void setVolume(final int volume) throws Exception {
        mpdClient.setVolume(volume);
    }

    public static RadioService fromEnv() {
        final var host = env("MPD_HOST", "127.0.0.1");
        final var port = parseInt(env("MPD_PORT", "6600"), 6600);
        final var streamUrl = env("ICECAST_STREAM_URL", "http://127.0.0.1:8000/live");
        final var timeoutMs = parseInt(env("MPD_TIMEOUT_MS", "1500"), 1500);
        final var client = new MpdClient(host, port, Duration.ofMillis(timeoutMs));
        return new RadioService(client, streamUrl);
    }

    private static String env(final String key, final String fallback) {
        final var value = System.getenv(key);
        return (value == null || value.isBlank()) ? fallback : value;
    }

    private static int parseInt(final String raw, final int fallback) {
        try {
            return Integer.parseInt(raw);
        } catch (final Exception ignored) {
            return fallback;
        }
    }
}
