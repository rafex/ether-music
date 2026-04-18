package dev.rafex.ether.music.melody;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

public final class MelodyGenerator {

    private static final String[] NOTE_NAMES = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" };
    private static final Map<String, Integer> NOTE_TO_SEMITONE = buildSemitoneMap();

    public MelodyResponse generate(final MelodyRequest input) {
        final var normalized = normalize(input);
        final var scale = ScaleType.fromSlug(normalized.scale());
        final var palette = buildPalette(normalized.root(), normalized.octave(), scale);
        final var melody = buildMelody(normalized.steps(), palette);

        return new MelodyResponse(
                normalized,
                scale.label(),
                "weighted-random-step-motion",
                palette,
                melody);
    }

    private MelodyRequest normalize(final MelodyRequest input) {
        final var root = normalizeRoot(input == null ? null : input.root());
        final var scale = input == null ? ScaleType.MINOR.slug() : ScaleType.fromSlug(input.scale()).slug();
        final var octave = clamp(input == null ? 4 : input.octave(), 2, 6);
        final var steps = clamp(input == null ? 16 : input.steps(), 8, 32);
        return new MelodyRequest(root, scale, octave, steps);
    }

    private List<ScaleNote> buildPalette(final String root, final int octave, final ScaleType scale) {
        final var rootSemitone = NOTE_TO_SEMITONE.get(root);
        final var notes = new ArrayList<ScaleNote>();
        int index = 0;
        for (int octaveOffset = 0; octaveOffset < 2; octaveOffset++) {
            for (final int interval : scale.intervals()) {
                final var midi = 12 * (octave + 1 + octaveOffset) + rootSemitone + interval;
                notes.add(new ScaleNote(index++, midiToName(midi), midi, midiToFrequency(midi)));
            }
        }
        return List.copyOf(notes);
    }

    private List<MelodyStep> buildMelody(final int steps, final List<ScaleNote> palette) {
        final var out = new ArrayList<MelodyStep>(steps);
        final var random = ThreadLocalRandom.current();
        int previousIndex = Math.max(0, palette.size() / 2);

        for (int step = 0; step < steps; step++) {
            if (random.nextDouble() < 0.15d) {
                out.add(new MelodyStep(step, true, null, null, null));
                continue;
            }

            final int nextIndex;
            final var movement = random.nextDouble();
            if (movement < 0.60d) {
                nextIndex = clamp(previousIndex + (random.nextBoolean() ? 1 : -1), 0, palette.size() - 1);
            } else if (movement < 0.90d) {
                nextIndex = clamp(previousIndex + (random.nextBoolean() ? 2 : -2), 0, palette.size() - 1);
            } else {
                nextIndex = random.nextInt(palette.size());
            }

            previousIndex = nextIndex;
            final var note = palette.get(nextIndex);
            out.add(new MelodyStep(step, false, note.index(), note.name(), note.frequencyHz()));
        }

        return List.copyOf(out);
    }

    private static double midiToFrequency(final int midi) {
        return 440.0d * Math.pow(2.0d, (midi - 69) / 12.0d);
    }

    private static String midiToName(final int midi) {
        final var noteName = NOTE_NAMES[Math.floorMod(midi, 12)];
        final var octave = (midi / 12) - 1;
        return noteName + octave;
    }

    private static String normalizeRoot(final String value) {
        if (value == null || value.isBlank()) {
            return "C";
        }
        final var normalized = value.trim()
                .replace("Db", "C#")
                .replace("Eb", "D#")
                .replace("Gb", "F#")
                .replace("Ab", "G#")
                .replace("Bb", "A#")
                .toUpperCase();
        if (NOTE_TO_SEMITONE.containsKey(normalized)) {
            return normalized;
        }
        return "C";
    }

    private static Map<String, Integer> buildSemitoneMap() {
        final var map = new LinkedHashMap<String, Integer>();
        for (int i = 0; i < NOTE_NAMES.length; i++) {
            map.put(NOTE_NAMES[i], i);
        }
        return Map.copyOf(map);
    }

    private static int clamp(final int value, final int min, final int max) {
        return Math.max(min, Math.min(max, value));
    }
}
