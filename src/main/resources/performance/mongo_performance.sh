#!/bin/bash

# Pfad zur application.properties
PROPERTIES_FILE="src/main/resources/application.properties"

# Funktion zum Abrufen der Properties
get_property() {
    grep "^$1=" "$PROPERTIES_FILE" | cut -d'=' -f2
}

# Lade Konfiguration aus application.properties
MONGO_CLIENT_PATH=$(get_property "mongo.path")
MONGO_URI_FULL=$(get_property "mongodb.uri")
MONGO_DB=$(get_property "mongodb.database")

# Verarbeite die URI, um nur den Teil bis `.mongodb.net/` zu übernehmen
MONGO_URI=$(echo "$MONGO_URI_FULL" | sed -E 's/(mongodb\+srv:\/\/[^\/]+\/).*/\1/')

# Log-Verzeichnis
LOG_DIR="src/main/resources/logs"
LOG_FILE="$LOG_DIR/mongo_performance.log"

# Verzeichnis sicherstellen
mkdir -p "$LOG_DIR"

# Debug-Ausgabe
echo "Geladene MONGO_URI: $MONGO_URI"
echo "Geladene MONGO_DB: $MONGO_DB"

# Zeitmessung und Logging initialisieren
echo "MongoDB Performance Test - $(date)" > "$LOG_FILE"
echo "-----------------------------------" >> "$LOG_FILE"

# Abfragen und Operationen definieren
operations=(
    'db.Person.find({ "role": "borrower" });'                                                # 1. SELECT alle Borrower
    'db.Lending.countDocuments({ "status": "borrowed" });'                                   # 2. SELECT Anzahl der ausgeliehenen Bücher
    'db.Book.find({ "copies": { $gt: 2 } });'                                               # 3. SELECT Bücher mit mehr als 2 Exemplaren
    'db.Lending.insertOne({ "lendingId": 999, "bookId": 1, "borrowerId": 7, "workerId": 10, "status": "borrowed", "checkoutDate": "2025-01-01", "dueDate": "2025-01-28" });' # 4. INSERT neuer Ausleiheintrag
    'db.Book.updateOne({ "isbn.short": "7208158034" }, { $inc: { "copies": -1 } });'         # 5. UPDATE Buch-Exemplare reduzieren
    'db.Waitlist.deleteOne({ "waitlistId": 5 });'                                            # 6. DELETE Eintrag aus der Warteliste
    'db.Person.aggregate([{ $match: { "lendings.status": "borrowed" } }, { $lookup: { from: "Book", localField: "lendings.bookId", foreignField: "bookId", as: "borrowedBooks" } }, { $project: { "personalDetails.firstName": 1, "personalDetails.lastName": 1, "borrowedBooks.metadata.title": 1 } }]);' # 7. SELECT komplexe Query: Borrower und ausgeliehene Bücher
    'db.Review.aggregate([{ $match: { "bookId": 1 } }, { $group: { _id: null, avgRating: { $avg: "$rating" } } }]);' # 8. SELECT Durchschnittsbewertung eines Buches
    'db.Contact.insertOne({ "contactId": 999, "userId": 1, "email": "test@example.com", "phone": "123456", "mobile": "987654321" });' # 9. INSERT neuer Kontakt
    'db.Lending.updateOne({ "lendingId": 1 }, { $set: { "status": "returned" } });'          # 10. UPDATE Status einer Ausleihe
)

# Vorgänge durchlaufen
for operation in "${operations[@]}"; do
    echo "Führe Operation aus: $operation" | tee -a "$LOG_FILE"

    # Zeitmessung starten
    start_time=$(date +%s%3N)
    result=$("$MONGO_CLIENT_PATH" "$MONGO_URI/$MONGO_DB" --quiet --eval "$operation" 2>&1)
    end_time=$(date +%s%3N)

    # Dauer berechnen
    duration=$((end_time - start_time))

    # Ergebnis und Dauer protokollieren
    echo "$result" | tee -a "$LOG_FILE"
    echo "Ausführungszeit: ${duration} Millisekunden" | tee -a "$LOG_FILE"
    echo "--------------------------------" | tee -a "$LOG_FILE"
done

echo "MongoDB Performance Test abgeschlossen. Ergebnisse in $LOG_FILE"
