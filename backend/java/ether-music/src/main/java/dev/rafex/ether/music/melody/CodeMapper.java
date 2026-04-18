package dev.rafex.ether.music.melody;

public final class CodeMapper {

    public record Mapping(MelodyRequest request, int bpm, String interpretation) {
    }

    public Mapping map(final CodeSessionRequest req) {
        final int kpm = req == null ? 60 : Math.max(0, req.keystrokesPerMinute());
        final int errors = req == null ? 0 : Math.max(0, req.errorsLastMinute());
        final int lines = req == null ? 10 : Math.max(0, req.linesWritten());
        final int deletions = req == null ? 0 : Math.max(0, req.deletions());

        final int bpm;
        final String tempoLabel;
        if (kpm < 40) {
            bpm = 60;
            tempoLabel = "slow";
        } else if (kpm > 100) {
            bpm = 150;
            tempoLabel = "fast";
        } else {
            bpm = 60 + kpm;
            tempoLabel = "medium";
        }

        final double noiseRatio = lines > 0
                ? (errors + deletions) / (double) (lines + 1)
                : (errors + deletions) / 5.0;

        final String[] scale;
        final String moodLabel;
        if (errors == 0 && noiseRatio < 0.2) {
            scale = new String[]{"C", "major"};
            moodLabel = "flow state";
        } else if (errors <= 2 && noiseRatio < 0.5) {
            scale = new String[]{"D", "dorian"};
            moodLabel = "focused";
        } else if (errors <= 5) {
            scale = new String[]{"A", "minor"};
            moodLabel = "debugging";
        } else {
            scale = new String[]{"E", "pentatonic-minor"};
            moodLabel = "firefighting";
        }

        final int octave = kpm < 40 ? 3 : (kpm > 100 ? 5 : 4);
        final int steps = lines <= 5 ? 8 : (lines >= 30 ? 32 : 16);

        final var interp = kpm + " kpm → " + tempoLabel + " (" + bpm + " BPM)"
                + ", " + errors + " errores → " + moodLabel
                + ", " + lines + " líneas → " + steps + " pasos";

        return new Mapping(new MelodyRequest(scale[0], scale[1], octave, steps), bpm, interp);
    }
}
