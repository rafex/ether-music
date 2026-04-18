package dev.rafex.ether.music.synth;

import java.util.List;

import dev.rafex.ether.music.melody.MelodyStep;

public final class ServerSynthesizer {

    private static final int SAMPLE_RATE = 44100;

    private ServerSynthesizer() {
    }

    public static byte[] synthesize(final SynthRequest request) {
        final List<MelodyStep> melody = request.melody();
        if (melody == null || melody.isEmpty()) {
            return WavEncoder.encode(new float[SAMPLE_RATE], SAMPLE_RATE);
        }

        final double secondsPerBeat = 60.0 / Math.max(1, request.bpm());
        final double noteDuration = secondsPerBeat * 0.5;
        final int samplesPerNote = (int) (noteDuration * SAMPLE_RATE);
        final int totalSamples = samplesPerNote * melody.size();

        final float[] buffer = new float[totalSamples];
        final float amplitude = (float) Math.clamp(request.intensity(), 0.1, 1.0) * 0.7f;

        for (int i = 0; i < melody.size(); i++) {
            final MelodyStep step = melody.get(i);
            if (step.rest() || step.frequencyHz() == null || step.frequencyHz() <= 0) continue;

            final int offset = i * samplesPerNote;
            final String synth = request.synthesizer() == null ? "fm" : request.synthesizer().toLowerCase();

            switch (synth) {
                case "additive" -> renderAdditive(buffer, offset, samplesPerNote, step.frequencyHz(), amplitude);
                case "wavetable" -> renderWavetable(buffer, offset, samplesPerNote, step.frequencyHz(), amplitude);
                default -> renderFm(buffer, offset, samplesPerNote, step.frequencyHz(), amplitude);
            }
        }

        float[] processed = buffer;

        if (request.effectDelay() > 0.0) {
            processed = AudioEffects.applyDelay(processed, 0.25, SAMPLE_RATE);
        }
        if (request.effectReverb() > 0.0) {
            processed = AudioEffects.applyReverb(processed, request.effectReverb(), SAMPLE_RATE);
        }

        processed = WavEncoder.normalize(processed, 0.9);
        return WavEncoder.encode(processed, SAMPLE_RATE);
    }

    private static void renderFm(final float[] buf, final int offset, final int length,
            final double fc, final float amplitude) {
        final double fm = fc * 2.0;
        final double modIndex = 3.0;
        final double twoPi = 2.0 * Math.PI;

        for (int n = 0; n < length; n++) {
            final double t = (double) n / SAMPLE_RATE;
            final double env = adsr(n, length);
            final double modulator = modIndex * Math.sin(twoPi * fm * t);
            buf[offset + n] += (float) (amplitude * env * Math.sin(twoPi * fc * t + modulator));
        }
    }

    private static void renderAdditive(final float[] buf, final int offset, final int length,
            final double fundamental, final float amplitude) {
        final double twoPi = 2.0 * Math.PI;
        final double[] harmonicAmps = {1.0, 0.5, 0.25, 0.125, 0.0625};

        for (int n = 0; n < length; n++) {
            final double t = (double) n / SAMPLE_RATE;
            final double env = adsr(n, length);
            double sample = 0.0;
            for (int h = 0; h < harmonicAmps.length; h++) {
                sample += harmonicAmps[h] * Math.sin(twoPi * fundamental * (h + 1) * t);
            }
            buf[offset + n] += (float) (amplitude * env * sample * 0.5);
        }
    }

    private static void renderWavetable(final float[] buf, final int offset, final int length,
            final double frequency, final float amplitude) {
        final int tableSize = 2048;
        final double[] table = buildSawtoothTable(tableSize);
        final double phaseIncrement = frequency * tableSize / SAMPLE_RATE;
        double phase = 0.0;

        for (int n = 0; n < length; n++) {
            final double env = adsr(n, length);
            final int idx = (int) phase % tableSize;
            buf[offset + n] += (float) (amplitude * env * table[idx]);
            phase += phaseIncrement;
            if (phase >= tableSize) phase -= tableSize;
        }
    }

    private static double[] buildSawtoothTable(final int size) {
        final double[] table = new double[size];
        for (int i = 0; i < size; i++) {
            table[i] = 2.0 * i / size - 1.0;
        }
        return table;
    }

    private static double adsr(final int n, final int total) {
        final int attack = (int) (total * 0.05);
        final int decay = (int) (total * 0.10);
        final int release = (int) (total * 0.20);
        final int sustain = total - attack - decay - release;
        final double sustainLevel = 0.7;

        if (n < attack) {
            return (double) n / attack;
        } else if (n < attack + decay) {
            return 1.0 - (1.0 - sustainLevel) * (double) (n - attack) / decay;
        } else if (n < attack + decay + sustain) {
            return sustainLevel;
        } else {
            final int r = n - attack - decay - sustain;
            return sustainLevel * (1.0 - (double) r / release);
        }
    }
}
