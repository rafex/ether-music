@param dev.rafex.ether.music.frontend.HomePageModel model
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${model.title()}</title>
    <link rel="manifest" href="/manifest.json">
    <meta name="theme-color" content="#00e5ff">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="apple-mobile-web-app-title" content="Ether Music">
    <link rel="apple-touch-icon" href="/icons/icon.svg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Bebas+Neue&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #090b0f;
            --surface: #0d1117;
            --panel: #111820;
            --border: #1e2d3d;
            --accent: #00e5ff;
            --accent2: #ff6b35;
            --accent3: #a8ff3e;
            --text: #c9d6df;
            --muted: #5f7486;
            --font-mono: "Share Tech Mono", monospace;
            --font-display: "Bebas Neue", sans-serif;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background:
                radial-gradient(circle at top, rgba(0, 229, 255, 0.12), transparent 30%),
                linear-gradient(180deg, #05070a 0%, #090b0f 100%);
            color: var(--text);
            font-family: var(--font-mono);
            padding: 24px;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            background: repeating-linear-gradient(
                0deg,
                transparent,
                transparent 2px,
                rgba(0, 229, 255, 0.015) 2px,
                rgba(0, 229, 255, 0.015) 4px
            );
        }

        main {
            position: relative;
            z-index: 1;
            width: min(1200px, 100%);
            margin: 0 auto;
        }

        header {
            margin-bottom: 24px;
        }

        h1 {
            margin: 0 0 4px 0;
            font-family: var(--font-display);
            font-size: clamp(2rem, 7vw, 5rem);
            letter-spacing: 0.08em;
            line-height: 0.95;
            color: var(--accent);
            text-shadow: 0 0 32px rgba(0, 229, 255, 0.25);
        }

        .subtitle {
            margin: 0;
            font-size: 0.82rem;
            letter-spacing: 0.22em;
            color: var(--muted);
            text-transform: uppercase;
        }

        .filter-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
            flex-wrap: wrap;
            align-items: center;
        }

        .filter-btn {
            padding: 8px 16px;
            border: 1px solid var(--border);
            background: transparent;
            color: var(--text);
            font-family: var(--font-mono);
            font-size: 0.75rem;
            letter-spacing: 0.08em;
            cursor: pointer;
            border-radius: 4px;
            transition: all 0.2s ease;
            text-transform: uppercase;
        }

        .filter-btn:hover,
        .filter-btn.active {
            border-color: var(--accent);
            color: var(--accent);
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .song-card {
            position: relative;
            background: rgba(17, 24, 32, 0.92);
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .song-card:hover {
            border-color: var(--accent);
            box-shadow: 0 8px 24px rgba(0, 229, 255, 0.1);
            transform: translateY(-4px);
        }

        .card-thumb {
            width: 100%;
            aspect-ratio: 1;
            background: linear-gradient(135deg, rgba(0, 229, 255, 0.1), rgba(255, 107, 53, 0.1));
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            font-size: 2.5rem;
        }

        .card-waveform {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2px;
            padding: 8px;
        }

        .waveform-bar {
            width: 3px;
            background: var(--accent);
            border-radius: 1px;
            opacity: 0.6;
        }

        .play-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .song-card:hover .play-overlay {
            opacity: 1;
        }

        .play-btn {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: var(--accent);
            border: none;
            color: var(--bg);
            font-size: 1.4rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .play-btn:hover {
            transform: scale(1.1);
        }

        .card-content {
            padding: 16px;
        }

        .card-title {
            margin: 0 0 8px 0;
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text);
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .card-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            font-size: 0.7rem;
            color: var(--muted);
            margin-bottom: 8px;
        }

        .card-badge {
            background: rgba(0, 229, 255, 0.15);
            padding: 2px 8px;
            border-radius: 3px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .card-date {
            font-size: 0.65rem;
            color: var(--muted);
        }

        .empty-state {
            text-align: center;
            padding: 64px 24px;
            color: var(--muted);
        }

        .empty-state h2 {
            font-family: var(--font-display);
            font-size: 1.8rem;
            margin: 0 0 12px 0;
            color: var(--text);
        }

        .empty-state p {
            font-size: 0.9rem;
            margin: 0 0 24px 0;
        }

        .empty-state a {
            display: inline-block;
            padding: 12px 24px;
            border: 1px solid var(--accent);
            color: var(--accent);
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.2s ease;
        }

        .empty-state a:hover {
            background: rgba(0, 229, 255, 0.1);
        }

        @media (max-width: 720px) {
            .grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 16px;
            }

            .card-content {
                padding: 12px;
            }

            .card-title {
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
    <main>
        <header>
            <h1>ETHER</h1>
            <p class="subtitle">Mi Biblioteca</p>
        </header>

        <div class="filter-bar" id="filters">
            <button class="filter-btn active" data-filter="all">Todo</button>
            <button class="filter-btn" data-filter="classic">Clásico</button>
            <button class="filter-btn" data-filter="express">Express</button>
            <button class="filter-btn" data-filter="words">Palabras</button>
            <button class="filter-btn" data-filter="code">Código</button>
        </div>

        <div class="grid" id="songs-grid">
            <div class="empty-state">
                <h2>Biblioteca vacía</h2>
                <p>Aún no hay canciones guardadas. Crea tu primera melodía.</p>
                <a href="/create">ir a crear</a>
            </div>
        </div>
    </main>

    <script>
        let allSongs = [];
        let currentFilter = "all";
        let audioCtx = null;
        let masterGain = null;
        let scheduledTimeouts = [];

        function initAudio() {
            if (audioCtx) return;
            audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            masterGain = audioCtx.createGain();
            masterGain.gain.value = 0.25;
            masterGain.connect(audioCtx.destination);
        }

        function clearPlaybackState() {
            scheduledTimeouts.forEach(function(id) { clearTimeout(id); });
            scheduledTimeouts = [];
        }

        function scheduleStep(stepInfo, when, duration) {
            if (!audioCtx || !masterGain || stepInfo.rest || !stepInfo.frequencyHz) {
                return;
            }
            const oscillator = audioCtx.createOscillator();
            const gain = audioCtx.createGain();
            oscillator.type = "sine";
            oscillator.frequency.setValueAtTime(stepInfo.frequencyHz, when);
            gain.gain.setValueAtTime(0.0001, when);
            gain.gain.linearRampToValueAtTime(0.75, when + 0.01);
            gain.gain.exponentialRampToValueAtTime(0.45, when + Math.max(duration - 0.04, 0.02));
            gain.gain.exponentialRampToValueAtTime(0.0001, when + duration);
            oscillator.connect(gain);
            gain.connect(masterGain);
            oscillator.start(when);
            oscillator.stop(when + duration);
        }

        function playMelody(song) {
            initAudio();
            clearPlaybackState();
            if (audioCtx.state === "suspended") {
                audioCtx.resume();
            }
            const bpm = song.bpm || 110;
            const stepDuration = (60 / bpm) / 2;
            const startAt = audioCtx.currentTime + 0.08;
            const melody = song.melody || [];
            for (let i = 0; i < melody.length; i++) {
                scheduleStep(melody[i], startAt + (i * stepDuration), stepDuration * 0.85);
            }
        }

        function loadSongs() {
            const grid = document.getElementById("songs-grid");
            fetch("/api/songs")
                .then(function(res) {
                    if (!res.ok) throw new Error("status " + res.status);
                    return res.json();
                })
                .then(function(songs) {
                    allSongs = songs;
                    renderSongs();
                })
                .catch(function(e) {
                    grid.innerHTML = "<div class=\"empty-state\"><h2>Error</h2><p>" + e.message + "</p></div>";
                });
        }

        function renderSongs() {
            const grid = document.getElementById("songs-grid");
            let filtered = [];
            if (currentFilter === "all") {
                filtered = allSongs;
            } else {
                for (let i = 0; i < allSongs.length; i++) {
                    const src = (allSongs[i].source || "classic").toLowerCase();
                    if (src === currentFilter) {
                        filtered.push(allSongs[i]);
                    }
                }
            }

            if (filtered.length === 0) {
                grid.innerHTML = "<div class=\"empty-state\" style=\"grid-column:1/-1;\"><h2>Sin resultados</h2><p>No hay canciones con este filtro.</p></div>";
                return;
            }

            grid.innerHTML = "";
            for (let idx = 0; idx < filtered.length; idx++) {
                const song = filtered[idx];
                const card = document.createElement("div");
                card.className = "song-card";

                const bars = Math.min(16, song.steps || 8);
                let waveformHTML = "";
                for (let i = 0; i < bars; i++) {
                    const h = Math.random() * 70 + 10;
                    waveformHTML += "<div class=\"waveform-bar\" style=\"height:" + h + "%;\"></div>";
                }

                const ts = song.createdAt ? new Date(song.createdAt).toLocaleDateString() : "---";
                const interp = song.interpretation || "Sin titulo";
                const src = song.source || "?";
                const bpmVal = song.bpm || "---";

                let html = "<div class=\"card-thumb\"><div class=\"card-waveform\">";
                html = html + waveformHTML + "</div>";
                html = html + "<div class=\"play-overlay\"><button class=\"play-btn\" data-id=\"" + song.id + "\">⏵</button></div>";
                html = html + "</div><div class=\"card-content\"><h3 class=\"card-title\">" + interp + "</h3>";
                html = html + "<div class=\"card-meta\"><span class=\"card-badge\">" + src + "</span>";
                html = html + "<span>" + bpmVal + " BPM</span></div>";
                html = html + "<div class=\"card-date\">" + ts + "</div></div>";

                card.innerHTML = html;

                const playBtn = card.querySelector(".play-btn");
                playBtn.addEventListener("click", (function(songId) {
                    return function(e) {
                        e.preventDefault();
                        fetch("/api/songs/" + songId)
                            .then(function(res) {
                                if (!res.ok) throw new Error("status " + res.status);
                                return res.json();
                            })
                            .then(function(full) {
                                playMelody(full);
                            })
                            .catch(function(e) {
                                console.error("Play error:", e);
                            });
                    };
                })(song.id));

                grid.appendChild(card);
            }
        }

        const filterBtns = document.querySelectorAll(".filter-btn");
        for (let i = 0; i < filterBtns.length; i++) {
            filterBtns[i].addEventListener("click", function() {
                for (let j = 0; j < filterBtns.length; j++) {
                    filterBtns[j].classList.remove("active");
                }
                this.classList.add("active");
                currentFilter = this.getAttribute("data-filter");
                renderSongs();
            });
        }

        window.addEventListener("beforeunload", function() {
            clearPlaybackState();
        });

        if (navigator.serviceWorker) {
            window.addEventListener("load", function() {
                navigator.serviceWorker.register("/sw.js", { scope: "/" })
                    .catch(function(err) {
                        console.warn("SW error:", err);
                    });
            });
        }

        loadSongs();
    </script>
</body>
</html>
