# CD.md

## Objetivo

Describir como `ether-music` se publica y llega al servidor k3s.

## Flujo

1. `publish_container.yml` construye la imagen multi-arquitectura del
   modulo Java y la publica en GHCR.
2. `deploy.yml` instala o actualiza la release Helm `ether-music` en el
   namespace `mvps`.
3. El chart expone la aplicacion por Ingress en
   `music.v1.rafex.cloud`.

## Artefactos

- Imagen OCI:
  `ghcr.io/rafex/ether-music:<tag>`
- Chart Helm:
  `helm/ether-music`
- Secretos esperados:
  `KUBE_CONFIG_DATA` en GitHub Actions y `DEEPSEEK_API_KEY` opcional en
  Kubernetes.

## Restricciones

- La persistencia actual usa SQLite sobre un volumen del chart.
- La release debe mantenerse en una sola replica por consistencia del
  archivo SQLite.
- El proceso de deploy no crea certificados ni DNS; asume que la clase
  de Ingress del cluster ya resuelve eso.
