#!/bin/bash

# Pfad zur application.properties
PROPERTIES_FILE="src/main/resources/application.properties"

# Funktion zum Abrufen der Properties
get_property() {
    grep "^$1=" "$PROPERTIES_FILE" | cut -d'=' -f2
}

# Lade Konfiguration aus application.properties
MONGO_URI=$(get_property "mongodb.uri")
MONGO_DB=$(get_property "mongodb.database")
BACKUP_DIR="src/main/resources/backups/mongodb"

# Aktuelles Datum für den Backup-Ordner
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FOLDER="$BACKUP_DIR/mongodump_${MONGO_DB}_$DATE"

# Backup-Verzeichnis sicherstellen
mkdir -p "$BACKUP_DIR"

# Prüfen, ob mongodump verfügbar
if ! command -v mongodump &> /dev/null; then
    echo "Fehler: 'mongodump' wurde nicht gefunden. Bitte sicherstellen, dass MongoDB-Tools installiert sind." | tee -a "$BACKUP_DIR/mongo_backup.log"
    exit 1
fi

# Backup starten
echo "Starte MongoDB-Backup für die Datenbank: $MONGO_DB" | tee -a "$BACKUP_DIR/mongo_backup.log"
mongodump --uri="$MONGO_URI" --db="$MONGO_DB" --out="$BACKUP_FOLDER" 2>> "$BACKUP_DIR/mongo_backup.log"

# Erfolg oder Fehler prüfen
if [ $? -eq 0 ]; then
    echo "MongoDB-Backup erfolgreich gespeichert unter: $BACKUP_FOLDER" | tee -a "$BACKUP_DIR/mongo_backup.log"
else
    echo "Fehler beim MongoDB-Backup. Details siehe Logdatei: $BACKUP_DIR/mongo_backup.log"
fi
