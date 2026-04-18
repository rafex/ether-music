# SPEC.md

### Metadata

- ID: `SPEC-0001`
- Estado: `done`
- Owner: Codex
- Fecha de creacion: 2026-04-17
- Ultima actualizacion: 2026-04-17
- Reemplaza: `none`
- Tareas relacionadas: `TASK-0001`, `TASK-0002`, `TASK-0003`
- Decisiones relacionadas: `DEC-0001`, `DEC-0002`

### Resumen

Construir la primera base ejecutable de `ether-music`: backend REST en
Ether para generar melodias algoritmicas y un frontend simple que las
visualice y reproduzca desde el navegador.

### Problema

Existe solo una idea visual aislada y no hay todavia una aplicacion ni
un contrato API que permitan iterar el producto, validar el flujo o
desarrollar capacidades futuras sobre una base real.

### Objetivo

Al terminar esta iniciativa debe existir una aplicacion local que:

- sirva una pagina principal
- exponga una API HTTP para generar melodias
- permita reproducir la secuencia generada desde el navegador

### Alcance

- Incluye:
  backend Java 21 con Ether, render HTML con `jte`, JS del frontend,
  generacion melodica basica y documentacion base del proyecto.
- Excluye:
  persistencia, autenticacion, exportacion MIDI/WAV, multiusuario,
  despliegue productivo y edicion avanzada de partituras.

### Requisitos funcionales

- RF-1: exponer `GET /api/melodies/generate` con parametros basicos de
  escala, raiz, octava y longitud.
- RF-2: devolver JSON con la paleta de notas y la secuencia generada.
- RF-3: servir una pagina principal que llame a la API y pinte la
  secuencia.
- RF-4: permitir reproducir la secuencia en el navegador.

### Requisitos no funcionales

- RNF-1: mantener el backend sin frameworks pesados adicionales.
- RNF-2: compilar y probar con Maven.
- RNF-3: dejar documentado el alcance real de `jte` dentro del proyecto.

### Criterios de aceptacion

- Dado que el servidor esta corriendo
- Cuando abro `/`
- Entonces veo una interfaz funcional que puede generar y reproducir una
  melodia.

- Dado que llamo `GET /api/melodies/generate`
- Cuando envio parametros validos
- Entonces recibo una respuesta `200` con JSON estructurado.

### Dependencias y riesgos

- Dependencia: artefactos publicados de Ether y `jte`.
- Riesgo: la API publica de Ether disponible en Maven difiera de la
  documentada en repos locales.
- Riesgo: el navegador no permita iniciar audio sin gesto del usuario.

### Plan de ejecucion

- Tarea o lote de tareas:
  documentacion base, arranque Maven, dominio de melodia, handlers HTTP
  y frontend inicial.
- Orden sugerido:
  primero docs y esqueleto, luego API y finalmente UI.
- Bloqueos conocidos:
  ninguno actual.
- Criterio de cierre:
  `mvn test` pasa y el flujo manual principal funciona.

### Plan de validacion

- Test manual:
  abrir la pagina, generar una melodia y reproducirla.
- Test automatizado:
  pruebas unitarias del generador y smoke tests HTTP.
- Evidencia esperada:
  `mvn test` verde y endpoints respondiendo localmente.

### Trazabilidad

- Commits o PRs:
- Archivos principales:
  `backend/java/ether-music/pom.xml`,
  `backend/java/ether-music/src/main/java/*`,
  `backend/java/ether-music/src/main/jte/*`
- Resultado de validacion:
  `./mvnw test`; `GET /` => 200; `GET /api/melodies/generate?...` => 200
