package dev.rafex.ether.music.melody;

import java.util.ArrayList;
import java.util.List;

public final class GraphicMusicMapper {

    public record Point(double x, double y) {
    }

    public record GraphicInput(List<Point> points, int targetSteps) {
    }

    // Paleta de notas fijas para melodía dibujada (C mayor)
    private static final double[] FREQUENCIES = {
            261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88,
            523.25, 587.33, 659.25, 698.46, 783.99
    };

    private static final String[] NOTE_NAMES = {
            "C4", "D4", "E4", "F4", "G4", "A4", "B4",
            "C5", "D5", "E5", "F5", "G5"
    };

    private static final List<ScaleNote> PALETTE;

    static {
        final var list = new ArrayList<ScaleNote>();
        for (int i = 0; i < NOTE_NAMES.length; i++) {
            list.add(new ScaleNote(i, NOTE_NAMES[i], 60 + i, FREQUENCIES[i]));
        }
        PALETTE = List.copyOf(list);
    }

    public ComposedResponse map(final GraphicInput input) {
        final int steps = Math.max(4, Math.min(32, input.targetSteps()));
        final var interpolated = interpolate(input.points(), steps);

        final var melody = new ArrayList<MelodyStep>(steps);
        for (int i = 0; i < steps; i++) {
            final double y = i < interpolated.size() ? interpolated.get(i) : 0.5;
            // y=0 es arriba (nota alta), y=1 es abajo (nota baja) — invertir
            final double normalizedY = 1.0 - Math.max(0.0, Math.min(1.0, y));
            final int noteIndex = (int) Math.round(normalizedY * (PALETTE.size() - 1));
            final var note = PALETTE.get(noteIndex);
            melody.add(new MelodyStep(i, false, note.index(), note.name(), note.frequencyHz()));
        }

        final var request = new MelodyRequest("C", "major", 4, steps);
        return new ComposedResponse(
                "graphic",
                "Melodía dibujada con " + input.points().size() + " puntos → " + steps + " pasos",
                110,
                request,
                "Mayor",
                "graphic-interpolation",
                PALETTE,
                List.copyOf(melody));
    }

    private static List<Double> interpolate(final List<Point> points, final int targetSteps) {
        if (points == null || points.isEmpty()) {
            final var flat = new ArrayList<Double>(targetSteps);
            for (int i = 0; i < targetSteps; i++) flat.add(0.5);
            return flat;
        }
        if (points.size() == 1) {
            final var flat = new ArrayList<Double>(targetSteps);
            for (int i = 0; i < targetSteps; i++) flat.add(points.get(0).y());
            return flat;
        }

        // Ordenar puntos por x
        final var sorted = points.stream().sorted((a, b) -> Double.compare(a.x(), b.x())).toList();

        final var result = new ArrayList<Double>(targetSteps);
        for (int i = 0; i < targetSteps; i++) {
            final double t = (double) i / (targetSteps - 1);
            result.add(interpolateY(sorted, t));
        }
        return result;
    }

    private static double interpolateY(final List<Point> sorted, final double t) {
        if (t <= sorted.get(0).x()) return sorted.get(0).y();
        if (t >= sorted.get(sorted.size() - 1).x()) return sorted.get(sorted.size() - 1).y();

        for (int i = 0; i < sorted.size() - 1; i++) {
            final var p1 = sorted.get(i);
            final var p2 = sorted.get(i + 1);
            if (t >= p1.x() && t <= p2.x()) {
                final double segLen = p2.x() - p1.x();
                if (segLen == 0) return p1.y();
                final double frac = (t - p1.x()) / segLen;
                return p1.y() + frac * (p2.y() - p1.y());
            }
        }
        return 0.5;
    }
}
