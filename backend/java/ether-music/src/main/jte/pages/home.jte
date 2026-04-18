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

    <section class="panel" data-label="Control Deck">
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
                bpm
                <input id="bpm" type="range" min="70" max="160" value="110">
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
            <button id="play" class="secondary">Play</button>
            <button id="stop" class="tertiary">Stop</button>
        </div>
    </section>

    <section class="panel" data-label="Telemetry">
        <div class="status">
            <div class="metric">
                <span class="k">Escala</span>
                <span class="v" id="current-scale">Minor</span>
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
                <span class="v" id="current-steps">16</span>
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
</main>

<script>
const apiEndpoint = "${model.apiEndpoint()}";
const rootSelect = document.getElementById("root");
const scaleSelect = document.getElementById("scale");
const octaveInput = document.getElementById("octave");
const stepsInput = document.getElementById("steps");
const bpmInput = document.getElementById("bpm");
const waveSelect = document.getElementById("wave");
const generateBtn = document.getElementById("generate");
const playBtn = document.getElementById("play");
const stopBtn = document.getElementById("stop");
const roll = document.getElementById("roll");
const logNode = document.getElementById("log");
const currentScaleNode = document.getElementById("current-scale");
const currentNoteNode = document.getElementById("current-note");
const currentFrequencyNode = document.getElementById("current-frequency");
const currentStepsNode = document.getElementById("current-steps");
const waveformCanvas = document.getElementById("waveform");
const waveformCtx = waveformCanvas.getContext("2d");

let currentMelody = null;
let audioCtx = null;
let analyser = null;
let masterGain = null;
let animationFrameId = null;
let scheduledTimeouts = [];

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
            if (!stepInfo.rest && stepInfo.noteIndex === row) {
                cell.classList.add("active");
            }
            cell.dataset.step = String(stepInfo.step);
            cell.dataset.row = String(row);
            column.appendChild(cell);
        }

        roll.appendChild(column);
    });
}

function markCurrentStep(step) {
    document.querySelectorAll(".cell.current").forEach((node) => node.classList.remove("current"));
    document.querySelectorAll('.cell[data-step="' + step + '"]').forEach((node) => node.classList.add("current"));
}

function clearPlaybackState() {
    scheduledTimeouts.forEach((id) => clearTimeout(id));
    scheduledTimeouts = [];
    document.querySelectorAll(".cell.current").forEach((node) => node.classList.remove("current"));
    currentNoteNode.textContent = "-";
    currentFrequencyNode.textContent = "- Hz";
}

async function fetchMelody() {
    const params = new URLSearchParams({
        root: rootSelect.value,
        scale: scaleSelect.value,
        octave: octaveInput.value,
        steps: stepsInput.value
    });

    const response = await fetch(apiEndpoint + "?" + params.toString());
    if (!response.ok) {
        throw new Error("API error " + response.status);
    }
    return response.json();
}

async function generateMelody() {
    clearPlaybackState();
    currentMelody = await fetchMelody();
    buildRoll();
    currentScaleNode.textContent = currentMelody.request.root + " " + currentMelody.scaleLabel;
    currentStepsNode.textContent = String(currentMelody.request.steps);
    log("Melodia generada con " + currentMelody.algorithm + " · " + currentMelody.request.root + " " + currentMelody.scaleLabel);
}

function scheduleStep(stepInfo, when, duration) {
    if (!audioCtx || !masterGain || stepInfo.rest || !stepInfo.frequencyHz) {
        const timeoutId = window.setTimeout(() => markCurrentStep(stepInfo.step), Math.max(0, (when - audioCtx.currentTime) * 1000));
        scheduledTimeouts.push(timeoutId);
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

    const timeoutId = window.setTimeout(() => {
        markCurrentStep(stepInfo.step);
        currentNoteNode.textContent = stepInfo.noteName ?? "Silencio";
        currentFrequencyNode.textContent = stepInfo.frequencyHz ? (stepInfo.frequencyHz.toFixed(2) + " Hz") : "- Hz";
    }, Math.max(0, (when - audioCtx.currentTime) * 1000));
    scheduledTimeouts.push(timeoutId);
}

async function playMelody() {
    if (!currentMelody) {
        await generateMelody();
    }

    initAudio();
    clearPlaybackState();
    if (audioCtx.state === "suspended") {
        await audioCtx.resume();
    }

    const secondsPerBeat = 60 / Number(bpmInput.value);
    const stepDuration = secondsPerBeat / 2;
    const startAt = audioCtx.currentTime + 0.08;

    currentMelody.melody.forEach((stepInfo, index) => {
        scheduleStep(stepInfo, startAt + (index * stepDuration), stepDuration * 0.85);
    });

    log("Reproduciendo a " + bpmInput.value + " BPM con " + currentMelody.melody.length + " pasos");
}

generateBtn.addEventListener("click", async () => {
    try {
        await generateMelody();
    } catch (error) {
        log("No se pudo generar la melodia: " + error.message);
    }
});

playBtn.addEventListener("click", async () => {
    try {
        await playMelody();
    } catch (error) {
        log("No se pudo reproducir la melodia: " + error.message);
    }
});

stopBtn.addEventListener("click", () => {
    clearPlaybackState();
    log("Reproduccion detenida");
});

window.addEventListener("beforeunload", () => {
    if (animationFrameId) cancelAnimationFrame(animationFrameId);
});

generateMelody().catch((error) => {
    log("No se pudo iniciar la interfaz: " + error.message);
});
</script>
</body>
</html>
