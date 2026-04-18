package dev.rafex.ether.music.ai;

import java.io.IOException;

public interface LlmAnalysisPort {

    ElectronicCompositionParams analyzeForMusic(String content, String sourceType) throws IOException, InterruptedException;
}
