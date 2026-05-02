# CI.md

## Objetivo

Definir los gates automaticos minimos que deben pasar antes de publicar
o desplegar `ether-music`.

## Gates obligatorios

- Build Java del modulo `backend/java/ether-music` via Maven Wrapper.
- Ejecucion de pruebas con `./mvnw test`.
- Verificacion del modulo con `./mvnw verify`.
- Lint del chart Helm con `helm lint helm/ether-music`.

## Implementacion actual

- Local:
  `make test`, `make verify` o `make helm-lint`
- GitHub Actions:
  el workflow de despliegue vuelve a ejecutar `helm lint` antes de
  aplicar la release.

## Observaciones

- Aun no existe analisis estatico separado ni escaneo de contenedor.
- El despliegue real depende de que la imagen ya exista en GHCR.
