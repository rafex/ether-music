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

## Verificacion manual

Con la app levantada:

```bash
curl -i http://127.0.0.1:8080/
curl -i "http://127.0.0.1:8080/api/melodies/generate?root=C&scale=minor&octave=4&steps=16"
curl -i -X POST http://127.0.0.1:8080/api/express/create \
  -H 'Content-Type: application/json' \
  -d '{"mood":"happy","energy":"high","tempo":"fast","length":"short"}'
curl -i http://127.0.0.1:8080/api/songs
```
