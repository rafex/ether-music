package dev.rafex.ether.music.melody;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class MelodyGeneratorTest {

    private final MelodyGenerator generator = new MelodyGenerator();

    @Test
    void shouldGenerateMelodyWithinNormalizedBounds() {
        final var response = generator.generate(new MelodyRequest("Db", "major", 9, 64));

        assertEquals("C#", response.request().root());
        assertEquals("major", response.request().scale());
        assertEquals(6, response.request().octave());
        assertEquals(32, response.request().steps());
        assertFalse(response.palette().isEmpty());
        assertEquals(32, response.melody().size());
        assertTrue(response.melody().stream().anyMatch(step -> !step.rest()));
    }

    @Test
    void shouldExposePlayableFrequenciesForActiveSteps() {
        final var response = generator.generate(new MelodyRequest("A", "minor", 4, 16));

        final var activeStep = response.melody().stream().filter(step -> !step.rest()).findFirst().orElseThrow();
        assertNotNull(activeStep.noteName());
        assertNotNull(activeStep.frequencyHz());
        assertTrue(activeStep.frequencyHz() > 100.0d);
    }
}
