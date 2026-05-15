package dev.rafex.ether.music.ondemand;

public record OnDemandTrack(
        String id,
        String title,
        String artist,
        String album,
        String extension,
        String mimeType,
        long sizeBytes) {
}
