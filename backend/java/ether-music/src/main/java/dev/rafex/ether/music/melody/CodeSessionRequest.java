package dev.rafex.ether.music.melody;

public record CodeSessionRequest(int keystrokesPerMinute, int errorsLastMinute, int linesWritten, int deletions) {
}
