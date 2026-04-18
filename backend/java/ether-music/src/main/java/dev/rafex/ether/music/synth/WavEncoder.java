package dev.rafex.ether.music.synth;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public final class WavEncoder {

    private WavEncoder() {
    }

    public static byte[] encode(final float[] samples, final int sampleRate) {
        final int numSamples = samples.length;
        final int byteRate = sampleRate * 2; // 16-bit mono
        final int dataSize = numSamples * 2;

        final var buf = ByteBuffer.allocate(44 + dataSize).order(ByteOrder.LITTLE_ENDIAN);

        // RIFF header
        buf.put(new byte[]{'R', 'I', 'F', 'F'});
        buf.putInt(36 + dataSize);
        buf.put(new byte[]{'W', 'A', 'V', 'E'});

        // fmt chunk
        buf.put(new byte[]{'f', 'm', 't', ' '});
        buf.putInt(16);         // chunk size
        buf.putShort((short) 1); // PCM
        buf.putShort((short) 1); // mono
        buf.putInt(sampleRate);
        buf.putInt(byteRate);
        buf.putShort((short) 2);  // block align
        buf.putShort((short) 16); // bits per sample

        // data chunk
        buf.put(new byte[]{'d', 'a', 't', 'a'});
        buf.putInt(dataSize);

        for (final float s : samples) {
            final float clamped = Math.max(-1.0f, Math.min(1.0f, s));
            buf.putShort((short) (clamped * 32767));
        }

        return buf.array();
    }

    public static float[] normalize(final float[] samples, final double targetPeak) {
        float maxAbs = 0f;
        for (final float s : samples) {
            final float abs = Math.abs(s);
            if (abs > maxAbs) maxAbs = abs;
        }
        if (maxAbs < 1e-6f) return samples;
        final float scale = (float) (targetPeak / maxAbs);
        final float[] out = new float[samples.length];
        for (int i = 0; i < samples.length; i++) {
            out[i] = samples[i] * scale;
        }
        return out;
    }
}
