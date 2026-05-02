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
            --accent4: #bf5fff; --accent5: #7c4dff;
            --text: #c9d6df; --muted: #5f7486;
            --font-mono: "Share Tech Mono", monospace; --font-display: "Bebas Neue", sans-serif;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh;
            background: radial-gradient(circle at top left, rgba(124, 77, 255, 0.07), transparent 35%),
                        radial-gradient(circle at bottom right, rgba(0, 229, 255, 0.06), transparent 35%),
                        linear-gradient(180deg, #05070a 0%, #090b0f 100%);
            color: var(--text); font-family: var(--font-mono); padding: 24px; display: flex; flex-direction: column;
        }
        body::before { content: ""; position: fixed; inset: 0; pointer-events: none; background: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(124, 77, 255, 0.007) 2px, rgba(124, 77, 255, 0.007) 4px); }
        main { position: relative; z-index: 1; width: min(1300px, 100%); margin: 0 auto; flex: 1; display: flex; flex-direction: column; }
        header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
        h1 { margin: 0; font-family: var(--font-display); font-size: clamp(2.5rem, 6vw, 4.5rem); letter-spacing: 0.08em; line-height: 0.95; color: var(--accent5); text-shadow: 0 0 40px rgba(124, 77, 255, 0.35); }
        .subtitle { margin-top: 6px; font-size: 0.78rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .nav-links { display: flex; gap: 12px; font-size: 0.72rem; letter-spacing: 0.12em; flex-wrap: wrap; }
        .nav-links a { color: var(--muted); text-decoration: none; padding: 6px 12px; border: 1px solid var(--border); border-radius: 4px; transition: all 0.2s; }
        .nav-links a:hover { color: var(--accent); border-color: var(--accent); }
        .panel { position: relative; background: rgba(17, 24, 32, 0.92); border: 1px solid var(--border); border-radius: 8px; padding: 18px; overflow: hidden; }
        .panel::before { content: attr(data-label); position: absolute; top: 10px; right: 14px; font-size: 0.62rem; letter-spacing: 0.22em; color: var(--muted); text-transform: uppercase; }
        .panel.sq-border { border-color: rgba(124, 77, 255, 0.4); }

        /* Controls */
        .controls-bar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; margin-bottom: 16px; }
        .btn { padding: 9px 16px; border: 1px solid var(--border); border-radius: 4px; font-family: var(--font-mono); font-size: 0.78rem; letter-spacing: 0.1em; cursor: pointer; transition: all 0.18s; background: var(--surface); color: var(--text); }
        .btn:hover { border-color: var(--accent5); color: var(--accent5); }
        .btn.accent { background: var(--accent5); color: #fff; border-color: var(--accent5); }
        .btn.accent:hover { background: transparent; color: var(--accent5); }
        .btn.play { background: var(--accent3); color: #000; border-color: var(--accent3); }
        .btn.play:hover { background: transparent; color: var(--accent3); }
        .btn.stop { background: var(--accent2); color: #fff; border-color: var(--accent2); }
        .btn.stop:hover { background: transparent; color: var(--accent2); }
        .bpm-group { display: flex; align-items: center; gap: 8px; margin-left: auto; }
        .bpm-group label { font-size: 0.68rem; letter-spacing: 0.18em; color: var(--muted); text-transform: uppercase; }
        .bpm-group input[type="range"] { accent-color: var(--accent5); width: 120px; }
        .bpm-val { font-size: 1rem; color: var(--accent5); min-width: 60px; }

        /* Sequencer Grid */
        .sequencer-wrap { overflow-x: auto; padding-bottom: 8px; }
        .sequencer-grid { display: flex; flex-direction: column; border: 1px solid rgba(124, 77, 255, 0.3); border-radius: 6px; min-width: max-content; }
        .seq-row { display: flex; align-items: stretch; }
        .seq-row:not(:last-child) { border-bottom: 1px solid rgba(124, 77, 255, 0.1); }
        .note-label {
            width: 44px; min-width: 44px; display: flex; align-items: center; justify-content: center;
            font-size: 0.65rem; letter-spacing: 0.08em; color: var(--muted);
            border-right: 1px solid rgba(124, 77, 255, 0.2); background: rgba(124, 77, 255, 0.05);
            user-select: none;
        }
        .note-label.black-key { background: rgba(124, 77, 255, 0.12); color: var(--accent5); }
        .seq-cell {
            width: 38px; min-width: 38px; height: 38px; border-right: 1px solid rgba(124, 77, 255, 0.08);
            cursor: pointer; transition: background 0.12s; position: relative;
            background: transparent;
        }
        .seq-cell:hover { background: rgba(124, 77, 255, 0.18); }
        .seq-cell.active { background: var(--accent5); }
        .seq-cell.active:hover { background: rgba(124, 77, 255, 0.75); }
        .seq-cell.beat-marker { border-right-color: rgba(124, 77, 255, 0.3); }
        .seq-cell.playing { background: var(--accent3) !important; }
        .seq-cell:last-child { border-right: none; }

        /* Step numbers row */
        .step-numbers { display: flex; }
        .step-num-spacer { width: 44px; min-width: 44px; }
        .step-num {
            width: 38px; min-width: 38px; height: 22px; display: flex; align-items: center; justify-content: center;
            font-size: 0.58rem; color: var(--muted); border-right: 1px solid rgba(124, 77, 255, 0.08);
        }
        .step-num.beat { color: var(--accent5); }

        /* Bottom panels */
        .bottom-row { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; margin-top: 16px; }
        .synth-select select { width: 100%; padding: 8px 10px; background: var(--surface); border: 1px solid var(--border); border-radius: 4px; color: var(--text); font-family: var(--font-mono); font-size: 0.82rem; }
        .synth-select select:focus { outline: none; border-color: var(--accent5); }
        .effect-row { display: flex; flex-direction: column; gap: 8px; }
        .effect-item { display: flex; align-items: center; gap: 10px; font-size: 0.72rem; color: var(--muted); }
        .effect-item span { min-width: 60px; text-align: right; color: var(--text); }
        .effect-item input[type="range"] { flex: 1; accent-color: var(--accent5); }
        .status-box { font-size: 0.72rem; line-height: 1.6; color: var(--muted); min-height: 60px; }
        .status-box .val { color: var(--accent5); }

        /* Download area */
        .download-row { display: flex; gap: 10px; margin-top: 16px; align-items: center; flex-wrap: wrap; }
        .dl-status { font-size: 0.72rem; color: var(--muted); }

        /* Piano roll hint strip */
        .hint-strip { display: flex; gap: 6px; align-items: center; font-size: 0.68rem; color: var(--muted); margin-bottom: 10px; }
        .hint-key { display: inline-block; padding: 3px 8px; border: 1px solid var(--border); border-radius: 3px; }

        @media (max-width: 900px) {
            .bottom-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<main>
    <header>
        <div>
            <h1>SEQUENCER</h1>
            <p class="subtitle">Piano Roll Interactivo — Compón Visualmente</p>
        </div>
        <nav class="nav-links">
            <a href="/">Inicio</a>
            <a href="/create">Crear</a>
            <a href="/electronic">Electrónico</a>
            <a href="/conversation">Conversación</a>
            <a href="/feedback">Feedback</a>
            <a href="/visual-input">Visual</a>
        </nav>
    </header>

    <div class="panel sq-border" data-label="CONTROLES" style="margin-bottom:16px;">
        <div class="controls-bar">
            <button class="btn play" id="play-btn">▶ Reproducir</button>
            <button class="btn stop" id="stop-btn">⏹ Detener</button>
            <button class="btn" id="add-step-btn">+ Paso</button>
            <button class="btn" id="remove-step-btn">– Paso</button>
            <button class="btn" id="clear-btn">🗑 Limpiar</button>
            <button class="btn accent" id="download-btn">⬇ Descargar WAV</button>
            <div class="bpm-group">
                <label>BPM</label>
                <input type="range" id="bpm-slider" min="40" max="200" value="120">
                <span class="bpm-val" id="bpm-display">120</span>
            </div>
        </div>
        <div class="hint-strip">
            <span class="hint-key">Clic</span> activar/desactivar nota &nbsp;|&nbsp;
            <span class="hint-key">Espacio</span> reproducir/detener &nbsp;|&nbsp;
            <span class="hint-key">C</span> limpiar todo
        </div>
    </div>

    <div class="panel sq-border" data-label="PIANO ROLL" style="margin-bottom:0;">
        <div class="step-numbers" id="step-numbers"></div>
        <div class="sequencer-wrap">
            <div class="sequencer-grid" id="sequencer-grid"></div>
        </div>
    </div>

    <div class="bottom-row">
        <div class="panel" data-label="SINTETIZADOR">
            <div class="synth-select" style="margin-bottom:12px;">
                <label style="font-size:0.68rem;letter-spacing:0.18em;color:var(--muted);text-transform:uppercase;display:block;margin-bottom:6px;">Tipo de Síntesis</label>
                <select id="synth-type">
                    <option value="fm">FM Synthesis</option>
                    <option value="additive">Additive</option>
                    <option value="wavetable">Wavetable</option>
                </select>
            </div>
            <div class="effect-row">
                <div class="effect-item">
                    <label>Reverb</label>
                    <input type="range" id="reverb" min="0" max="100" value="30">
                    <span id="reverb-val">0.30</span>
                </div>
                <div class="effect-item">
                    <label>Delay</label>
                    <input type="range" id="delay" min="0" max="100" value="20">
                    <span id="delay-val">0.20</span>
                </div>
                <div class="effect-item">
                    <label>Intensidad</label>
                    <input type="range" id="intensity" min="10" max="100" value="80">
                    <span id="intensity-val">0.80</span>
                </div>
            </div>
        </div>

        <div class="panel" data-label="ESTADO">
            <div class="status-box" id="status-box">
                <div>Pasos: <span class="val" id="stat-steps">16</span></div>
                <div>BPM: <span class="val" id="stat-bpm">120</span></div>
                <div>Notas activas: <span class="val" id="stat-notes">0</span></div>
                <div>Síntesis: <span class="val" id="stat-synth">fm</span></div>
                <div id="stat-playing" style="color:var(--accent3);display:none;">▶ REPRODUCIENDO...</div>
            </div>
        </div>

        <div class="panel" data-label="EXPORTAR">
            <p style="font-size:0.72rem;color:var(--muted);line-height:1.6;margin:0 0 12px;">
                Renderiza la composición en el servidor usando el sintetizador seleccionado y descarga el audio WAV.
            </p>
            <div class="download-row">
                <button class="btn accent" id="download-btn-2">⬇ WAV desde Servidor</button>
            </div>
            <div class="dl-status" id="dl-status" style="margin-top:8px;"></div>
        </div>
    </div>
</main>

<script>
const NOTES = [
    { label: "C5",  freq: 523.25, black: false },
    { label: "B4",  freq: 493.88, black: false },
    { label: "A#4", freq: 466.16, black: true  },
    { label: "A4",  freq: 440.00, black: false },
    { label: "G#4", freq: 415.30, black: true  },
    { label: "G4",  freq: 392.00, black: false },
    { label: "F#4", freq: 369.99, black: true  },
    { label: "F4",  freq: 349.23, black: false },
    { label: "E4",  freq: 329.63, black: false },
    { label: "D#4", freq: 311.13, black: true  },
    { label: "D4",  freq: 293.66, black: false },
    { label: "C#4", freq: 277.18, black: true  },
    { label: "C4",  freq: 261.63, black: false }
];

let steps = 16;
let bpm = 120;
let isPlaying = false;
let playInterval = null;
let currentStep = -1;
let audioCtx = null;

const grid = document.getElementById("sequencer-grid");
const stepNumbersEl = document.getElementById("step-numbers");

function buildGrid() {
    grid.innerHTML = "";
    stepNumbersEl.innerHTML = "";

    // Step numbers header
    const spacer = document.createElement("div");
    spacer.className = "step-num-spacer";
    stepNumbersEl.appendChild(spacer);
    for (let s = 0; s < steps; s++) {
        const sn = document.createElement("div");
        sn.className = "step-num" + ((s % 4 === 0) ? " beat" : "");
        sn.textContent = s + 1;
        stepNumbersEl.appendChild(sn);
    }

    // Note rows
    NOTES.forEach((note, rowIdx) => {
        const row = document.createElement("div");
        row.className = "seq-row";

        const label = document.createElement("div");
        label.className = "note-label" + (note.black ? " black-key" : "");
        label.textContent = note.label;
        row.appendChild(label);

        for (let s = 0; s < steps; s++) {
            const cell = document.createElement("div");
            cell.className = "seq-cell" + ((s % 4 === 3) ? " beat-marker" : "");
            cell.dataset.row = rowIdx;
            cell.dataset.step = s;
            cell.addEventListener("click", () => toggleCell(cell));
            row.appendChild(cell);
        }

        grid.appendChild(row);
    });

    updateStats();
}

function toggleCell(cell) {
    cell.classList.toggle("active");
    updateStats();
}

function getActiveCells() {
    return document.querySelectorAll(".seq-cell.active");
}

function updateStats() {
    document.getElementById("stat-steps").textContent = steps;
    document.getElementById("stat-bpm").textContent = bpm;
    document.getElementById("stat-notes").textContent = getActiveCells().length;
    document.getElementById("stat-synth").textContent = document.getElementById("synth-type").value;
}

function getOrCreateAudioCtx() {
    if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    return audioCtx;
}

function playNote(freq, duration) {
    const ctx = getOrCreateAudioCtx();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.type = "sine";
    osc.frequency.setValueAtTime(freq, ctx.currentTime);
    gain.gain.setValueAtTime(0, ctx.currentTime);
    gain.gain.linearRampToValueAtTime(0.4, ctx.currentTime + 0.01);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + duration * 0.9);
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + duration);
}

function startPlayback() {
    if (isPlaying) return;
    isPlaying = true;
    currentStep = -1;
    document.getElementById("stat-playing").style.display = "";
    const stepDuration = 60 / bpm;

    playInterval = setInterval(() => {
        // Remove previous highlight
        document.querySelectorAll(".seq-cell.playing").forEach(c => c.classList.remove("playing"));

        currentStep = (currentStep + 1) % steps;

        // Highlight current step column and play notes
        for (let rowIdx = 0; rowIdx < NOTES.length; rowIdx++) {
            const cell = document.querySelector(".seq-cell[data-row=\"" + rowIdx + "\"][data-step=\"" + currentStep + "\"]");
            if (cell) {
                cell.classList.add("playing");
                if (cell.classList.contains("active")) {
                    playNote(NOTES[rowIdx].freq, stepDuration * 0.85);
                }
            }
        }
    }, stepDuration * 1000);
}

function stopPlayback() {
    isPlaying = false;
    clearInterval(playInterval);
    playInterval = null;
    document.querySelectorAll(".seq-cell.playing").forEach(c => c.classList.remove("playing"));
    document.getElementById("stat-playing").style.display = "none";
}

function buildMelodyPayload() {
    const melody = [];
    for (let s = 0; s < steps; s++) {
        let found = false;
        for (let r = 0; r < NOTES.length; r++) {
            const cell = document.querySelector(".seq-cell[data-row=\"" + r + "\"][data-step=\"" + s + "\"]");
            if (cell && cell.classList.contains("active")) {
                melody.push({
                    step: s,
                    rest: false,
                    noteIndex: NOTES.length - 1 - r,
                    noteName: NOTES[r].label,
                    frequencyHz: NOTES[r].freq
                });
                found = true;
                break;
            }
        }
        if (!found) {
            melody.push({ step: s, rest: true, noteIndex: 0, noteName: "C4", frequencyHz: 261.63 });
        }
    }
    return {
        melody,
        bpm,
        synthesizer: document.getElementById("synth-type").value,
        effectReverb: parseFloat(document.getElementById("reverb").value) / 100,
        effectDelay: parseFloat(document.getElementById("delay").value) / 100,
        intensity: parseFloat(document.getElementById("intensity").value) / 100,
        loops: 1
    };
}

async function downloadWav() {
    const dlStatus = document.getElementById("dl-status");
    dlStatus.textContent = "Sintetizando en servidor...";
    try {
        const payload = buildMelodyPayload();
        const res = await fetch("/api/synthesize", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(payload)
        });
        if (!res.ok) throw new Error("Error " + res.status);
        const blob = await res.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download = "sequencer-melody.wav";
        a.click();
        URL.revokeObjectURL(url);
        dlStatus.textContent = "¡Descarga iniciada!";
    } catch (e) {
        dlStatus.textContent = "Error al sintetizar: " + e.message;
    }
}

// Wire controls
document.getElementById("play-btn").addEventListener("click", startPlayback);
document.getElementById("stop-btn").addEventListener("click", stopPlayback);
document.getElementById("download-btn").addEventListener("click", downloadWav);
document.getElementById("download-btn-2").addEventListener("click", downloadWav);

document.getElementById("add-step-btn").addEventListener("click", () => {
    stopPlayback();
    steps = Math.min(steps + 1, 32);
    buildGrid();
});
document.getElementById("remove-step-btn").addEventListener("click", () => {
    stopPlayback();
    steps = Math.max(steps - 1, 4);
    buildGrid();
});
document.getElementById("clear-btn").addEventListener("click", () => {
    stopPlayback();
    document.querySelectorAll(".seq-cell.active").forEach(c => c.classList.remove("active"));
    updateStats();
});

document.getElementById("bpm-slider").addEventListener("input", e => {
    bpm = parseInt(e.target.value);
    document.getElementById("bpm-display").textContent = bpm;
    document.getElementById("stat-bpm").textContent = bpm;
    if (isPlaying) { stopPlayback(); startPlayback(); }
});

["reverb","delay","intensity"].forEach(id => {
    document.getElementById(id).addEventListener("input", e => {
        document.getElementById(id + "-val").textContent = (e.target.value / 100).toFixed(2);
    });
});

document.getElementById("synth-type").addEventListener("change", updateStats);

document.addEventListener("keydown", e => {
    if (e.target.tagName === "INPUT" || e.target.tagName === "SELECT") return;
    if (e.code === "Space") {
        e.preventDefault();
        isPlaying ? stopPlayback() : startPlayback();
    }
    if (e.key === "c" || e.key === "C") {
        document.querySelectorAll(".seq-cell.active").forEach(c => c.classList.remove("active"));
        updateStats();
    }
});

buildGrid();
</script>
</body>
</html>
