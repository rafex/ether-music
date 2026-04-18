package dev.rafex.ether.music.db;

import dev.rafex.ether.database.core.DatabaseClient;
import dev.rafex.ether.database.core.sql.SqlQuery;

public final class SchemaInitializer {

    private SchemaInitializer() {
    }

    public static void initialize(final DatabaseClient db) {
        db.query(SqlQuery.of("PRAGMA journal_mode=WAL"), rs -> {
            rs.next();
            return rs.getString(1);
        });

        db.execute(SqlQuery.of("""
                CREATE TABLE IF NOT EXISTS songs (
                    id          INTEGER PRIMARY KEY AUTOINCREMENT,
                    created_at  TEXT    NOT NULL,
                    source      TEXT    NOT NULL,
                    bpm         INTEGER NOT NULL,
                    scale_label TEXT    NOT NULL,
                    root        TEXT    NOT NULL,
                    steps       INTEGER NOT NULL,
                    interpretation TEXT,
                    data_json   TEXT    NOT NULL
                )
                """));
    }
}
