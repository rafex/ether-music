package dev.rafex.ether.music.ai;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record ElectronicCompositionParams(
        String synthesizer,
        String scale,
        String root,
        @JsonProperty("tempo_bpm") int tempoBpm,
        int octave,
        int steps,
        @JsonProperty("effect_reverb") double effectReverb,
        @JsonProperty("effect_delay") double effectDelay,
        @JsonProperty("frequency_min") int frequencyMin,
        @JsonProperty("frequency_max") int frequencyMax,
        double intensity,
        String interpretation) {

    public ElectronicCompositionParams {
        if (synthesizer == null || synthesizer.isBlank()) synthesizer = "fm";
        if (scale == null || scale.isBlank()) scale = "aeolian";
        if (root == null || root.isBlank()) root = "A";
        if (tempoBpm < 40 || tempoBpm > 240) tempoBpm = 110;
        if (octave < 2 || octave > 6) octave = 4;
        if (steps < 4 || steps > 64) steps = 16;
        effectReverb = Math.clamp(effectReverb, 0.0, 1.0);
        effectDelay = Math.clamp(effectDelay, 0.0, 1.0);
        if (frequencyMin < 20) frequencyMin = 80;
        if (frequencyMax > 20000 || frequencyMax < frequencyMin) frequencyMax = 4000;
        intensity = Math.clamp(intensity, 0.1, 1.0);
        if (interpretation == null) interpretation = "";
    }
}
