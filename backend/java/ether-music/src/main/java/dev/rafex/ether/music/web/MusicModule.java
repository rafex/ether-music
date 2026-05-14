package dev.rafex.ether.music.web;

import dev.rafex.ether.http.jetty12.JettyModule;
import dev.rafex.ether.http.jetty12.JettyModuleContext;
import dev.rafex.ether.http.jetty12.JettyRouteRegistry;
import dev.rafex.ether.music.ai.ElectronicCompositionService;
import dev.rafex.ether.music.db.SongRepository;
import dev.rafex.ether.music.frontend.FrontendRenderer;
import dev.rafex.ether.music.melody.MelodyGenerator;
import dev.rafex.ether.music.radio.RadioService;

public final class MusicModule implements JettyModule {

    private final FrontendRenderer renderer;
    private final MelodyGenerator melodyGenerator;
    private final SongRepository repository;
    private final ElectronicCompositionService electronicService;
    private final RadioService radioService;

    public MusicModule(final FrontendRenderer renderer, final MelodyGenerator melodyGenerator) {
        this(renderer, melodyGenerator, null, null, RadioService.fromEnv());
    }

    public MusicModule(final FrontendRenderer renderer, final MelodyGenerator melodyGenerator,
            final SongRepository repository) {
        this(renderer, melodyGenerator, repository, null, RadioService.fromEnv());
    }

    public MusicModule(final FrontendRenderer renderer, final MelodyGenerator melodyGenerator,
            final SongRepository repository, final ElectronicCompositionService electronicService) {
        this(renderer, melodyGenerator, repository, electronicService, RadioService.fromEnv());
    }

    public MusicModule(final FrontendRenderer renderer, final MelodyGenerator melodyGenerator,
            final SongRepository repository, final ElectronicCompositionService electronicService,
            final RadioService radioService) {
        this.renderer = renderer;
        this.melodyGenerator = melodyGenerator;
        this.repository = repository;
        this.electronicService = electronicService;
        this.radioService = radioService;
    }

    @Override
    public void registerRoutes(final JettyRouteRegistry routes, final JettyModuleContext context) {
        final var pwa = new PwaStaticHandler();
        routes.add("/health", new HealthHandler());
        routes.add("/manifest.json", pwa);
        routes.add("/sw.js", pwa);
        routes.add("/icons/*", pwa);
        routes.add("/", new IndexPageHandler(renderer));
        routes.add("/create", new CreatePageHandler(renderer));
        routes.add("/play", new PlayPageHandler(renderer));
        routes.add("/radio", new RadioPageHandler(renderer, radioService));
        routes.add("/electronic", new ElectronicPageHandler(renderer));
        routes.add("/agent", new AgentPageHandler(renderer));
        routes.add("/conversation", new ConversationPageHandler(renderer));
        routes.add("/feedback", new FeedbackPageHandler(renderer));
        routes.add("/visual-input", new VisualInputPageHandler(renderer));
        routes.add("/sequencer", new SequencerPageHandler(renderer));
        routes.add("/api/synthesize", new SynthesizeHandler());
        routes.add("/api/melodies/*", new MelodyApiHandler(context.jsonCodec(), melodyGenerator, repository));
        routes.add("/api/express/*", new ExpressApiHandler(context.jsonCodec(), melodyGenerator, repository));
        routes.add("/api/data/*", new DataApiHandler(context.jsonCodec(), melodyGenerator, repository));
        routes.add("/api/feedback", new FeedbackApiHandler(melodyGenerator, repository));
        routes.add("/api/compose/emojis", new EmojiCompositionHandler(melodyGenerator, repository));
        routes.add("/api/compose/color", new ColorCompositionHandler(melodyGenerator, repository));
        routes.add("/api/compose/graphic", new GraphicCompositionHandler(repository));
        routes.add("/api/radio/*", new RadioApiHandler(radioService));

        if (repository != null) {
            final var songsHandler = new SongsApiHandler(context.jsonCodec(), repository);
            routes.add("/api/songs", songsHandler);
            routes.add("/api/songs/*", songsHandler);
            routes.add("/api/songs-wav/*", new SongWavHandler(repository));
        }

        if (electronicService != null) {
            final var electronicHandler = new ElectronicCompositionHandler(electronicService);
            routes.add("/api/electronic/*", electronicHandler);
        }
    }
}
