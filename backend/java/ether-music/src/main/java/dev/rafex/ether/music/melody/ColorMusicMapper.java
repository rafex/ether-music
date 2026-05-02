package dev.rafex.ether.music.melody;

public final class ColorMusicMapper {

    public record Mapping(MelodyRequest request, int bpm, String interpretation) {
    }

    public Mapping map(final String hexColor) {
        final int rgb = parseHex(hexColor);
        final int r = (rgb >> 16) & 0xFF;
        final int g = (rgb >> 8) & 0xFF;
        final int b = rgb & 0xFF;

        final double[] hsb = rgbToHsb(r, g, b);
        final double hue = hsb[0];
        final double saturation = hsb[1];
        final double brightness = hsb[2];

        final String[] scale = hueToScale(hue);
        final int octave = (int) Math.round(2 + brightness * 4);  // 2-6
        final int bpm = (int) Math.round(50 + brightness * 100);  // 50-150
        final int steps = saturation > 0.5 ? 24 : 16;

        final var interp = "Color " + hexColor + " (H=" + (int) hue + "°, S=" + (int) (saturation * 100)
                + "%, B=" + (int) (brightness * 100) + "%) → " + scale[0] + " " + scale[1]
                + ", octava " + octave + ", " + bpm + " BPM";

        return new Mapping(new MelodyRequest(scale[0], scale[1], octave, steps), bpm, interp);
    }

    private static String[] hueToScale(final double hue) {
        if (hue < 30 || hue >= 330) return new String[]{"C", "major"};           // rojo → mayor
        if (hue < 60) return new String[]{"G", "major"};                          // naranja → mayor
        if (hue < 90) return new String[]{"C", "major"};                          // amarillo → mayor optimista
        if (hue < 150) return new String[]{"G", "pentatonic-major"};              // verde → pentatónica mayor
        if (hue < 180) return new String[]{"C", "pentatonic-major"};              // cian-verde → pentatónica mayor
        if (hue < 210) return new String[]{"C", "major"};                         // cian → major frío
        if (hue < 240) return new String[]{"A", "minor"};                         // azul claro → menor melancólico
        if (hue < 270) return new String[]{"A", "minor"};                         // azul → menor
        if (hue < 300) return new String[]{"D", "dorian"};                        // violeta → dorian
        return new String[]{"E", "pentatonic-minor"};                             // magenta/rosa → pentatónica menor
    }

    private static double[] rgbToHsb(final int r, final int g, final int b) {
        final double rf = r / 255.0;
        final double gf = g / 255.0;
        final double bf = b / 255.0;

        final double max = Math.max(rf, Math.max(gf, bf));
        final double min = Math.min(rf, Math.min(gf, bf));
        final double delta = max - min;

        final double brightness = max;
        final double saturation = max == 0 ? 0 : delta / max;

        final double hue;
        if (delta == 0) {
            hue = 0;
        } else if (max == rf) {
            hue = 60 * (((gf - bf) / delta) % 6);
        } else if (max == gf) {
            hue = 60 * (((bf - rf) / delta) + 2);
        } else {
            hue = 60 * (((rf - gf) / delta) + 4);
        }

        return new double[]{hue < 0 ? hue + 360 : hue, saturation, brightness};
    }

    private static int parseHex(final String hex) {
        final String clean = hex.startsWith("#") ? hex.substring(1) : hex;
        try {
            return Integer.parseInt(clean, 16);
        } catch (final NumberFormatException e) {
            return 0x808080; // gris por defecto
        }
    }
}
