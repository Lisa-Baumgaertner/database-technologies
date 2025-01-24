#!/bin/bash

# Pfad zur application.properties
PROPERTIES_FILE="src/main/resources/application.properties"

# Funktion zum Abrufen der Properties
get_property() {
    grep "^$1=" "$PROPERTIES_FILE" | cut -d'=' -f2
}

# PostgreSQL-Verbindungsdetails aus application.properties laden
PG_URL=$(get_property "database.url")
PG_USER=$(get_property "database.username")
PG_PASSWORD=$(get_property "database.password")

# PostgreSQL-Verbindungsdetails extrahieren
PG_HOST=$(echo $PG_URL | sed -E 's/jdbc:postgresql:\/\/([^:]+):[0-9]+\/.*/\1/')
PG_PORT=$(echo $PG_URL | sed -E 's/jdbc:postgresql:\/\/[^:]+:([0-9]+)\/.*/\1/')
PG_DB=$(echo $PG_URL | sed -E 's/jdbc:postgresql:\/\/[^\/]+\/(.+)/\1/')

# Zeitmessung und Logging
PERFORMANCE_LOG="src/main/resources/performance/postgres_performance.log"
mkdir -p "src/main/resources/performance"
> "$PERFORMANCE_LOG" # Log leeren

# Passwort setzen
export PGPASSWORD="$PG_PASSWORD"

# Abfragen und Operationen
operations=(
    "SELECT * FROM PERSON WHERE ROLE = 'borrower';"                                   # 1. SELECT alle Borrower
    "SELECT COUNT(*) FROM LENDING WHERE STATUS = 'borrowed';"                         # 2. SELECT Anzahl der ausgeliehenen Bücher
    "SELECT * FROM BOOK WHERE COPIES > 2;"                                           # 3. SELECT Bücher mit mehr als 2 Exemplaren
    "INSERT INTO LENDING (LENDING_ID, BOOK_ID, BORROWER_ID, WORKER_ID, STATUS, CHECKOUT_DATE, DUE_DATE) VALUES (DEFAULT, 1, 7, 10, 'borrowed', '2025-01-01', '2025-01-28');" # 4. INSERT neuer Ausleiheintrag
    "UPDATE BOOK SET COPIES = COPIES - 1 WHERE ISBN = '978-8-87-256827-0';"           # 5. UPDATE Buch-Exemplare reduzieren
    "DELETE FROM WAITLIST WHERE WAITLIST_ID = 5;"                                     # 6. DELETE Eintrag aus der Warteliste
    "SELECT p.FIRSTNAME, p.LASTNAME, b.TITLE FROM PERSON p JOIN LENDING l ON p.USER_ID = l.BORROWER_ID JOIN BOOK b ON l.BOOK_ID = b.BOOK_ID WHERE l.STATUS = 'borrowed';" # 7. SELECT komplexe Query: Borrower und ausgeliehene Bücher
    "SELECT AVG(r.RATING) FROM REVIEW r WHERE r.BOOK_ID = 1;"                         # 8. SELECT Durchschnittsbewertung eines Buches
    "INSERT INTO CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) VALUES (DEFAULT, 1, 'test@example.com', '123456', '987654321');" # 9. INSERT neuer Kontakt
    "UPDATE LENDING SET STATUS = 'returned' WHERE LENDING_ID = 1;"                    # 10. UPDATE Status einer Ausleihe
)

# Zeit messen jeder Abfrage
for query in "${operations[@]}"; do
    echo "Führe Abfrage aus: $query" | tee -a "$PERFORMANCE_LOG"
    start_time=$(date +%s%3N)  # Startzeit in Millisekunden
    echo "$query" | psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" > /dev/null 2>&1
    end_time=$(date +%s%3N)    # Endzeit in Millisekunden
    duration=$((end_time - start_time)) # Dauer berechnen
    echo "Abfragezeit: ${duration} Millisekunden" | tee -a "$PERFORMANCE_LOG"
    echo "--------------------------------" | tee -a "$PERFORMANCE_LOG"
done

# Passwort entfernen
unset PGPASSWORD
