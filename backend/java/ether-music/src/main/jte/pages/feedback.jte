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
            --accent4: #bf5fff; --accent5: #f0c040;
            --text: #c9d6df; --muted: #5f7486;
            --font-mono: "Share Tech Mono", monospace; --font-display: "Bebas Neue", sans-serif;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh;
            background: radial-gradient(circle at top left, rgba(240, 192, 64, 0.07), transparent 35%),
                        radial-gradient(circle at bottom right, rgba(0, 229, 255, 0.06), transparent 35%),
                        linear-gradient(180deg, #05070a 0%, #090b0f 100%);
            color: var(--text); font-family: var(--font-mono); padding: 24px; display: flex; flex-direction: column;
        }
        body::before { content: ""; position: fixed; inset: 0; pointer-events: none; background: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(240, 192, 64, 0.007) 2px, rgba(240, 192, 64, 0.007) 4px); }
        main { position: relative; z-index: 1; width: min(1100px, 100%); margin: 0 auto; flex: 1; display: flex; flex-direction: column; }
        header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
        h1 { margin: 0; font-family: var(--font-display); font-size: clamp(2.5rem, 6vw, 4.5rem); letter-spacing: 0.08em; line-height: 0.95; color: var(--accent5); text-shadow: 0 0 40px rgba(240, 192, 64, 0.35); }
        .subtitle { margin-top: 6px; font-size: 0.78rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .nav-links { display: flex; gap: 12px; font-size: 0.72rem; letter-spacing: 0.12em; }
        .nav-links a { color: var(--muted); text-decoration: none; padding: 6px 12px; border: 1px solid var(--border); border-radius: 4px; transition: all 0.2s; }
        .nav-links a:hover { color: var(--accent); border-color: var(--accent); }
        .layout { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; flex: 1; }
        .col-left, .col-right { display: flex; flex-direction: column; gap: 16px; }
        .panel { position: relative; background: rgba(17, 24, 32, 0.92); border: 1px solid var(--border); border-radius: 8px; padding: 18px; overflow: hidden; }
        .panel::before { content: attr(data-label); position: absolute; top: 10px; right: 14px; font-size: 0.62rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .panel.fb-border { border-color: rgba(240, 192, 64, 0.4); }
        .metrics-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .metric-input { display: flex; flex-direction: column; gap: 6px; }
        .metric-input label { font-size: 0.68rem; letter-spacing: 0.18em; color: var(--muted); text-transform: uppercase; }
        .metric-input input[type="number"] {
            width: 100%; padding: 10px 12px; background: var(--surface); border: 1px solid var(--border);
            border-radius: 4px; color: var(--accent5); font-family: var(--font-mono); font-size: 1.1rem; text-align: center;
        }
        .metric-input input[type="number"]:focus { outline: none; border-color: var(--accent5); box-shadow: 0 0 0 2px rgba(240, 192, 64, 0.15); }
        .metric-input input[type="range"] { accent-color: var(--accent5); }
        .auto-compose-row { display: flex; align-items: center; gap: 12px; margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--border); }
        .toggle-label { font-size: 0.72rem; letter-spacing: 0.15em; color: var(--muted); text-transform: uppercase; }
        input[type="checkbox"] { width: 20px; height: 20px; accent-color: var(--accent5); cursor: pointer; }
        button {
            border: 1px solid var(--accent); background: transparent; color: var(--accent);
            border-radius: 4px; padding: 10px 16px; font-family: var(--font-mono); font-size: 0.78rem;
            letter-spacing: 0.15em; text-transform: uppercase; cursor: pointer; transition: all 0.2s;
        }
        button:hover { background: rgba(0, 229, 255, 0.1); }
        button.play-btn { border-color: var(--accent3); color: var(--accent3); }
        button.play-btn:hover { background: rgba(168, 255, 62, 0.1); }
        button.stop-btn { border-color: var(--accent2); color: var(--accent2); }
        button.stop-btn:hover { background: rgba(255, 107, 53, 0.1); }
        .compose-btn-fb {
            width: 100%; padding: 12px; margin-top: 12px;
            border: 1px solid var(--accent5); background: rgba(240, 192, 64, 0.08);
            color: var(--accent5); font-family: var(--font-mono); font-size: 0.78rem;
            letter-spacing: 0.18em; text-transform: uppercase; border-radius: 4px; cursor: pointer; transition: all 0.2s;
        }
        .compose-btn-fb:hover { background: rgba(240, 192, 64, 0.18); }
        .actions { display: flex; gap: 10px; flex-wrap: wrap; }
        label { display: grid; gap: 8px; font-size: 0.72rem; letter-spacing: 0.15em; color: var(--muted); text-transform: uppercase; }
        select { appearance: none; border: 1px solid var(--border); background: var(--surface); color: var(--text); border-radius: 4px; padding: 10px 12px; font-family: var(--font-mono); width: 100%; }
        input[type="range"] { width: 100%; accent-color: var(--accent5); }
        .bpm-row { display: flex; align-items: center; gap: 12px; }
        .bpm-value { min-width: 3em; text-align: right; color: var(--accent); font-size: 0.90rem; }
        .status { display: grid; grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); gap: 10px; }
        .metric { padding: 10px 12px; border-radius: 6px; border: 1px solid var(--border); background: var(--surface); }
        .metric .k { font-size: 0.60rem; letter-spacing: 0.18em; color: var(--muted); text-transform: uppercase; margin-bottom: 4px; display: block; }
        .metric .v { font-size: 0.95rem; color: var(--accent5); display: block; }
        #roll { display: grid; grid-template-columns: repeat(16, minmax(0, 1fr)); gap: 3px; align-items: end; min-height: 160px; }
        .column { display: grid; gap: 3px; }
        .cell { height: 12px; border-radius: 2px; border: 1px solid var(--border); background: var(--surface); }
        .cell.active { background: rgba(240, 192, 64, 0.35); border-color: var(--accent5); }
        .cell.current { background: rgba(255, 107, 53, 0.85); border-color: var(--accent2); box-shadow: 0 0 10px rgba(255, 107, 53, 0.5); }
        canvas { width: 100%; height: 100px; display: block; background: #07090c; border: 1px solid var(--border); border-radius: 6px; }
        .wav-btn { width: 100%; padding: 11px 14px; border-color: var(--accent3); color: var(--accent3); background: rgba(168, 255, 62, 0.06); }
        .wav-btn:hover { background: rgba(168, 255, 62, 0.12); }
        .wav-btn:disabled { opacity: 0.4; cursor: not-allowed; }
        audio { width: 100%; margin-top: 10px; display: none; }
        .interp-text { font-size: 0.78rem; color: var(--muted); margin-top: 10px; font-style: italic; min-height: 30px; }
        @media (max-width: 860px) { .layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<main>
    <header>
        <div>
            <h1>FEEDBACK EN VIVO</h1>
            <p class="subtitle">Música que refleja tu sesión de código</p>
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
            <section class="panel fb-border" data-label="Métricas de sesión" style="flex:1;display:flex;flex-direction:column;gap:16px;">
                <p style="margin:0;font-size:0.78rem;color:var(--muted);line-height:1.5;">
                    Ingresa las métricas de tu sesión de código. La música se adaptará automáticamente.
                </p>
                <div class="metrics-grid">
                    <div class="metric-input">
                        <label>Teclas por minuto</label>
                        <input type="number" id="kpm" value="60" min="0" max="300">
                    </div>
                    <div class="metric-input">
                        <label>Errores (último minuto)</label>
                        <input type="number" id="errors" value="0" min="0" max="50">
                    </div>
                    <div class="metric-input">
                        <label>Líneas escritas</label>
                        <input type="number" id="lines" value="10" min="0" max="200">
                    </div>
                    <div class="metric-input">
                        <label>Borrados</label>
                        <input type="number" id="deletions" value="0" min="0" max="100">
                    </div>
                </div>

                <div class="auto-compose-row">
                    <input type="checkbox" id="auto-compose" checked>
                    <label class="toggle-label" for="auto-compose">Auto-componer al cambiar</label>
                </div>
                <button class="compose-btn-fb" id="compose-btn">Componer ahora</button>
                <p class="interp-text" id="interp-text">Ajusta las métricas y la música reflejará tu estado de codificación.</p>
            </section>

            <section class="panel" data-label="Estado del mood">
                <div class="status">
                    <div class="metric"><span class="k">Mood</span><span class="v" id="mood-label">—</span></div>
                    <div class="metric"><span class="k">Escala</span><span class="v" id="current-scale">—</span></div>
                    <div class="metric"><span class="k">BPM</span><span class="v" id="current-bpm">—</span></div>
                    <div class="metric"><span class="k">Pasos</span><span class="v" id="current-steps">—</span></div>
                </div>
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
    let masterGain = null, animFrameId = null, scheduledTimeouts = [], debounceTimer = null;

    const bpmInput = document.getElementById("bpm");
    const bpmDisplay = document.getElementById("bpm-display");
    const loopsInput = document.getElementById("loops");
    const loopsDisplay = document.getElementById("loops-display");
    const waveSelect = document.getElementById("wave");
    const playBtn = document.getElementById("play");
    const stopBtn = document.getElementById("stop");
    const composeBtn = document.getElementById("compose-btn");
    const autoComposeChk = document.getElementById("auto-compose");
    const kpmInput = document.getElementById("kpm");
    const errorsInput = document.getElementById("errors");
    const linesInput = document.getElementById("lines");
    const deletionsInput = document.getElementById("deletions");
    const interpText = document.getElementById("interp-text");
    const roll = document.getElementById("roll");
    const waveformCanvas = document.getElementById("waveform");
    const waveformCtx = waveformCanvas.getContext("2d");
    const wavPlayer = document.getElementById("wav-player");
    const downloadWavBtn = document.getElementById("download-wav-btn");

    bpmInput.addEventListener("input", function() { activeBpm = Number(bpmInput.value); bpmDisplay.textContent = String(activeBpm); });
    loopsInput.addEventListener("input", function() { loopsDisplay.textContent = String(loopsInput.value); });

    [kpmInput, errorsInput, linesInput, deletionsInput].forEach(function(inp) {
        inp.addEventListener("input", function() {
            if (!autoComposeChk.checked) return;
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(composeFromMetrics, 600);
        });
    });

    composeBtn.addEventListener("click", composeFromMetrics);

    function composeFromMetrics() {
        const payload = {
            keystrokesPerMinute: Number(kpmInput.value),
            errorsLastMinute: Number(errorsInput.value),
            linesWritten: Number(linesInput.value),
            deletions: Number(deletionsInput.value)
        };
        composeBtn.disabled = true;
        fetch("/api/feedback", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(payload)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            applyMelody(data);
            interpText.textContent = data.interpretation || "";
            updateMoodLabel(data);
            composeBtn.disabled = false;
        })
        .catch(function(e) {
            interpText.textContent = "Error: " + e.message;
            composeBtn.disabled = false;
        });
    }

    function updateMoodLabel(data) {
        const kpm = Number(kpmInput.value);
        const errors = Number(errorsInput.value);
        let mood = "concentrado";
        if (errors > 5) mood = "firefighting 🔥";
        else if (errors > 2) mood = "debugging 🐛";
        else if (kpm > 100) mood = "en flujo ⚡";
        else if (kpm < 40) mood = "pensativo 🤔";
        document.getElementById("mood-label").textContent = mood;
    }

    function applyMelody(data) {
        currentMelody = data;
        buildRoll();
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
        waveformCtx.strokeStyle = "#f0c040"; waveformCtx.lineWidth = 1.5; waveformCtx.beginPath();
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
        gain.gain.setValueAtTime(0.0001, when);
        gain.gain.linearRampToValueAtTime(0.75, when + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.45, when + Math.max(duration - 0.04, 0.02));
        gain.gain.exponentialRampToValueAtTime(0.0001, when + duration);
        osc.connect(gain); gain.connect(masterGain); osc.start(when); osc.stop(when + duration);
        const id = window.setTimeout(function() { markCurrentStep(stepInfo.step); }, Math.max(0, (when - audioCtx.currentTime) * 1000));
        scheduledTimeouts.push(id);
    }

    playBtn.addEventListener("click", function() {
        if (!currentMelody) { composeFromMetrics(); return; }
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
            effectReverb: 0.3, effectDelay: 0.2, intensity: 0.8,
            loops: Number(loopsInput.value)
        };
        fetch("/api/synthesize", { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(payload) })
        .then(function(res) { if (!res.ok) throw new Error("HTTP " + res.status); return res.blob(); })
        .then(function(blob) {
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a"); a.href = url; a.download = "ether-feedback.wav"; a.click();
            wavPlayer.src = url; wavPlayer.style.display = "block";
            downloadWavBtn.textContent = "Descargar WAV"; downloadWavBtn.disabled = false;
        })
        .catch(function(e) {
            interpText.textContent = "Error al generar WAV: " + e.message;
            downloadWavBtn.textContent = "Descargar WAV"; downloadWavBtn.disabled = false;
        });
    });

    // Composición inicial
    window.addEventListener("load", function() { composeFromMetrics(); });

    if (navigator.serviceWorker) {
        window.addEventListener("load", function() {
            navigator.serviceWorker.register("/sw.js", { scope: "/" }).catch(function(e) { console.warn("SW:", e); });
        });
    }
</script>
</body>
</html>
