package dev.rafex.ether.music.melody;

public record SongRecord(long id, String createdAt, String source, int bpm, String scaleLabel, String root,
        int steps, String interpretation) {
}
