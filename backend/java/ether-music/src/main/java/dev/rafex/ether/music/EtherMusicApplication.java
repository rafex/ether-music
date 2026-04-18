package dev.rafex.ether.music;

import java.nio.file.Path;
import java.util.List;

import org.eclipse.jetty.server.ServerConnector;

import dev.rafex.ether.http.jetty12.JettyServerConfig;
import dev.rafex.ether.http.jetty12.JettyServerFactory;
import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.json.JacksonJsonCodec;
import dev.rafex.ether.music.melody.MelodyGenerator;
import dev.rafex.ether.music.web.MusicModule;

public final class EtherMusicApplication {

    private EtherMusicApplication() {
    }

    public static void main(final String[] args) throws Exception {
        final var config = JettyServerConfig.fromEnv();
        final var jsonCodec = new JacksonJsonCodec();
        final var renderer = new FrontendRenderer(Path.of("src/main/jte"));
        final var module = new MusicModule(renderer, new MelodyGenerator());

        final var runner = JettyServerFactory.create(config, jsonCodec, null, List.of(module));
        runner.start();

        final var connector = (ServerConnector) runner.server().getConnectors()[0];
        System.out.printf("ether-music escuchando en http://127.0.0.1:%d%n", connector.getLocalPort());

        runner.await();
    }
}
