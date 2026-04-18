package dev.rafex.ether.music.synth;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.Test;

import dev.rafex.ether.music.melody.MelodyStep;

class ServerSynthesizerTest {

    private static final List<MelodyStep> MELODY = List.of(
            new MelodyStep(0, false, 4, "A4", 440.0),
            new MelodyStep(1, false, 5, "B4", 493.88),
            new MelodyStep(2, true, null, null, null),
            new MelodyStep(3, false, 3, "G4", 392.0));

    @Test
    void wavTieneHeaderRiffValido() {
        final var req = new SynthRequest(MELODY, 120, "fm", 0.3, 0.2, 0.8);
        final byte[] wav = ServerSynthesizer.synthesize(req);

        assertNotNull(wav);
        assertTrue(wav.length > 44, "WAV debe tener más de 44 bytes");
        assertEquals('R', wav[0]);
        assertEquals('I', wav[1]);
        assertEquals('F', wav[2]);
        assertEquals('F', wav[3]);
        assertEquals('W', wav[8]);
        assertEquals('A', wav[9]);
        assertEquals('V', wav[10]);
        assertEquals('E', wav[11]);
    }

    @Test
    void sintetizaConFmAditivoYWavetable() {
        final var reqFm = new SynthRequest(MELODY, 100, "fm", 0.0, 0.0, 0.7);
        final var reqAdd = new SynthRequest(MELODY, 100, "additive", 0.0, 0.0, 0.7);
        final var reqWt = new SynthRequest(MELODY, 100, "wavetable", 0.0, 0.0, 0.7);

        final byte[] fm = ServerSynthesizer.synthesize(reqFm);
        final byte[] additive = ServerSynthesizer.synthesize(reqAdd);
        final byte[] wavetable = ServerSynthesizer.synthesize(reqWt);

        assertEquals(fm.length, additive.length, "FM y Aditivo deben producir WAV del mismo tamaño");
        assertEquals(fm.length, wavetable.length, "FM y Wavetable deben producir WAV del mismo tamaño");
    }

    @Test
    void melodiaVaciaProduceWavValido() {
        final var req = new SynthRequest(List.of(), 120, "fm", 0.0, 0.0, 0.8);
        final byte[] wav = ServerSynthesizer.synthesize(req);

        assertNotNull(wav);
        assertTrue(wav.length >= 44);
        assertEquals('R', wav[0]);
    }

    @Test
    void efectosNoCorrompenElWav() {
        final var req = new SynthRequest(MELODY, 120, "fm", 0.8, 0.6, 1.0);
        final byte[] wav = ServerSynthesizer.synthesize(req);

        assertNotNull(wav);
        assertTrue(wav.length > 44);
        assertEquals('R', wav[0]);
        assertEquals('I', wav[1]);
    }

    @Test
    void wavConMultiplesLoopsEsMasLargo() {
        final var req1 = new SynthRequest(MELODY, 120, "fm", 0.0, 0.0, 0.8, 1);
        final var req2 = new SynthRequest(MELODY, 120, "fm", 0.0, 0.0, 0.8, 2);
        final var req3 = new SynthRequest(MELODY, 120, "fm", 0.0, 0.0, 0.8, 3);

        final byte[] wav1 = ServerSynthesizer.synthesize(req1);
        final byte[] wav2 = ServerSynthesizer.synthesize(req2);
        final byte[] wav3 = ServerSynthesizer.synthesize(req3);

        assertNotNull(wav1);
        assertNotNull(wav2);
        assertNotNull(wav3);
        assertTrue(wav2.length > wav1.length, "2 loops debe ser más largo que 1 loop");
        assertTrue(wav3.length > wav2.length, "3 loops debe ser más largo que 2 loops");
        assertTrue(wav2.length >= wav1.length * 1.8, "2 loops debe ser ~2× más largo");
        assertTrue(wav3.length >= wav1.length * 2.8, "3 loops debe ser ~3× más largo");
    }

    @Test
    void loopsSeValidaAMaximo10() {
        final var reqTooMany = new SynthRequest(MELODY, 120, "fm", 0.0, 0.0, 0.8, 100);
        final byte[] wav = ServerSynthesizer.synthesize(reqTooMany);

        assertNotNull(wav);
        assertTrue(wav.length > 44);
    }
}
