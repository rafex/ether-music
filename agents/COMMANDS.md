# COMMANDS.md

### Setup

```bash
just test
# o directamente:
make test
```

### Desarrollo

```bash
just run
# o directamente:
cd backend/java/ether-music && ./mvnw -DskipTests compile exec:java
```

### Tests

```bash
just test
```

### Lint y formato

```bash
just helm-lint
# o directamente:
make helm-lint
```

### Build

```bash
just build
```

### Package y deploy

```bash
cd backend/java/ether-music && ./mvnw package
helm template ether-music ./helm/ether-music
```

### Utilidad

```bash
just run 9090
cd backend/java/ether-music && PORT=9090 ./mvnw -DskipTests compile exec:java
```
