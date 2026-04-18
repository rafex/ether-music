@param dev.rafex.ether.music.frontend.HomePageModel model
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${model.title()}</title>
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
            width: min(1080px, 100%);
            margin: 0 auto;
        }

        header {
            margin-bottom: 24px;
        }

        h1 {
            margin: 0;
            font-family: var(--font-display);
            font-size: clamp(3rem, 7vw, 5rem);
            letter-spacing: 0.08em;
            line-height: 0.95;
            color: var(--accent);
            text-shadow: 0 0 32px rgba(0, 229, 255, 0.25);
        }

        .subtitle {
            margin-top: 8px;
            font-size: 0.82rem;
            letter-spacing: 0.22em;
            color: var(--muted);
            text-transform: uppercase;
        }

        .grid {
            display: grid;
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

        .controls {
            display: grid;
            gap: 14px;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            align-items: end;
        }

        label {
            display: grid;
            gap: 8px;
            font-size: 0.72rem;
            letter-spacing: 0.15em;
            color: var(--muted);
            text-transform: uppercase;
        }

        select,
        input[type="range"] {
            width: 100%;
        }

        select {
            appearance: none;
            border: 1px solid var(--border);
            background: var(--surface);
            color: var(--text);
            border-radius: 4px;
            padding: 10px 12px;
            font-family: var(--font-mono);
        }

        input[type="range"] {
            accent-color: var(--accent);
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
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
        }

        button.secondary {
            color: var(--accent2);
            border-color: var(--accent2);
        }

        button.tertiary {
            color: var(--accent3);
            border-color: var(--accent3);
        }

        button:hover {
            background: rgba(0, 229, 255, 0.12);
        }

        .status {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 12px;
        }

        .metric {
            padding: 12px;
            border-radius: 6px;
            border: 1px solid var(--border);
            background: var(--surface);
        }

        .metric span {
            display: block;
        }

        .metric .k {
            font-size: 0.65rem;
            letter-spacing: 0.18em;
            color: var(--muted);
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .metric .v {
            font-size: 1rem;
            color: var(--accent);
        }

        #roll {
            display: grid;
            grid-template-columns: repeat(16, minmax(0, 1fr));
            gap: 4px;
            align-items: end;
            min-height: 240px;
        }

        .column {
            display: grid;
            gap: 4px;
        }

        .cell {
            height: 14px;
            border-radius: 2px;
            border: 1px solid var(--border);
            background: var(--surface);
        }

        .cell.active {
            background: rgba(0, 229, 255, 0.32);
            border-color: var(--accent);
        }

        .cell.current {
            background: rgba(255, 107, 53, 0.82);
            border-color: var(--accent2);
            box-shadow: 0 0 12px rgba(255, 107, 53, 0.5);
        }

        canvas {
            width: 100%;
            height: 140px;
            display: block;
            background: #07090c;
            border: 1px solid var(--border);
            border-radius: 6px;
        }

        pre {
            margin: 0;
            white-space: pre-wrap;
            color: var(--muted);
            font-size: 0.82rem;
            line-height: 1.45;
        }

        .tabs {
            display: flex;
            gap: 4px;
            margin-bottom: 16px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 0;
        }

        .tab-btn {
            border: 1px solid transparent;
            border-bottom: none;
            background: transparent;
            color: var(--muted);
            border-radius: 4px 4px 0 0;
            padding: 8px 14px;
            font-size: 0.72rem;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            cursor: pointer;
            position: relative;
            bottom: -1px;
        }

        .tab-btn.active {
            color: var(--accent);
            border-color: var(--border);
            border-bottom-color: var(--panel);
            background: var(--panel);
        }

        .tab-panel {
            display: none;
        }

        .tab-panel.active {
            display: block;
        }

        textarea {
            width: 100%;
            min-height: 90px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 4px;
            color: var(--text);
            font-family: var(--font-mono);
            font-size: 0.80rem;
            padding: 10px 12px;
            resize: vertical;
        }

        input[type="number"] {
            appearance: none;
            border: 1px solid var(--border);
            background: var(--surface);
            color: var(--text);
            border-radius: 4px;
            padding: 10px 12px;
            font-family: var(--font-mono);
            width: 100%;
        }

        .interpretation {
            margin-top: 10px;
            font-size: 0.72rem;
            color: var(--accent3);
            letter-spacing: 0.08em;
            min-height: 1.2em;
        }

        .song-card {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 8px;
            align-items: center;
            padding: 10px 14px;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: var(--surface);
        }

        .song-card .song-meta {
            font-size: 0.74rem;
            color: var(--text);
            line-height: 1.5;
        }

        .song-card .song-sub {
            font-size: 0.68rem;
            color: var(--muted);
            margin-top: 2px;
        }

        .song-card button {
            padding: 7px 12px;
            font-size: 0.68rem;
            white-space: nowrap;
        }

        @media (max-width: 720px) {
            body {
                padding: 16px;
            }

            #roll {
                grid-template-columns: repeat(8, minmax(0, 1fr));
            }
        }
    </style>
</head>
<body>
<main>
    <header>
        <h1>ETHER MUSIC</h1>
        <div class="subtitle">melodia algoritmica via rest + web audio</div>
    </header>

    <section class="panel" data-label="Input Mode">
        <div class="tabs">
            <button class="tab-btn active" data-tab="classic">Classic</button>
            <button class="tab-btn" data-tab="express">Express</button>
            <button class="tab-btn" data-tab="words">Word Cloud</button>
            <button class="tab-btn" data-tab="code">Code Session</button>
        </div>

        <div class="tab-panel active" id="tab-classic">
            <div class="controls">
                <label>
                    raiz
                    <select id="root">
                        <option>C</option>
                        <option>C#</option>
                        <option>D</option>
                        <option>D#</option>
                        <option>E</option>
                        <option>F</option>
                        <option>F#</option>
                        <option>G</option>
                        <option>G#</option>
                        <option>A</option>
                        <option>A#</option>
                        <option>B</option>
                    </select>
                </label>
                <label>
                    escala
                    <select id="scale">
                        <option value="minor">Menor natural</option>
                        <option value="major">Mayor</option>
                        <option value="dorian">Dorian</option>
                        <option value="pentatonic-major">Pentatonica mayor</option>
                        <option value="pentatonic-minor">Pentatonica menor</option>
                    </select>
                </label>
                <label>
                    octava
                    <input id="octave" type="range" min="2" max="6" value="4">
                </label>
                <label>
                    pasos
                    <input id="steps" type="range" min="8" max="32" step="8" value="16">
                </label>
                <label>
                    waveform
                    <select id="wave">
                        <option value="sine">Sine</option>
                        <option value="triangle" selected>Triangle</option>
                        <option value="square">Square</option>
                        <option value="sawtooth">Sawtooth</option>
                    </select>
                </label>
            </div>
            <div class="actions" style="margin-top:16px;">
                <button id="generate">Generar</button>
            </div>
        </div>

        <div class="tab-panel" id="tab-express">
            <div class="controls">
                <label>
                    mood
                    <select id="ex-mood">
                        <option value="happy">happy — alegre</option>
                        <option value="sad">sad — triste</option>
                        <option value="tense">tense — tenso</option>
                        <option value="calm">calm — tranquilo</option>
                        <option value="mysterious">mysterious — misterioso</option>
                        <option value="epic">epic — épico</option>
                    </select>
                </label>
                <label>
                    energy
                    <select id="ex-energy">
                        <option value="low">low</option>
                        <option value="medium" selected>medium</option>
                        <option value="high">high</option>
                    </select>
                </label>
                <label>
                    tempo
                    <select id="ex-tempo">
                        <option value="slow">slow</option>
                        <option value="medium" selected>medium</option>
                        <option value="fast">fast</option>
                    </select>
                </label>
                <label>
                    length
                    <select id="ex-length">
                        <option value="short">short — 8 pasos</option>
                        <option value="medium" selected>medium — 16 pasos</option>
                        <option value="long">long — 32 pasos</option>
                    </select>
                </label>
            </div>
            <div class="actions" style="margin-top:16px;">
                <button id="express-generate">Componer</button>
            </div>
            <div class="interpretation" id="ex-interpretation"></div>
        </div>

        <div class="tab-panel" id="tab-words">
            <label style="display:block;margin-bottom:10px;">
                palabras con peso (JSON array)
                <textarea id="words-input" spellcheck="false">[
  { "word": "love", "weight": 0.9 },
  { "word": "hope", "weight": 0.7 },
  { "word": "storm", "weight": 0.4 }
]</textarea>
            </label>
            <div class="actions">
                <button id="words-generate">Generar desde palabras</button>
            </div>
            <div class="interpretation" id="words-interpretation"></div>
        </div>

        <div class="tab-panel" id="tab-code">
            <div class="controls">
                <label>
                    keystrokes / min
                    <input id="code-kpm" type="number" min="0" max="400" value="80">
                </label>
                <label>
                    errores último min
                    <input id="code-errors" type="number" min="0" max="50" value="1">
                </label>
                <label>
                    líneas escritas
                    <input id="code-lines" type="number" min="0" max="200" value="20">
                </label>
                <label>
                    borrados
                    <input id="code-deletions" type="number" min="0" max="200" value="5">
                </label>
            </div>
            <div class="actions" style="margin-top:16px;">
                <button id="code-generate">Generar desde código</button>
            </div>
            <div class="interpretation" id="code-interpretation"></div>
        </div>

        <div style="margin-top:16px;border-top:1px solid var(--border);padding-top:14px;" class="actions">
            <button id="play" class="secondary">Play</button>
            <button id="stop" class="tertiary">Stop</button>
            <label style="display:inline-flex;align-items:center;gap:8px;font-size:0.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:0.15em;">
                bpm
                <input id="bpm" type="range" min="40" max="200" value="110" style="width:120px;">
                <span id="bpm-display">110</span>
            </label>
        </div>
    </section>

    <section class="panel" data-label="Telemetry">
        <div class="status">
            <div class="metric">
                <span class="k">Escala</span>
                <span class="v" id="current-scale">-</span>
            </div>
            <div class="metric">
                <span class="k">Nota actual</span>
                <span class="v" id="current-note">-</span>
            </div>
            <div class="metric">
                <span class="k">Frecuencia</span>
                <span class="v" id="current-frequency">- Hz</span>
            </div>
            <div class="metric">
                <span class="k">Pasos</span>
                <span class="v" id="current-steps">-</span>
            </div>
            <div class="metric">
                <span class="k">BPM</span>
                <span class="v" id="current-bpm">-</span>
            </div>
            <div class="metric">
                <span class="k">Fuente</span>
                <span class="v" id="current-source">-</span>
            </div>
        </div>
    </section>

    <section class="panel" data-label="Piano Roll">
        <div id="roll"></div>
    </section>

    <section class="panel" data-label="Waveform">
        <canvas id="waveform" width="960" height="140"></canvas>
    </section>

    <section class="panel" data-label="Log">
        <pre id="log">Listo para generar una melodia...</pre>
    </section>

    <section class="panel" data-label="History">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
            <span style="font-size:0.72rem;letter-spacing:0.15em;color:var(--muted);text-transform:uppercase;">canciones guardadas</span>
            <button id="history-refresh" class="secondary" style="padding:6px 12px;font-size:0.68rem;">Actualizar</button>
        </div>
        <div id="history-list" style="display:grid;gap:8px;">
            <span style="color:var(--muted);font-size:0.80rem;">Cargando historial...</span>
        </div>
    </section>
</main>

<script>
const apiEndpoint = "${model.apiEndpoint()}";
const rootSelect = document.getElementById("root");
const scaleSelect = document.getElementById("scale");
const octaveInput = document.getElementById("octave");
const stepsInput = document.getElementById("steps");
const bpmInput = document.getElementById("bpm");
const bpmDisplay = document.getElementById("bpm-display");
const waveSelect = document.getElementById("wave");
const generateBtn = document.getElementById("generate");
const expressGenerateBtn = document.getElementById("express-generate");
const wordsGenerateBtn = document.getElementById("words-generate");
const codeGenerateBtn = document.getElementById("code-generate");
const playBtn = document.getElementById("play");
const stopBtn = document.getElementById("stop");
const roll = document.getElementById("roll");
const logNode = document.getElementById("log");
const currentScaleNode = document.getElementById("current-scale");
const currentNoteNode = document.getElementById("current-note");
const currentFrequencyNode = document.getElementById("current-frequency");
const currentStepsNode = document.getElementById("current-steps");
const currentBpmNode = document.getElementById("current-bpm");
const currentSourceNode = document.getElementById("current-source");
const waveformCanvas = document.getElementById("waveform");
const waveformCtx = waveformCanvas.getContext("2d");

let currentMelody = null;
let activeBpm = 110;
let audioCtx = null;
let analyser = null;
let masterGain = null;
let animationFrameId = null;
let scheduledTimeouts = [];

bpmInput.addEventListener("input", () => {
    activeBpm = Number(bpmInput.value);
    bpmDisplay.textContent = String(activeBpm);
});

document.querySelectorAll(".tab-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
        const tab = btn.dataset.tab;
        document.querySelectorAll(".tab-btn").forEach((b) => b.classList.remove("active"));
        document.querySelectorAll(".tab-panel").forEach((p) => p.classList.remove("active"));
        btn.classList.add("active");
        document.getElementById("tab-" + tab).classList.add("active");
    });
});

function log(message) {
    logNode.textContent = message;
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
        animationFrameId = requestAnimationFrame(drawWaveform);
        return;
    }
    const bufferLength = analyser.fftSize;
    const data = new Float32Array(bufferLength);
    analyser.getFloatTimeDomainData(data);
    waveformCtx.fillStyle = "#07090c";
    waveformCtx.fillRect(0, 0, waveformCanvas.width, waveformCanvas.height);
    waveformCtx.strokeStyle = "#00e5ff";
    waveformCtx.lineWidth = 1.5;
    waveformCtx.beginPath();
    const sliceWidth = waveformCanvas.width / bufferLength;
    let x = 0;
    for (let i = 0; i < bufferLength; i++) {
        const y = (data[i] * waveformCanvas.height * 0.38) + waveformCanvas.height / 2;
        if (i === 0) waveformCtx.moveTo(x, y);
        else waveformCtx.lineTo(x, y);
        x += sliceWidth;
    }
    waveformCtx.stroke();
    animationFrameId = requestAnimationFrame(drawWaveform);
}

function applyMelody(data) {
    currentMelody = data;
    buildRoll();
    currentScaleNode.textContent = data.request.root + " " + data.scaleLabel;
    currentStepsNode.textContent = String(data.request.steps);
    currentBpmNode.textContent = data.bpm != null ? String(data.bpm) : String(activeBpm);
    currentSourceNode.textContent = data.source ?? "classic";
    if (data.bpm != null) {
        activeBpm = data.bpm;
        bpmInput.value = activeBpm;
        bpmDisplay.textContent = String(activeBpm);
    }
}

function buildRoll() {
    const steps = currentMelody?.melody ?? [];
    const rows = currentMelody?.palette?.length ?? 0;
    roll.style.gridTemplateColumns = "repeat(" + Math.max(steps.length, 1) + ", minmax(0, 1fr))";
    roll.innerHTML = "";
    steps.forEach((stepInfo) => {
        const column = document.createElement("div");
        column.className = "column";
        for (let row = rows - 1; row >= 0; row--) {
            const cell = document.createElement("div");
            cell.className = "cell";
            if (!stepInfo.rest && stepInfo.noteIndex === row) cell.classList.add("active");
            cell.dataset.step = String(stepInfo.step);
            cell.dataset.row = String(row);
            column.appendChild(cell);
        }
        roll.appendChild(column);
    });
}

function markCurrentStep(step) {
    document.querySelectorAll(".cell.current").forEach((n) => n.classList.remove("current"));
    document.querySelectorAll('.cell[data-step="' + step + '"]').forEach((n) => n.classList.add("current"));
}

function clearPlaybackState() {
    scheduledTimeouts.forEach((id) => clearTimeout(id));
    scheduledTimeouts = [];
    document.querySelectorAll(".cell.current").forEach((n) => n.classList.remove("current"));
    currentNoteNode.textContent = "-";
    currentFrequencyNode.textContent = "- Hz";
}

async function fetchClassic() {
    const params = new URLSearchParams({
        root: rootSelect.value,
        scale: scaleSelect.value,
        octave: octaveInput.value,
        steps: stepsInput.value,
        bpm: String(activeBpm)
    });
    const res = await fetch(apiEndpoint + "?" + params.toString());
    if (!res.ok) throw new Error("API error " + res.status);
    const data = await res.json();
    data.source = "classic";
    data.bpm = null;
    return data;
}

async function fetchExpress() {
    const body = {
        mood: document.getElementById("ex-mood").value,
        energy: document.getElementById("ex-energy").value,
        tempo: document.getElementById("ex-tempo").value,
        length: document.getElementById("ex-length").value
    };
    const res = await fetch("/api/express/create", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(body)
    });
    if (!res.ok) throw new Error("API error " + res.status);
    return res.json();
}

async function fetchWords() {
    const raw = document.getElementById("words-input").value.trim();
    let words;
    try {
        words = JSON.parse(raw);
    } catch (e) {
        throw new Error("JSON inválido en palabras: " + e.message);
    }
    const res = await fetch("/api/data/words", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ words })
    });
    if (!res.ok) throw new Error("API error " + res.status);
    return res.json();
}

async function fetchCode() {
    const body = {
        keystrokesPerMinute: Number(document.getElementById("code-kpm").value) || 0,
        errorsLastMinute: Number(document.getElementById("code-errors").value) || 0,
        linesWritten: Number(document.getElementById("code-lines").value) || 0,
        deletions: Number(document.getElementById("code-deletions").value) || 0
    };
    const res = await fetch("/api/data/code", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(body)
    });
    if (!res.ok) throw new Error("API error " + res.status);
    return res.json();
}

function scheduleStep(stepInfo, when, duration) {
    if (!audioCtx || !masterGain || stepInfo.rest || !stepInfo.frequencyHz) {
        const id = window.setTimeout(() => markCurrentStep(stepInfo.step), Math.max(0, (when - audioCtx.currentTime) * 1000));
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
    const id = window.setTimeout(() => {
        markCurrentStep(stepInfo.step);
        currentNoteNode.textContent = stepInfo.noteName ?? "Silencio";
        currentFrequencyNode.textContent = stepInfo.frequencyHz ? (stepInfo.frequencyHz.toFixed(2) + " Hz") : "- Hz";
    }, Math.max(0, (when - audioCtx.currentTime) * 1000));
    scheduledTimeouts.push(id);
}

async function playMelody() {
    if (!currentMelody) return;
    initAudio();
    clearPlaybackState();
    if (audioCtx.state === "suspended") await audioCtx.resume();
    const stepDuration = (60 / activeBpm) / 2;
    const startAt = audioCtx.currentTime + 0.08;
    currentMelody.melody.forEach((stepInfo, index) => {
        scheduleStep(stepInfo, startAt + (index * stepDuration), stepDuration * 0.85);
    });
    log("Reproduciendo a " + activeBpm + " BPM · " + currentMelody.melody.length + " pasos · fuente: " + (currentMelody.source ?? "classic"));
}

generateBtn.addEventListener("click", async () => {
    try {
        clearPlaybackState();
        const data = await fetchClassic();
        applyMelody(data);
        log("Classic · " + data.request.root + " " + data.scaleLabel + " · " + data.algorithm);
    } catch (e) { log("Error: " + e.message); }
});

expressGenerateBtn.addEventListener("click", async () => {
    try {
        clearPlaybackState();
        const data = await fetchExpress();
        applyMelody(data);
        document.getElementById("ex-interpretation").textContent = data.interpretation ?? "";
        log("Express · " + data.interpretation);
    } catch (e) { log("Error: " + e.message); }
});

wordsGenerateBtn.addEventListener("click", async () => {
    try {
        clearPlaybackState();
        const data = await fetchWords();
        applyMelody(data);
        document.getElementById("words-interpretation").textContent = data.interpretation ?? "";
        log("Words · " + data.interpretation);
    } catch (e) { log("Error: " + e.message); }
});

codeGenerateBtn.addEventListener("click", async () => {
    try {
        clearPlaybackState();
        const data = await fetchCode();
        applyMelody(data);
        document.getElementById("code-interpretation").textContent = data.interpretation ?? "";
        log("Code · " + data.interpretation);
    } catch (e) { log("Error: " + e.message); }
});

playBtn.addEventListener("click", async () => {
    try { await playMelody(); } catch (e) { log("Error: " + e.message); }
});

stopBtn.addEventListener("click", () => {
    clearPlaybackState();
    log("Reproduccion detenida");
});

window.addEventListener("beforeunload", () => {
    if (animationFrameId) cancelAnimationFrame(animationFrameId);
});

async function loadHistory() {
    const list = document.getElementById("history-list");
    try {
        const res = await fetch("/api/songs");
        if (!res.ok) throw new Error("status " + res.status);
        const songs = await res.json();
        if (!songs.length) {
            list.innerHTML = '<span style="color:var(--muted);font-size:0.80rem;">Sin canciones guardadas aún.</span>';
            return;
        }
        list.innerHTML = "";
        songs.forEach((song) => {
            const card = document.createElement("div");
            card.className = "song-card";
            const ts = song.createdAt ? new Date(song.createdAt).toLocaleString() : "—";
            const label = "[" + (song.source || "?") + "] " + song.scaleLabel + " · " + song.bpm + " BPM · " + song.steps + " pasos";
            const sub = song.interpretation || ts;
            card.innerHTML = '<div class="song-meta">' + label + '<div class="song-sub">' + sub + '</div></div>'
                + '<button data-id="' + song.id + '">Replay</button>';
            list.appendChild(card);
        });
        list.querySelectorAll("button[data-id]").forEach((btn) => {
            btn.addEventListener("click", async () => {
                try {
                    const res2 = await fetch("/api/songs/" + btn.dataset.id);
                    if (!res2.ok) throw new Error("status " + res2.status);
                    const data = await res2.json();
                    clearPlaybackState();
                    applyMelody(data);
                    log("Replay #" + btn.dataset.id + " · " + (data.interpretation || data.scaleLabel));
                    await playMelody();
                } catch (e) { log("Error replay: " + e.message); }
            });
        });
    } catch (e) {
        list.innerHTML = '<span style="color:var(--muted);font-size:0.80rem;">Historial no disponible: ' + e.message + '</span>';
    }
}

document.getElementById("history-refresh").addEventListener("click", loadHistory);

fetchClassic().then((data) => {
    applyMelody(data);
    log("Listo · genera o explora los modos Express, Words y Code");
    loadHistory();
}).catch((e) => log("No se pudo iniciar: " + e.message));
</script>
</body>
</html>
