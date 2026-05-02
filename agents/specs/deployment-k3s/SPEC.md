# SPEC.md

### Metadata

- ID: `SPEC-0002`
- Estado: `active`
- Owner: Codex
- Fecha de creacion: 2026-04-24
- Ultima actualizacion: 2026-04-24
- Reemplaza: `none`
- Tareas relacionadas: `TASK-0101`, `TASK-0102`, `TASK-0103`
- Decisiones relacionadas: `DEC-0003`, `DEC-0004`, `DEC-0005`

### Resumen

Empaquetar `ether-music` como contenedor, publicarlo en GHCR y
desplegarlo en k3s mediante Helm y GitHub Actions bajo el subdominio
`music.v1.rafex.cloud`.

### Problema

El proyecto ya puede ejecutarse localmente, pero no existe todavia un
camino reproducible para construir imagenes, publicarlas y desplegarlas
en el servidor k3s del proyecto.

### Objetivo

Al terminar debe existir un flujo reproducible que:

- construya una imagen del modulo Java
- la publique en GHCR
- despliegue una release Helm en k3s
- publique la aplicacion en `music.v1.rafex.cloud`

### Alcance

- Incluye:
  Dockerfile, chart Helm, workflows de GitHub Actions, documentacion de
  CI/CD y comandos operativos.
- Excluye:
  observabilidad avanzada, base de datos externa, multi-entorno y
  automatizacion de certificados fuera del Ingress ya existente.

### Requisitos funcionales

- RF-1: construir una imagen del modulo `backend/java/ether-music`.
- RF-2: publicar imagenes multi-arquitectura a GHCR.
- RF-3: desplegar con Helm en el namespace `mvps`.
- RF-4: configurar Ingress para `music.v1.rafex.cloud`.
- RF-5: persistir el directorio `data/` para SQLite.

### Requisitos no funcionales

- RNF-1: el flujo debe seguir el patron operativo de `HouseDB`.
- RNF-2: la operacion local debe seguir entrando por `make` y `just`.
- RNF-3: la documentacion debe existir tanto en `agents/` como en
  `docs/` y `pipelines/`.

### Criterios de aceptacion

- Dado un tag de release o un disparo manual
- Cuando corren los workflows de publish y deploy
- Entonces la imagen se publica en GHCR y Helm despliega la release.

- Dado el chart Helm
- Cuando se renderiza o despliega
- Entonces expone la app en `music.v1.rafex.cloud`.

### Dependencias y riesgos

- Dependencia: secreto `KUBE_CONFIG_DATA` en GitHub Actions.
- Dependencia: acceso pull a GHCR desde el cluster.
- Riesgo: SQLite sobre volumen local limita escalado horizontal real.
- Riesgo: la release falle si `DEEPSEEK_API_KEY` no existe y el chart la
  trate como obligatoria.

### Plan de ejecucion

- Tarea o lote de tareas:
  definir docs/contexto, empaquetado contenedor, chart Helm y workflows.
- Orden sugerido:
  primero empaquetado, luego chart, luego workflows y documentacion.
- Bloqueos conocidos:
  no se puede validar el despliegue real sin credenciales del cluster.
- Criterio de cierre:
  `make test`, `helm lint` y la configuracion declarativa quedan listas.

### Plan de validacion

- Test manual:
  inspeccion del YAML, render Helm y revision de workflows.
- Test automatizado:
  build del modulo y `helm lint`.
- Evidencia esperada:
  Dockerfile funcional, chart renderizable y workflows coherentes.

### Trazabilidad

- Commits o PRs:
- Archivos principales:
  `.github/workflows/*`, `helm/ether-music/*`, `backend/java/Dockerfile`,
  `pipelines/*`
- Resultado de validacion:
  `make test`; `make verify`; `helm template ether-music ./helm/ether-music`;
  `PORT=18080 java -jar target/ether-music.jar` + `GET /health`
