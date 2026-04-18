package dev.rafex.ether.music.json;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.http.jetty12.JsonCodec;

public final class JacksonJsonCodec implements JsonCodec {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public String toJson(final Object body) {
        try {
            return objectMapper.writeValueAsString(body);
        } catch (final JsonProcessingException e) {
            throw new IllegalStateException("No se pudo serializar la respuesta JSON", e);
        }
    }
}
