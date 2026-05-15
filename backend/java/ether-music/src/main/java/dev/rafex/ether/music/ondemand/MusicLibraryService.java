package dev.rafex.ether.music.ondemand;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Stream;

public final class MusicLibraryService {

    private static final Set<String> AUDIO_EXTENSIONS = Set.of("mp3", "flac", "ogg", "oga", "wav", "aac", "m4a");

    private final Path rootDirectory;

    public MusicLibraryService(final Path rootDirectory) {
        this.rootDirectory = rootDirectory;
    }

    public static MusicLibraryService fromEnv() {
        final String explicit = System.getenv("MUSIC_LIBRARY_DIR");
        if (explicit != null && !explicit.isBlank()) {
            return new MusicLibraryService(expandHome(explicit.strip()));
        }
        return new MusicLibraryService(Path.of(System.getProperty("user.home"), "Music"));
    }

    public String rootDirectoryText() {
        return rootDirectory.toAbsolutePath().normalize().toString();
    }

    public List<OnDemandTrack> listTracks(final int maxItems) {
        if (!Files.isDirectory(rootDirectory)) {
            return List.of();
        }

        final var tracks = new ArrayList<OnDemandTrack>();
        try (Stream<Path> stream = Files.walk(rootDirectory)) {
            stream.filter(Files::isRegularFile)
                    .filter(this::isAudioFile)
                    .sorted(Comparator.comparing(path -> path.toString().toLowerCase(Locale.ROOT)))
                    .limit(Math.max(1, maxItems))
                    .forEach(path -> tracks.add(toTrack(path)));
        } catch (final IOException ignored) {
            return List.of();
        }
        return tracks;
    }

    public Optional<Path> resolveById(final String encodedId) {
        if (encodedId == null || encodedId.isBlank()) {
            return Optional.empty();
        }
        try {
            final byte[] decoded = Base64.getUrlDecoder().decode(encodedId);
            final String relative = new String(decoded, StandardCharsets.UTF_8);
            final Path resolved = rootDirectory.resolve(relative).normalize();
            if (!resolved.startsWith(rootDirectory.normalize()) || !Files.exists(resolved) || !Files.isRegularFile(resolved)) {
                return Optional.empty();
            }
            return Optional.of(resolved);
        } catch (final IllegalArgumentException ignored) {
            return Optional.empty();
        }
    }

    private boolean isAudioFile(final Path path) {
        final String extension = extension(path);
        return AUDIO_EXTENSIONS.contains(extension);
    }

    private OnDemandTrack toTrack(final Path path) {
        final Path relative = rootDirectory.relativize(path);
        final String id = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(relative.toString().getBytes(StandardCharsets.UTF_8));
        final String extension = extension(path);
        final String mimeType = detectMimeType(path, extension);
        final long size = safeSize(path);

        final String baseName = baseName(path.getFileName().toString());
        final String[] parts = baseName.split(" - ", 2);
        final String artist = parts.length > 1 ? parts[0].strip() : "Unknown";
        final String title = parts.length > 1 ? parts[1].strip() : baseName;

        String album = "";
        final Path parent = relative.getParent();
        if (parent != null) {
            album = parent.toString();
        }

        return new OnDemandTrack(id, title, artist, album, extension, mimeType, size);
    }

    private static Path expandHome(final String raw) {
        if (raw.startsWith("~/")) {
            return Path.of(System.getProperty("user.home"), raw.substring(2));
        }
        if (raw.equals("~")) {
            return Path.of(System.getProperty("user.home"));
        }
        return Path.of(raw);
    }

    private static String extension(final Path path) {
        final String fileName = path.getFileName().toString();
        final int dot = fileName.lastIndexOf('.');
        if (dot < 0 || dot == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(dot + 1).toLowerCase(Locale.ROOT);
    }

    private static String baseName(final String fileName) {
        final int dot = fileName.lastIndexOf('.');
        return dot > 0 ? fileName.substring(0, dot) : fileName;
    }

    private static String detectMimeType(final Path path, final String extension) {
        try {
            final String mime = Files.probeContentType(path);
            if (mime != null && !mime.isBlank()) {
                return mime;
            }
        } catch (final IOException ignored) {
        }
        return switch (extension) {
            case "mp3" -> "audio/mpeg";
            case "flac" -> "audio/flac";
            case "ogg", "oga" -> "audio/ogg";
            case "wav" -> "audio/wav";
            case "aac" -> "audio/aac";
            case "m4a" -> "audio/mp4";
            default -> "application/octet-stream";
        };
    }

    private static long safeSize(final Path path) {
        try {
            return Files.size(path);
        } catch (final IOException ignored) {
            return -1L;
        }
    }
}
