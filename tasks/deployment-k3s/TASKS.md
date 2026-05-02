# TASKS.md

## Metadata

- Iniciativa: `deployment-k3s`
- Spec relacionada: `SPEC-0002`
- Owner: Codex
- Estado general: `done`

## Tareas

### TASK-0101 - Definir contexto y documentacion del despliegue

- ID: `TASK-0101`
- State: `done`
- Owner: Codex
- Dependencies:
- Expected files:
  `agents/*`, `pipelines/*`, `docs/*`
- Close criteria:
  existe una spec activa y documentacion coherente para humanos y
  agentes.
- Validation:
  revision manual de consistencia documental.

### TASK-0102 - Empaquetar ether-music para contenedor y Helm

- ID: `TASK-0102`
- State: `done`
- Owner: Codex
- Dependencies: `TASK-0101`
- Expected files:
  `backend/java/Dockerfile`, `helm/ether-music/**`, `Makefile`
- Close criteria:
  la app puede construirse para despliegue y el chart Helm renderiza.
- Validation:
  `helm lint`, validacion local de build.

### TASK-0103 - Crear workflows de publicacion y despliegue a k3s

- ID: `TASK-0103`
- State: `done`
- Owner: Codex
- Dependencies: `TASK-0102`
- Expected files:
  `.github/workflows/*.yml`
- Close criteria:
  existe un flujo declarativo para publicar imagen y desplegar release.
- Validation:
  revision de YAML y consistencia con Helm.
