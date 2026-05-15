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
            --bg: #0b0f16;
            --panel: #141b26;
            --line: #223046;
            --text: #e8eefc;
            --muted: #9fb0c9;
            --accent: #57f0ff;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            background: radial-gradient(circle at top left, rgba(87, 240, 255, 0.16), transparent 30%), var(--bg);
            color: var(--text);
            font-family: "Segoe UI", sans-serif;
            padding: 24px;
        }
        .shell {
            max-width: 1100px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 16px;
        }
        .panel {
            border: 1px solid var(--line);
            background: var(--panel);
            border-radius: 12px;
            padding: 18px;
        }
        h1 { margin: 0 0 8px 0; }
        .muted { color: var(--muted); }
        .row {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 8px;
            margin-top: 10px;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .row button {
            border: 1px solid var(--line);
            color: var(--text);
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            padding: 8px 10px;
            cursor: pointer;
        }
        .row button:hover { border-color: var(--accent); }
        audio { width: 100%; margin-top: 14px; }
        .small { font-size: 0.82rem; color: var(--muted); }
        @media (max-width: 920px) { .shell { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<main class="shell">
    <section class="panel">
        <h1>Player individual (On-Demand)</h1>
        <p class="muted">Cada usuario reproduce su propia canción usando HTTP Range. Biblioteca: <code>${model.apiEndpoint()}</code></p>
        <div>
            <input id="search" type="search" placeholder="Filtrar por título o artista" style="width:100%;padding:10px;border-radius:8px;border:1px solid var(--line);background:#0f141d;color:var(--text);">
        </div>
        <div id="tracks"></div>
    </section>

    <aside class="panel">
        <h2 style="margin-top:0;">Reproductor</h2>
        <p id="now-title" style="margin:0;font-weight:700;">Selecciona una canción</p>
        <p id="now-meta" class="small">Aún sin reproducción.</p>
        <audio id="audio" controls preload="metadata"></audio>
        <p class="small">Este modo es independiente del stream <code>/live</code>.</p>
        <p><a href="/radio" style="color:var(--accent);">Ir a Radio Live</a></p>
    </aside>
</main>
<script>
    let tracks = [];
    let filtered = [];
    const listEl = document.getElementById("tracks");
    const searchEl = document.getElementById("search");
    const audioEl = document.getElementById("audio");
    const nowTitle = document.getElementById("now-title");
    const nowMeta = document.getElementById("now-meta");

    function esc(v) {
        return String(v || "").replace(/[&<>"']/g, function(s) {
            return ({ "&":"&amp;", "<":"&lt;", ">":"&gt;", "\"":"&quot;", "'":"&#39;" })[s];
        });
    }

    function render() {
        if (!filtered.length) {
            listEl.innerHTML = "<p class=\"muted\">Sin resultados.</p>";
            return;
        }
        let html = "";
        for (const track of filtered) {
            const meta = (track.artist || "Unknown") + " · " + (track.album || "Sin álbum");
            html += "<div class=\"row\">";
            html += "<div><strong>" + esc(track.title) + "</strong><div class=\"small\">" + esc(meta) + "</div></div>";
            html += "<button data-id=\"" + esc(track.id) + "\">Play</button></div>";
        }
        listEl.innerHTML = html;
        listEl.querySelectorAll("button[data-id]").forEach((btn) => {
            btn.addEventListener("click", () => {
                const track = filtered.find((t) => t.id === btn.dataset.id);
                if (!track) return;
                audioEl.src = "/api/stream/" + track.id;
                audioEl.play().catch(() => {});
                nowTitle.textContent = track.title || "Sin título";
                nowMeta.textContent = (track.artist || "Unknown") + " · " + (track.album || "Sin álbum");
            });
        });
    }

    function applyFilter() {
        const q = searchEl.value.trim().toLowerCase();
        filtered = !q ? tracks : tracks.filter((t) => {
            return (t.title || "").toLowerCase().includes(q)
                || (t.artist || "").toLowerCase().includes(q)
                || (t.album || "").toLowerCase().includes(q);
        });
        render();
    }

    fetch("/api/library/songs?limit=5000")
        .then((res) => res.json())
        .then((data) => {
            tracks = Array.isArray(data) ? data : [];
            filtered = tracks;
            render();
        })
        .catch(() => {
            listEl.innerHTML = "<p class=\"muted\">No se pudo cargar la biblioteca.</p>";
        });

    searchEl.addEventListener("input", applyFilter);
</script>
</body>
</html>
