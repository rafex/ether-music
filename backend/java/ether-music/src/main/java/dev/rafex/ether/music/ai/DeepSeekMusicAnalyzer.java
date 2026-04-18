package dev.rafex.ether.music.ai;

import java.io.IOException;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.ai.core.chat.AiChatRequest;
import dev.rafex.ether.ai.core.chat.AiChatModel;
import dev.rafex.ether.ai.core.message.AiMessage;
import dev.rafex.ether.ai.deepseek.chat.DeepSeekChatModel;
import dev.rafex.ether.ai.deepseek.config.DeepSeekConfig;

public final class DeepSeekMusicAnalyzer implements LlmAnalysisPort {

    private static final String MODEL = "deepseek-chat";

    private final AiChatModel model;
    private final ObjectMapper mapper;

    public DeepSeekMusicAnalyzer(final String apiKey) {
        this(new DeepSeekChatModel(DeepSeekConfig.of(apiKey)), new ObjectMapper());
    }

    DeepSeekMusicAnalyzer(final AiChatModel model, final ObjectMapper mapper) {
        this.model = model;
        this.mapper = mapper;
    }

    @Override
    public ElectronicCompositionParams analyzeForMusic(final String content, final String sourceType)
            throws IOException, InterruptedException {
        final var messages = List.of(
                AiMessage.system(MusicPromptBuilder.systemPrompt()),
                AiMessage.user(MusicPromptBuilder.userPrompt(content, sourceType)));

        final var request = new AiChatRequest(MODEL, messages, 0.7, 512);
        final var response = model.generate(request);
        return parseJson(response.text());
    }

    private ElectronicCompositionParams parseJson(final String rawText) throws IOException {
        final String json = extractJson(rawText);
        return mapper.readValue(json, ElectronicCompositionParams.class);
    }

    private static String extractJson(final String text) {
        if (text == null || text.isBlank()) {
            throw new IllegalArgumentException("Respuesta vacía del LLM");
        }
        final int start = text.indexOf('{');
        final int end = text.lastIndexOf('}');
        if (start == -1 || end == -1 || end < start) {
            throw new IllegalArgumentException("No se encontró JSON en la respuesta: " + text);
        }
        return text.substring(start, end + 1);
    }
}
