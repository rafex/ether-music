package dev.rafex.ether.music.melody;

public final class ExpressMapper {

    public record Mapping(MelodyRequest request, int bpm, String interpretation) {
    }

    public Mapping map(final ExpressRequest express) {
        final var mood = express == null || express.mood() == null ? "happy" : express.mood().toLowerCase().trim();
        final var energy = express == null || express.energy() == null ? "medium" : express.energy().toLowerCase().trim();
        final var tempo = express == null || express.tempo() == null ? "medium" : express.tempo().toLowerCase().trim();
        final var length = express == null || express.length() == null ? "medium" : express.length().toLowerCase().trim();

        final var scale = moodToScale(mood);
        final int octave = energyToOctave(energy);
        final int bpm = tempoToBpm(tempo);
        final int steps = lengthToSteps(length);

        final var interp = "mood=" + mood + " → " + scale[0] + " " + scale[1]
                + ", energía=" + energy + " → octava " + octave
                + ", tempo=" + tempo + " → " + bpm + " BPM"
                + ", longitud=" + length + " → " + steps + " pasos";

        return new Mapping(new MelodyRequest(scale[0], scale[1], octave, steps), bpm, interp);
    }

    private static String[] moodToScale(final String mood) {
        return switch (mood) {
            case "happy" -> new String[]{"C", "major"};
            case "sad" -> new String[]{"A", "minor"};
            case "tense" -> new String[]{"D", "dorian"};
            case "calm" -> new String[]{"G", "pentatonic-major"};
            case "mysterious" -> new String[]{"E", "pentatonic-minor"};
            case "epic" -> new String[]{"G", "major"};
            default -> new String[]{"C", "major"};
        };
    }

    private static int energyToOctave(final String energy) {
        return switch (energy) {
            case "low" -> 3;
            case "high" -> 5;
            default -> 4;
        };
    }

    private static int tempoToBpm(final String tempo) {
        return switch (tempo) {
            case "slow" -> 60;
            case "fast" -> 160;
            default -> 100;
        };
    }

    private static int lengthToSteps(final String length) {
        return switch (length) {
            case "short" -> 8;
            case "long" -> 32;
            default -> 16;
        };
    }
}
