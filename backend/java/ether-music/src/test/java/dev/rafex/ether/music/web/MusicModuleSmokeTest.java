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
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;

import dev.rafex.ether.http.jetty12.JettyServerConfig;
import dev.rafex.ether.http.jetty12.JettyServerFactory;
import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.json.JacksonJsonCodec;
import dev.rafex.ether.music.melody.MelodyGenerator;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class MusicModuleSmokeTest {

    private Object runner;
    private String baseUrl;
    private HttpClient client;

    @BeforeAll
    void startServer() throws Exception {
        final var config = new JettyServerConfig(0, 24, 8, 10_000, "ether-music-test", "test");
        final var jsonCodec = new JacksonJsonCodec();
        final var module = new MusicModule(new FrontendRenderer(Path.of("src/main/jte")), new MelodyGenerator());
        runner = JettyServerFactory.create(config, jsonCodec, null, List.of(module));
        ((dev.rafex.ether.http.jetty12.JettyServerRunner) runner).start();
        final var connector = (ServerConnector) ((dev.rafex.ether.http.jetty12.JettyServerRunner) runner).server().getConnectors()[0];
        baseUrl = "http://127.0.0.1:" + connector.getLocalPort();
        client = HttpClient.newHttpClient();
    }

    @AfterAll
    void stopServer() throws Exception {
        ((dev.rafex.ether.http.jetty12.JettyServerRunner) runner).stop();
    }

    @Test
    void indexPageDevuelve200() throws Exception {
        final var res = client.send(
                HttpRequest.newBuilder(URI.create(baseUrl + "/")).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("ETHER"));
    }

    @Test
    void createPageDevuelve200() throws Exception {
        final var res = client.send(
                HttpRequest.newBuilder(URI.create(baseUrl + "/create")).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("ETHER MUSIC"));
    }

    @Test
    void playPageDevuelve200() throws Exception {
        final var res = client.send(
                HttpRequest.newBuilder(URI.create(baseUrl + "/play")).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("Biblioteca"));
    }

    @Test
    void electronicPageDevuelve200() throws Exception {
        final var res = client.send(
                HttpRequest.newBuilder(URI.create(baseUrl + "/electronic")).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("ELECTR"));
    }

    @Test
    void agentPageDevuelve200() throws Exception {
        final var res = client.send(
                HttpRequest.newBuilder(URI.create(baseUrl + "/agent")).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("AGENTE"));
    }

    @Test
    void melodyApiDevuelveComposicion() throws Exception {
        final var res = client.send(
                HttpRequest.newBuilder(URI.create(baseUrl + "/api/melodies/generate?root=D&scale=major&steps=8"))
                        .GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("\"root\":\"D\""));
        assertTrue(res.body().contains("\"melody\""));
    }

    @Test
    void synthesizeApiDevuelveWav() throws Exception {
        final var body = "{\"melody\":[{\"step\":0,\"rest\":false,\"noteIndex\":0,\"noteName\":\"A4\",\"frequencyHz\":440.0}],"
                + "\"bpm\":120,\"synthesizer\":\"fm\",\"effectReverb\":0.0,\"effectDelay\":0.0,\"intensity\":0.8}";
        final var res = client.send(
                HttpRequest.newBuilder(URI.create(baseUrl + "/api/synthesize"))
                        .POST(HttpRequest.BodyPublishers.ofString(body))
                        .header("content-type", "application/json")
                        .build(),
                HttpResponse.BodyHandlers.ofByteArray());
        assertEquals(200, res.statusCode());
        assertTrue(res.headers().firstValue("content-type").orElse("").contains("audio/wav"));
        final byte[] wav = res.body();
        assertTrue(wav.length > 44);
        assertEquals('R', wav[0]);
        assertEquals('I', wav[1]);
        assertEquals('F', wav[2]);
        assertEquals('F', wav[3]);
    }
}
