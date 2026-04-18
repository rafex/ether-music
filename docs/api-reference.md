# API Reference

Base URL local por defecto:

```text
http://127.0.0.1:8080
```

## Resumen

La API permite generar musica de cuatro formas:

- clasica, eligiendo raiz, escala, octava y numero de pasos
- express, describiendo intencion musical
- a partir de palabras ponderadas
- a partir de senales de una sesion de codigo

Cada composicion generada se guarda en SQLite local y puede consultarse
despues desde `/api/songs`.

## Endpoints

### `GET /api/melodies/generate`

Genera una melodia clasica a partir de parametros directos.

Query params:

- `root`: nota raiz. Ejemplos: `C`, `F#`, `A#`
- `scale`: `major`, `minor`, `dorian`, `pentatonic-major`, `pentatonic-minor`
- `octave`: entero entre `2` y `6`
- `steps`: entero entre `8` y `32`
- `bpm`: entero libre para metadato de tempo en la respuesta

Ejemplo:

```bash
curl -X GET \
  "http://127.0.0.1:8080/api/melodies/generate?root=F%23&scale=dorian&octave=4&steps=16&bpm=120"
```

### `POST /api/express/create`

Convierte una intencion simple en una composicion.

Body JSON:

```json
{
  "mood": "happy",
  "energy": "high",
  "tempo": "fast",
  "length": "short"
}
```

Valores utiles:

- `mood`: `happy`, `sad`, `tense`, `calm`, `mysterious`, `epic`
- `energy`: `low`, `medium`, `high`
- `tempo`: `slow`, `medium`, `fast`
- `length`: `short`, `medium`, `long`

Ejemplo:

```bash
curl -X POST \
  "http://127.0.0.1:8080/api/express/create" \
  -H "Content-Type: application/json" \
  -d '{"mood":"epic","energy":"high","tempo":"fast","length":"long"}'
```

### `POST /api/data/words`

Mapea palabras ponderadas a una composicion.

Body JSON:

```json
{
  "words": [
    { "word": "love", "weight": 0.9 },
    { "word": "sun", "weight": 0.8 },
    { "word": "peace", "weight": 0.7 }
  ]
}
```

Ejemplo:

```bash
curl -X POST \
  "http://127.0.0.1:8080/api/data/words" \
  -H "Content-Type: application/json" \
  -d '{
    "words": [
      { "word": "feliz", "weight": 0.9 },
      { "word": "amor", "weight": 0.8 },
      { "word": "paz", "weight": 0.7 },
      { "word": "sol", "weight": 0.6 }
    ]
  }'
```

### `POST /api/data/code`

Compone una melodia desde telemetria simple de una sesion de codigo.

Body JSON:

```json
{
  "keystrokesPerMinute": 95,
  "errorsLastMinute": 2,
  "linesWritten": 18,
  "deletions": 6
}
```

Ejemplo:

```bash
curl -X POST \
  "http://127.0.0.1:8080/api/data/code" \
  -H "Content-Type: application/json" \
  -d '{"keystrokesPerMinute":95,"errorsLastMinute":2,"linesWritten":18,"deletions":6}'
```

### `GET /api/songs`

Lista las ultimas 50 composiciones guardadas.

Ejemplo:

```bash
curl "http://127.0.0.1:8080/api/songs"
```

### `GET /api/songs/{id}`

Devuelve el `ComposedResponse` completo de una composicion guardada.

Ejemplo:

```bash
curl "http://127.0.0.1:8080/api/songs/1"
```

### `DELETE /api/songs/{id}`

Elimina una composicion guardada.

Devuelve `204` si fue eliminada, `404` si no existe.

Ejemplo:

```bash
curl -X DELETE "http://127.0.0.1:8080/api/songs/1"
```

### `GET /api/songs-wav/{id}`

Sintetiza una composicion guardada y devuelve el archivo WAV (FM synthesis, reverb 0.35, delay 0.25).

Ejemplo:

```bash
curl "http://127.0.0.1:8080/api/songs-wav/1" -o cancion.wav
```

### `POST /api/electronic/{type}`

Analiza contenido con DeepSeek y genera una composicion electronica.
`{type}` puede ser `code`, `text` o `words`.

Requiere la variable de entorno `DEEPSEEK_API_KEY`.

Body: texto plano (codigo, texto libre, o JSON de nube de palabras segun el tipo).

Ejemplo:

```bash
curl -X POST "http://127.0.0.1:8080/api/electronic/text" \
  -H "Content-Type: text/plain" \
  -d "Una noche de lluvia intensa en la ciudad"
```

### `POST /api/synthesize`

Sintetiza una melodia en el servidor y devuelve un archivo WAV descargable.

Body JSON:

```json
{
  "melody": [
    { "step": 0, "rest": false, "noteIndex": 4, "noteName": "A4", "frequencyHz": 440.0 }
  ],
  "bpm": 120,
  "synthesizer": "fm",
  "effectReverb": 0.4,
  "effectDelay": 0.3,
  "intensity": 0.8,
  "loops": 1
}
```

Parámetros:
- `synthesizer`: `fm`, `additive`, `wavetable`
- `loops`: número de repeticiones de la melodía (1-10, default 1). Controla la duración total del audio:
  - 1 loop = duración base
  - 2 loops = 2× la duración
  - etc.

Ejemplo (con 3 loops para triplicar duración):

```bash
curl -X POST "http://127.0.0.1:8080/api/synthesize" \
  -H "Content-Type: application/json" \
  -d '{"melody":[{"step":0,"rest":false,"noteIndex":4,"noteName":"A4","frequencyHz":440.0}],"bpm":120,"synthesizer":"fm","effectReverb":0.4,"effectDelay":0.3,"intensity":0.8,"loops":3}' \
  -o salida.wav
```

## Forma de la respuesta de composicion

Todos los endpoints generativos devuelven un `ComposedResponse` con este
esqueleto:

```json
{
  "source": "classic",
  "interpretation": "mood=happy → C major, energía=high → octava 5, tempo=fast → 160 BPM, longitud=short → 8 pasos",
  "bpm": 160,
  "request": {
    "root": "C",
    "scale": "major",
    "octave": 5,
    "steps": 8
  },
  "scaleLabel": "Mayor",
  "algorithm": "weighted-random-step-motion",
  "palette": [
    { "index": 0, "name": "C5", "midiNumber": 72, "frequencyHz": 523.25 }
  ],
  "melody": [
    { "step": 0, "rest": false, "noteIndex": 3, "noteName": "F5", "frequencyHz": 698.46 },
    { "step": 1, "rest": true, "noteIndex": null, "noteName": null, "frequencyHz": null }
  ]
}
```

## Postman y OpenAPI

El contrato importable esta en:

- [`../openapi/ether-music.yaml`](../openapi/ether-music.yaml)

En Postman puedes usar `Import` y seleccionar ese archivo YAML.
