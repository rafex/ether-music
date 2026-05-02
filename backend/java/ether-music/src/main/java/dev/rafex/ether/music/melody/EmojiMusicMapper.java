package dev.rafex.ether.music.melody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public final class EmojiMusicMapper {

    public record Mapping(MelodyRequest request, int bpm, String interpretation) {
    }

    private record MusicalAttribute(String root, String scale, int octave, int bpm, double reverb) {
    }

    private static final Map<String, MusicalAttribute> EMOJI_LEXICON = Map.ofEntries(
            // Emociones positivas
            Map.entry("😊", new MusicalAttribute("C", "major", 5, 110, 0.2)),
            Map.entry("😄", new MusicalAttribute("C", "major", 5, 120, 0.3)),
            Map.entry("😃", new MusicalAttribute("G", "major", 5, 130, 0.2)),
            Map.entry("😍", new MusicalAttribute("G", "pentatonic-major", 4, 100, 0.4)),
            Map.entry("🥰", new MusicalAttribute("F", "major", 4, 95, 0.5)),
            Map.entry("😇", new MusicalAttribute("C", "pentatonic-major", 5, 90, 0.6)),
            Map.entry("🚀", new MusicalAttribute("G", "major", 5, 145, 0.1)),
            Map.entry("✨", new MusicalAttribute("A", "pentatonic-major", 5, 130, 0.5)),
            Map.entry("⭐", new MusicalAttribute("C", "major", 4, 100, 0.4)),
            Map.entry("🌟", new MusicalAttribute("G", "major", 5, 115, 0.4)),
            Map.entry("🎉", new MusicalAttribute("C", "major", 5, 140, 0.2)),
            Map.entry("🎊", new MusicalAttribute("G", "major", 5, 135, 0.2)),
            Map.entry("💪", new MusicalAttribute("G", "major", 4, 130, 0.1)),
            Map.entry("🔥", new MusicalAttribute("D", "dorian", 3, 155, 0.1)),
            Map.entry("⚡", new MusicalAttribute("D", "minor", 3, 160, 0.1)),
            Map.entry("💡", new MusicalAttribute("C", "major", 4, 110, 0.3)),
            Map.entry("🎵", new MusicalAttribute("C", "major", 4, 100, 0.4)),
            Map.entry("🎶", new MusicalAttribute("G", "pentatonic-major", 4, 95, 0.5)),
            Map.entry("🌈", new MusicalAttribute("C", "major", 5, 120, 0.4)),
            Map.entry("🌺", new MusicalAttribute("G", "pentatonic-major", 4, 85, 0.5)),
            // Emociones negativas / tensas
            Map.entry("😢", new MusicalAttribute("A", "minor", 3, 70, 0.6)),
            Map.entry("😭", new MusicalAttribute("A", "minor", 2, 60, 0.7)),
            Map.entry("😔", new MusicalAttribute("D", "minor", 3, 75, 0.6)),
            Map.entry("😞", new MusicalAttribute("A", "minor", 3, 72, 0.65)),
            Map.entry("😰", new MusicalAttribute("D", "dorian", 2, 120, 0.2)),
            Map.entry("😨", new MusicalAttribute("E", "pentatonic-minor", 2, 115, 0.3)),
            Map.entry("😱", new MusicalAttribute("E", "pentatonic-minor", 2, 140, 0.2)),
            Map.entry("😠", new MusicalAttribute("E", "pentatonic-minor", 2, 150, 0.1)),
            Map.entry("😡", new MusicalAttribute("D", "dorian", 2, 160, 0.1)),
            Map.entry("💀", new MusicalAttribute("E", "pentatonic-minor", 2, 130, 0.3)),
            Map.entry("☠️", new MusicalAttribute("E", "pentatonic-minor", 2, 140, 0.2)),
            // Emociones neutrales / místicas
            Map.entry("🌙", new MusicalAttribute("A", "pentatonic-minor", 3, 65, 0.7)),
            Map.entry("🌌", new MusicalAttribute("E", "pentatonic-minor", 3, 70, 0.8)),
            Map.entry("🌀", new MusicalAttribute("D", "dorian", 4, 90, 0.5)),
            Map.entry("💎", new MusicalAttribute("C", "major", 5, 100, 0.3)),
            Map.entry("🔮", new MusicalAttribute("E", "pentatonic-minor", 4, 80, 0.7)),
            Map.entry("🌊", new MusicalAttribute("G", "pentatonic-major", 4, 75, 0.8)),
            Map.entry("🏔️", new MusicalAttribute("A", "minor", 3, 65, 0.6)),
            Map.entry("🌲", new MusicalAttribute("G", "pentatonic-major", 3, 70, 0.7)),
            Map.entry("🤔", new MusicalAttribute("D", "dorian", 4, 85, 0.4)),
            Map.entry("🧠", new MusicalAttribute("D", "dorian", 4, 90, 0.3)),
            Map.entry("💻", new MusicalAttribute("D", "dorian", 4, 100, 0.2)),
            Map.entry("⚙️", new MusicalAttribute("D", "minor", 3, 110, 0.2))
    );

    public Mapping map(final String emojiString) {
        final var emojis = extractEmojis(emojiString);
        if (emojis.isEmpty()) {
            return new Mapping(new MelodyRequest("C", "major", 4, 16), 100, "Composición por defecto");
        }

        final var attrs = emojis.stream()
                .map(EMOJI_LEXICON::get)
                .filter(a -> a != null)
                .toList();

        if (attrs.isEmpty()) {
            return new Mapping(new MelodyRequest("C", "pentatonic-major", 4, 16), 100,
                    "Emojis: " + String.join(" ", emojis));
        }

        final String root = attrs.get(0).root();
        final String scale = attrs.get(0).scale();
        final int octave = (int) attrs.stream().mapToInt(MusicalAttribute::octave).average().orElse(4);
        final int bpm = (int) attrs.stream().mapToInt(MusicalAttribute::bpm).average().orElse(100);
        final int steps = Math.min(8 + (emojis.size() * 2), 32);

        final var interp = "Emojis " + String.join(" ", emojis) + " → " + root + " " + scale
                + ", octava " + octave + ", " + bpm + " BPM, " + steps + " pasos";

        return new Mapping(new MelodyRequest(root, scale, octave, steps), bpm, interp);
    }

    private static List<String> extractEmojis(final String input) {
        if (input == null || input.isBlank()) return List.of();
        final var result = new ArrayList<String>();
        for (int i = 0; i < input.length(); ) {
            final int codePoint = input.codePointAt(i);
            final var s = new String(Character.toChars(codePoint));
            // Incluir solo code points que son emojis (> U+00FF)
            if (codePoint > 0x00FF || EMOJI_LEXICON.containsKey(s)) {
                result.add(s);
            }
            i += Character.charCount(codePoint);
        }
        return result;
    }
}
