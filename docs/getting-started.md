# Getting Started

## Requisitos

- Java 21
- Acceso de red para que Maven Wrapper descargue dependencias si hace
  falta

## Comandos recomendados

Desde la raiz del repositorio:

```bash
just test
just build
just run
```

## Comandos directos del modulo

Si quieres operar el modulo Java sin pasar por `make` o `just`:

```bash
cd backend/java/ether-music
./mvnw test
./mvnw package
PORT=9090 ./mvnw exec:java
```

## Configuración de DeepSeek (Composición Electrónica)

Para activar la composición electrónica con IA (endpoints `/electronic` y `/api/electronic/*`), necesitas:

1. **Obtener API Key:** Crea una cuenta en [DeepSeek](https://platform.deepseek.com) y genera una API key
2. **Establecer variable de entorno:**

```bash
export DEEPSEEK_API_KEY="sk-xxxxxxxxxxxxxxxx"
```

3. **Reinicia la aplicación:**

```bash
just run
# o
PORT=8080 ./mvnw exec:java
```

Una vez configurada, podrás usar:
- Página `/electronic` — composición con análisis de código/texto
- Página `/agent` — interfaz conversacional para componer música
- Endpoint `POST /api/electronic/{code|text|words}` — API REST

**Sin la API key:** Estos endpoints no estarán disponibles (se registran solo si `DEEPSEEK_API_KEY` existe).

## Verificacion manual

Con la app levantada:

```bash
# Endpoints sin DeepSeek
curl -i http://127.0.0.1:8080/
curl -i "http://127.0.0.1:8080/api/melodies/generate?root=C&scale=minor&octave=4&steps=16"
curl -i -X POST http://127.0.0.1:8080/api/express/create \
  -H 'Content-Type: application/json' \
  -d '{"mood":"happy","energy":"high","tempo":"fast","length":"short"}'
curl -i http://127.0.0.1:8080/api/songs

# Endpoints con DeepSeek (requieren DEEPSEEK_API_KEY)
curl -i -X POST http://127.0.0.1:8080/api/electronic/text \
  -H 'Content-Type: text/plain' \
  -d 'Una noche lluviosa en la ciudad'
```
