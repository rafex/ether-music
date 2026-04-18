# ether-music

Proyecto experimental para generar melodias algoritmicas con una API
REST en Ether y un frontend ligero renderizado con `jte`.

## Estructura

- `agents/`: contexto de producto, arquitectura, decisiones y specs.
- `backend/`: codigo ejecutable del producto.
- `backend/java/ether-music/`: modulo Java con backend Ether y frontend `jte`.
- `docs/`: documentacion para humanos.
- `tasks/`: plan ejecutable derivado de la spec activa.

## Estado actual

La primera iteracion expone:

- una pagina principal con controles de generacion y reproduccion
- una API `GET /api/melodies/generate`
- un motor inicial de melodias basado en escalas y movimiento
  probabilistico

## Operacion local

- `just build`: construye el artefacto a traves de `make`.
- `just test`: corre la validacion a traves de `make`.
- `just run`: levanta la aplicacion en desarrollo.
- `make ...`: usa `./mvnw` dentro de `backend/java/ether-music`.

## Siguiente lectura

Si vas a trabajar en el repo:

1. Lee `AGENTS.md`.
2. Lee `agents/README.md`.
3. Entra a la spec activa en
   `agents/specs/melody-rest-mvp/README.md`.
4. Si vas a tocar codigo Java, lee `backend/README.md` y luego
   `backend/java/README.md`.
5. Si buscas una guia humana de operacion, entra a `docs/README.md`.
