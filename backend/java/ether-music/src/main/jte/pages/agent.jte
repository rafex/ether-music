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
            --accent5: #ff9500;
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
                radial-gradient(circle at top left, rgba(255, 149, 0, 0.08), transparent 35%),
                radial-gradient(circle at bottom right, rgba(191, 95, 255, 0.06), transparent 35%),
                linear-gradient(180deg, #05070a 0%, #090b0f 100%);
            color: var(--text);
            font-family: var(--font-mono);
            padding: 24px;
            display: flex;
            flex-direction: column;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            background: repeating-linear-gradient(
                0deg, transparent, transparent 2px,
                rgba(255, 149, 0, 0.008) 2px, rgba(255, 149, 0, 0.008) 4px
            );
        }

        main {
            position: relative;
            z-index: 1;
            width: min(1100px, 100%);
            margin: 0 auto;
            flex: 1;
            display: flex;
            flex-direction: column;
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
            color: var(--accent5);
            text-shadow: 0 0 40px rgba(255, 149, 0, 0.35);
        }

        .subtitle {
            margin-top: 6px;
            font-size: 0.78rem;
            letter-spacing: 0.22em;
            color: var(--muted);
            text-transform: uppercase;
        }

        .nav-links { display: flex; gap: 12px; font-size: 0.72rem; letter-spacing: 0.12em; }
        .nav-links a {
            color: var(--muted); text-decoration: none; padding: 6px 12px;
            border: 1px solid var(--border); border-radius: 4px; transition: all 0.2s;
        }
        .nav-links a:hover { color: var(--accent); border-color: var(--accent); }

        .layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            flex: 1;
        }

        .col-left { display: flex; flex-direction: column; gap: 16px; }
        .col-right { display: flex; flex-direction: column; gap: 16px; }

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
            top: 10px; right: 14px;
            font-size: 0.62rem; letter-spacing: 0.22em;
            color: var(--muted); text-transform: uppercase;
        }

        .panel.agent-border { border-color: rgba(255, 149, 0, 0.4); }

        /* Chat */
        .chat-messages {
            display: flex;
            flex-direction: column;
            gap: 14px;
            min-height: 320px;
            max-height: 420px;
            overflow-y: auto;
            padding-right: 4px;
            margin-bottom: 16px;
        }

        .chat-messages::-webkit-scrollbar { width: 4px; }
        .chat-messages::-webkit-scrollbar-track { background: transparent; }
        .chat-messages::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

        .msg {
            display: flex;
            flex-direction: column;
            gap: 4px;
            max-width: 90%;
        }

        .msg.user { align-self: flex-end; align-items: flex-end; }
        .msg.agent { align-self: flex-start; align-items: flex-start; }

        .msg-label {
            font-size: 0.58rem;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--muted);
        }

        .msg-bubble {
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 0.82rem;
            line-height: 1.5;
            border: 1px solid var(--border);
        }

        .msg.user .msg-bubble {
            background: rgba(255, 149, 0, 0.1);
            border-color: rgba(255, 149, 0, 0.35);
            color: var(--text);
        }

        .msg.agent .msg-bubble {
            background: rgba(17, 24, 32, 0.95);
            border-color: rgba(191, 95, 255, 0.35);
            color: var(--text);
        }

        .msg.agent.composing .msg-bubble {
            border-color: rgba(255, 149, 0, 0.5);
            color: var(--accent5);
            animation: pulse-border 1.2s ease-in-out infinite;
        }

        @keyframes pulse-border {
            0%, 100% { border-color: rgba(255, 149, 0, 0.3); }
            50% { border-color: rgba(255, 149, 0, 0.8); }
        }

        .chat-input-row {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }

        .chat-input-row textarea {
            flex: 1;
            min-height: 60px;
            max-height: 120px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 4px;
            color: var(--text);
            font-family: var(--font-mono);
            font-size: 0.82rem;
            padding: 10px 12px;
            resize: none;
            line-height: 1.5;
        }

        .chat-input-row textarea:focus {
            outline: none;
            border-color: var(--accent5);
            box-shadow: 0 0 0 2px rgba(255, 149, 0, 0.15);
        }

        .send-btn {
            border: 1px solid var(--accent5);
            background: transparent;
            color: var(--accent5);
            border-radius: 4px;
            padding: 10px 18px;
            font-family: var(--font-mono);
            font-size: 0.78rem;
            letter-spacing: 0.15em;
            cursor: pointer;
            transition: all 0.2s;
            white-space: nowrap;
            height: fit-content;
        }

        .send-btn:hover { background: rgba(255, 149, 0, 0.12); }
        .send-btn:disabled { opacity: 0.5; cursor: not-allowed; }

        .suggestions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .suggestion-chip {
            border: 1px solid var(--border);
            background: transparent;
            color: var(--muted);
            border-radius: 20px;
            padding: 5px 12px;
            font-family: var(--font-mono);
            font-size: 0.68rem;
            letter-spacing: 0.08em;
            cursor: pointer;
            transition: all 0.2s;
        }

        .suggestion-chip:hover {
            border-color: var(--accent5);
            color: var(--accent5);
            background: rgba(255, 149, 0, 0.08);
        }

        /* Playback */
        button {
            border: 1px solid var(--accent);
            background: transparent;
            color: var(--accent);
            border-radius: 4px;
            padding: 10px 16px;
            font-family: var(--font-mono);
            font-size: 0.78rem;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s;
        }

        button:hover { background: rgba(0, 229, 255, 0.1); }

        button.play-btn { border-color: var(--accent3); color: var(--accent3); }
        button.play-btn:hover { background: rgba(168, 255, 62, 0.1); }
        button.stop-btn { border-color: var(--accent2); color: var(--accent2); }
        button.stop-btn:hover { background: rgba(255, 107, 53, 0.1); }

        .actions { display: flex; gap: 10px; flex-wrap: wrap; }

        label {
            display: grid; gap: 8px;
            font-size: 0.72rem; letter-spacing: 0.15em;
            color: var(--muted); text-transform: uppercase;
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

        input[type="range"] { width: 100%; accent-color: var(--accent5); }

        .bpm-row { display: flex; align-items: center; gap: 12px; }
        .bpm-value { min-width: 3em; text-align: right; color: var(--accent); font-size: 0.90rem; }

        /* Telemetry */
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
            font-size: 0.60rem; letter-spacing: 0.18em;
            color: var(--muted); text-transform: uppercase;
            margin-bottom: 4px; display: block;
        }

        .metric .v { font-size: 0.95rem; color: var(--accent5); display: block; }

        /* Piano Roll */
        #roll {
            display: grid;
            grid-template-columns: repeat(16, minmax(0, 1fr));
            gap: 3px; align-items: end;
            min-height: 160px;
        }

        .column { display: grid; gap: 3px; }

        .cell {
            height: 12px; border-radius: 2px;
            border: 1px solid var(--border);
            background: var(--surface);
        }

        .cell.active { background: rgba(255, 149, 0, 0.35); border-color: var(--accent5); }
        .cell.current {
            background: rgba(255, 107, 53, 0.85);
            border-color: var(--accent2);
            box-shadow: 0 0 10px rgba(255, 107, 53, 0.5);
        }

        canvas {
            width: 100%; height: 100px; display: block;
            background: #07090c;
            border: 1px solid var(--border); border-radius: 6px;
        }

        pre {
            margin: 0; white-space: pre-wrap;
            color: var(--muted); font-size: 0.78rem; line-height: 1.45;
        }

        /* Download WAV */
        .wav-btn {
            width: 100%; padding: 11px 14px;
            border-color: var(--accent3); color: var(--accent3);
            background: rgba(168, 255, 62, 0.06);
        }

        .wav-btn:hover { background: rgba(168, 255, 62, 0.12); }
        .wav-btn:disabled { opacity: 0.4; cursor: not-allowed; }

        audio { width: 100%; margin-top: 10px; display: none; }

        @media (max-width: 860px) {
            .layout { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<main>
    <header>
        <div>
            <h1>AGENTE</h1>
            <p class="subtitle">Composición Conversacional con IA</p>
        </div>
        <nav class="nav-links">
            <a href="/">Inicio</a>
            <a href="/create">Crear</a>
            <a href="/electronic">Electrónica</a>
            <a href="/play">Biblioteca</a>
        </nav>
    </header>

    <div class="layout">
        <!-- Columna izquierda: chat -->
        <div class="col-left">
            <section class="panel agent-border" data-label="Agente Musical" style="flex:1;display:flex;flex-direction:column;">
                <div class="suggestions" id="suggestions">
                    <button class="suggestion-chip" data-text="Compón algo melancólico y lento para una tarde lluviosa">Tarde lluviosa</button>
                    <button class="suggestion-chip" data-text="Quiero música enérgica y rápida para concentrarme programando">Programando</button>
                    <button class="suggestion-chip" data-text="Algo misterioso y oscuro en escala frigia">Oscuro y frígío</button>
                    <button class="suggestion-chip" data-text="Música tranquila para meditar, pentatónica menor">Meditación</button>
                    <button class="suggestion-chip" data-text="Algo épico y grandioso, máxima energía">Épico</button>
                </div>

                <div class="chat-messages" id="chat-messages">
                    <div class="msg agent">
                        <span class="msg-label">Agente</span>
                        <div class="msg-bubble">Hola. Dime qué tipo de música quieres y la compondré. Puedes describir un estado de ánimo, una escena, una actividad o lo que sientas.</div>
                    </div>
                </div>

                <div class="chat-input-row">
                    <textarea id="chat-input" placeholder="Describe la música que quieres..." rows="2"></textarea>
                    <button class="send-btn" id="send-btn">Enviar</button>
                </div>
            </section>
        </div>

        <!-- Columna derecha: visualización + reproducción -->
        <div class="col-right">
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
    let currentMelody = null;
    let activeBpm = 110;
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
    const sendBtn = document.getElementById("send-btn");
    const chatInput = document.getElementById("chat-input");
    const chatMessages = document.getElementById("chat-messages");
    const roll = document.getElementById("roll");
    const waveformCanvas = document.getElementById("waveform");
    const waveformCtx = waveformCanvas.getContext("2d");
    const wavPlayer = document.getElementById("wav-player");
    const downloadWavBtn = document.getElementById("download-wav-btn");

    bpmInput.addEventListener("input", function() {
        activeBpm = Number(bpmInput.value);
        bpmDisplay.textContent = String(activeBpm);
    });

    loopsInput.addEventListener("input", function() {
        loopsDisplay.textContent = String(loopsInput.value);
    });

    document.querySelectorAll(".suggestion-chip").forEach(function(chip) {
        chip.addEventListener("click", function() {
            chatInput.value = chip.getAttribute("data-text");
            chatInput.focus();
        });
    });

    chatInput.addEventListener("keydown", function(e) {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            sendBtn.click();
        }
    });

    function appendMessage(role, text, extraClass) {
        const wrapper = document.createElement("div");
        wrapper.className = "msg " + role + (extraClass ? " " + extraClass : "");
        const label = document.createElement("span");
        label.className = "msg-label";
        label.textContent = role === "user" ? "Tú" : "Agente";
        const bubble = document.createElement("div");
        bubble.className = "msg-bubble";
        bubble.textContent = text;
        wrapper.appendChild(label);
        wrapper.appendChild(bubble);
        chatMessages.appendChild(wrapper);
        chatMessages.scrollTop = chatMessages.scrollHeight;
        return wrapper;
    }

    sendBtn.addEventListener("click", function() {
        const text = chatInput.value.trim();
        if (!text) return;

        appendMessage("user", text);
        chatInput.value = "";
        sendBtn.disabled = true;

        const thinkingMsg = appendMessage("agent", "Analizando y componiendo...", "composing");

        fetch("/api/electronic/text", {
            method: "POST",
            headers: { "content-type": "text/plain; charset=utf-8" },
            body: text
        })
        .then(function(res) {
            if (!res.ok) {
                return res.json().then(function(err) { throw new Error(err.error || ("HTTP " + res.status)); });
            }
            return res.json();
        })
        .then(function(data) {
            chatMessages.removeChild(thinkingMsg);
            const interpretation = data.interpretation || (data.scaleLabel + " a " + data.bpm + " BPM");
            appendMessage("agent", "Composición lista: " + interpretation);
            applyMelody(data);
            sendBtn.disabled = false;
        })
        .catch(function(e) {
            chatMessages.removeChild(thinkingMsg);
            appendMessage("agent", "Error: " + e.message);
            sendBtn.disabled = false;
        });
    });

    function applyMelody(data) {
        currentMelody = data;
        buildRoll();
        document.getElementById("current-scale").textContent = (data.request ? data.request.root + " " : "") + (data.scaleLabel || "");
        document.getElementById("current-steps").textContent = data.request ? String(data.request.steps) : "—";
        document.getElementById("current-bpm").textContent = data.bpm ? String(data.bpm) : String(activeBpm);
        if (data.bpm) {
            activeBpm = data.bpm;
            bpmInput.value = activeBpm;
            bpmDisplay.textContent = String(activeBpm);
        }
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
        analyser = audioCtx.createAnalyser();
        analyser.fftSize = 2048;
        masterGain = audioCtx.createGain();
        masterGain.gain.value = 0.25;
        masterGain.connect(analyser);
        analyser.connect(audioCtx.destination);
        drawWaveform();
    }

    function drawWaveform() {
        if (!analyser) { animFrameId = requestAnimationFrame(drawWaveform); return; }
        const bufferLength = analyser.fftSize;
        const data = new Float32Array(bufferLength);
        analyser.getFloatTimeDomainData(data);
        waveformCtx.fillStyle = "#07090c";
        waveformCtx.fillRect(0, 0, waveformCanvas.width, waveformCanvas.height);
        waveformCtx.strokeStyle = "#ff9500";
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

    function scheduleStep(stepInfo, when, duration) {
        if (!audioCtx || !masterGain || stepInfo.rest || !stepInfo.frequencyHz) {
            const id = window.setTimeout(function() { markCurrentStep(stepInfo.step); }, Math.max(0, (when - audioCtx.currentTime) * 1000));
            scheduledTimeouts.push(id);
            return;
        }
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = waveSelect.value;
        osc.frequency.setValueAtTime(stepInfo.frequencyHz, when);
        gain.gain.setValueAtTime(0.0001, when);
        gain.gain.linearRampToValueAtTime(0.75, when + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.45, when + Math.max(duration - 0.04, 0.02));
        gain.gain.exponentialRampToValueAtTime(0.0001, when + duration);
        osc.connect(gain);
        gain.connect(masterGain);
        osc.start(when);
        osc.stop(when + duration);
        const id = window.setTimeout(function() {
            markCurrentStep(stepInfo.step);
            document.getElementById("current-note").textContent = stepInfo.noteName || "Silencio";
            document.getElementById("current-frequency").textContent = stepInfo.frequencyHz ? (stepInfo.frequencyHz.toFixed(2) + " Hz") : "—";
        }, Math.max(0, (when - audioCtx.currentTime) * 1000));
        scheduledTimeouts.push(id);
    }

    playBtn.addEventListener("click", function() {
        if (!currentMelody) return;
        initAudio();
        clearPlaybackState();
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
        downloadWavBtn.disabled = true;
        downloadWavBtn.textContent = "Sintetizando...";

        const payload = {
            melody: currentMelody.melody,
            bpm: activeBpm,
            synthesizer: document.getElementById("server-synth").value,
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
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = "ether-agent.wav";
            a.click();
            wavPlayer.src = url;
            wavPlayer.style.display = "block";
            downloadWavBtn.textContent = "Descargar WAV";
            downloadWavBtn.disabled = false;
        })
        .catch(function(e) {
            appendMessage("agent", "Error al generar WAV: " + e.message);
            downloadWavBtn.textContent = "Descargar WAV";
            downloadWavBtn.disabled = false;
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
