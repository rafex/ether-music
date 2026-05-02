FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /workspace/ether-music

COPY ether-music/.mvn/ .mvn/
COPY ether-music/mvnw .
COPY ether-music/pom.xml .
COPY ether-music/src ./src

RUN chmod +x ./mvnw \
    && ./mvnw -q -DskipTests package

FROM eclipse-temurin:21-jre-jammy

ENV PORT=8080

RUN useradd --create-home --uid 10001 --shell /usr/sbin/nologin appuser

WORKDIR /app

COPY --from=build /workspace/ether-music/target/ether-music.jar /app/ether-music.jar

RUN mkdir -p /app/data /tmp \
    && chown -R appuser:appuser /app /tmp

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/ether-music.jar"]
