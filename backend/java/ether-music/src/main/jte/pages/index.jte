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
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
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
            width: min(900px, 100%);
            text-align: center;
        }

        h1 {
            margin: 0 0 8px 0;
            font-family: var(--font-display);
            font-size: clamp(2rem, 8vw, 5rem);
            letter-spacing: 0.08em;
            line-height: 1;
            color: var(--accent);
            text-shadow: 0 0 32px rgba(0, 229, 255, 0.25);
        }

        .subtitle {
            margin: 0 0 48px 0;
            font-size: 0.75rem;
            letter-spacing: 0.22em;
            color: var(--muted);
            text-transform: uppercase;
        }

        .hero-text {
            margin-bottom: 64px;
            font-size: 1.1rem;
            line-height: 1.6;
            color: var(--text);
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .ctas {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .cta-card {
            position: relative;
            background: rgba(17, 24, 32, 0.92);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 32px 24px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 16px;
        }

        .cta-card:hover {
            border-color: var(--accent);
            background: rgba(17, 24, 32, 0.98);
            transform: translateY(-4px);
            box-shadow: 0 8px 32px rgba(0, 229, 255, 0.15);
        }

        .cta-icon {
            width: 64px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
        }

        .cta-title {
            margin: 0;
            font-family: var(--font-display);
            font-size: 1.5rem;
            letter-spacing: 0.06em;
            color: var(--accent);
        }

        .cta-description {
            margin: 0;
            font-size: 0.9rem;
            color: var(--muted);
            line-height: 1.5;
        }

        .cta-arrow {
            margin-top: 8px;
            font-size: 0.8rem;
            color: var(--accent2);
            transition: transform 0.3s ease;
        }

        .cta-card:hover .cta-arrow {
            transform: translateX(4px);
        }

        footer {
            margin-top: 64px;
            font-size: 0.75rem;
            color: var(--muted);
            letter-spacing: 0.08em;
        }

        @media (max-width: 640px) {
            body {
                padding: 16px;
            }

            h1 {
                font-size: clamp(1.5rem, 6vw, 3rem);
            }

            .hero-text {
                font-size: 0.95rem;
                margin-bottom: 48px;
            }

            .ctas {
                gap: 16px;
            }

            .cta-card {
                padding: 24px 16px;
            }

            .cta-icon {
                width: 48px;
                height: 48px;
                font-size: 2rem;
            }

            .cta-title {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <main>
        <header>
            <h1>ETHER</h1>
            <p class="subtitle">Generador de Melodías Algorítmicas</p>
        </header>

        <p class="hero-text">
            Transforma ideas, palabras y datos en música. Genera melodías únicas usando algoritmos musicales—sin experiencia previa necesaria.
        </p>

        <div class="ctas">
            <a href="/create" class="cta-card">
                <div class="cta-icon">🎵</div>
                <h2 class="cta-title">Crear</h2>
                <p class="cta-description">Componer música usando diferentes modos: clásico, expresivo, de palabras o de código</p>
                <span class="cta-arrow">→ Ir</span>
            </a>

            <a href="/electronic" class="cta-card">
                <div class="cta-icon">⚡</div>
                <h2 class="cta-title">Electrónica</h2>
                <p class="cta-description">Pega código o texto y la IA (DeepSeek) analiza el contexto para componer música electrónica</p>
                <span class="cta-arrow">→ Ir</span>
            </a>

            <a href="/play" class="cta-card">
                <div class="cta-icon">🎶</div>
                <h2 class="cta-title">Biblioteca</h2>
                <p class="cta-description">Explora y reproduce todas tus composiciones guardadas. Redescubre tu trabajo.</p>
                <span class="cta-arrow">→ Ir</span>
            </a>

            <a href="/radio" class="cta-card">
                <div class="cta-icon">📻</div>
                <h2 class="cta-title">Radio</h2>
                <p class="cta-description">Controla MPD y escucha el stream de Icecast desde una sola interfaz HTMX.</p>
                <span class="cta-arrow">→ Ir</span>
            </a>
        </div>

        <footer>
            © 2026 Ether Music — Algorithmic Composition
        </footer>
    </main>

    <script>
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/sw.js', { scope: '/' })
                    .catch(err => console.warn('SW error:', err));
            });
        }
    </script>
</body>
</html>
