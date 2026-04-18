package dev.rafex.ether.music.ai;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;

import org.junit.jupiter.api.Test;

import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.melody.MelodyGenerator;

class ElectronicCompositionServiceTest {

    private static final String SAMPLE_JSON = """
            {
              "synthesizer": "fm",
              "scale": "aeolian",
              "root": "A",
              "tempo_bpm": 120,
              "octave": 4,
              "steps": 16,
              "effect_reverb": 0.4,
              "effect_delay": 0.25,
              "frequency_min": 200,
              "frequency_max": 2000,
              "intensity": 0.7,
              "interpretation": "Código tenso con bucle de reintentos y manejo de errores"
            }
            """;

    @Test
    void debeComponerDesdeCodigoConLlmMock() throws IOException, InterruptedException {
        final LlmAnalysisPort llmMock = (content, sourceType) -> {
            assertEquals("code", sourceType);
            return new com.fasterxml.jackson.databind.ObjectMapper()
                    .readValue(SAMPLE_JSON, ElectronicCompositionParams.class);
        };

        final var service = new ElectronicCompositionService(llmMock, new MelodyGenerator(), null);
        final ComposedResponse result = service.composeFromCode("for(int i=0;i<10;i++) {}");

        assertNotNull(result);
        assertEquals(120, result.bpm());
        assertTrue(result.source().startsWith("electronic-"));
        assertEquals("Código tenso con bucle de reintentos y manejo de errores", result.interpretation());
        assertNotNull(result.melody());
        assertTrue(result.melody().size() > 0);
    }

    @Test
    void debeComponerDesdeTextoConLlmMock() throws IOException, InterruptedException {
        final LlmAnalysisPort llmMock = (content, sourceType) -> {
            assertEquals("text", sourceType);
            return new com.fasterxml.jackson.databind.ObjectMapper()
                    .readValue(SAMPLE_JSON, ElectronicCompositionParams.class);
        };

        final var service = new ElectronicCompositionService(llmMock, new MelodyGenerator(), null);
        final ComposedResponse result = service.composeFromText("La lluvia cae sobre la ciudad dormida");

        assertNotNull(result);
        assertEquals("electronic-text", result.source());
        assertNotNull(result.palette());
        assertTrue(result.palette().size() > 0);
    }

    @Test
    void parametrosDebenSanitizarseCorrectamente() {
        final var params = new ElectronicCompositionParams(
                null, null, null, 999, 0, 1, -0.5, 2.0, 10, 100, 0.05, null);

        assertEquals("fm", params.synthesizer());
        assertEquals("aeolian", params.scale());
        assertEquals("A", params.root());
        assertEquals(110, params.tempoBpm());
        assertEquals(4, params.octave());
        assertEquals(16, params.steps());
        assertEquals(0.0, params.effectReverb());
        assertEquals(1.0, params.effectDelay());
        assertEquals(80, params.frequencyMin());
        assertEquals(100, params.frequencyMax());
        assertEquals(0.1, params.intensity());
        assertEquals("", params.interpretation());
    }
}
