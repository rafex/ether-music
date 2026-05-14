# Repository Layout

## Raiz del repo

- `README.md`: resumen del proyecto.
- `Makefile`: build y validacion.
- `justfile`: task runner de entrada.
- `docs/`: documentacion para humanos.
- `scripts/`: instaladores operativos (MPD + Icecast para Debian).
- `agents/`: contexto de SpecNative y agentes.
- `tasks/`: ejecucion trazable derivada de specs.
- `workflows/`: procedimientos repetibles del framework.

## Codigo del producto

- `backend/README.md`: indice del codigo ejecutable.
- `backend/java/README.md`: indice de runtimes Java.
- `backend/java/ether-music/`: modulo Java principal.

## Dentro del modulo `backend/java/ether-music`

- `pom.xml`: definicion Maven.
- `mvnw`: entrypoint de build del modulo.
- `src/main/java/`: backend y dominio.
- `src/main/jte/`: frontend renderizado por el backend.
- `src/test/java/`: pruebas.
