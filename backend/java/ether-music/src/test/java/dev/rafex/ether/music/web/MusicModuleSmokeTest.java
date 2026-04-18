package dev.rafex.ether.music.web;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.util.List;

import org.eclipse.jetty.server.ServerConnector;
import org.junit.jupiter.api.Test;

import dev.rafex.ether.http.jetty12.JettyServerConfig;
import dev.rafex.ether.http.jetty12.JettyServerFactory;
import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.json.JacksonJsonCodec;
import dev.rafex.ether.music.melody.MelodyGenerator;

class MusicModuleSmokeTest {

    @Test
    void shouldServeHomePageAndMelodyApi() throws Exception {
        final var config = new JettyServerConfig(0, 24, 8, 10_000, "ether-music-test", "test");
        final var jsonCodec = new JacksonJsonCodec();
        final var module = new MusicModule(new FrontendRenderer(Path.of("src/main/jte")), new MelodyGenerator());
        final var runner = JettyServerFactory.create(config, jsonCodec, null, List.of(module));
        runner.start();

        try {
            final var connector = (ServerConnector) runner.server().getConnectors()[0];
            final var baseUrl = "http://127.0.0.1:" + connector.getLocalPort();
            final var client = HttpClient.newHttpClient();

            final var pageResponse = client.send(
                    HttpRequest.newBuilder(URI.create(baseUrl + "/")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            assertEquals(200, pageResponse.statusCode());
            assertTrue(pageResponse.body().contains("ETHER"));

            final var apiResponse = client.send(
                    HttpRequest.newBuilder(URI.create(baseUrl + "/api/melodies/generate?root=D&scale=major&steps=8"))
                            .GET()
                            .build(),
                    HttpResponse.BodyHandlers.ofString());
            assertEquals(200, apiResponse.statusCode());
            assertTrue(apiResponse.body().contains("\"root\":\"D\""));
            assertTrue(apiResponse.body().contains("\"melody\""));
        } finally {
            runner.stop();
        }
    }
}
