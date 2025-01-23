#!/bin/bash

PROPERTIES_FILE="src/main/resources/application.properties"

# Funktion zum Abrufen der Properties
get_property() {
    grep "^$1=" "$PROPERTIES_FILE" | cut -d'=' -f2
}

# Lade Konfiguration
PG_URL=$(get_property "database.url")
PG_USER=$(get_property "database.username")
PG_PASSWORD=$(get_property "database.password")
PG_DUMP_PATH=$(get_property "pg_dump.path")

BACKUP_DIR="src/main/resources/backups/postgres"
LOG_FILE="$BACKUP_DIR/postgres_backup.log"

# Falls kein pg_dump-Pfad gesetzt ist, Standard verwenden
if [ -z "$PG_DUMP_PATH" ]; then
  PG_DUMP_PATH="pg_dump"
fi

# PostgreSQL-Verbindungsdetails extrahieren
PG_HOST=$(echo $PG_URL | sed -E 's/jdbc:postgresql:\/\/([^:]+):[0-9]+\/.*/\1/')
PG_PORT=$(echo $PG_URL | sed -E 's/jdbc:postgresql:\/\/[^:]+:([0-9]+)\/.*/\1/')
PG_DB=$(echo $PG_URL | sed -E 's/jdbc:postgresql:\/\/[^\/]+\/(.+)/\1/')

# Backup-Dateinamen erstellen
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${PG_DB}_backup_$DATE.sql"

# Backup-Verzeichnis sicherstellen
mkdir -p "$BACKUP_DIR"

# Passwort setzen
export PGPASSWORD="$PG_PASSWORD"

# Zeitmessung starten (Millisekunden)
start_time=$(date +%s%3N)

# Backup starten
"$PG_DUMP_PATH" -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" "$PG_DB" > "$BACKUP_FILE" 2>> "$LOG_FILE"

# Zeitmessung beenden (Millisekunden)
end_time=$(date +%s%3N)

# Dauer berechnen
backup_duration=$((end_time - start_time))

# Ergebnis prüfen und Log schreiben
if [ $? -eq 0 ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") - PostgreSQL-Backup erfolgreich: $BACKUP_FILE" >> "$LOG_FILE"
    echo "Backup-Dauer: ${backup_duration} Millisekunden" >> "$LOG_FILE"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Fehler beim PostgreSQL-Backup." >> "$LOG_FILE"
    echo "Backup-Dauer: ${backup_duration} Millisekunden (fehlgeschlagen)" >> "$LOG_FILE"
fi

# Passwort entfernen
unset PGPASSWORD
