@param dev.rafex.ether.music.frontend.HomePageModel model
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${model.title()}</title>
    <script src="https://unpkg.com/htmx.org@2.0.4"></script>
    <style>
        :root {
            --bg0: #0a0f1f;
            --bg1: #13203e;
            --glass: rgba(13, 22, 44, 0.8);
            --line: rgba(255, 255, 255, 0.15);
            --text: #f3f6ff;
            --muted: #a9b7d1;
            --accent: #ffd166;
            --accent2: #73e2a7;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Nunito", "Segoe UI", sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at 15% 20%, rgba(115, 226, 167, 0.22), transparent 28%),
                radial-gradient(circle at 80% 10%, rgba(255, 209, 102, 0.22), transparent 26%),
                linear-gradient(140deg, var(--bg0) 0%, var(--bg1) 100%);
            padding: 24px;
        }

        .layout {
            width: min(1220px, 100%);
            margin: 0 auto;
            background: var(--glass);
            border: 1px solid var(--line);
            border-radius: 18px;
            backdrop-filter: blur(10px);
            display: grid;
            grid-template-columns: 240px 1fr 330px;
            overflow: hidden;
        }

        .menu {
            border-right: 1px solid var(--line);
            padding: 22px 14px;
        }

        .logo {
            font-size: 1.4rem;
            letter-spacing: 0.06em;
            font-weight: 800;
            margin: 0 0 18px 10px;
            color: var(--accent);
        }

        .menu a {
            display: block;
            padding: 10px 12px;
            margin: 6px 0;
            color: var(--text);
            text-decoration: none;
            border-radius: 10px;
            opacity: 0.9;
        }

        .menu a.active, .menu a:hover {
            background: rgba(255, 255, 255, 0.08);
            opacity: 1;
        }

        .content {
            padding: 26px;
            border-right: 1px solid var(--line);
        }

        h1 {
            margin: 0 0 14px 0;
            font-size: 1.7rem;
        }

        .hero {
            margin-bottom: 20px;
            color: var(--muted);
            line-height: 1.5;
        }

        .controls {
            display: grid;
            grid-template-columns: repeat(4, minmax(80px, 1fr));
            gap: 10px;
            margin-bottom: 12px;
        }

        .controls button {
            border: 1px solid var(--line);
            background: rgba(255, 255, 255, 0.08);
            color: var(--text);
            border-radius: 10px;
            padding: 10px;
            cursor: pointer;
            font-weight: 700;
        }

        .controls button:hover {
            background: rgba(255, 209, 102, 0.14);
            border-color: rgba(255, 209, 102, 0.6);
        }

        .volume {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
        }

        .volume input {
            width: 180px;
        }

        #playlist-panel {
            margin-top: 20px;
            border: 1px solid var(--line);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.04);
            padding: 12px;
        }

        .playlist-items {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .playlist-items li {
            display: grid;
            grid-template-columns: 30px 1fr 56px;
            gap: 10px;
            align-items: center;
            padding: 8px 4px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .playlist-items li:last-child { border-bottom: 0; }
        .p-index { color: var(--muted); font-size: 0.8rem; }
        .p-title { margin: 0; font-size: 0.92rem; font-weight: 700; }
        .p-artist { margin: 1px 0 0 0; font-size: 0.78rem; color: var(--muted); }
        .p-time { text-align: right; font-size: 0.82rem; color: var(--accent2); }

        .player {
            padding: 26px 18px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .player-card {
            border: 1px solid var(--line);
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.06);
            padding: 14px;
        }

        .player-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .player-header h3 {
            margin: 0;
            font-size: 0.95rem;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: var(--muted);
        }

        .badge {
            border-radius: 999px;
            padding: 4px 10px;
            font-size: 0.72rem;
            font-weight: 700;
        }

        .badge.online {
            background: rgba(115, 226, 167, 0.18);
            color: var(--accent2);
        }

        .badge.offline {
            background: rgba(255, 95, 109, 0.18);
            color: #ff7b7b;
        }

        .track-title {
            margin: 10px 0 0 0;
            font-size: 1.2rem;
            font-weight: 800;
        }

        .track-artist {
            margin: 4px 0 10px 0;
            color: var(--muted);
        }

        .track-meta {
            margin: 0;
            color: var(--accent);
            font-size: 0.9rem;
        }

        .volume-wrap {
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            color: var(--muted);
        }

        .status-message {
            margin-top: 10px;
            font-size: 0.8rem;
            color: var(--muted);
        }

        audio {
            width: 100%;
        }

        @media (max-width: 1060px) {
            .layout {
                grid-template-columns: 1fr;
            }
            .menu, .content {
                border-right: 0;
                border-bottom: 1px solid var(--line);
            }
        }
    </style>
</head>
<body>
<main class="layout">
    <aside class="menu">
        <h2 class="logo">ETHER RADIO</h2>
        <a href="/" >Inicio</a>
        <a href="/create">Crear</a>
        <a href="/play">Biblioteca</a>
        <a href="/electronic">Electrónica</a>
        <a href="/radio" class="active">Radio (MPD/Icecast)</a>
    </aside>

    <section class="content">
        <h1>Spotify casero</h1>
        <p class="hero">Controla `MPD`, escucha por `Icecast` y actualiza estado con `htmx` sin recarga.</p>

        <div class="controls">
            <button hx-post="/api/radio/control" hx-vals='{"action":"prev"}' hx-target="#radio-status" hx-swap="outerHTML">◀ Prev</button>
            <button hx-post="/api/radio/control" hx-vals='{"action":"play"}' hx-target="#radio-status" hx-swap="outerHTML">▶ Play</button>
            <button hx-post="/api/radio/control" hx-vals='{"action":"pause"}' hx-target="#radio-status" hx-swap="outerHTML">⏸ Pause</button>
            <button hx-post="/api/radio/control" hx-vals='{"action":"next"}' hx-target="#radio-status" hx-swap="outerHTML">Next ▶</button>
        </div>

        <form class="volume"
              hx-post="/api/radio/control"
              hx-target="#radio-status"
              hx-swap="outerHTML">
            <input type="hidden" name="action" value="volume">
            <label for="volume">Vol</label>
            <input id="volume" type="range" min="0" max="100" value="65" name="value">
            <button type="submit">Aplicar</button>
        </form>

        <audio controls autoplay preload="none">
            <source src="${model.apiEndpoint()}" type="audio/mpeg">
        </audio>

        <div id="playlist-panel"
             hx-get="/api/radio/playlist"
             hx-trigger="load, every 20s"
             hx-swap="outerHTML">
            <p>Cargando playlist...</p>
        </div>
    </section>

    <aside class="player">
        <div id="radio-status"
             class="player-card"
             hx-get="/api/radio/status"
             hx-trigger="load, every 5s"
             hx-swap="outerHTML">
            <p>Cargando estado del reproductor...</p>
        </div>
    </aside>
</main>
</body>
</html>
