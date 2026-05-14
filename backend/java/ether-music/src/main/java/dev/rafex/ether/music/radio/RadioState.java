package dev.rafex.ether.music.radio;

import java.util.List;

public record RadioState(
        boolean online,
        String statusMessage,
        String playbackState,
        int volume,
        String elapsed,
        String duration,
        RadioTrack nowPlaying,
        List<RadioTrack> playlist) {
}
