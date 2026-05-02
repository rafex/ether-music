@param dev.rafex.ether.music.frontend.HomePageModel model
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${model.title()}</title>
    <link rel="manifest" href="/manifest.json">
    <meta name="theme-color" content="#00e5ff">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Bebas+Neue&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #090b0f; --surface: #0d1117; --panel: #111820; --border: #1e2d3d;
            --accent: #00e5ff; --accent2: #ff6b35; --accent3: #a8ff3e;
            --accent4: #bf5fff; --accent5: #ff6bdc;
            --text: #c9d6df; --muted: #5f7486;
            --font-mono: "Share Tech Mono", monospace; --font-display: "Bebas Neue", sans-serif;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh;
            background: radial-gradient(circle at top left, rgba(255, 107, 220, 0.07), transparent 35%),
                        radial-gradient(circle at bottom right, rgba(191, 95, 255, 0.06), transparent 35%),
                        linear-gradient(180deg, #05070a 0%, #090b0f 100%);
            color: var(--text); font-family: var(--font-mono); padding: 24px; display: flex; flex-direction: column;
        }
        body::before { content: ""; position: fixed; inset: 0; pointer-events: none; background: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(255, 107, 220, 0.006) 2px, rgba(255, 107, 220, 0.006) 4px); }
        main { position: relative; z-index: 1; width: min(1200px, 100%); margin: 0 auto; flex: 1; display: flex; flex-direction: column; }
        header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
        h1 { margin: 0; font-family: var(--font-display); font-size: clamp(2.5rem, 6vw, 4.5rem); letter-spacing: 0.08em; line-height: 0.95; color: var(--accent5); text-shadow: 0 0 40px rgba(255, 107, 220, 0.35); }
        .subtitle { margin-top: 6px; font-size: 0.78rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .nav-links { display: flex; gap: 12px; font-size: 0.72rem; letter-spacing: 0.12em; }
        .nav-links a { color: var(--muted); text-decoration: none; padding: 6px 12px; border: 1px solid var(--border); border-radius: 4px; transition: all 0.2s; }
        .nav-links a:hover { color: var(--accent); border-color: var(--accent); }
        .layout { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; flex: 1; }
        .col-left, .col-right { display: flex; flex-direction: column; gap: 16px; }
        .panel { position: relative; background: rgba(17, 24, 32, 0.92); border: 1px solid var(--border); border-radius: 8px; padding: 18px; overflow: hidden; }
        .panel::before { content: attr(data-label); position: absolute; top: 10px; right: 14px; font-size: 0.62rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .panel.vi-border { border-color: rgba(255, 107, 220, 0.4); }
        .tab-bar { display: flex; gap: 0; margin-bottom: 18px; border: 1px solid var(--border); border-radius: 6px; overflow: hidden; }
        .tab-btn { flex: 1; padding: 9px; background: transparent; border: none; color: var(--muted); font-family: var(--font-mono); font-size: 0.72rem; letter-spacing: 0.14em; text-transform: uppercase; cursor: pointer; transition: all 0.2s; border-right: 1px solid var(--border); }
        .tab-btn:last-child { border-right: none; }
        .tab-btn.active { background: rgba(255, 107, 220, 0.12); color: var(--accent5); }
        .tab-btn:hover:not(.active) { background: rgba(255, 107, 220, 0.06); color: var(--text); }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .emoji-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 14px; max-height: 220px; overflow-y: auto; }
        .emoji-btn {
            background: var(--surface); border: 1px solid var(--border); border-radius: 6px;
            font-size: 1.5rem; padding: 8px 10px; cursor: pointer; transition: all 0.15s; line-height: 1;
        }
        .emoji-btn:hover { border-color: var(--accent5); background: rgba(255, 107, 220, 0.1); transform: scale(1.1); }
        .emoji-btn.selected { border-color: var(--accent5); background: rgba(255, 107, 220, 0.25); }
        .selected-emojis { min-height: 50px; padding: 10px; background: var(--surface); border: 1px solid var(--border); border-radius: 4px; font-size: 1.4rem; letter-spacing: 4px; margin-bottom: 10px; }
        .color-picker-wrap { display: flex; flex-direction: column; gap: 14px; }
        .color-preview { width: 100%; height: 80px; border-radius: 6px; border: 1px solid var(--border); transition: background-color 0.3s; background: #808080; }
        input[type="color"] { width: 100%; height: 50px; padding: 4px; background: var(--surface); border: 1px solid var(--border); border-radius: 4px; cursor: pointer; }
        canvas#graphic-canvas { width: 100%; height: 160px; background: var(--surface); border: 1px solid var(--border); border-radius: 6px; cursor: crosshair; touch-action: none; }
        .clear-canvas-btn { font-size: 0.68rem; padding: 6px 12px; border-color: var(--muted); color: var(--muted); }
        .clear-canvas-btn:hover { border-color: var(--accent2); color: var(--accent2); }
        .compose-visual-btn {
            width: 100%; padding: 12px; margin-top: 10px;
            border: 1px solid var(--accent5); background: rgba(255, 107, 220, 0.08);
            color: var(--accent5); font-family: var(--font-mono); font-size: 0.78rem;
            letter-spacing: 0.18em; text-transform: uppercase; border-radius: 4px; cursor: pointer; transition: all 0.2s;
        }
        .compose-visual-btn:hover { background: rgba(255, 107, 220, 0.18); }
        .compose-visual-btn:disabled { opacity: 0.45; cursor: not-allowed; }
        button { border: 1px solid var(--accent); background: transparent; color: var(--accent); border-radius: 4px; padding: 10px 16px; font-family: var(--font-mono); font-size: 0.78rem; letter-spacing: 0.15em; text-transform: uppercase; cursor: pointer; transition: all 0.2s; }
        button:hover { background: rgba(0, 229, 255, 0.1); }
        button.play-btn { border-color: var(--accent3); color: var(--accent3); }
        button.play-btn:hover { background: rgba(168, 255, 62, 0.1); }
        button.stop-btn { border-color: var(--accent2); color: var(--accent2); }
        button.stop-btn:hover { background: rgba(255, 107, 53, 0.1); }
        .actions { display: flex; gap: 10px; flex-wrap: wrap; }
        label { display: grid; gap: 8px; font-size: 0.72rem; letter-spacing: 0.15em; color: var(--muted); text-transform: uppercase; }
        select { appearance: none; border: 1px solid var(--border); background: var(--surface); color: var(--text); border-radius: 4px; padding: 10px 12px; font-family: var(--font-mono); width: 100%; }
        input[type="range"] { width: 100%; accent-color: var(--accent5); }
        .bpm-row { display: flex; align-items: center; gap: 12px; }
        .bpm-value { min-width: 3em; text-align: right; color: var(--accent); font-size: 0.90rem; }
        .status { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 10px; }
        .metric { padding: 10px 12px; border-radius: 6px; border: 1px solid var(--border); background: var(--surface); }
        .metric .k { font-size: 0.60rem; letter-spacing: 0.18em; color: var(--muted); text-transform: uppercase; margin-bottom: 4px; display: block; }
        .metric .v { font-size: 0.95rem; color: var(--accent5); display: block; }
        #roll { display: grid; grid-template-columns: repeat(16, minmax(0, 1fr)); gap: 3px; align-items: end; min-height: 160px; }
        .column { display: grid; gap: 3px; }
        .cell { height: 12px; border-radius: 2px; border: 1px solid var(--border); background: var(--surface); }
        .cell.active { background: rgba(255, 107, 220, 0.4); border-color: var(--accent5); }
        .cell.current { background: rgba(255, 107, 53, 0.85); border-color: var(--accent2); box-shadow: 0 0 10px rgba(255, 107, 53, 0.5); }
        canvas#waveform { width: 100%; height: 100px; display: block; background: #07090c; border: 1px solid var(--border); border-radius: 6px; }
        .wav-btn { width: 100%; padding: 11px 14px; border-color: var(--accent3); color: var(--accent3); background: rgba(168, 255, 62, 0.06); }
        .wav-btn:hover { background: rgba(168, 255, 62, 0.12); }
        .wav-btn:disabled { opacity: 0.4; cursor: not-allowed; }
        audio { width: 100%; margin-top: 10px; display: none; }
        .interp-box { padding: 10px 12px; background: rgba(255, 107, 220, 0.06); border: 1px solid rgba(255, 107, 220, 0.2); border-radius: 5px; font-size: 0.78rem; color: var(--muted); min-height: 36px; }
        @media (max-width: 860px) { .layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<main>
    <header>
        <div>
            <h1>ENTRADA VISUAL</h1>
            <p class="subtitle">Emojis · Colores · Gráficos</p>
        </div>
        <nav class="nav-links">
            <a href="/">Inicio</a>
            <a href="/create">Crear</a>
            <a href="/electronic">Electrónica</a>
            <a href="/play">Biblioteca</a>
        </nav>
    </header>

    <div class="layout">
        <div class="col-left">
            <section class="panel vi-border" data-label="Entrada" style="flex:1;display:flex;flex-direction:column;">
                <div class="tab-bar">
                    <button class="tab-btn active" data-tab="emojis">Emojis</button>
                    <button class="tab-btn" data-tab="color">Color</button>
                    <button class="tab-btn" data-tab="graphic">Gráfico</button>
                </div>

                <!-- Tab Emojis -->
                <div class="tab-content active" id="tab-emojis">
                    <p style="margin:0 0 10px;font-size:0.75rem;color:var(--muted);">Selecciona emojis para describir tu estado de ánimo:</p>
                    <div class="emoji-grid" id="emoji-grid">
                        <button class="emoji-btn" data-emoji="😊">😊</button>
                        <button class="emoji-btn" data-emoji="😄">😄</button>
                        <button class="emoji-btn" data-emoji="😍">😍</button>
                        <button class="emoji-btn" data-emoji="🥰">🥰</button>
                        <button class="emoji-btn" data-emoji="😇">😇</button>
                        <button class="emoji-btn" data-emoji="🚀">🚀</button>
                        <button class="emoji-btn" data-emoji="✨">✨</button>
                        <button class="emoji-btn" data-emoji="🌟">🌟</button>
                        <button class="emoji-btn" data-emoji="⭐">⭐</button>
                        <button class="emoji-btn" data-emoji="🎉">🎉</button>
                        <button class="emoji-btn" data-emoji="💪">💪</button>
                        <button class="emoji-btn" data-emoji="🔥">🔥</button>
                        <button class="emoji-btn" data-emoji="⚡">⚡</button>
                        <button class="emoji-btn" data-emoji="💡">💡</button>
                        <button class="emoji-btn" data-emoji="💻">💻</button>
                        <button class="emoji-btn" data-emoji="🧠">🧠</button>
                        <button class="emoji-btn" data-emoji="💎">💎</button>
                        <button class="emoji-btn" data-emoji="🎵">🎵</button>
                        <button class="emoji-btn" data-emoji="🌈">🌈</button>
                        <button class="emoji-btn" data-emoji="😢">😢</button>
                        <button class="emoji-btn" data-emoji="😭">😭</button>
                        <button class="emoji-btn" data-emoji="😔">😔</button>
                        <button class="emoji-btn" data-emoji="😰">😰</button>
                        <button class="emoji-btn" data-emoji="😨">😨</button>
                        <button class="emoji-btn" data-emoji="😱">😱</button>
                        <button class="emoji-btn" data-emoji="😠">😠</button>
                        <button class="emoji-btn" data-emoji="🌙">🌙</button>
                        <button class="emoji-btn" data-emoji="🌌">🌌</button>
                        <button class="emoji-btn" data-emoji="🌀">🌀</button>
                        <button class="emoji-btn" data-emoji="🔮">🔮</button>
                        <button class="emoji-btn" data-emoji="🌊">🌊</button>
                        <button class="emoji-btn" data-emoji="🏔️">🏔️</button>
                        <button class="emoji-btn" data-emoji="🌲">🌲</button>
                        <button class="emoji-btn" data-emoji="🤔">🤔</button>
                        <button class="emoji-btn" data-emoji="🌺">🌺</button>
                    </div>
                    <div style="font-size:0.68rem;color:var(--muted);margin-bottom:6px;">SELECCIONADOS:</div>
                    <div class="selected-emojis" id="selected-emojis-display"></div>
                    <button class="compose-visual-btn" id="compose-emojis-btn">Componer desde emojis</button>
                </div>

                <!-- Tab Color -->
                <div class="tab-content" id="tab-color">
                    <p style="margin:0 0 12px;font-size:0.75rem;color:var(--muted);">Elige un color — su tono, saturación y brillo definen la música:</p>
                    <div class="color-picker-wrap">
                        <input type="color" id="color-picker" value="#3a7abf">
                        <div class="color-preview" id="color-preview"></div>
                        <div style="font-size:0.70rem;color:var(--muted);" id="color-info">Hue → escala &nbsp;·&nbsp; Saturación → intensidad &nbsp;·&nbsp; Brillo → octava y tempo</div>
                    </div>
                    <button class="compose-visual-btn" id="compose-color-btn" style="margin-top:14px;">Componer desde color</button>
                </div>

                <!-- Tab Gráfico -->
                <div class="tab-content" id="tab-graphic">
                    <p style="margin:0 0 8px;font-size:0.75rem;color:var(--muted);">Dibuja una línea — la altura representa las notas de la melodía:</p>
                    <canvas id="graphic-canvas" width="600" height="160"></canvas>
                    <div style="display:flex;gap:8px;margin-top:8px;">
                        <button class="clear-canvas-btn" id="clear-canvas-btn">Limpiar</button>
                        <span style="font-size:0.65rem;color:var(--muted);align-self:center;">Haz clic y arrastra para dibujar</span>
                    </div>
                    <button class="compose-visual-btn" id="compose-graphic-btn" style="margin-top:8px;">Componer desde gráfico</button>
                </div>
            </section>

            <section class="panel" data-label="Interpretación">
                <div class="interp-box" id="interp-box">La interpretación aparecerá aquí después de componer.</div>
            </section>
        </div>

        <div class="col-right">
            <section class="panel" data-label="Reproducción">
                <div class="actions" style="margin-bottom:14px;">
                    <button id="play" class="play-btn">Play</button>
                    <button id="stop" class="stop-btn">Stop</button>
                </div>
                <label>BPM
                    <div class="bpm-row">
                        <input type="range" id="bpm" min="40" max="200" value="100">
                        <span class="bpm-value" id="bpm-display">100</span>
                    </div>
                </label>
                <label style="margin-top:12px;">Onda
                    <select id="wave">
                        <option value="sine">Sine</option>
                        <option value="triangle">Triangle</option>
                        <option value="sawtooth">Sawtooth</option>
                        <option value="square">Square</option>
                    </select>
                </label>
                <div style="margin-top:16px;border-top:1px solid var(--border);padding-top:14px;">
                    <label>Sintetizador servidor</label>
                    <select id="server-synth" style="margin-bottom:10px;">
                        <option value="fm">FM Synthesis</option>
                        <option value="additive">Aditivo</option>
                        <option value="wavetable">Wavetable</option>
                    </select>
                    <label style="margin-top:12px;">Loops (repeticiones)
                        <div class="bpm-row">
                            <input type="range" id="loops" min="1" max="10" value="1">
                            <span class="bpm-value" id="loops-display">1</span>
                        </div>
                    </label>
                    <button class="wav-btn" id="download-wav-btn" disabled>Descargar WAV</button>
                    <audio id="wav-player" controls></audio>
                </div>
            </section>

            <section class="panel" data-label="Telemetría">
                <div class="status">
                    <div class="metric"><span class="k">Fuente</span><span class="v" id="current-source">—</span></div>
                    <div class="metric"><span class="k">Escala</span><span class="v" id="current-scale">—</span></div>
                    <div class="metric"><span class="k">Nota</span><span class="v" id="current-note">—</span></div>
                    <div class="metric"><span class="k">Pasos</span><span class="v" id="current-steps">—</span></div>
                    <div class="metric"><span class="k">BPM</span><span class="v" id="current-bpm">—</span></div>
                </div>
            </section>

            <section class="panel" data-label="Piano Roll">
                <div id="roll"></div>
            </section>

            <section class="panel" data-label="Waveform">
                <canvas id="waveform" width="960" height="100"></canvas>
            </section>
        </div>
    </div>
</main>

<script>
    let currentMelody = null, activeBpm = 100, audioCtx = null, analyser = null;
    let masterGain = null, animFrameId = null, scheduledTimeouts = [];
    const selectedEmojis = new Set();
    const graphicPoints = [];
    let isDrawing = false;

    // Tabs
    document.querySelectorAll(".tab-btn").forEach(function(btn) {
        btn.addEventListener("click", function() {
            document.querySelectorAll(".tab-btn").forEach(function(b) { b.classList.remove("active"); });
            document.querySelectorAll(".tab-content").forEach(function(c) { c.classList.remove("active"); });
            btn.classList.add("active");
            document.getElementById("tab-" + btn.getAttribute("data-tab")).classList.add("active");
        });
    });

    // Emojis
    document.querySelectorAll(".emoji-btn").forEach(function(btn) {
        btn.addEventListener("click", function() {
            const emoji = btn.getAttribute("data-emoji");
            if (selectedEmojis.has(emoji)) {
                selectedEmojis.delete(emoji);
                btn.classList.remove("selected");
            } else {
                selectedEmojis.add(emoji);
                btn.classList.add("selected");
            }
            document.getElementById("selected-emojis-display").textContent = Array.from(selectedEmojis).join(" ");
        });
    });

    document.getElementById("compose-emojis-btn").addEventListener("click", function() {
        const emojiStr = Array.from(selectedEmojis).join("");
        if (!emojiStr) return;
        composeVisual("/api/compose/emojis", emojiStr, "text/plain");
    });

    // Color
    const colorPicker = document.getElementById("color-picker");
    const colorPreview = document.getElementById("color-preview");
    colorPreview.style.backgroundColor = colorPicker.value;

    colorPicker.addEventListener("input", function() {
        colorPreview.style.backgroundColor = colorPicker.value;
    });

    document.getElementById("compose-color-btn").addEventListener("click", function() {
        composeVisual("/api/compose/color", colorPicker.value, "text/plain");
    });

    // Gráfico
    const graphicCanvas = document.getElementById("graphic-canvas");
    const gCtx = graphicCanvas.getContext("2d");

    function getCanvasPoint(e) {
        const rect = graphicCanvas.getBoundingClientRect();
        const scaleX = graphicCanvas.width / rect.width;
        const scaleY = graphicCanvas.height / rect.height;
        const clientX = e.touches ? e.touches[0].clientX : e.clientX;
        const clientY = e.touches ? e.touches[0].clientY : e.clientY;
        return {
            x: (clientX - rect.left) * scaleX / graphicCanvas.width,
            y: (clientY - rect.top) * scaleY / graphicCanvas.height
        };
    }

    function redrawGraphic() {
        gCtx.fillStyle = "#0d1117"; gCtx.fillRect(0, 0, graphicCanvas.width, graphicCanvas.height);
        if (graphicPoints.length < 2) return;
        gCtx.strokeStyle = "#ff6bdc"; gCtx.lineWidth = 2; gCtx.lineCap = "round"; gCtx.lineJoin = "round";
        gCtx.beginPath();
        graphicPoints.forEach(function(p, i) {
            const x = p.x * graphicCanvas.width;
            const y = p.y * graphicCanvas.height;
            if (i === 0) gCtx.moveTo(x, y); else gCtx.lineTo(x, y);
        });
        gCtx.stroke();
    }

    graphicCanvas.addEventListener("mousedown", function(e) {
        isDrawing = true; graphicPoints.length = 0;
        const p = getCanvasPoint(e); graphicPoints.push(p); redrawGraphic();
    });
    graphicCanvas.addEventListener("mousemove", function(e) {
        if (!isDrawing) return;
        const p = getCanvasPoint(e); graphicPoints.push(p); redrawGraphic();
    });
    graphicCanvas.addEventListener("mouseup", function() { isDrawing = false; });
    graphicCanvas.addEventListener("mouseleave", function() { isDrawing = false; });
    graphicCanvas.addEventListener("touchstart", function(e) {
        e.preventDefault(); isDrawing = true; graphicPoints.length = 0;
        const p = getCanvasPoint(e); graphicPoints.push(p); redrawGraphic();
    });
    graphicCanvas.addEventListener("touchmove", function(e) {
        e.preventDefault(); if (!isDrawing) return;
        const p = getCanvasPoint(e); graphicPoints.push(p); redrawGraphic();
    });
    graphicCanvas.addEventListener("touchend", function() { isDrawing = false; });

    document.getElementById("clear-canvas-btn").addEventListener("click", function() {
        graphicPoints.length = 0;
        gCtx.fillStyle = "#0d1117"; gCtx.fillRect(0, 0, graphicCanvas.width, graphicCanvas.height);
    });

    document.getElementById("compose-graphic-btn").addEventListener("click", function() {
        if (graphicPoints.length < 2) return;
        const payload = JSON.stringify({ points: graphicPoints, targetSteps: 16 });
        composeVisual("/api/compose/graphic", payload, "application/json");
    });

    function composeVisual(url, body, contentType) {
        document.getElementById("interp-box").textContent = "Componiendo...";
        fetch(url, { method: "POST", headers: { "content-type": contentType }, body: body })
        .then(function(res) {
            if (!res.ok) return res.json().then(function(e) { throw new Error(e.error || "HTTP " + res.status); });
            return res.json();
        })
        .then(function(data) {
            applyMelody(data);
            document.getElementById("interp-box").textContent = data.interpretation || (data.scaleLabel + " a " + data.bpm + " BPM");
            document.getElementById("current-source").textContent = data.source || "—";
        })
        .catch(function(e) {
            document.getElementById("interp-box").textContent = "Error: " + e.message;
        });
    }

    // Playback común
    const bpmInput = document.getElementById("bpm");
    const bpmDisplay = document.getElementById("bpm-display");
    const loopsInput = document.getElementById("loops");
    const loopsDisplay = document.getElementById("loops-display");
    const waveSelect = document.getElementById("wave");
    const playBtn = document.getElementById("play");
    const stopBtn = document.getElementById("stop");
    const roll = document.getElementById("roll");
    const waveformCanvas = document.getElementById("waveform");
    const waveformCtx = waveformCanvas.getContext("2d");
    const wavPlayer = document.getElementById("wav-player");
    const downloadWavBtn = document.getElementById("download-wav-btn");

    bpmInput.addEventListener("input", function() { activeBpm = Number(bpmInput.value); bpmDisplay.textContent = String(activeBpm); });
    loopsInput.addEventListener("input", function() { loopsDisplay.textContent = String(loopsInput.value); });

    function applyMelody(data) {
        currentMelody = data; buildRoll();
        document.getElementById("current-scale").textContent = (data.request ? data.request.root + " " : "") + (data.scaleLabel || "");
        document.getElementById("current-steps").textContent = data.request ? String(data.request.steps) : "—";
        document.getElementById("current-bpm").textContent = data.bpm ? String(data.bpm) : String(activeBpm);
        if (data.bpm) { activeBpm = data.bpm; bpmInput.value = activeBpm; bpmDisplay.textContent = String(activeBpm); }
        downloadWavBtn.disabled = false;
    }

    function buildRoll() {
        const steps = currentMelody ? currentMelody.melody : [];
        const rows = currentMelody && currentMelody.palette ? currentMelody.palette.length : 0;
        roll.style.gridTemplateColumns = "repeat(" + Math.max(steps.length, 1) + ", minmax(0,1fr))";
        roll.innerHTML = "";
        steps.forEach(function(stepInfo) {
            const col = document.createElement("div"); col.className = "column";
            for (let r = rows - 1; r >= 0; r--) {
                const cell = document.createElement("div"); cell.className = "cell";
                if (!stepInfo.rest && stepInfo.noteIndex === r) cell.classList.add("active");
                cell.setAttribute("data-step", String(stepInfo.step));
                cell.setAttribute("data-row", String(r));
                col.appendChild(cell);
            }
            roll.appendChild(col);
        });
    }

    function markCurrentStep(step) {
        document.querySelectorAll(".cell.current").forEach(function(n) { n.classList.remove("current"); });
        document.querySelectorAll(".cell[data-step=\"" + step + "\"]").forEach(function(n) { n.classList.add("current"); });
    }

    function clearPlaybackState() {
        scheduledTimeouts.forEach(function(id) { clearTimeout(id); });
        scheduledTimeouts = [];
        document.querySelectorAll(".cell.current").forEach(function(n) { n.classList.remove("current"); });
        document.getElementById("current-note").textContent = "—";
    }

    function initAudio() {
        if (audioCtx) return;
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        analyser = audioCtx.createAnalyser(); analyser.fftSize = 2048;
        masterGain = audioCtx.createGain(); masterGain.gain.value = 0.25;
        masterGain.connect(analyser); analyser.connect(audioCtx.destination);
        drawWaveform();
    }

    function drawWaveform() {
        if (!analyser) { animFrameId = requestAnimationFrame(drawWaveform); return; }
        const data = new Float32Array(analyser.fftSize);
        analyser.getFloatTimeDomainData(data);
        waveformCtx.fillStyle = "#07090c"; waveformCtx.fillRect(0, 0, waveformCanvas.width, waveformCanvas.height);
        waveformCtx.strokeStyle = "#ff6bdc"; waveformCtx.lineWidth = 1.5; waveformCtx.beginPath();
        const sliceWidth = waveformCanvas.width / data.length; let x = 0;
        for (let i = 0; i < data.length; i++) {
            const y = (data[i] * waveformCanvas.height * 0.38) + waveformCanvas.height / 2;
            if (i === 0) waveformCtx.moveTo(x, y); else waveformCtx.lineTo(x, y);
            x += sliceWidth;
        }
        waveformCtx.stroke(); animFrameId = requestAnimationFrame(drawWaveform);
    }

    function scheduleStep(stepInfo, when, duration) {
        if (!audioCtx || !masterGain || stepInfo.rest || !stepInfo.frequencyHz) {
            const id = window.setTimeout(function() { markCurrentStep(stepInfo.step); }, Math.max(0, (when - audioCtx.currentTime) * 1000));
            scheduledTimeouts.push(id); return;
        }
        const osc = audioCtx.createOscillator(); const gain = audioCtx.createGain();
        osc.type = waveSelect.value;
        osc.frequency.setValueAtTime(stepInfo.frequencyHz, when);
        gain.gain.setValueAtTime(0.0001, when); gain.gain.linearRampToValueAtTime(0.75, when + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.45, when + Math.max(duration - 0.04, 0.02));
        gain.gain.exponentialRampToValueAtTime(0.0001, when + duration);
        osc.connect(gain); gain.connect(masterGain); osc.start(when); osc.stop(when + duration);
        const id = window.setTimeout(function() {
            markCurrentStep(stepInfo.step);
            document.getElementById("current-note").textContent = stepInfo.noteName || "Silencio";
        }, Math.max(0, (when - audioCtx.currentTime) * 1000));
        scheduledTimeouts.push(id);
    }

    playBtn.addEventListener("click", function() {
        if (!currentMelody) return;
        initAudio(); clearPlaybackState();
        if (audioCtx.state === "suspended") audioCtx.resume();
        const stepDuration = (60 / activeBpm) / 2;
        const startAt = audioCtx.currentTime + 0.08;
        currentMelody.melody.forEach(function(stepInfo, index) {
            scheduleStep(stepInfo, startAt + (index * stepDuration), stepDuration * 0.85);
        });
    });

    stopBtn.addEventListener("click", function() { clearPlaybackState(); });

    downloadWavBtn.addEventListener("click", function() {
        if (!currentMelody) return;
        downloadWavBtn.disabled = true; downloadWavBtn.textContent = "Sintetizando...";
        const payload = {
            melody: currentMelody.melody, bpm: activeBpm,
            synthesizer: document.getElementById("server-synth").value,
            effectReverb: 0.4, effectDelay: 0.3, intensity: 0.8,
            loops: Number(loopsInput.value)
        };
        fetch("/api/synthesize", { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(payload) })
        .then(function(res) { if (!res.ok) throw new Error("HTTP " + res.status); return res.blob(); })
        .then(function(blob) {
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a"); a.href = url; a.download = "ether-visual.wav"; a.click();
            wavPlayer.src = url; wavPlayer.style.display = "block";
            downloadWavBtn.textContent = "Descargar WAV"; downloadWavBtn.disabled = false;
        })
        .catch(function(e) {
            document.getElementById("interp-box").textContent = "Error al generar WAV: " + e.message;
            downloadWavBtn.textContent = "Descargar WAV"; downloadWavBtn.disabled = false;
        });
    });

    // Inicializar canvas
    gCtx.fillStyle = "#0d1117"; gCtx.fillRect(0, 0, graphicCanvas.width, graphicCanvas.height);

    if (navigator.serviceWorker) {
        window.addEventListener("load", function() {
            navigator.serviceWorker.register("/sw.js", { scope: "/" }).catch(function(e) { console.warn("SW:", e); });
        });
    }
</script>
</body>
</html>
