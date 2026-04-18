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

La API actual expone:

- una pagina principal con controles de generacion y reproduccion
- generacion clasica con `GET /api/melodies/generate`
- composicion desde intencion con `POST /api/express/create`
- composicion desde palabras con `POST /api/data/words`
- composicion desde senales de sesion de codigo con `POST /api/data/code`
- historial persistido con `GET /api/songs` y `GET /api/songs/{id}`

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
6. Si quieres integrar la API desde clientes HTTP, revisa
   `openapi/ether-music.yaml`.
