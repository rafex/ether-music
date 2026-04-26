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

    public String renderIndex(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/index.jte", model, output);
        return output.toString();
    }

    public String renderCreate(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/create.jte", model, output);
        return output.toString();
    }

    public String renderPlay(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/play.jte", model, output);
        return output.toString();
    }

    public String renderElectronic(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/electronic.jte", model, output);
        return output.toString();
    }

    public String renderAgent(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/agent.jte", model, output);
        return output.toString();
    }

    public String renderConversation(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/conversation.jte", model, output);
        return output.toString();
    }

    public String renderFeedback(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/feedback.jte", model, output);
        return output.toString();
    }

    public String renderVisualInput(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/visual-input.jte", model, output);
        return output.toString();
    }

    public String renderSequencer(final HomePageModel model) {
        final var output = new StringOutput();
        templateEngine.render("pages/sequencer.jte", model, output);
        return output.toString();
    }
}
