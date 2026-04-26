# STACK.md

### Runtime

- Lenguaje: Java
- Version: 21 como baseline de compilacion
- Ubicacion del modulo: `backend/java/ether-music/`
- Build tool entrypoint: Maven Wrapper `./mvnw`

### Frameworks

- Ether `ether-http-jetty12` `3.0.8-v20260303`:
  servidor HTTP y registro de rutas REST.
- `jte` `3.2.3`:
  render de templates HTML del frontend.
- Jackson Databind `2.20.0`:
  implementacion local del `JsonCodec` requerido por la version
  publicada de Ether.

### Infraestructura

- Build: Maven 3.9+
- Servidor HTTP embebido: Jetty 12 via Ether
- Reproduccion de audio: Web Audio API en navegador
- Persistencia local: SQLite via `sqlite-jdbc`
- Contenedor: Docker multi-stage con Eclipse Temurin 21
- Orquestacion: Helm sobre k3s
- Registro de imagenes: GHCR
- CI/CD: GitHub Actions

### Integraciones

- Navegador moderno con Web Audio API:
  reproduccion local del audio generado.

### Restricciones

- Compilar con `--release 21`.
- Mantener el frontend sin bundler en esta fase.
- No depender de almacenamiento externo para el MVP inicial.
- Mantener una sola replica mientras la base siga en SQLite.
