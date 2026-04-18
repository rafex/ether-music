package dev.rafex.ether.music.synth;

public final class AudioEffects {

    private AudioEffects() {
    }

    /**
     * Delay simple con feedback.
     * delayTime: fracción de segundo (e.g. 0.25 = 250 ms)
     * mix: 0.0 (seco) a 1.0 (todo delay)
     */
    public static float[] applyDelay(final float[] input, final double delayTime, final int sampleRate) {
        if (delayTime <= 0.0) return input;
        final int delaySamples = (int) (delayTime * sampleRate);
        final float feedback = 0.45f;
        final float mix = 0.35f;
        final float[] out = new float[input.length];
        final float[] buf = new float[input.length + delaySamples];

        for (int i = 0; i < input.length; i++) {
            buf[i] = input[i];
        }
        for (int i = 0; i < input.length; i++) {
            final float delayed = (i >= delaySamples) ? buf[i - delaySamples] : 0f;
            out[i] = input[i] + mix * delayed;
            buf[i] += feedback * delayed;
        }
        return out;
    }

    /**
     * Reverb simplificado — 4 comb filters paralelos + 2 all-pass en serie.
     * amount: 0.0 (sin reverb) a 1.0 (máximo)
     */
    public static float[] applyReverb(final float[] input, final double amount, final int sampleRate) {
        if (amount <= 0.0) return input;

        final float wet = (float) amount * 0.5f;
        final float dry = 1.0f - wet * 0.5f;

        // Longitudes de comb filters en muestras (primes para evitar peinado)
        final int[] combLengths = {
            (int) (0.0297 * sampleRate),
            (int) (0.0371 * sampleRate),
            (int) (0.0411 * sampleRate),
            (int) (0.0437 * sampleRate)
        };
        final float combG = 0.84f;

        float[] reverbSignal = new float[input.length];

        // 4 comb filters en paralelo
        for (final int len : combLengths) {
            final float[] combBuf = new float[len];
            int combIdx = 0;
            for (int i = 0; i < input.length; i++) {
                final float delayed = combBuf[combIdx];
                final float out = input[i] + combG * delayed;
                combBuf[combIdx] = out;
                combIdx = (combIdx + 1) % len;
                reverbSignal[i] += out * 0.25f;
            }
        }

        // 2 all-pass en serie
        final int[] apLengths = {
            (int) (0.0090 * sampleRate),
            (int) (0.0124 * sampleRate)
        };
        final float apG = 0.7f;

        for (final int len : apLengths) {
            final float[] apBuf = new float[len];
            final float[] apOut = new float[reverbSignal.length];
            int apIdx = 0;
            for (int i = 0; i < reverbSignal.length; i++) {
                final float delayed = apBuf[apIdx];
                apOut[i] = -apG * reverbSignal[i] + delayed + apG * (i < len ? 0 : apBuf[apIdx]);
                apBuf[apIdx] = reverbSignal[i] + apG * delayed;
                apIdx = (apIdx + 1) % len;
            }
            reverbSignal = apOut;
        }

        // Mezcla dry + wet
        final float[] result = new float[input.length];
        for (int i = 0; i < input.length; i++) {
            result[i] = dry * input[i] + wet * reverbSignal[i];
        }
        return result;
    }
}
