package dev.rafex.ether.music.melody;

import java.util.List;

public record ComposedResponse(
        String source,
        String interpretation,
        int bpm,
        MelodyRequest request,
        String scaleLabel,
        String algorithm,
        List<ScaleNote> palette,
        List<MelodyStep> melody) {

    public static ComposedResponse from(final String source, final String interpretation,
            final int bpm, final MelodyResponse m) {
        return new ComposedResponse(source, interpretation, bpm,
                m.request(), m.scaleLabel(), m.algorithm(), m.palette(), m.melody());
    }
}
