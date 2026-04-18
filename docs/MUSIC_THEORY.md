# Teoría Musical en Ether Music

Una guía profunda para compositores y músicos.

## Escalas Implementadas

Ether Music implementa los **siete modos de la escala mayor**, más escalas pentatónicas y variantes.

### Modos de La Escala Mayor (Jónico)

Partiendo de C (Do):

| Modo | Fórmula Intervalar | Carácter | Uso Algoritmo |
|------|-------------------|----------|---------------|
| **Jónico** (Mayor) | 1 2 3 4 5 6 7 | Alegre, luminoso, mayoritario | Mood: Alegre |
| **Dórico** | 1 2 b3 4 5 6 b7 | Sofisticado, modal, fluido | Mood: Relajado |
| **Frigio** | 1 b2 b3 4 5 b6 b7 | Español, oscuro, exótico | Mood: Melancólico oscuro |
| **Lidio** | 1 2 3 #4 5 6 7 | Brillo dulce, soñador | (Reserve) |
| **Mixolidio** | 1 2 3 4 5 6 b7 | Blues, soulful, dominante | (Reserve) |
| **Eólico** (Menor Natural) | 1 2 b3 4 5 b6 b7 | Triste, reflexivo, grave | Mood: Melancólico |
| **Locrio** | 1 b2 b3 4 b5 b6 b7 | Diminuido, siniestro, tensión | (Reserve) |

### Escalas Pentatónicas

| Tipo | Fórmula | Carácter | Uso Algoritmo |
|------|---------|----------|---------------|
| **Pentatónica Mayor** | 1 2 3 5 6 | Alegre, pop, accesible | Mood: Enérgico |
| **Pentatónica Menor** | 1 b3 4 5 b7 | Blues, rock, visceral | Mood: Enérgico + triste |

### Matriz Mood → Escala

```
┌─────────────────┬────────────────┬────────────────┬──────────────────┐
│     ENERGY      │ Baja           │ Media          │ Alta             │
├─────────────────┼────────────────┼────────────────┼──────────────────┤
│ Alegre          │ Jónico (grave) │ Jónico (mid)   │ Pentatónica Mayor│
│ Melancólico     │ Eólico (grave) │ Eólico (mid)   │ Pentatónica Menor│
│ Enérgico        │ Frigio (mid)   │ Frigio (agudo) │ Frigio (agudo)   │
│ Relajado        │ Dórico (grave) │ Dórico (mid)   │ Dórico (mid)     │
└─────────────────┴────────────────┴────────────────┴──────────────────┘
```

**Mapping Específico:**

```javascript
// Pseudo-código
function getMood(mood, energy) {
    const moodMap = {
        "alegre": { scale: "jónico", positive: 1.0 },
        "melancólico": { scale: "eólico", positive: -0.5 },
        "enérgico": { scale: "pentatónicaMenor", positive: 0.8 },
        "relajado": { scale: "dórico", positive: 0.3 }
    };
    
    const octave = {
        "baja": 3,
        "media": 4,
        "alta": 5
    }[energy];
    
    return { scale, octave };
}
```

## Generación de Melodías: El Algoritmo

### Pseudocódigo

```javascript
generateMelody(scale, root, octaveRange, numSteps) {
    const scaleNotes = buildScale(scale, root);
    const melody = [];
    
    for (let i = 0; i < numSteps; i++) {
        const octave = randomizeOctave(octaveRange); // ±1 octava de variación
        const noteIndex = random(0, scaleNotes.length - 1);
        const note = scaleNotes[noteIndex];
        const frequency = noteToFrequency(note, octave);
        const duration = randomizeDuration([0.25, 0.5, 1.0]); // Semicorchea, corchea, negra
        const rest = random(0.0, 1.0) < 0.1; // 10% de silencio
        
        melody.push({
            noteIndex,
            noteName: note.name,
            frequencyHz: frequency,
            duration,
            rest,
            step: i
        });
    }
    
    return melody;
}
```

### Detalles de Implementación

#### 1. **Selección de Notas**

- Índice aleatorio dentro de la escala (0 a length-1)
- Garantiza **armonía**: solo suenan notas que pertenecen a la escala
- No hay restricción de "flow" entre notas (saltos grandes son posibles)

#### 2. **Octava**

- Octava base según energía: 3 (grave) a 5 (agudo)
- Variación aleatoria: ±1 octava por nota
- Evita rango inusual (<20 Hz o >20 kHz)

#### 3. **Duración de Notas**

Distribución discreta:
- 25% de probabilidad: negra (0.5 seg a 120 BPM)
- 50% de probabilidad: corchea (0.25 seg)
- 25% de probabilidad: blanca (1.0 seg)

Se ajusta dinámicamente según BPM: `realDuration = noteDuration * (60 / BPM) / 2`

#### 4. **Silencios (Rests)**

- 10% de probabilidad por nota
- No genera sonido, pero mantiene el timing
- Crea "breathing space" en la melodía

### Riqueza Armónica

#### Por Qué No Usar Acordes

Ether Music genera **melodías monofónicas** (una nota a la vez) por:

1. **Simpledad**: Web Audio API monofónica es más eficiente
2. **Claridad**: Una melodía es más memorable que acordes complejos
3. **Flexibilidad**: El usuario puede superponer (futuros remixes)

#### Estructura Rítmica

No hay "meter" formal (4/4, 3/4, etc.). En su lugar:

- Duraciones variables por nota
- Silencios estratégicos
- **Tension & Release** mediante agudos/graves

## Mapeando Datos Externos a Música

### Modo Palabras (Sentiment Analysis)

**Palabras Positivas** (Inglés + Español):
```
happy, joy, love, light, brilliant, success, peace,
alegría, amor, luz, brillante, éxito, paz, esperanza
```

**Palabras Negativas**:
```
sad, anger, fear, dark, broken, failure, pain,
tristeza, ira, miedo, oscuro, roto, fracaso, dolor
```

**Algoritmo Sentiment**:

```javascript
function sentimentFromWords(words) {
    let positiveScore = 0, negativeScore = 0;
    let totalWeight = 0;
    
    words.forEach(w => {
        totalWeight += w.weight;
        if (isPositive(w.word)) positiveScore += w.weight;
        if (isNegative(w.word)) negativeScore += w.weight;
    });
    
    const mood = positiveScore > negativeScore ? "alegre" : "melancólico";
    const confidence = Math.abs(positiveScore - negativeScore) / totalWeight;
    const length = Math.ceil(words.length / 2) * 2; // Redondea a par
    
    return { mood, confidence, length };
}
```

### Modo Código (Activity Metrics)

**Mapeo Keystroke Metrics**:

```javascript
function getMelodyFromCodeSession(metrics) {
    const { keystrokesPerMinute, errorsLastMinute, linesWritten, deletions } = metrics;
    
    // BPM basado en veloci KPM
    const bpm = Math.min(160, Math.max(60, keystrokesPerMinute * 0.8));
    
    // Escala basada en "flow state"
    const errorRatio = errorsLastMinute / (keystrokesPerMinute / 60 + 1);
    let scale, mood;
    if (errorRatio < 0.05) {
        scale = "jónico"; mood = "alegre"; // Flow state
    } else if (errorRatio < 0.15) {
        scale = "dórico"; mood = "relajado"; // Normal debugging
    } else if (errorRatio < 0.30) {
        scale = "eólico"; mood = "melancólico"; // Frustrated
    } else {
        scale = "pentatónicaMenor"; mood = "enérgico"; // Crisis mode
    }
    
    // Steps basado en productivity
    const netLines = Math.max(linesWritten - deletions, 1);
    const steps = Math.ceil(Math.sqrt(netLines) * 2);
    
    return { scale, mood, bpm, steps };
}
```

**Interpretación**:

| KPM | Errors | Estado | Mood |
|-----|--------|--------|------|
| Alto | Bajo | Flow, fluida | Alegre |
| Alto | Alto | Debugging furioso | Enérgico |
| Bajo | Bajo | Pausa, lectura | Relajado |
| Bajo | Alto | Atascado | Melancólico |

## Frecuencias y Afinación

### Estándar de Afinación: A440

```
A4 = 440 Hz (estándar internacional moderno)

Fórmula para nota n semitonos arriba de A0 (27.5 Hz):
frequency = 27.5 * 2^(n/12)

Ejemplo: C4 (Do central) = 262 Hz
```

### Rango de Reproducción

- **Mínimo**: 20 Hz (C0, muy grave, casi subsónico)
- **Máximo**: 20 kHz (C10, ultrasónico)
- **Rango Útil**: C3 (130 Hz) a C6 (1047 Hz) para claridad óptima
- **Ether Default**: C3 a C6 (octavas 3–5)

## Optimizaciones del Algoritmo

### Evitar Monotonía

Sin restricciones formales (voice leading, suspensiones), las melodías pueden sonar aburridas. Mitigaciones:

1. **Octava Aleatoria**: Salta entre octavas → contorno más interesante
2. **Duraciones Variadas**: Mezcla ritmos → menos "robot"
3. **Silencios**: Pausas → phrasing más natural
4. **Step Aleatorio**: No sigue patrón mecánico

### Garantía de Armonía

Cada nota pertenece a la escala seleccionada:
- Todas las notas "encajan"
- Ninguna nota "fuera de lugar"
- Usuario siempre oye "música real", aunque sea generada

## Casos de Borde y Limitaciones

### Limitaciones Conocidas

1. **Sin Armonía Vertical**: Solo melodía, sin acordes acompañantes
2. **Sin "Desarrollo" Temático**: Cada nota es idéntica en importancia (no hay "climax" estructurado)
3. **Sin Dinámica**: Volumen fijo; sin crescendo/decrescendo
4. **Sin Timbre**: Solo onda sinusoidal; sin variedad instrumental
5. **Sin Cuantización**: El timing es matemáticamente perfecto (peut-être demasiado "robótico")

### Trabajo Futuro

- [ ] Añadir acordes acompañantes (generador armónico)
- [ ] Dinámica (volumen variable)
- [ ] Múltiples timbres (FM synthesis, wavetables)
- [ ] "Phrase" structure (intro, verso, chorus, outro)
- [ ] Machine learning para "estilo" personalizado

## Ejemplos de Generación Real

### Ejemplo 1: "Alegre + Alta Energía"

```
Scale: Pentatónica Mayor en Do
Octave: 5 (agudo)
BPM: 160

Resultado posible:
C5 (262 Hz × 2) × 0.25s
E5 (330 Hz × 2) × 0.25s
G5 (392 Hz × 2) × 0.5s
[Silencio] × 0.25s
A5 (440 Hz × 2) × 0.25s
...

Sonido: "Bright, uplifting, almost like a videogame jingle"
```

### Ejemplo 2: "Melancólico + Baja Energía"

```
Scale: Eólico (Menor Natural) en A
Octave: 3 (grave)
BPM: 60

Resultado posible:
A3 (110 Hz) × 1.0s
C4 (130 Hz) × 0.5s
E4 (165 Hz) × 0.5s
[Silencio] × 0.5s
A3 (110 Hz) × 1.0s
...

Sonido: "Slow, introspective, like a piano requiem"
```

## Referencias

- **Intervalos**: [Wikipedia - Interval (music)](https://en.wikipedia.org/wiki/Interval_(music))
- **Scales & Modes**: [Wikipedia - Mode](https://en.wikipedia.org/wiki/Mode_(music))
- **Pentatonic**: [Wikipedia - Pentatonic scale](https://en.wikipedia.org/wiki/Pentatonic_scale)
- **Equal Temperament**: [Wikipedia - Equal temperament](https://en.wikipedia.org/wiki/Equal_temperament)
- **Web Audio API**: [MDN - Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)
