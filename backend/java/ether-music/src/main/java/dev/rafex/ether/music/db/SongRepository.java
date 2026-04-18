package dev.rafex.ether.music.db;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import com.fasterxml.jackson.databind.ObjectMapper;

import dev.rafex.ether.database.core.DatabaseClient;
import dev.rafex.ether.database.core.sql.SqlParameter;
import dev.rafex.ether.database.core.sql.SqlQuery;
import dev.rafex.ether.music.melody.ComposedResponse;
import dev.rafex.ether.music.melody.SongRecord;

public final class SongRepository {

    private static final String INSERT = """
            INSERT INTO songs (created_at, source, bpm, scale_label, root, steps, interpretation, data_json)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;

    private static final String SELECT_ALL = """
            SELECT id, created_at, source, bpm, scale_label, root, steps, interpretation
            FROM songs
            ORDER BY created_at DESC
            LIMIT 50
            """;

    private static final String SELECT_BY_ID = "SELECT data_json FROM songs WHERE id = ?";

    private final DatabaseClient db;
    private final ObjectMapper objectMapper;

    public SongRepository(final DatabaseClient db, final ObjectMapper objectMapper) {
        this.db = db;
        this.objectMapper = objectMapper;
    }

    public void save(final ComposedResponse response) {
        try {
            final var dataJson = objectMapper.writeValueAsString(response);
            db.execute(new SqlQuery(INSERT, List.of(
                    SqlParameter.text(Instant.now().toString()),
                    SqlParameter.text(response.source() != null ? response.source() : "unknown"),
                    SqlParameter.of(response.bpm()),
                    SqlParameter.text(response.request().root() + " " + response.scaleLabel()),
                    SqlParameter.text(response.request().root()),
                    SqlParameter.of(response.request().steps()),
                    SqlParameter.text(response.interpretation()),
                    SqlParameter.text(dataJson))));
        } catch (final Exception e) {
            System.err.println("No se pudo guardar la canción: " + e.getMessage());
        }
    }

    public List<SongRecord> findAll() {
        return db.queryList(SqlQuery.of(SELECT_ALL), rs -> new SongRecord(
                rs.getLong("id"),
                rs.getString("created_at"),
                rs.getString("source"),
                rs.getInt("bpm"),
                rs.getString("scale_label"),
                rs.getString("root"),
                rs.getInt("steps"),
                rs.getString("interpretation")));
    }

    public Optional<ComposedResponse> findById(final long id) {
        return db.queryOne(new SqlQuery(SELECT_BY_ID, List.of(SqlParameter.of(id))), rs -> {
            try {
                return objectMapper.readValue(rs.getString("data_json"), ComposedResponse.class);
            } catch (final Exception e) {
                throw new RuntimeException("No se pudo deserializar la canción id=" + id, e);
            }
        });
    }
}
