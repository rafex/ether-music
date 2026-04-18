package dev.rafex.ether.music.melody;

import java.util.List;

public enum ScaleType {
    MAJOR("major", "Mayor", List.of(0, 2, 4, 5, 7, 9, 11)),
    MINOR("minor", "Menor natural", List.of(0, 2, 3, 5, 7, 8, 10)),
    DORIAN("dorian", "Dorian", List.of(0, 2, 3, 5, 7, 9, 10)),
    PENTATONIC_MAJOR("pentatonic-major", "Pentatonica mayor", List.of(0, 2, 4, 7, 9)),
    PENTATONIC_MINOR("pentatonic-minor", "Pentatonica menor", List.of(0, 3, 5, 7, 10));

    private final String slug;
    private final String label;
    private final List<Integer> intervals;

    ScaleType(final String slug, final String label, final List<Integer> intervals) {
        this.slug = slug;
        this.label = label;
        this.intervals = intervals;
    }

    public String slug() {
        return slug;
    }

    public String label() {
        return label;
    }

    public List<Integer> intervals() {
        return intervals;
    }

    public static ScaleType fromSlug(final String value) {
        if (value == null || value.isBlank()) {
            return MINOR;
        }
        for (final var type : values()) {
            if (type.slug.equalsIgnoreCase(value.trim())) {
                return type;
            }
        }
        return MINOR;
    }
}
