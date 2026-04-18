# Java Backend

Modulo Java principal de `ether-music`.

## Contenido

- `pom.xml`: build Maven del modulo.
- `mvnw`: Maven Wrapper del modulo.
- `src/main/java/`: codigo del backend y dominio de melodia.
- `src/main/jte/`: templates del frontend servido por el backend.
- `src/test/java/`: pruebas del modulo.

## Operacion

Este modulo se ejecuta normalmente desde el root del repo via
`make` y `just`, pero la fuente de verdad del build es `./mvnw`.

## Comandos directos

```bash
./mvnw test
./mvnw package
PORT=9090 ./mvnw exec:java
```
