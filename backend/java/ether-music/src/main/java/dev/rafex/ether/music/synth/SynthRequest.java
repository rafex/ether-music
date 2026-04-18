package dev.rafex.ether.music.synth;

import java.util.List;

import dev.rafex.ether.music.melody.MelodyStep;

public record SynthRequest(
        List<MelodyStep> melody,
        int bpm,
        String synthesizer,
        double effectReverb,
        double effectDelay,
        double intensity,
        int loops) {

    public SynthRequest(List<MelodyStep> melody, int bpm, String synthesizer,
            double effectReverb, double effectDelay, double intensity) {
        this(melody, bpm, synthesizer, effectReverb, effectDelay, intensity, 1);
    }
}
