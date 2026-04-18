package dev.rafex.ether.music;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import org.eclipse.jetty.server.ServerConnector;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.http.jetty12.JettyServerConfig;
import dev.rafex.ether.http.jetty12.JettyServerFactory;
import dev.rafex.ether.jdbc.client.JdbcDatabaseClient;
import dev.rafex.ether.jdbc.datasource.SimpleDataSource;
import dev.rafex.ether.music.ai.DeepSeekMusicAnalyzer;
import dev.rafex.ether.music.ai.ElectronicCompositionService;
import dev.rafex.ether.music.db.SchemaInitializer;
import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.json.JacksonJsonCodec;
import dev.rafex.ether.music.melody.MelodyGenerator;
import dev.rafex.ether.music.web.MusicModule;

public final class EtherMusicApplication {

    private EtherMusicApplication() {
    }

    public static void main(final String[] args) throws Exception {
        Files.createDirectories(Path.of("data"));

        final var dataSource = new SimpleDataSource("jdbc:sqlite:./data/ether-music.db");
        final var db = new JdbcDatabaseClient(dataSource);
        SchemaInitializer.initialize(db);
        final var repository = new SongRepository(db, new ObjectMapper());

        final var config = JettyServerConfig.fromEnv();
        final var jsonCodec = new JacksonJsonCodec();
        final var renderer = new FrontendRenderer(Path.of("src/main/jte"));
        final var melodyGenerator = new MelodyGenerator();

        final var deepseekApiKey = System.getenv("DEEPSEEK_API_KEY");
        ElectronicCompositionService electronicService = null;
        if (deepseekApiKey != null && !deepseekApiKey.isBlank()) {
            final var llm = new DeepSeekMusicAnalyzer(deepseekApiKey);
            electronicService = new ElectronicCompositionService(llm, melodyGenerator, repository);
            System.out.println("ether-music LLM electrónica activada (DeepSeek)");
        } else {
            System.out.println("ether-music DEEPSEEK_API_KEY no configurada — endpoints /api/electronic/* desactivados");
        }

        final var module = new MusicModule(renderer, melodyGenerator, repository, electronicService);

        final var runner = JettyServerFactory.create(config, jsonCodec, null, List.of(module));
        runner.start();

        final var connector = (ServerConnector) runner.server().getConnectors()[0];
        System.out.printf("ether-music escuchando en http://127.0.0.1:%d%n", connector.getLocalPort());

        runner.await();
    }
}
