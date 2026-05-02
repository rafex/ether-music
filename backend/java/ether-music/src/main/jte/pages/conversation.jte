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
            --accent4: #bf5fff; --accent5: #00d4aa;
            --text: #c9d6df; --muted: #5f7486;
            --font-mono: "Share Tech Mono", monospace; --font-display: "Bebas Neue", sans-serif;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh;
            background: radial-gradient(circle at top left, rgba(0, 212, 170, 0.07), transparent 35%),
                        radial-gradient(circle at bottom right, rgba(0, 229, 255, 0.06), transparent 35%),
                        linear-gradient(180deg, #05070a 0%, #090b0f 100%);
            color: var(--text); font-family: var(--font-mono); padding: 24px;
            display: flex; flex-direction: column;
        }
        body::before {
            content: ""; position: fixed; inset: 0; pointer-events: none;
            background: repeating-linear-gradient(0deg, transparent, transparent 2px,
                rgba(0, 212, 170, 0.007) 2px, rgba(0, 212, 170, 0.007) 4px);
        }
        main { position: relative; z-index: 1; width: min(1100px, 100%); margin: 0 auto; flex: 1; display: flex; flex-direction: column; }
        header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
        h1 { margin: 0; font-family: var(--font-display); font-size: clamp(2.5rem, 6vw, 4.5rem); letter-spacing: 0.08em; line-height: 0.95; color: var(--accent5); text-shadow: 0 0 40px rgba(0, 212, 170, 0.35); }
        .subtitle { margin-top: 6px; font-size: 0.78rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .nav-links { display: flex; gap: 12px; font-size: 0.72rem; letter-spacing: 0.12em; }
        .nav-links a { color: var(--muted); text-decoration: none; padding: 6px 12px; border: 1px solid var(--border); border-radius: 4px; transition: all 0.2s; }
        .nav-links a:hover { color: var(--accent); border-color: var(--accent); }
        .layout { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; flex: 1; }
        .col-left, .col-right { display: flex; flex-direction: column; gap: 16px; }
        .panel {
            position: relative; background: rgba(17, 24, 32, 0.92);
            border: 1px solid var(--border); border-radius: 8px; padding: 18px; overflow: hidden;
        }
        .panel::before { content: attr(data-label); position: absolute; top: 10px; right: 14px; font-size: 0.62rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .panel.conv-border { border-color: rgba(0, 212, 170, 0.4); }
        textarea {
            width: 100%; min-height: 120px; background: var(--surface); border: 1px solid var(--border);
            border-radius: 4px; color: var(--text); font-family: var(--font-mono); font-size: 0.85rem;
            padding: 14px; resize: vertical; line-height: 1.6;
        }
        textarea:focus { outline: none; border-color: var(--accent5); box-shadow: 0 0 0 2px rgba(0, 212, 170, 0.15); }
        textarea::placeholder { color: var(--muted); }
        .compose-btn {
            width: 100%; padding: 14px; margin-top: 12px;
            border: 1px solid var(--accent5); background: rgba(0, 212, 170, 0.08);
            color: var(--accent5); font-family: var(--font-mono); font-size: 0.80rem;
            letter-spacing: 0.18em; text-transform: uppercase; border-radius: 4px; cursor: pointer; transition: all 0.2s;
        }
        .compose-btn:hover { background: rgba(0, 212, 170, 0.18); }
        .compose-btn:disabled { opacity: 0.45; cursor: not-allowed; }
        .suggestions { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 14px; }
        .suggestion-chip {
            border: 1px solid var(--border); background: transparent; color: var(--muted);
            border-radius: 20px; padding: 5px 12px; font-family: var(--font-mono); font-size: 0.68rem;
            letter-spacing: 0.08em; cursor: pointer; transition: all 0.2s;
        }
        .suggestion-chip:hover { border-color: var(--accent5); color: var(--accent5); background: rgba(0, 212, 170, 0.08); }
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
        .cell.active { background: rgba(0, 212, 170, 0.4); border-color: var(--accent5); }
        .cell.current { background: rgba(255, 107, 53, 0.85); border-color: var(--accent2); box-shadow: 0 0 10px rgba(255, 107, 53, 0.5); }
        canvas { width: 100%; height: 100px; display: block; background: #07090c; border: 1px solid var(--border); border-radius: 6px; }
        .wav-btn { width: 100%; padding: 11px 14px; border-color: var(--accent3); color: var(--accent3); background: rgba(168, 255, 62, 0.06); }
        .wav-btn:hover { background: rgba(168, 255, 62, 0.12); }
        .wav-btn:disabled { opacity: 0.4; cursor: not-allowed; }
        audio { width: 100%; margin-top: 10px; display: none; }
        .interpretation-box { padding: 12px 14px; background: rgba(0, 212, 170, 0.06); border: 1px solid rgba(0, 212, 170, 0.25); border-radius: 6px; font-size: 0.80rem; line-height: 1.55; color: var(--text); min-height: 40px; }
        @media (max-width: 860px) { .layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<main>
    <header>
        <div>
            <h1>CONVERSACIÓN</h1>
            <p class="subtitle">Describe tu música con palabras</p>
        </div>
        <nav class="nav-links">
            <a href="/">Inicio</a>
            <a href="/create">Crear</a>
            <a href="/electronic">Electrónica</a>
            <a href="/agent">Agente</a>
            <a href="/play">Biblioteca</a>
        </nav>
    </header>

    <div class="layout">
        <div class="col-left">
            <section class="panel conv-border" data-label="Descripción musical" style="flex:1;display:flex;flex-direction:column;gap:12px;">
                <p style="margin:0 0 8px;font-size:0.80rem;color:var(--muted);line-height:1.5;">
                    Describe libremente la música que quieres. Puedes combinar emociones, referencias, escenas o intenciones.
                </p>
                <div class="suggestions" id="suggestions">
                    <button class="suggestion-chip" data-text="Algo melancólico pero con esperanza, como el amanecer después de una noche difícil">Melancólico + esperanza</button>
                    <button class="suggestion-chip" data-text="Tensión de película de suspenso, oscuro y rápido">Suspenso</button>
                    <button class="suggestion-chip" data-text="Tranquilidad profunda para concentrarme programando">Concentración</button>
                    <button class="suggestion-chip" data-text="Épico y grandioso, como música de videojuego final">Épico</button>
                    <button class="suggestion-chip" data-text="Misterioso y onírico, como explorar lo desconocido">Misterioso</button>
                    <button class="suggestion-chip" data-text="Alegría tranquila, felicidad simple de una tarde de sol">Alegría tranquila</button>
                </div>
                <textarea id="description" placeholder="Describe la música que quieres... Ej: algo melancólico pero esperanzador, como ver la lluvia desde la ventana"></textarea>
                <button class="compose-btn" id="compose-btn">Componer desde descripción</button>
            </section>

            <section class="panel" data-label="Interpretación">
                <div class="interpretation-box" id="interpretation-box">La interpretación de la IA aparecerá aquí después de componer.</div>
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
                    <div class="metric"><span class="k">Escala</span><span class="v" id="current-scale">—</span></div>
                    <div class="metric"><span class="k">Nota</span><span class="v" id="current-note">—</span></div>
                    <div class="metric"><span class="k">Hz</span><span class="v" id="current-frequency">—</span></div>
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

    const bpmInput = document.getElementById("bpm");
    const bpmDisplay = document.getElementById("bpm-display");
    const loopsInput = document.getElementById("loops");
    const loopsDisplay = document.getElementById("loops-display");
    const waveSelect = document.getElementById("wave");
    const playBtn = document.getElementById("play");
    const stopBtn = document.getElementById("stop");
    const composeBtn = document.getElementById("compose-btn");
    const descInput = document.getElementById("description");
    const interpBox = document.getElementById("interpretation-box");
    const roll = document.getElementById("roll");
    const waveformCanvas = document.getElementById("waveform");
    const waveformCtx = waveformCanvas.getContext("2d");
    const wavPlayer = document.getElementById("wav-player");
    const downloadWavBtn = document.getElementById("download-wav-btn");

    bpmInput.addEventListener("input", function() { activeBpm = Number(bpmInput.value); bpmDisplay.textContent = String(activeBpm); });
    loopsInput.addEventListener("input", function() { loopsDisplay.textContent = String(loopsInput.value); });

    document.querySelectorAll(".suggestion-chip").forEach(function(chip) {
        chip.addEventListener("click", function() { descInput.value = chip.getAttribute("data-text"); descInput.focus(); });
    });

    descInput.addEventListener("keydown", function(e) {
        if (e.key === "Enter" && e.ctrlKey) { e.preventDefault(); composeBtn.click(); }
    });

    composeBtn.addEventListener("click", function() {
        const text = descInput.value.trim();
        if (!text) return;
        composeBtn.disabled = true;
        composeBtn.textContent = "Analizando con IA...";
        interpBox.textContent = "La IA está interpretando tu descripción...";

        fetch("/api/electronic/conversation", {
            method: "POST",
            headers: { "content-type": "text/plain; charset=utf-8" },
            body: text
        })
        .then(function(res) {
            if (!res.ok) return res.json().then(function(e) { throw new Error(e.error || "HTTP " + res.status); });
            return res.json();
        })
        .then(function(data) {
            applyMelody(data);
            interpBox.textContent = data.interpretation || (data.scaleLabel + " a " + data.bpm + " BPM");
            composeBtn.textContent = "Componer desde descripción";
            composeBtn.disabled = false;
        })
        .catch(function(e) {
            interpBox.textContent = "Error: " + e.message;
            composeBtn.textContent = "Componer desde descripción";
            composeBtn.disabled = false;
        });
    });

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
            const col = document.createElement("div");
            col.className = "column";
            for (let r = rows - 1; r >= 0; r--) {
                const cell = document.createElement("div");
                cell.className = "cell";
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
        document.getElementById("current-frequency").textContent = "—";
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
        waveformCtx.fillStyle = "#07090c";
        waveformCtx.fillRect(0, 0, waveformCanvas.width, waveformCanvas.height);
        waveformCtx.strokeStyle = "#00d4aa"; waveformCtx.lineWidth = 1.5; waveformCtx.beginPath();
        const sliceWidth = waveformCanvas.width / data.length;
        let x = 0;
        for (let i = 0; i < data.length; i++) {
            const y = (data[i] * waveformCanvas.height * 0.38) + waveformCanvas.height / 2;
            if (i === 0) waveformCtx.moveTo(x, y); else waveformCtx.lineTo(x, y);
            x += sliceWidth;
        }
        waveformCtx.stroke();
        animFrameId = requestAnimationFrame(drawWaveform);
    }

    function scheduleStep(stepInfo, when, duration) {
        if (!audioCtx || !masterGain || stepInfo.rest || !stepInfo.frequencyHz) {
            const id = window.setTimeout(function() { markCurrentStep(stepInfo.step); }, Math.max(0, (when - audioCtx.currentTime) * 1000));
            scheduledTimeouts.push(id); return;
        }
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = waveSelect.value;
        osc.frequency.setValueAtTime(stepInfo.frequencyHz, when);
        gain.gain.setValueAtTime(0.0001, when);
        gain.gain.linearRampToValueAtTime(0.75, when + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.45, when + Math.max(duration - 0.04, 0.02));
        gain.gain.exponentialRampToValueAtTime(0.0001, when + duration);
        osc.connect(gain); gain.connect(masterGain);
        osc.start(when); osc.stop(when + duration);
        const id = window.setTimeout(function() {
            markCurrentStep(stepInfo.step);
            document.getElementById("current-note").textContent = stepInfo.noteName || "Silencio";
            document.getElementById("current-frequency").textContent = stepInfo.frequencyHz ? (stepInfo.frequencyHz.toFixed(2) + " Hz") : "—";
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
            const a = document.createElement("a"); a.href = url; a.download = "ether-conversation.wav"; a.click();
            wavPlayer.src = url; wavPlayer.style.display = "block";
            downloadWavBtn.textContent = "Descargar WAV"; downloadWavBtn.disabled = false;
        })
        .catch(function(e) {
            interpBox.textContent = "Error al generar WAV: " + e.message;
            downloadWavBtn.textContent = "Descargar WAV"; downloadWavBtn.disabled = false;
        });
    });

    if (navigator.serviceWorker) {
        window.addEventListener("load", function() {
            navigator.serviceWorker.register("/sw.js", { scope: "/" }).catch(function(e) { console.warn("SW:", e); });
        });
    }
</script>
</body>
</html>
