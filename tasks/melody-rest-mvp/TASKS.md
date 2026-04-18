# TASKS.md

## Metadata

- Iniciativa: `melody-rest-mvp`
- Spec relacionada: `SPEC-0001`
- Owner: Codex
- Estado general: `done`

## Tareas

### TASK-0001 - Definir la base documental y tecnica del MVP

- ID: `TASK-0001`
- State: `done`
- Owner: Codex
- Dependencies:
- Expected files:
  `README.md`, `agents/*`, `agents/specs/melody-rest-mvp/*`, `pom.xml`
- Close criteria:
  existe una spec activa, decisiones persistentes y stack/documentacion
  coherentes con el MVP.
- Validation:
  revision manual de consistencia documental.

### TASK-0002 - Implementar API REST y dominio de generacion melodica

- ID: `TASK-0002`
- State: `done`
- Owner: Codex
- Dependencies: `TASK-0001`
- Expected files:
  `src/main/java/**`
- Close criteria:
  el backend arranca y responde `GET /api/melodies/generate`.
- Validation:
  tests unitarios y smoke test HTTP.

### TASK-0003 - Integrar frontend web servido por Ether

- ID: `TASK-0003`
- State: `done`
- Owner: Codex
- Dependencies: `TASK-0002`
- Expected files:
  `src/main/jte/**`
- Close criteria:
  la pagina principal consume la API, pinta la secuencia y reproduce
  audio desde el navegador.
- Validation:
  smoke test HTTP y verificacion manual local.
