package dev.rafex.ether.music.melody;

import java.util.Set;

public final class WordsMapper {

    private static final Set<String> POSITIVE = Set.of(
            "love", "joy", "happy", "sun", "light", "beautiful", "peace", "harmony",
            "bright", "warm", "hope", "dream", "free", "good", "great", "wonderful",
            "smile", "dance", "song", "laugh", "sweet", "bliss", "glory", "magic",
            "alive", "shine", "fresh", "flow", "create", "play", "win", "success",
            "feliz", "amor", "sol", "paz", "esperanza", "bueno", "bello", "alegria");

    private static final Set<String> NEGATIVE = Set.of(
            "pain", "dark", "fear", "chaos", "hate", "evil", "sad", "cold", "anger",
            "broken", "lost", "death", "hurt", "bad", "terrible", "storm", "war",
            "cry", "fail", "crash", "error", "bug", "problem", "issue", "wrong",
            "slow", "heavy", "burden", "stress", "anxiety", "worry", "confused",
            "triste", "miedo", "oscuro", "mal", "falla", "caos", "problema", "odio");

    public record Mapping(MelodyRequest request, int bpm, String interpretation) {
    }

    public Mapping map(final WordsRequest req) {
        if (req == null || req.words() == null || req.words().isEmpty()) {
            return new Mapping(new MelodyRequest("C", "major", 4, 16), 100,
                    "sin palabras → C major por defecto");
        }

        final var words = req.words();

        final double positiveScore = words.stream()
                .filter(e -> e.word() != null && POSITIVE.contains(e.word().toLowerCase()))
                .mapToDouble(WordEntry::weight)
                .sum();
        final double negativeScore = words.stream()
                .filter(e -> e.word() != null && NEGATIVE.contains(e.word().toLowerCase()))
                .mapToDouble(WordEntry::weight)
                .sum();

        final double avgWeight = words.stream()
                .mapToDouble(WordEntry::weight)
                .average()
                .orElse(0.5);

        final String mood;
        final String[] scale;
        if (positiveScore > negativeScore * 1.5) {
            mood = "happy";
            scale = new String[]{"C", "major"};
        } else if (negativeScore > positiveScore * 1.5) {
            mood = "sad";
            scale = new String[]{"A", "minor"};
        } else if (negativeScore > positiveScore) {
            mood = "tense";
            scale = new String[]{"D", "dorian"};
        } else if (positiveScore > 0 && negativeScore == 0) {
            mood = "calm";
            scale = new String[]{"G", "pentatonic-major"};
        } else {
            mood = "mysterious";
            scale = new String[]{"E", "pentatonic-minor"};
        }

        final int octave;
        final String energyLabel;
        if (avgWeight < 0.33) {
            octave = 3;
            energyLabel = "low";
        } else if (avgWeight > 0.66) {
            octave = 5;
            energyLabel = "high";
        } else {
            octave = 4;
            energyLabel = "medium";
        }

        final int steps;
        final String lengthLabel;
        if (words.size() <= 5) {
            steps = 8;
            lengthLabel = "short";
        } else if (words.size() > 15) {
            steps = 32;
            lengthLabel = "long";
        } else {
            steps = 16;
            lengthLabel = "medium";
        }

        final int bpm = positiveScore >= negativeScore ? 110 : 75;

        final var interp = words.size() + " palabras → mood=" + mood
                + " (+" + String.format("%.1f", positiveScore) + " -" + String.format("%.1f", negativeScore) + ")"
                + ", energía=" + energyLabel + ", longitud=" + lengthLabel + ", " + bpm + " BPM";

        return new Mapping(new MelodyRequest(scale[0], scale[1], octave, steps), bpm, interp);
    }
}
