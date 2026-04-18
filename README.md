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

La aplicacion expone tres rutas web:

- `/` - Pagina de bienvenida con acceso a Crear y Biblioteca
- `/create` - Interfaz de composicion con cuatro modos (Clasico, Express, Palabras, Codigo)
- `/play` - Biblioteca de canciones guardadas, reproduccion y filtrado

La API REST:

- `GET /api/melodies/generate` - generacion clasica
- `POST /api/express/create` - composicion desde intencion (mood, energia, tempo, length)
- `POST /api/data/words` - composicion desde palabras ponderadas
- `POST /api/data/code` - composicion desde metricas de sesion de codigo
- `GET /api/songs` - listado de canciones guardadas
- `GET /api/songs/{id}` - recuperar cancion completa por ID

PWA:
- Manifest, Service Worker y iconos instalables
- Reproduccion offline de canciones guardadas
- Caching inteligente por ruta

## Documentacion

Para entender como funciona Ether Music:

- **Para no-musicos**: Lee [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md) - guia en lenguaje simple sobre cada modo de composicion, conceptos basicos de musica, y ejemplos.
- **Para musicos**: Lee [docs/MUSIC_THEORY.md](docs/MUSIC_THEORY.md) - explicacion detallada de escalas, modos, algoritmos de generacion, y mappeos de datos a musica.

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
