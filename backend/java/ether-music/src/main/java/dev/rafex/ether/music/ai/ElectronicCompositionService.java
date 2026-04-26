package dev.rafex.ether.music.ai;

import java.io.IOException;

import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.melody.MelodyGenerator;
import dev.rafex.ether.music.melody.MelodyRequest;

public final class ElectronicCompositionService {

    private final LlmAnalysisPort llm;
    private final MelodyGenerator melodyGenerator;
    private final SongRepository repository;

    public ElectronicCompositionService(final LlmAnalysisPort llm, final MelodyGenerator melodyGenerator,
            final SongRepository repository) {
        this.llm = llm;
        this.melodyGenerator = melodyGenerator;
        this.repository = repository;
    }

    public ComposedResponse composeFromCode(final String code) throws IOException, InterruptedException {
        return compose(code, "code");
    }

    public ComposedResponse composeFromText(final String text) throws IOException, InterruptedException {
        return compose(text, "text");
    }

    public ComposedResponse composeFromWords(final String wordsJson) throws IOException, InterruptedException {
        return compose(wordsJson, "words");
    }

    public ComposedResponse composeFromConversation(final String description) throws IOException, InterruptedException {
        return compose(description, "conversation");
    }

    private ComposedResponse compose(final String content, final String sourceType)
            throws IOException, InterruptedException {
        final ElectronicCompositionParams params = llm.analyzeForMusic(content, sourceType);

        final var melodyReq = new MelodyRequest(params.root(), params.scale(), params.octave(), params.steps());
        final var melodyResp = melodyGenerator.generate(melodyReq);

        final var composed = ComposedResponse.from(
                "electronic-" + sourceType,
                params.interpretation(),
                params.tempoBpm(),
                melodyResp);

        if (repository != null) {
            try {
                repository.save(composed);
            } catch (Exception e) {
                // No bloquear la respuesta si falla el guardado
            }
        }

        return composed;
    }
}
