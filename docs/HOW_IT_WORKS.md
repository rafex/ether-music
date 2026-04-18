# Cómo Funciona Ether Music

Una guía para personas sin experiencia en música.

## ¿Qué es Ether Music?

Ether Music es un generador de música **algorítmico**. Significa que usamos reglas matemáticas y artísticas para crear melodías. No necesitas saber música—le dices a la app cómo te sientes, qué palabras te inspiran, o cómo fue tu sesión de código, y ella inventa la música para ti.

## Las Cuatro Formas de Crear Música

### 1. **Modo Clásico** — Control Total (para curiosos)

Aquí controlas cada pieza del rompecabezas:

- **Nota Base (Root)**: La "casa" de la melodía. Ejemplo: Do, Re, Mi. La música siempre vuelve a esta nota.
- **Escala**: Un conjunto de notas que suenan bien juntas. Piensa en ella como una "paleta de colores musicales".
  - **Mayor** → sonido alegre, optimista
  - **Menor** → sonido triste, reflexivo  
  - **Pentatónica** → sonido exótico, oriental
- **Octava**: Qué tan agudo o grave es. 3 = grave (como una tuba), 5 = agudo (como un flautín).
- **Pasos**: Cuántas notas tiene la melodía. 8 = corta y pegadiza, 32 = épica y larga.

### 2. **Modo Express** — Por Emoción (para impacientes)

Dile a la app cómo te sientes, y ella crea la música perfecta para ese mood.

**Mood (Ánimo)**:
- Alegre → Escala Mayor (brillante, optimista)
- Melancólico → Escala Menor (introspectivo, profundo)
- Enérgico → Escala Pentatónica (agresivo, puro)
- Relajado → Escala Dórica (suave, fluido)

**Energy (Energía)**:
- Baja → Notas graves, tempo lento (duerme)
- Media → Rango medio, tempo moderado (conversación)
- Alta → Notas agudas, tempo rápido (carrera)

**Tempo (Velocidad)**:
- Lento → 60 BPM (como un corazón tranquilo)
- Moderado → 100 BPM (paso normal)
- Rápido → 160 BPM (corriendo)

**Length (Duración)**:
- Corta → 8 notas (Instagram short)
- Media → 16 notas (canción pop)
- Larga → 32 notas (épica)

### 3. **Modo Palabras** — Por Sentimiento (para poetas)

Pega una lista de palabras con pesos, y la app convierte el sentimiento en música.

```json
[
  { "word": "alegría", "weight": 0.9 },
  { "word": "luz", "weight": 0.8 },
  { "word": "tristeza", "weight": 0.3 }
]
```

- Palabras **positivas** (alegría, amor, éxito, brillante) → mayor, agudo
- Palabras **negativas** (tristeza, error, muerte, oscuro) → menor, grave
- **Weight** es importancia (0.0 = ignore, 1.0 = máximo impacto)

### 4. **Modo Código** — Por Actividad (para hackers)

Cuéntale cómo fue tu sesión de código:

- **Keystrokes/min**: Cuántas pulsaciones por minuto. 50 = relajado, 150 = furioso
- **Errors**: Errores en el último minuto. Influye en la "tensión" de la música
- **Lines Written**: Líneas de código. Más líneas = más notas
- **Deletions**: Líneas eliminadas. Influye en la "caída" emocional

## Conceptos Clave

### Escalas (Set de Notas que Suenan Bien)

Una **escala** es como un conjunto de LEGO musicales. Todas las notas encajan bien juntas porque tienen relaciones matemáticas especiales.

Imagina que tienes 7 botones en un piano:
- Presiona cualquiera → suena bien
- Combina cualquiera → suena bien
- Mezcla todas → armonía

Por eso las melodías generadas siempre suenan "correctas" aunque son completamente aleatorias.

### BPM (Beats Per Minute)

Velocidad de la música. Como el pulso de un corazón.
- 60 BPM = corazón en reposo (música lenta)
- 100 BPM = caminata normal (música moderada)
- 160 BPM = corrida (música rápida)

### Melodía

Es la **secuencia de notas** que escuchas. Cada nota tiene:
- Una **frecuencia** (qué tan aguda: Hz = Hertz, el número de vibraciones por segundo)
- Una **duración** (cuánto tiempo suena)
- Un **silenio** (pausas entre notas)

## Debajo del Capó: Cómo Funciona Técnicamente

### 1. Algoritmo

Cuando generas una melodía, el algoritmo:

1. **Elige una escala** (basada en mood, palabras, o tu selección)
2. **Elige un rango de notas** (agudo/grave, basado en energía o context)
3. **Genera N notas aleatorias** de la escala elegida
4. **Asigna duraciones** (semi-aleatorias, rítmicas)
5. **Devuelve los parámetros** como JSON

### 2. Reproducción (Web Audio API)

Tu navegador entonces:

1. Crea **osciladores** (generadores de ondas de sonido)
2. Para cada nota:
   - Fija la frecuencia (Hz) del oscilador
   - Fija el **volumen** (sube rápido, baja lentamente para suavidad)
   - **Reproduce** durante la duración correcta
3. Mezcla todos los osciladores → sonido final

Es como tocar un instrumento: cada nota es un toque, el timing es todo.

### 3. Guardado

Cada melodía que creas se guarda en **SQLite** (una base de datos):
- Parámetros de la escala
- La secuencia de notas
- Cuándo la creaste
- Tu "interpretation" (descripción)

Luego puedes reproducirla sin regenerarla.

## Consejos y Trucos

### Express Mode Magic

- **Alegre + Alta Energía** = uplifting, positivo (para celebraciones)
- **Melancólico + Baja Energía** = contemplativo, introspectivo (para pensar)
- **Enérgico + Rápido** = épico, emocionante (para hype)
- **Relajado + Lento** = meditativo, calmante (para dormir)

### Words Mode Magic

Prueba con contradicciones:
```json
[
  { "word": "alegría", "weight": 0.8 },
  { "word": "adiós", "weight": 0.8 }
]
```
Escala mayor (alegría) pero tempo lento (adiós) = "Bittersweet"

### Code Mode Insights

- Cuando `keystrokesPerMinute` es muy alto pero `errors` también → música caótica (frustración)
- Cuando ambas son bajas → música tranquila (flujo, concentración)
- Cuando eliminaciones son altas → música con "caídas" emocionales (refactoring)

## FAQ

**P: ¿Puedo editar una melodía guardada?**  
R: No, pero puedes regenerarla con parámetros ligeramente diferentes.

**P: ¿Puedo descargar la música como MP3?**  
R: Ahora no, pero está en el roadmap.

**P: ¿La música se guarda en el servidor?**  
R: No. Está en **tu navegador** (SQLite local) con el Service Worker.Modo offline: puedes reproducir todas tus canciones sin internet.

**P: ¿Por qué algunas melodías no suenan bien?**  
R: Es aleatorio. A veces suena extraño, a veces suena hermoso. ¡Regenera!

**P: ¿Puedo compartir mis melodías?**  
R: Próximamente con URLs públicas.

## Más Información

Para una explicación técnica profunda sobre escalas, algoritmos y teoría musical, lee [MUSIC_THEORY.md](MUSIC_THEORY.md).
