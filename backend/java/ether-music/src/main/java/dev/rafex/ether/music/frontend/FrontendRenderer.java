package dev.rafex.ether.music.frontend;

import java.nio.file.Path;

import gg.jte.ContentType;
import gg.jte.TemplateEngine;
import gg.jte.output.StringOutput;

public final class FrontendRenderer {

    private final TemplateEngine templateEngine;

    public FrontendRenderer(final Path templateDirectory) {
        this.templateEngine = TemplateEngine.createPrecompiled(ContentType.Plain);
    }

    public String renderHome(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/home.jte", model, output);
        return output.toString();
    }
}
