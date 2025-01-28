package application.repository;

import application.model.Lending;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Projections.elemMatch;

import com.mongodb.client.model.Updates;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementierung des LendingRepository für MongoDB.
 * Diese Klasse bietet Methoden zum Verwalten von Ausleiheinträgen.
 */
public class MongoLendingRepositoryImpl implements LendingRepository {
    private final MongoCollection<Document> personCollection;
    private final MongoCollection<Document> bookCollection;
    private final MongoCollection<Document> keywordCollection;

    /**
     * Konstruktor zur Initialisierung der MongoDB-Collection.
     */
    public MongoLendingRepositoryImpl(MongoDatabase mongoDatabase) {
        this.personCollection = mongoDatabase.getCollection(MongoCollectionNameRepository.getCollectionName("Person"));
        this.bookCollection = mongoDatabase.getCollection(MongoCollectionNameRepository.getCollectionName("Book"));
        this.keywordCollection = mongoDatabase.getCollection(MongoCollectionNameRepository.getCollectionName("Keyword"));
    }

    /**
     * Holt alle Ausleiheinträge aus der Datenbank.
     */
    public List<Lending> getAllLendinglistEntries() {
        List<Lending> lendings = new ArrayList<>();

        // MongoDB Aggregation für beide Collections
        List<MongoCollection<Document>> collections = List.of(this.personCollection, this.bookCollection);

        for (MongoCollection<Document> collection : collections) {
            try (MongoCursor<Document> cursor = collection.aggregate(List.of(
                    new Document("$unwind", "$lendings"), // Entpacken des lendings-Arrays
                    new Document("$replaceRoot", new Document("newRoot", "$lendings")) // Extrahieren der lendings
            )).iterator()) {
                while (cursor.hasNext()) {
                    Document lendingDoc = cursor.next();
                    // lendings.add(documentToLending(lendingDoc));
                }
            }
        }

        System.out.println("Total lending entries found via aggregation: " + lendings.size());
        return lendings;
    }

    /**
     * Fügt einen neuen Ausleiheintrag hinzu.
     */
    public void addToLending(Long userId, Long workerId, Long bookId, String status, LocalDate checkoutDate) {
        // Ermittle die nächste lendingId
        int newLendingId = getMaxLendingId() + 1;

        // Lending-Daten erstellen
        Document newLending = new Document()
                .append("lendingId", newLendingId)
                .append("bookId", bookId)
                .append("workerId", workerId)
                .append("status", status)
                .append("checkoutDate", formatDate(checkoutDate))
                .append("dueDate", formatDate(checkoutDate.plusDays(28))) // Standardmäßig 28 Tage
                .append("returnDate", "Noch nicht zurückgegeben");

        // Zu Person-Dokument hinzufügen
        UpdateResult personResult = personCollection.updateOne(
                eq("userId", userId),
                new Document("$push", new Document("lendings", newLending))
        );

        // Zu Buch-Dokument hinzufügen
        UpdateResult bookResult = bookCollection.updateOne(
                eq("bookId", bookId),
                new Document("$push", new Document("lendings", newLending))
        );

        if (personResult.getModifiedCount() > 0 && bookResult.getModifiedCount() > 0) {
            System.out.println("Lending erfolgreich hinzugefügt.");
            updateBookStatusAndCopies(bookId); // Status & Copies akutalisieren
        } else {
            System.err.println("Fehler beim Hinzufügen der Lending.");
        }
    }

    /**
     * Ermittelt die höchste derzeitige Lending-Id
     */
    private int getMaxLendingId() {
        // Höchste lendingId aus der Person-Kollektion
        Document personMax = personCollection.aggregate(Arrays.asList(
                new Document("$unwind", "$lendings"),
                new Document("$group", new Document("_id", null).append("maxId", new Document("$max", "$lendings.lendingId")))
        )).first();

        int maxPersonId = (personMax != null) ? personMax.getInteger("maxId", 0) : 0;

        // Höchste lendingId aus der Buch-Kollektion
        Document bookMax = bookCollection.aggregate(Arrays.asList(
                new Document("$unwind", "$lendings"),
                new Document("$group", new Document("_id", null).append("maxId", new Document("$max", "$lendings.lendingId")))
        )).first();

        int maxBookId = (bookMax != null) ? bookMax.getInteger("maxId", 0) : 0;

        // Höchsten Wert zurückgeben
        return Math.max(maxPersonId, maxBookId);
    }

    /**
     * Holt alle Ausleiheinträge zu einem bestimmten Buch.
     */
    public List<Lending> getLendingForBook(Long bookId) {
        List<Lending> lendings = new ArrayList<>();

        // Buch-Dokument suchen
        Document bookDoc = bookCollection.find(eq("bookId", bookId)).first();
        if (bookDoc != null && bookDoc.containsKey("lendings")) {
            List<Document> lendingDocs = (List<Document>) bookDoc.get("lendings");

            for (Document lendingDoc : lendingDocs) {
                lendings.add(documentToLending(lendingDoc));
            }
        }
        return lendings;
    }

    /**
     * Holt alle Ausleiheinträge für einen bestimmten Nutzer.
     */
    public List<Lending> getLendingForUser(Long userId) {
        List<Lending> lendings = new ArrayList<>();

        // Nutzer-Dokument suchen
        Document personDoc = personCollection.find(eq("userId", userId)).first();
        if (personDoc != null && personDoc.containsKey("lendings")) {
            List<Document> lendingDocs = (List<Document>) personDoc.get("lendings");

            for (Document lendingDoc : lendingDocs) {
                lendings.add(documentToLending(lendingDoc));
            }
        }
        return lendings;
    }

    /**
     * Aktualisiert den Status einer Ausleihe (z. B. von "ausgeliehen" auf "zurückgegeben").
     */
    public  void updateStatus(Long lendingId, String status) {
        // Status in der Person-Kollektion aktualisieren
        UpdateResult personResult = personCollection.updateOne(
                eq("lendings.lendingId", lendingId),
                new Document("$set", new Document("lendings.$.status", status))
        );

        // Status in der Buch-Kollektion aktualisieren
        UpdateResult bookResult = bookCollection.updateOne(
                eq("lendings.lendingId", lendingId),
                new Document("$set", new Document("lendings.$.status", status))
        );

        if (personResult.getModifiedCount() > 0 || bookResult.getModifiedCount() > 0) {
            System.out.println("Lending-Status erfolgreich aktualisiert.");

            // Buch-ID abrufen, um Kopien & Status anzupassen
            Document lendingDoc = bookCollection.find(eq("lendings.lendingId", lendingId)).first();
            if (lendingDoc != null) {
                Long bookId = lendingDoc.getLong("bookId");
                updateBookStatusAndCopies(bookId);
            }
        } else {
            System.err.println("Fehler beim Aktualisieren des Lending-Status.");
        }
    }

    /**
     * Entfernt einen Ausleiheintrag aus der Datenbank.
     */
    public  void removeFromLending(Long lendingId) {

        Document lendingDoc = bookCollection.find(Filters.elemMatch("lendings", eq("lendingId", lendingId))).first();
        if (lendingDoc == null) {
            System.out.println("Kein Lending mit ID " + lendingId + " gefunden.");
            return;
        }

        Long bookId = lendingDoc.getLong("bookId");

        // Lending aus der Person-Kollektion entfernen
        UpdateResult personResult = personCollection.updateOne(
                Filters.elemMatch("lendings", eq("lendingId", lendingId)),
                new Document("$pull", new Document("lendings", new Document("lendingId", lendingId)))
        );

        // Lending aus der Buch-Kollektion entfernen
        UpdateResult bookResult = bookCollection.updateOne(
                Filters.elemMatch("lendings", eq("lendingId", lendingId)),
                new Document("$pull", new Document("lendings", new Document("lendingId", lendingId)))
        );

        if (personResult.getModifiedCount() > 0 || bookResult.getModifiedCount() > 0) {
            System.out.println("Lending erfolgreich entfernt.");
            updateBookStatusAndCopies(bookId);
        } else {
            System.err.println("Fehler beim Entfernen des Lending.");
        }
    }

    /**
     * Holt einen Ausleiheintrag anhand seiner ID.
     */
    public Lending getLendingById(Long lendingId) {
        System.out.println("lendingId " + lendingId);

        // Suche in der Person-Kollektion
        Document personDoc = personCollection.find(
                eq("lendings.lendingId", lendingId)
        ).projection(new Document("lendings.$", 1)).first();

        if (personDoc != null) {
            System.out.println("Lending gefunden in Person-Kollektion.");
            Document lendingDoc = (Document) personDoc.getList("lendings", Document.class).get(0);
            return documentToLending(lendingDoc);
        }
        // Suche in der Peron-Kollektion
        Document bookDoc = bookCollection.find(
                eq("lendings.lendingId", lendingId)
        ).projection(new Document("lendings.$", 1)).first();

        if (bookDoc != null) {
            System.out.println("Lending gefunden in Book-Kollektion.");
            Document lendingDoc = (Document) bookDoc.getList("lendings", Document.class).get(0);
            return documentToLending(lendingDoc);
        }

        System.out.println("Lending mit ID " + lendingId + " nicht gefunden.");
        return null;
    }

    /**
     * Aktualisiert das Fälligkeitsdatum einer Ausleihe.
     */
    public  void updateDueDate(Long lendingId, LocalDate newDueDate) {
        // Formatieren des Datums für MongoDB als String im Format "dd-MM-yyyy"
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        String formattedDate = newDueDate.format(formatter);

        // Update in der Person-Kollektion
        UpdateResult personResult = personCollection.updateOne(
                eq("lendings.lendingId", lendingId),
                new Document("$set", new Document("lendings.$.dueDate", formattedDate))
        );

        // Update in der Book-Kollektion
        UpdateResult bookResult = bookCollection.updateOne(
                eq("lendings.lendingId", lendingId),
                new Document("$set", new Document("lendings.$.dueDate", formattedDate))
        );

        if (bookResult.getModifiedCount() > 0) {
            System.out.println("dueDate in Book-Kollektion aktualisiert.");
        } else {
            System.out.println("LendingId nicht in Book-Kollektion gefunden.");
        }

        // Falls die ID in keiner der Kollektionen gefunden wurde
        if (personResult.getModifiedCount() == 0 && bookResult.getModifiedCount() == 0) {
            System.out.println("Lending mit ID " + lendingId + " nicht gefunden. Aktualisierung fehlgeschlagen.");
        }
    }

    /**
     * Filtert Ausleiheinträge basierend auf einem bestimmten Filterkriterium.
     */
    public List<Lending> getFilteredLendings(String filter) {return null;}

    /**
     * Berechnet, wie oft eine Ausleihe verlängert wurde.
     */
    public int  calculateExtensionCount(Lending lending) {
        System.out.println("Calculating extension count for lending: " + lending);

        if (lending == null || lending.getCheckoutDate() == null || lending.getDueDate() == null) {
            System.out.println("Ungültige Lending-Daten.");
            return 0;
        }
        // Ursprüngliches Fälligkeitsdatum = Checkout-Datum + 28 Tage
        LocalDate originalDueDate = lending.getCheckoutDate().plusDays(28);

        // Verwende das aktuelle Datum, falls kein Rückgabedatum gesetzt ist
        LocalDate effectiveReturnDate = lending.getReturnDate() != null ? lending.getReturnDate() : LocalDate.now();

        // Überprüfen, ob das Rückgabedatum nach dem ursprünglichen Fälligkeitsdatum liegt
        if (effectiveReturnDate.isAfter(originalDueDate)) {
            // Berechne die Anzahl der 28-tägigen Verlängerungen
            int extensionCount = (int) (ChronoUnit.DAYS.between(originalDueDate, effectiveReturnDate) / 28);

            // Maximal 3 Verlängerungen erlaubt
            if (extensionCount > 3) {
                System.out.println("Maximale Verlängerungsanzahl erreicht (3).");
                return 3;
            }
            return extensionCount;
        }

        // Keine Verlängerung, wenn das Rückgabedatum vor oder am ursprünglichen Fälligkeitsdatum liegt
        return 0;
    }

    /**
     * Holt Ausleiheinträge für einen Nutzer basierend auf seinem Namen.
     */
    public List<Lending> getLendingForUserByName(String userName) {
        List<Lending> lendings = new ArrayList<>();

        // MongoDB Aggregation Pipeline für die Suche nach Vor- und Nachnamen
        List<Bson> pipeline = Arrays.asList(
                Aggregates.match(Filters.or(
                        Filters.regex("personalDetails.firstName", ".*" + userName + ".*", "i"),
                        Filters.regex("personalDetails.lastName", ".*" + userName + ".*", "i")
                )),
                Aggregates.project(Projections.fields(
                        Projections.include("personalDetails.firstName", "personalDetails.lastName", "lendings", "userId")
                ))
        );

        try (MongoCursor<Document> cursor = this.personCollection.aggregate(pipeline).iterator()) {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                System.out.println("Gefundenes Dokument: " + doc.toJson());

                List<Lending> userLendings = documentToLendingList(doc);
                if (!userLendings.isEmpty()) {
                    lendings.addAll(userLendings);
                }
            }
        } catch (Exception e) {
            System.err.println("Fehler bei der Suche nach Ausleihen für '" + userName + "': " + e.getMessage());
        }

        return lendings;
    }

    /**
     * Filtert Ausleihen basierend auf dem Fälligkeitsdatum.
     */
    public List<Lending> filterByReturnDate() {
        List<Lending> lendingList = new ArrayList<>();

        // Definiere den Datumsformatter für die Datumsumwandlung
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

        // Suche nach Büchern mit existierenden Ausleihen, die ein Fälligkeitsdatum enthalten
        List<Document> books = bookCollection.find().into(new ArrayList<>());

        for (Document book : books) {
            if (book.containsKey("lendings")) {
                List<Document> lendings = (List<Document>) book.get("lendings");
                System.out.println("lendings" + lendings.size());

                List<Lending> filteredLendings = lendings.stream()
                        .filter(l -> {
                            // Überprüfen, ob das Feld dueDate vorhanden und nicht leer ist
                            String dueDateStr = l.getString("returnDate");
                            return dueDateStr != null && !dueDateStr.trim().isEmpty() &&
                                    !dueDateStr.equalsIgnoreCase("Noch nicht zurückgegeben");
                        })
                        .map(l -> new Lending(
                                l.getInteger("lendingId"),
                                book.getInteger("bookId"),
                                l.getInteger("borrowerId"),
                                l.getInteger("workerId"),
                                l.getString("status"),
                                parseDate(l.getString("checkoutDate"), formatter),
                                parseDate(l.getString("returnDate"), formatter),
                                parseDate(l.getString("dueDate"), formatter)
                        ))
                        .collect(Collectors.toList());

                lendingList.addAll(filteredLendings);
            }
        }

        return lendingList;
    }

    /**
     * Filtert Ausleihen basierend auf der Kategorie.
     */
    public List<Lending> filterByCategory(String category) {
        List<Lending> lendingList = new ArrayList<>();
        // Definiere den Datumsformatter für die Datumsumwandlung
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

          // Finde die keywordId für die übergebene Kategorie
        Document keywordDoc = keywordCollection.find(eq("keyword", category)).first();

        int keywordId = keywordDoc.getInteger("keyword_id");

        if (keywordDoc == null) {
            System.out.println("Kategorie nicht gefunden: " + category);
            return lendingList;  // Leere Liste zurückgeben, wenn die Kategorie nicht existiert
        }


        // Suche nach Büchern, die das angegebene Keyword enthalten
        List<Document> books = bookCollection.find(elemMatch("keywords", eq("keywordId", keywordId)))
                .into(new ArrayList<>());

        for (Document book : books) {
            if (book.containsKey("lendings")) {
                List<Document> lendings = (List<Document>) book.get("lendings");

                List<Lending> filteredLendings = lendings.stream()
                        .map(l -> new Lending(
                                l.getInteger("lendingId"),
                                book.getInteger("bookId"),
                                l.getInteger("borrowerId"),
                                l.getInteger("workerId"),
                                l.getString("status"),
                                parseDate(l.getString("checkoutDate"), formatter),
                                parseDate(l.getString("returnDate"), formatter),
                                parseDate(l.getString("dueDate"), formatter)
                        ))
                        .collect(Collectors.toList());

                lendingList.addAll(filteredLendings);
            }
        }

        return lendingList;
    }

    /**
     * Filtert Ausleihen basierend auf der Verfügbarkeit.
     */
    public List<Lending> filterByAvailability(String availabilityStatus) {
        List<Lending> lendingList = new ArrayList<>();

        // MongoDB-Abfrage zum Filtern nach Lending-Status
        List<Document> books = bookCollection.find().into(new ArrayList<>());

        for (Document book : books) {
            if (book.containsKey("lendings")) {
                List<Document> lendings = (List<Document>) book.get("lendings");
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

                List<Lending> filteredLendings = lendings.stream()
                        .filter(l -> availabilityStatus.equals(l.getString("status"))) // Status prüfen
                        .map(l -> new Lending(
                                l.getInteger("lendingId"),
                                book.getInteger("bookId"),
                                l.getInteger("borrowerId"),
                                l.getInteger("workerId"),
                                l.getString("status"),
                                parseDate(l.getString("checkoutDate"), formatter),
                                parseDate(l.getString("returnDate"), formatter),
                                parseDate(l.getString("dueDate"), formatter)
                        ))
                        .collect(Collectors.toList());

                lendingList.addAll(filteredLendings);
            }
        }

        return lendingList;
    }


    /**
     * Holt alle Schlüsselwörter Keywords.
     */
    public List<String> getAllKeywords() {
        List<String> keywordList = new ArrayList<>();

        // Alle Dokumente aus der Keyword-Sammlung abrufen
        List<Document> keywords = keywordCollection.find().into(new ArrayList<>());
        // Extrahiere die Keywords aus jedem Dokument
        keywordList = keywords.stream()
                .map(doc -> doc.getString("keyword"))
                .filter(keyword -> keyword != null && !keyword.isEmpty()) // Null oder leere Werte filtern
                .collect(Collectors.toList());

        return keywordList;
    }

    /**
     * Wandelt ein MongoDB-Dokument in Liste von Lending-Objekt um.
     */
    private List<Lending> documentToLendingList(Document doc) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        List<Lending> lendingList = new ArrayList<>();

        // Überprüfen, ob userId existiert, wenn nicht, Standardwert setzen
        int userIdBorrower = doc.containsKey("userId") ? doc.getInteger("userId", 0) : 0;
        System.out.println("Extracted userId: " + userIdBorrower);

        // Prüfen, ob das Feld "lendings" existiert und nicht null ist
        if (!doc.containsKey("lendings") || doc.get("lendings") == null) {
            System.out.println("Keine Lending-Daten gefunden.");
            return lendingList;
        }

        List<Document> lendingDocs = doc.getList("lendings", Document.class);
        if (lendingDocs.isEmpty()) {
            System.out.println("Lending-Array ist leer.");
            return lendingList;
        }

        // Iteration über alle Lending-Einträge
        for (Document lendingDoc : lendingDocs) {
            int lendingId = lendingDoc.getInteger("lendingId", 0);
            int bookId = lendingDoc.getInteger("bookId", 0);
            int workerId = lendingDoc.getInteger("workerId", 0);
            String status = lendingDoc.getString("status") != null ? lendingDoc.getString("status") : "unknown";

            // Sichere Datumsumwandlung
            LocalDate checkoutDate = parseDate(lendingDoc.getString("checkoutDate"), formatter);
            LocalDate dueDate = parseDate(lendingDoc.getString("dueDate"), formatter);
            LocalDate returnDate = parseDate(lendingDoc.getString("returnDate"), formatter);

            // Lending-Objekt erstellen und zur Liste hinzufügen
            Lending lending = new Lending(lendingId, bookId, userIdBorrower, workerId, status, checkoutDate, returnDate, dueDate);
            lendingList.add(lending);
        }

        return lendingList;
    }

    /**
     * Wandelt ein MongoDB-Dokument in ein Lending-Objekt um.
     */
    private Lending documentToLending(Document doc) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

        // Überprüfen, ob das Dokument null ist
        if (doc == null) {
            System.out.println("Das übergebene Dokument ist null.");
            return null;
        }

        // Überprüfen, ob userId existiert, wenn nicht, Standardwert setzen
        int borrowerId = doc.containsKey("borrowerId") ? doc.getInteger("borrowerId", 0) : 0;
        System.out.println("Extracted borrowerId: " + borrowerId);

        // Prüfen, ob das Feld "lendingId" existiert
        if (!doc.containsKey("lendingId")) {
            System.out.println("Keine Lending-Daten gefunden.");
            return null;
        }

        // Extrahiere Lending-Details
        int lendingId = doc.getInteger("lendingId", 0);
        int bookId = doc.getInteger("bookId", 0);
        int workerId = doc.getInteger("workerId", 0);
        String status = doc.getString("status") != null ? doc.getString("status") : "unknown";

        // Sichere Datumsumwandlung
        LocalDate checkoutDate = parseDate(doc.getString("checkoutDate"), formatter);
        LocalDate dueDate = parseDate(doc.getString("dueDate"), formatter);
        LocalDate returnDate = parseDate(doc.getString("returnDate"), formatter);

        // Lending-Objekt erstellen
        Lending lending = new Lending(lendingId, bookId, borrowerId, workerId, status, checkoutDate, returnDate, dueDate);

        return lending;
    }


    /**
     * Hilfsmethode zur sicheren Umwandlung eines Datumsstrings in LocalDate.
     */
    private LocalDate parseDate(String dateString, DateTimeFormatter formatter) {
        if (dateString == null || dateString.trim().isEmpty() || dateString.equalsIgnoreCase("Noch nicht zurückgegeben")) {
            return null;
        }
        try {
            return LocalDate.parse(dateString, formatter);
        } catch (Exception e) {
            System.err.println("Fehler bei der Datumsumwandlung für: " + dateString);
            return null;
        }
    }

    /**
     * Hilfsmethode zur sicheren Umwandlung eines LocalDate zu Datumsstring.
     */
    private String formatDate(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        return date.format(formatter);
    }

    private void updateBookStatusAndCopies(Long bookId) {
        Document book = bookCollection.find(Filters.eq("bookId", bookId)).first();
        if (book == null) {
            System.out.println("Kein Buch mit der ID " + bookId + " gefunden.");
            return;
        }

        int copies = book.getInteger("copies", 0);
        List<Document> lendings = book.getList("lendings", Document.class, new ArrayList<>());
        List<Document> waitlist = book.getList("waitlist", Document.class, new ArrayList<>());

        // Status und Kopien initialisieren
        int updatedCopies = copies;
        String newStatus = "available";

        // Verarbeitung der Lending-Liste
        for (Document lending : lendings) {
            String lendingStatus = lending.getString("status");
            if ("borrowed".equalsIgnoreCase(lendingStatus)) {
                updatedCopies--; // Reduziere Kopien, wenn ausgeliehen
            } else if ("returned".equalsIgnoreCase(lendingStatus)) {
                updatedCopies++; // Erhöhe Kopien, wenn zurückgegeben
            }
        }

        // Verarbeitung der Warteliste
        for (Document waitlistEntry : waitlist) {
            String waitlistStatus = waitlistEntry.getString("status");
            if ("waiting".equalsIgnoreCase(waitlistStatus)) {
                updatedCopies--; // Reduziere Kopien, wenn auf Warteliste
            } else if ("returned".equalsIgnoreCase(waitlistStatus)) {
                updatedCopies++; // Erhöhe Kopien, wenn zurückgegeben
            }
        }

        // Sicherstellen, dass die Kopienanzahl nicht negativ ist
        updatedCopies = Math.max(0, updatedCopies);

        // Status basierend auf den aktualisierten Kopien und Listen festlegen
        if (updatedCopies > 0) {
            newStatus = "available";
        } else {
            boolean isBorrowed = lendings.stream().anyMatch(l -> "borrowed".equalsIgnoreCase(l.getString("status")));
            boolean hasWaitlist = waitlist.stream().anyMatch(w -> "waiting".equalsIgnoreCase(w.getString("status")));
            if (isBorrowed) {
                newStatus = "borrowed";
            } else if (hasWaitlist) {
                newStatus = "waiting";
            }
        }

        // MongoDB-Dokument aktualisieren
        bookCollection.updateOne(Filters.eq("bookId", bookId),
                Updates.combine(
                        Updates.set("status", newStatus),
                        Updates.set("copies", updatedCopies)
                ));

        System.out.println("Status für Buch " + bookId + " gesetzt auf '" + newStatus + "', Verfügbare Exemplare: " + updatedCopies);
    }

}
