package dev.rafex.ether.music.radio;

public final class RadioHtmlRenderer {

    public String renderStatusFragment(final RadioState state) {
        final StringBuilder sb = new StringBuilder(2048);
        sb.append("<section id=\"radio-status\" class=\"player-shell\">");
        sb.append("<div class=\"player-header\">");
        sb.append("<h3>Now Playing</h3>");
        sb.append("<span class=\"badge ").append(state.online() ? "online" : "offline").append("\">");
        sb.append(state.online() ? "Online" : "Offline");
        sb.append("</span>");
        sb.append("</div>");
        sb.append("<p class=\"track-title\">").append(escape(state.nowPlaying().title())).append("</p>");
        sb.append("<p class=\"track-artist\">").append(escape(state.nowPlaying().artist())).append("</p>");
        sb.append("<p class=\"track-meta\">").append(escape(state.elapsed())).append(" / ")
                .append(escape(state.duration())).append("</p>");
        sb.append("<div class=\"volume-wrap\">");
        sb.append("<span>Volume</span><strong>").append(state.volume()).append("%</strong>");
        sb.append("</div>");
        sb.append("<div class=\"status-message\">").append(escape(state.statusMessage())).append("</div>");
        sb.append("</section>");
        return sb.toString();
    }

    public String renderPlaylistFragment(final RadioState state) {
        final StringBuilder sb = new StringBuilder(4096);
        sb.append("<section id=\"playlist-panel\" class=\"playlist-shell\">");
        sb.append("<h3>Playlist</h3>");
        if (state.playlist().isEmpty()) {
            sb.append("<p class=\"playlist-empty\">No hay tracks en cola o MPD no responde.</p>");
        } else {
            sb.append("<ol class=\"playlist-items\">");
            int index = 1;
            for (final var track : state.playlist()) {
                sb.append("<li>");
                sb.append("<span class=\"p-index\">").append(index++).append("</span>");
                sb.append("<div class=\"p-meta\">");
                sb.append("<p class=\"p-title\">").append(escape(track.title())).append("</p>");
                sb.append("<p class=\"p-artist\">").append(escape(track.artist())).append("</p>");
                sb.append("</div>");
                sb.append("<span class=\"p-time\">").append(escape(track.duration())).append("</span>");
                sb.append("</li>");
            }
            sb.append("</ol>");
        }
        sb.append("</section>");
        return sb.toString();
    }

    private static String escape(final String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
