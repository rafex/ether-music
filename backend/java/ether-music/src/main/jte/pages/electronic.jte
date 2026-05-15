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
            --accent4: #bf5fff;
            --text: #c9d6df;
            --muted: #5f7486;
            --font-mono: "Share Tech Mono", monospace;
            --font-display: "Bebas Neue", sans-serif;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            min-height: 100vh;
            background:
                radial-gradient(circle at top left, rgba(191, 95, 255, 0.1), transparent 35%),
                radial-gradient(circle at top right, rgba(0, 229, 255, 0.08), transparent 35%),
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
                0deg, transparent, transparent 2px,
                rgba(191, 95, 255, 0.012) 2px, rgba(191, 95, 255, 0.012) 4px
            );
        }

        main {
            position: relative;
            z-index: 1;
            width: min(1200px, 100%);
            margin: 0 auto;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }

        h1 {
            margin: 0;
            font-family: var(--font-display);
            font-size: clamp(2.5rem, 6vw, 4.5rem);
            letter-spacing: 0.08em;
            line-height: 0.95;
            color: var(--accent4);
            text-shadow: 0 0 40px rgba(191, 95, 255, 0.35);
        }

        .subtitle {
            margin-top: 6px;
            font-size: 0.78rem;
            letter-spacing: 0.22em;
            color: var(--muted);
            text-transform: uppercase;
        }

        .nav-links {
            display: flex;
            gap: 12px;
            font-size: 0.72rem;
            letter-spacing: 0.12em;
        }

        .nav-links a {
            color: var(--muted);
            text-decoration: none;
            padding: 6px 12px;
            border: 1px solid var(--border);
            border-radius: 4px;
            transition: all 0.2s;
        }

        .nav-links a:hover {
            color: var(--accent);
            border-color: var(--accent);
        }

        .layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: auto;
            gap: 16px;
        }

        .col-left {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .col-right {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .panel {
            position: relative;
            background: rgba(17, 24, 32, 0.92);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 18px;
            overflow: hidden;
        }

        .panel::before {
            content: attr(data-label);
            position: absolute;
            top: 10px;
            right: 14px;
            font-size: 0.62rem;
            letter-spacing: 0.22em;
            color: var(--muted);
            text-transform: uppercase;
        }

        .panel.accent-border { border-color: rgba(191, 95, 255, 0.4); }

        label {
            display: grid;
            gap: 8px;
            font-size: 0.72rem;
            letter-spacing: 0.15em;
            color: var(--muted);
            text-transform: uppercase;
        }

        select {
            appearance: none;
            border: 1px solid var(--border);
            background: var(--surface);
            color: var(--text);
            border-radius: 4px;
            padding: 10px 12px;
            font-family: var(--font-mono);
            width: 100%;
        }

        textarea {
            width: 100%;
            min-height: 220px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 4px;
            color: var(--text);
            font-family: var(--font-mono);
            font-size: 0.80rem;
            padding: 12px;
            resize: vertical;
            line-height: 1.5;
            tab-size: 2;
        }

        textarea:focus {
            outline: none;
            border-color: var(--accent4);
            box-shadow: 0 0 0 2px rgba(191, 95, 255, 0.15);
        }

        input[type="range"] {
            width: 100%;
            accent-color: var(--accent4);
        }

        button {
            border: 1px solid var(--accent);
            background: transparent;
            color: var(--accent);
            border-radius: 4px;
            padding: 11px 18px;
            font-family: var(--font-mono);
            font-size: 0.78rem;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s;
        }

        button:hover { background: rgba(0, 229, 255, 0.12); }

        button.ai-btn {
            border-color: var(--accent4);
            color: var(--accent4);
            width: 100%;
            padding: 14px;
            font-size: 0.82rem;
        }

        button.ai-btn:hover { background: rgba(191, 95, 255, 0.12); }

        button.ai-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        button.play-btn {
            border-color: var(--accent3);
            color: var(--accent3);
        }

        button.play-btn:hover { background: rgba(168, 255, 62, 0.1); }

        button.stop-btn {
            border-color: var(--accent2);
            color: var(--accent2);
        }

        button.stop-btn:hover { background: rgba(255, 107, 53, 0.1); }

        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .source-tabs {
            display: flex;
            gap: 4px;
            margin-bottom: 12px;
        }

        .source-tab {
            border: 1px solid var(--border);
            background: transparent;
            color: var(--muted);
            border-radius: 4px 4px 0 0;
            padding: 7px 14px;
            font-size: 0.68rem;
            letter-spacing: 0.15em;
            cursor: pointer;
        }

        .source-tab.active {
            border-color: var(--accent4);
            color: var(--accent4);
            background: rgba(191, 95, 255, 0.08);
        }

        .params-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 10px;
        }

        .param-card {
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: var(--surface);
        }

        .param-card .pk {
            font-size: 0.60rem;
            letter-spacing: 0.15em;
            color: var(--muted);
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .param-card .pv {
            font-size: 0.90rem;
            color: var(--accent4);
        }

        .interpretation-box {
            margin-top: 14px;
            padding: 12px 14px;
            border: 1px solid rgba(191, 95, 255, 0.3);
            border-radius: 6px;
            background: rgba(191, 95, 255, 0.06);
            font-size: 0.82rem;
            color: var(--text);
            line-height: 1.55;
            min-height: 3em;
        }

        .status {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 10px;
        }

        .metric {
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid var(--border);
            background: var(--surface);
        }

        .metric .k {
            font-size: 0.60rem;
            letter-spacing: 0.18em;
            color: var(--muted);
            text-transform: uppercase;
            margin-bottom: 4px;
            display: block;
        }

        .metric .v {
            font-size: 0.95rem;
            color: var(--accent);
            display: block;
        }

        #roll {
            display: grid;
            grid-template-columns: repeat(16, minmax(0, 1fr));
            gap: 3px;
            align-items: end;
            min-height: 180px;
        }

        .column { display: grid; gap: 3px; }

        .cell {
            height: 12px;
            border-radius: 2px;
            border: 1px solid var(--border);
            background: var(--surface);
        }

        .cell.active {
            background: rgba(191, 95, 255, 0.35);
            border-color: var(--accent4);
        }

        .cell.current {
            background: rgba(255, 107, 53, 0.85);
            border-color: var(--accent2);
            box-shadow: 0 0 10px rgba(255, 107, 53, 0.5);
        }

        canvas {
            width: 100%;
            height: 100px;
            display: block;
            background: #07090c;
            border: 1px solid var(--border);
            border-radius: 6px;
        }

        pre {
            margin: 0;
            white-space: pre-wrap;
            color: var(--muted);
            font-size: 0.80rem;
            line-height: 1.45;
        }

        .loading-indicator {
            display: none;
            text-align: center;
            padding: 24px;
            color: var(--accent4);
            font-size: 0.82rem;
            letter-spacing: 0.15em;
        }

        .loading-indicator.visible { display: block; }

        .bpm-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .bpm-value {
            min-width: 3em;
            text-align: right;
            color: var(--accent);
            font-size: 0.90rem;
        }

        .hint {
            font-size: 0.68rem;
            color: var(--muted);
            margin-top: 6px;
            letter-spacing: 0.05em;
        }

        @media (max-width: 860px) {
            .layout {
                grid-template-columns: 1fr;
            }

            textarea { min-height: 160px; }
        }
    </style>
</head>
<body>
<main>
    <header>
        <div>
            <h1>ELECTRÓNICA</h1>
            <p class="subtitle">Composición con Inteligencia Artificial</p>
        </div>
        <nav class="nav-links">
            <a href="/">Inicio</a>
            <a href="/create">Crear</a>
            <a href="/play">Biblioteca</a>
        </nav>
    </header>

    <div class="layout">
        <!-- Columna izquierda: entrada de texto/código -->
        <div class="col-left">
            <section class="panel accent-border" data-label="Entrada">
                <div class="source-tabs" id="source-tabs">
                    <button class="source-tab active" data-source="code">Código</button>
                    <button class="source-tab" data-source="text">Texto</button>
                    <button class="source-tab" data-source="words">Palabras</button>
                </div>

                <div id="hint-code" class="hint">Pega código Java, Python, JS, etc. El LLM analiza su estructura y emociones.</div>
                <div id="hint-text" class="hint" style="display:none;">Pega cualquier texto: poesía, narrativa, descripción. El LLM extrae el mood.</div>
                <div id="hint-words" class="hint" style="display:none;">Formato JSON: [{"word":"alegría","weight":0.9}, ...]. Máx. 50 palabras.</div>

                <textarea id="content-input" spellcheck="false" placeholder="// Pega tu código aquí..."></textarea>

                <button id="analyze-btn" class="ai-btn" style="margin-top:12px;">
                    Analizar con IA y Componer
                </button>

                <div id="loading" class="loading-indicator">
                    Consultando DeepSeek... analizando contexto musical...
                </div>
            </section>

            <section class="panel" data-label="Reproducción">
                <div class="actions" style="margin-bottom:14px;">
                    <button id="play" class="play-btn">Play</button>
                    <button id="stop" class="stop-btn">Stop</button>
                </div>
                <label>
                    BPM
                    <div class="bpm-row">
                        <input type="range" id="bpm" min="40" max="200" value="110">
                        <span class="bpm-value" id="bpm-display">110</span>
                    </div>
                </label>
                <label style="margin-top:12px;">
                    Onda
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
                    <label style="margin-top:12px;">
                        Loops (repeticiones)
                        <div class="bpm-row">
                            <input type="range" id="loops" min="1" max="10" value="1">
                            <span class="bpm-value" id="loops-display">1</span>
                        </div>
                    </label>
                    <button id="download-wav-btn" class="ai-btn" style="width:100%;background:rgba(168,255,62,0.1);border-color:var(--accent3);color:var(--accent3);" disabled>
                        Descargar WAV
                    </button>
                    <audio id="wav-player" controls style="width:100%;margin-top:10px;display:none;"></audio>
                </div>
            </section>
        </div>

        <!-- Columna derecha: análisis + visualización -->
        <div class="col-right">
            <section class="panel accent-border" id="analysis-panel" data-label="Análisis LLM" style="display:none;">
                <div class="params-grid" id="params-grid"></div>
                <div class="interpretation-box" id="interpretation-box"></div>
            </section>

            <section class="panel" data-label="Telemetría">
                <div class="status">
                    <div class="metric"><span class="k">Escala</span><span class="v" id="current-scale">—</span></div>
                    <div class="metric"><span class="k">Nota</span><span class="v" id="current-note">—</span></div>
                    <div class="metric"><span class="k">Hz</span><span class="v" id="current-frequency">—</span></div>
                    <div class="metric"><span class="k">Pasos</span><span class="v" id="current-steps">—</span></div>
                    <div class="metric"><span class="k">BPM</span><span class="v" id="current-bpm">—</span></div>
                    <div class="metric"><span class="k">Fuente</span><span class="v" id="current-source">—</span></div>
                </div>
            </section>

            <section class="panel" data-label="Piano Roll">
                <div id="roll"></div>
            </section>

            <section class="panel" data-label="Waveform">
                <canvas id="waveform" width="960" height="100"></canvas>
            </section>

            <section class="panel" data-label="Log">
                <pre id="log">Listo — pega código o texto y pulsa "Analizar con IA".</pre>
            </section>
        </div>
    </div>
</main>

<script>
    let currentMelody = null;
    let activeBpm = 110;
    let currentSource = "code";
    let audioCtx = null;
    let analyser = null;
    let masterGain = null;
    let animFrameId = null;
    let scheduledTimeouts = [];

    const bpmInput = document.getElementById("bpm");
    const bpmDisplay = document.getElementById("bpm-display");
    const loopsInput = document.getElementById("loops");
    const loopsDisplay = document.getElementById("loops-display");
    const waveSelect = document.getElementById("wave");
    const playBtn = document.getElementById("play");
    const stopBtn = document.getElementById("stop");
    const analyzeBtn = document.getElementById("analyze-btn");
    const contentInput = document.getElementById("content-input");
    const loadingEl = document.getElementById("loading");
    const analysisPanel = document.getElementById("analysis-panel");
    const paramsGrid = document.getElementById("params-grid");
    const interpretationBox = document.getElementById("interpretation-box");
    const roll = document.getElementById("roll");
    const logNode = document.getElementById("log");
    const waveformCanvas = document.getElementById("waveform");
    const waveformCtx = waveformCanvas.getContext("2d");
    const currentScaleNode = document.getElementById("current-scale");
    const currentNoteNode = document.getElementById("current-note");
    const currentFrequencyNode = document.getElementById("current-frequency");
    const currentStepsNode = document.getElementById("current-steps");
    const currentBpmNode = document.getElementById("current-bpm");
    const currentSourceNode = document.getElementById("current-source");

    bpmInput.addEventListener("input", function() {
        activeBpm = Number(bpmInput.value);
        bpmDisplay.textContent = String(activeBpm);
    });

    loopsInput.addEventListener("input", function() {
        loopsDisplay.textContent = String(loopsInput.value);
    });

    document.querySelectorAll(".source-tab").forEach(function(btn) {
        btn.addEventListener("click", function() {
            document.querySelectorAll(".source-tab").forEach(function(b) { b.classList.remove("active"); });
            btn.classList.add("active");
            currentSource = btn.getAttribute("data-source");
            document.getElementById("hint-code").style.display = "none";
            document.getElementById("hint-text").style.display = "none";
            document.getElementById("hint-words").style.display = "none";
            document.getElementById("hint-" + currentSource).style.display = "block";
            const placeholders = {
                code: "// Pega tu código aquí...",
                text: "Pega el texto que quieres convertir en música...",
                words: "[{\"word\":\"alegría\",\"weight\":0.9},{\"word\":\"código\",\"weight\":0.7}]"
            };
            contentInput.placeholder = placeholders[currentSource] || "";
        });
    });

    function log(msg) { logNode.textContent = msg; }

    function parseJsonSafely(raw) {
        try {
            return JSON.parse(raw);
        } catch (e) {
            return null;
        }
    }

    function initAudio() {
        if (audioCtx) return;
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        analyser = audioCtx.createAnalyser();
        analyser.fftSize = 2048;
        masterGain = audioCtx.createGain();
        masterGain.gain.value = 0.25;
        masterGain.connect(analyser);
        analyser.connect(audioCtx.destination);
        drawWaveform();
    }

    function drawWaveform() {
        if (!analyser) {
            animFrameId = requestAnimationFrame(drawWaveform);
            return;
        }
        const bufferLength = analyser.fftSize;
        const data = new Float32Array(bufferLength);
        analyser.getFloatTimeDomainData(data);
        waveformCtx.fillStyle = "#07090c";
        waveformCtx.fillRect(0, 0, waveformCanvas.width, waveformCanvas.height);
        waveformCtx.strokeStyle = "#bf5fff";
        waveformCtx.lineWidth = 1.5;
        waveformCtx.beginPath();
        const sliceWidth = waveformCanvas.width / bufferLength;
        let x = 0;
        for (let i = 0; i < bufferLength; i++) {
            const y = (data[i] * waveformCanvas.height * 0.38) + waveformCanvas.height / 2;
            if (i === 0) waveformCtx.moveTo(x, y); else waveformCtx.lineTo(x, y);
            x += sliceWidth;
        }
        waveformCtx.stroke();
        animFrameId = requestAnimationFrame(drawWaveform);
    }

    function applyMelody(data) {
        currentMelody = data;
        buildRoll();
        currentScaleNode.textContent = (data.request ? data.request.root + " " : "") + (data.scaleLabel || "");
        currentStepsNode.textContent = data.request ? String(data.request.steps) : "—";
        currentBpmNode.textContent = data.bpm ? String(data.bpm) : String(activeBpm);
        currentSourceNode.textContent = data.source || "—";
        if (data.bpm) {
            activeBpm = data.bpm;
            bpmInput.value = activeBpm;
            bpmDisplay.textContent = String(activeBpm);
        }
        document.getElementById("download-wav-btn").disabled = false;
    }

    function buildRoll() {
        const steps = currentMelody ? currentMelody.melody : [];
        const rows = currentMelody && currentMelody.palette ? currentMelody.palette.length : 0;
        roll.style.gridTemplateColumns = "repeat(" + Math.max(steps.length, 1) + ", minmax(0,1fr))";
        roll.innerHTML = "";
        steps.forEach(function(stepInfo) {
            const column = document.createElement("div");
            column.className = "column";
            for (let row = rows - 1; row >= 0; row--) {
                const cell = document.createElement("div");
                cell.className = "cell";
                if (!stepInfo.rest && stepInfo.noteIndex === row) cell.classList.add("active");
                cell.setAttribute("data-step", String(stepInfo.step));
                cell.setAttribute("data-row", String(row));
                column.appendChild(cell);
            }
            roll.appendChild(column);
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
        currentNoteNode.textContent = "-";
        currentFrequencyNode.textContent = "- Hz";
    }

    function scheduleStep(stepInfo, when, duration) {
        if (!audioCtx || !masterGain || stepInfo.rest || !stepInfo.frequencyHz) {
            const id = window.setTimeout(function() { markCurrentStep(stepInfo.step); }, Math.max(0, (when - audioCtx.currentTime) * 1000));
            scheduledTimeouts.push(id);
            return;
        }
        const oscillator = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        oscillator.type = waveSelect.value;
        oscillator.frequency.setValueAtTime(stepInfo.frequencyHz, when);
        gain.gain.setValueAtTime(0.0001, when);
        gain.gain.linearRampToValueAtTime(0.75, when + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.45, when + Math.max(duration - 0.04, 0.02));
        gain.gain.exponentialRampToValueAtTime(0.0001, when + duration);
        oscillator.connect(gain);
        gain.connect(masterGain);
        oscillator.start(when);
        oscillator.stop(when + duration);
        const id = window.setTimeout(function() {
            markCurrentStep(stepInfo.step);
            currentNoteNode.textContent = stepInfo.noteName || "Silencio";
            currentFrequencyNode.textContent = stepInfo.frequencyHz ? (stepInfo.frequencyHz.toFixed(2) + " Hz") : "- Hz";
        }, Math.max(0, (when - audioCtx.currentTime) * 1000));
        scheduledTimeouts.push(id);
    }

    function playMelody() {
        if (!currentMelody) return;
        initAudio();
        clearPlaybackState();
        if (audioCtx.state === "suspended") { audioCtx.resume(); }
        const stepDuration = (60 / activeBpm) / 2;
        const startAt = audioCtx.currentTime + 0.08;
        currentMelody.melody.forEach(function(stepInfo, index) {
            scheduleStep(stepInfo, startAt + (index * stepDuration), stepDuration * 0.85);
        });
        log("Reproduciendo " + currentMelody.source + " · " + activeBpm + " BPM · " + currentMelody.melody.length + " pasos");
    }

    function showAnalysisPanel(data) {
        const paramDefs = [
            ["BPM", data.bpm],
            ["Escala", data.scaleLabel],
            ["Pasos", data.request ? data.request.steps : "—"],
            ["Fuente", data.source]
        ];
        paramsGrid.innerHTML = "";
        paramDefs.forEach(function(item) {
            const card = document.createElement("div");
            card.className = "param-card";
            card.innerHTML = "<div class=\"pk\">" + item[0] + "</div><div class=\"pv\">" + (item[1] || "—") + "</div>";
            paramsGrid.appendChild(card);
        });
        interpretationBox.textContent = data.interpretation || "Sin interpretación disponible.";
        analysisPanel.style.display = "block";
    }

    analyzeBtn.addEventListener("click", function() {
        const content = contentInput.value.trim();
        if (!content) {
            log("Error: el campo de entrada está vacío.");
            return;
        }

        analyzeBtn.disabled = true;
        loadingEl.classList.add("visible");
        log("Enviando a DeepSeek para análisis...");

        const endpoint = "/api/electronic/" + currentSource;

        fetch(endpoint, {
            method: "POST",
            headers: { "content-type": "text/plain; charset=utf-8" },
            body: content
        })
        .then(function(res) {
            return res.text().then(function(raw) {
                const parsed = parseJsonSafely(raw);
                if (!res.ok) {
                    const errorMsg = parsed && (parsed.error || parsed.message)
                        ? (parsed.error || parsed.message)
                        : ("HTTP " + res.status + " " + (raw ? raw.slice(0, 180) : ""));
                    throw new Error(errorMsg.trim());
                }
                if (!parsed) {
                    throw new Error("Respuesta inválida del servidor (no JSON).");
                }
                return parsed;
            });
        })
        .then(function(data) {
            applyMelody(data);
            showAnalysisPanel(data);
            log("Composición lista: " + (data.interpretation || data.scaleLabel));
            analyzeBtn.disabled = false;
            loadingEl.classList.remove("visible");
        })
        .catch(function(e) {
            log("Error: " + e.message);
            analyzeBtn.disabled = false;
            loadingEl.classList.remove("visible");
        });
    });

    playBtn.addEventListener("click", function() {
        try { playMelody(); } catch (e) { log("Error: " + e.message); }
    });

    stopBtn.addEventListener("click", function() {
        clearPlaybackState();
        log("Reproducción detenida");
    });

    document.getElementById("download-wav-btn").addEventListener("click", function() {
        if (!currentMelody) return;
        const btn = document.getElementById("download-wav-btn");
        const serverSynth = document.getElementById("server-synth").value;
        const wavPlayer = document.getElementById("wav-player");
        btn.disabled = true;
        btn.textContent = "Sintetizando...";
        log("Sintetizando en servidor con " + serverSynth + "...");

        const payload = {
            melody: currentMelody.melody,
            bpm: activeBpm,
            synthesizer: serverSynth,
            effectReverb: 0.4,
            effectDelay: 0.3,
            intensity: 0.8,
            loops: Number(loopsInput.value)
        };

        fetch("/api/synthesize", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(payload)
        })
        .then(function(res) {
            if (!res.ok) throw new Error("HTTP " + res.status);
            return res.blob();
        })
        .then(function(blob) {
            const playerUrl = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = playerUrl;
            a.download = "ether-music.wav";
            a.click();
            wavPlayer.src = playerUrl;
            wavPlayer.style.display = "block";
            btn.textContent = "Descargar WAV";
            btn.disabled = false;
            log("WAV generado y descargado.");
        })
        .catch(function(e) {
            log("Error WAV: " + e.message);
            btn.textContent = "Descargar WAV";
            btn.disabled = false;
        });
    });

    window.addEventListener("beforeunload", function() {
        if (animFrameId) cancelAnimationFrame(animFrameId);
    });

    if (navigator.serviceWorker) {
        window.addEventListener("load", function() {
            navigator.serviceWorker.register("/sw.js", { scope: "/" })
                .catch(function(e) { console.warn("SW:", e); });
        });
    }
</script>
</body>
</html>
