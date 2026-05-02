# Deployment

Guia humana para publicar y desplegar `ether-music` en k3s.

## Destino

- Dominio publico: `music.v1.rafex.cloud`
- Namespace Kubernetes: `mvps`
- Release Helm: `ether-music`
- Imagen: `ghcr.io/rafex/ether-music`

## Requisitos

- GitHub Actions con secreto `KUBE_CONFIG_DATA`.
- Acceso pull desde el cluster a GHCR.
- Helm 3 para pruebas locales del chart.

## Publicar imagen

La imagen se construye desde `backend/java/Dockerfile` usando el modulo
`backend/java/ether-music`.

Formas de publicarla:

```bash
git tag v1.20260424
git push origin v1.20260424
```

o manualmente desde GitHub Actions con `publish_container.yml`,
enviando un tag con formato `vN.YYYYmmDD[-N]`.

## Preparar secretos

Si quieres habilitar composicion electronica con DeepSeek:

```bash
kubectl -n mvps create secret generic ether-music-secrets \
  --from-literal=DEEPSEEK_API_KEY='tu_api_key'
```

Si no existe ese secret, la app sigue funcionando y solo desactiva
`/api/electronic/*`.

## Validar chart localmente

```bash
make helm-lint
helm template ether-music ./helm/ether-music
```

## Desplegar

Manual:

```bash
helm upgrade --install ether-music ./helm/ether-music \
  --namespace mvps --create-namespace \
  --set image.repository=ghcr.io/rafex/ether-music \
  --set image.tag=v1.20260424 \
  --set existingSecret=ether-music-secrets
```

Por GitHub Actions:

- `publish_container.yml`: publica la imagen
- `deploy.yml`: despliega la release Helm

## Verificar

```bash
kubectl -n mvps get deploy,pods,svc,ingress,pvc
kubectl -n mvps rollout status deployment/ether-music
curl -i http://music.v1.rafex.cloud/health
```
