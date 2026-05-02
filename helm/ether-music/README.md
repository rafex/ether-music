# ether-music Helm Chart

Chart Helm para desplegar `ether-music` en Kubernetes con imagen en
GHCR y persistencia local para SQLite.

## Imagen por defecto

- `ghcr.io/rafex/ether-music:latest`

## Instalacion recomendada

1. Crear secret opcional con integraciones:

```bash
kubectl -n mvps create secret generic ether-music-secrets \
  --from-literal=DEEPSEEK_API_KEY='changeme'
```

2. Instalar o actualizar la release:

```bash
helm upgrade --install ether-music ./helm/ether-music \
  --namespace mvps --create-namespace \
  --set image.tag="<sha-o-tag-version>" \
  --set existingSecret="ether-music-secrets"
```

## Ingress

Por defecto publica la aplicacion en:

- `music.v1.rafex.cloud`

## Valores importantes

- `image.repository`, `image.tag`
- `persistence.enabled`, `persistence.size`
- `existingSecret`
- `ingress.hosts`
