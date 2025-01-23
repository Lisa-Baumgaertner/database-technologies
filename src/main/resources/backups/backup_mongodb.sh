#!/bin/bash

# Pfad zur application.properties
PROPERTIES_FILE="src/main/resources/application.properties"

# Funktion zum Abrufen von Properties
get_property() {
    grep "^$1=" "$PROPERTIES_FILE" | cut -d'=' -f2
}

# Lade Konfiguration aus application.properties
MONGO_DUMP_PATH=$(get_property "mongodump.path")
MONGO_URI_FULL=$(get_property "mongodb.uri")
MONGO_DB=$(get_property "mongodb.database")

# Verarbeite die URI, um nur den Teil bis `.mongodb.net/` zu übernehmen
MONGO_URI=$(echo "$MONGO_URI_FULL" | sed -E 's/(mongodb\+srv:\/\/[^\/]+\/).*/\1/')

# Backup-Verzeichnis
BACKUP_DIR="src/main/resources/backups/mongodb"

# Aktuelles Datum für den Backup-Ordner
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FOLDER="$BACKUP_DIR/mongodump_${MONGO_DB}_$DATE"

# Backup-Verzeichnis sicherstellen
mkdir -p "$BACKUP_DIR"

# Prüfen, ob der mongodump-Pfad existiert
if [ ! -f "$MONGO_DUMP_PATH" ]; then
    echo "Fehler: Der angegebene Pfad zu 'mongodump' ist ungültig: $MONGO_DUMP_PATH"
    exit 1
fi

# Debug-Ausgabe
echo "Geladene MONGO_URI: $MONGO_URI"
echo "Geladene MONGO_DB: $MONGO_DB"

# Backup starten
echo "Starte MongoDB-Backup für die Datenbank: $MONGO_DB"
"$MONGO_DUMP_PATH" --uri="${MONGO_URI}" --db="$MONGO_DB" --out="$BACKUP_FOLDER" 2>> "$BACKUP_DIR/mongo_backup.log"

# Erfolg oder Fehler prüfen
if [ $? -eq 0 ]; then
    echo "MongoDB-Backup erfolgreich gespeichert unter: $BACKUP_FOLDER"
else
    echo "Fehler beim MongoDB-Backup. Details siehe Logdatei: $BACKUP_DIR/mongo_backup.log"
fi
