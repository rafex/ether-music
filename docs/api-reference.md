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
