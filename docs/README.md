# Docs

Documentacion para humanos del proyecto.

## Contenido

**Setup y API:**
- [`getting-started.md`](./getting-started.md):
  como levantar, probar, navegar el proyecto y configurar DeepSeek.
- [`api-reference.md`](./api-reference.md):
  endpoints, payloads y ejemplos para consumir la API REST.
- [`deployment.md`](./deployment.md):
  como publicar imagen, preparar secretos y desplegar en k3s.
- [`repository-layout.md`](./repository-layout.md):
  como esta organizado el repo y donde vive cada cosa.

**Explicaciones para usuarios:**
- [`HOW_IT_WORKS.md`](./HOW_IT_WORKS.md):
  guía para no-músicos: cómo funciona Ether Music, modos de composición, conceptos básicos.
- [`MUSIC_THEORY.md`](./MUSIC_THEORY.md):
  guía para músicos: escalas, algoritmos, voicings, mapping de parámetros.

## Relacion con `agents/`

- `docs/` explica el proyecto a personas.
- `agents/` conserva el contexto fuente para agentes y SpecNative.
- `openapi/` contiene el contrato importable por clientes como Postman.
