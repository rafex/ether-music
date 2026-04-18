package dev.rafex.ether.music.melody;

import java.util.List;

public record MelodyResponse(
        MelodyRequest request,
        String scaleLabel,
        String algorithm,
        List<ScaleNote> palette,
        List<MelodyStep> melody) {
}
