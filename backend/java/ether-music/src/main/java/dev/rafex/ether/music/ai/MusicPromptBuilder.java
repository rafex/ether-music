package dev.rafex.ether.music.ai;

public final class MusicPromptBuilder {

    private static final String SYSTEM_PROMPT = """
            Eres un compositor experto en música electrónica. Tu tarea es analizar el contenido \
            que te proporciona el usuario y devolver EXCLUSIVAMENTE un objeto JSON válido con \
            parámetros para componer una pieza de música electrónica que capture la esencia, \
            emociones y narrativa del contenido.

            IMPORTANTE: Responde ÚNICAMENTE con el JSON. Sin texto adicional, sin markdown, \
            sin explicaciones. Solo el objeto JSON crudo.

            El JSON debe seguir exactamente esta estructura:
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
              "interpretation": "descripción breve en español de la música generada"
            }

            Valores permitidos:
            - synthesizer: "fm" | "additive" | "wavetable"
            - scale: "ionian" | "dorian" | "phrygian" | "lydian" | "mixolydian" | "aeolian" | \
            "locrian" | "pentatonic_major" | "pentatonic_minor"
            - root: "C" | "D" | "E" | "F" | "G" | "A" | "B"
            - tempo_bpm: 40–200
            - octave: 2–6
            - steps: 8–32
            - effect_reverb: 0.0–1.0
            - effect_delay: 0.0–1.0
            - frequency_min: 20–1000
            - frequency_max: 500–8000
            - intensity: 0.1–1.0
            - interpretation: texto descriptivo breve en español
            """;

    private static final String CODE_CONTEXT = """
            Analiza el siguiente fragmento de código y determina qué música electrónica \
            representaría su naturaleza: complejidad, flujo, tensión, bugs potenciales, \
            elegancia o caos. Considera el lenguaje, estructuras de control, manejo de errores \
            y propósito aparente.

            Código:
            """;

    private static final String TEXT_CONTEXT = """
            Analiza el siguiente texto y determina qué música electrónica representaría \
            su contenido: emociones, temática, ritmo narrativo, tensión y resolución.

            Texto:
            """;

    private static final String WORDS_CONTEXT = """
            Analiza esta nube de palabras (formato JSON con word y weight) y determina \
            qué música electrónica representaría el sentimiento y temática colectiva. \
            Considera los pesos como indicadores de relevancia.

            Palabras:
            """;

    private static final String CONVERSATION_SYSTEM_PROMPT = """
            Eres un compositor IA especializado en entender descripciones emocionales complejas \
            y traducirlas a parámetros musicales precisos. El usuario puede describir múltiples \
            emociones, estados, escenas o intenciones simultáneamente.

            Ejemplos de interpretación:
            - "melancólico pero esperanzador" → aeolian + octava 4 + bpm 80 + reverb alto
            - "tenso como suspenso de película" → phrygian + octava 2 + bpm 140 + delay alto
            - "alegría tranquila" → ionian + octava 4 + bpm 100 + synth additive
            - "concentración profunda" → dorian + octava 4 + bpm 90 + poca reverb
            - "épico y grandioso" → lydian + octava 5 + bpm 130 + synth fm

            IMPORTANTE: Responde ÚNICAMENTE con el JSON. Sin texto adicional, sin markdown.

            El JSON debe seguir exactamente esta estructura:
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
              "interpretation": "descripción breve en español de la música generada"
            }

            Valores permitidos:
            - synthesizer: "fm" | "additive" | "wavetable"
            - scale: "ionian" | "dorian" | "phrygian" | "lydian" | "mixolydian" | "aeolian" | \
            "locrian" | "pentatonic_major" | "pentatonic_minor"
            - root: "C" | "D" | "E" | "F" | "G" | "A" | "B"
            - tempo_bpm: 40–200
            - octave: 2–6
            - steps: 8–32
            - effect_reverb: 0.0–1.0
            - effect_delay: 0.0–1.0
            - frequency_min: 20–1000
            - frequency_max: 500–8000
            - intensity: 0.1–1.0
            - interpretation: texto descriptivo breve en español
            """;

    private static final String CONVERSATION_CONTEXT = """
            El usuario describe libremente qué tipo de música quiere escuchar. \
            Interpreta su descripción emocional y devuelve los parámetros musicales \
            que mejor capturen su intención.

            Descripción:
            """;

    private MusicPromptBuilder() {
    }

    public static String systemPrompt() {
        return SYSTEM_PROMPT;
    }

    public static String conversationSystemPrompt() {
        return CONVERSATION_SYSTEM_PROMPT;
    }

    public static String userPrompt(final String content, final String sourceType) {
        return switch (sourceType) {
            case "code" -> CODE_CONTEXT + "\n```\n" + content + "\n```";
            case "words" -> WORDS_CONTEXT + "\n" + content;
            case "conversation" -> CONVERSATION_CONTEXT + "\n" + content;
            default -> TEXT_CONTEXT + "\n" + content;
        };
    }
}
