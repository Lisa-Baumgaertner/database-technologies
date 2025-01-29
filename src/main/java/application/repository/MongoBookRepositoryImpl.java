package application.repository;

import static com.mongodb.client.model.Filters.eq;

import application.model.*;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementierung des BookRepository für MongoDB.
 * Diese Klasse bietet Methoden zum Abrufen, Einfügen, Aktualisieren und Löschen von Büchern in der MongoDB-Datenbank.
 */
public class MongoBookRepositoryImpl implements BookRepository {
    private final MongoCollection<Document> bookCollection;
    private final MongoCollection<Document> keywordCollection;

    /**
     * Konstruktor zur Initialisierung der MongoDB-Collection.
     */
    public MongoBookRepositoryImpl(MongoDatabase mongoDatabase) {
        this.bookCollection = mongoDatabase.getCollection(MongoCollectionNameRepository.getCollectionName("Book")); // Verwende die Collection "book"
        this.keywordCollection = mongoDatabase.getCollection(MongoCollectionNameRepository.getCollectionName("Keyword")); // Verwende die Collection "keyword"
    }

    /**
     * Holt alle Bücher aus der MongoDB-Collection.
     */
    @Override
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        try (MongoCursor<Document> cursor = this.bookCollection.find().iterator()) {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                books.add(mapDocumentToBook(doc));
            }
        } catch (Exception e) {
            System.out.println("Fehler beim Abrufen der Bücher: " + e.getMessage());
        }
        return books;
    }

    /**
     * Sucht Bücher anhand der Titel, Autoren, ISBN und Status.
     */

    @Override
    public List<Book> searchBooks(String title, String author, String isbn, String status) {
        List<Book> books = new ArrayList<>();
        List<Bson> filters = new ArrayList<>();

        // Filter für Titel
        if (title != null && !title.isEmpty()) {
            filters.add(Filters.regex("metadata.title", ".*" + title + ".*", "i")); // Teilwortsuche für Titel
        }

        // Filter für Autor
        if (author != null && !author.isEmpty()) {
            filters.add(Filters.regex("metadata.author", ".*" + author + ".*", "i")); // Teilwortsuche für Autor
        }

        // Filter für ISBN
        if (isbn != null && !isbn.isEmpty()) {
            filters.add(Filters.or(
                    Filters.eq("isbn.long", isbn),
                    Filters.eq("isbn.short", isbn)
            ));
        }

        // Filter für Status, wenn gesetzt
        if (status != null && !status.isEmpty()) {
            filters.add(Filters.eq("status", status));
        }

        // Kombiniere alle Filter
        Bson query = filters.isEmpty() ? new Document() : Filters.and(filters);
        try (MongoCursor<Document> cursor = this.bookCollection.find(query).iterator()) {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                books.add(mapDocumentToBook(doc));
            }
        } catch (Exception e) {
            System.err.println("Fehler bei der Suche in MongoDB: " + e.getMessage());
        }
        return books;
    }

    /**
     * Findet ein Buch anhand seiner ID.
     */
    @Override
    public Book findBookById(Long id) {
        // Buch mit der gegebenen ID in der MongoDB-Collection suchen
        Document bookDoc = bookCollection.find(Filters.eq("bookId", id)).first();
        if (bookDoc == null) {
            System.out.println("Kein Buch mit der ID " + id + " gefunden.");
            return null;
        }
        // Dokument in ein Book-Objekt umwandeln
        return mapDocumentToBook(bookDoc);
    }

    /**
     * Findet ein Buch anhand seiner ISBN (entweder 13-stellig oder 10-stellig).
     */
    @Override
    public Book findBookByIsbn(String isbnLong, String isbnShort) {
        // Filter für die Suche mit ISBN-13 oder ISBN-10
        Bson query = Filters.or(
                Filters.eq("isbn.long", isbnLong),
                Filters.eq("isbn.short", isbnShort)
        );

        // Docu suchen
        Document bookDoc = bookCollection.find(query).first();
        if (bookDoc == null) {
            System.out.println("Kein Buch mit ISBN " + isbnLong + " oder " + isbnShort + " gefunden.");
            return null;
        }

        // Dokument in ein Book-Objekt umwandeln
        return mapDocumentToBook(bookDoc);
    }

    /**
     * Findet ein Buch Titel anhand Id.
     */
    @Override
    public String getBookTitleById(int bookId) {
        Document query = new Document("bookId", bookId);
        Document result = bookCollection.find(query).first();

        if (result != null) {
            Document metadata = (Document) result.get("metadata");
            if (metadata != null) {
                return metadata.getString("title");
            }
        }
        return null;
    }

    /**
     * Holt Keywords ein Buch Titel anhand Id.
     */
    @Override
    public String getCategoryByBookId(int bookId) {
        // Buch anhand der bookId suchen
        Document book = bookCollection.find(eq("bookId", bookId)).first();

        if (book != null && book.containsKey("keywords")) {
            List<Document> keywords = (List<Document>) book.get("keywords");

            // Extrahiere die keywordId aus dem Buch-Dokument
            List<Integer> keywordIds = keywords.stream()
                    .map(k -> k.getInteger("keywordId"))
                    .collect(Collectors.toList());

            // Hole die tatsächlichen Kategorienamen aus der Keyword-Sammlung
            List<String> categories = keywordCollection.find(
                            eq("keyword_id", new Document("$in", keywordIds))
                    )
                    .map(doc -> doc.getString("keyword"))
                    .into(new java.util.ArrayList<>());

            // Falls keine Kategorien vorhanden sind, leere Zeichenkette zurückgeben
            if (categories.isEmpty()) {
                return "";
            }
            // Kategorien als durch Komma getrennte Zeichenkette formatieren
            return categories.stream()
                    .filter(s -> s != null && !s.isEmpty())  // Entferne null oder leere Werte
                    .collect(Collectors.joining(", "));
        }

        return "";  // Rückgabe eines leeren Strings, falls keine Kategorien gefunden wurden
    }

    /**
     * Fügt ein neues Buch in die MongoDB-Collection ein.
     */
    @Override
    public void insertBook(Book book) {
        int newBookId = getNextBookId();
        book.setBookId(newBookId);
        Document bookDoc = mapBookToDocumentForInsert(book);
        bookCollection.insertOne(bookDoc);
    }

    @Override
    public void insertBookKeyword(Long bookId, int keywordId) {
    // Just for SQl
    }
    /**
     * Aktualisiert ein vorhandenes Buch in der MongoDB-Collection.
     */
    @Override
    public void updateBook(Book book) {
        System.out.println("Starte Aktualisierung für Buch mit ID: " + book.getBookId());

        // Prüfen, ob das Buch existiert
        Document existingBookDoc = bookCollection.find(Filters.eq("bookId", book.getBookId())).first();

        if (existingBookDoc == null) {
            System.out.println("Fehler: Buch mit der ID " + book.getBookId() + " wurde nicht gefunden.");
            return;
        }

        // Neues aktualisiertes Dokument erstellen
        Document updatedDocument = mapBookToDocumentForUpdate(book);
        if (updatedDocument == null) {
            System.out.println("Fehler: Das Buch konnte nicht aktualisiert werden.");
            return;
        }

        // Buch in MongoDB aktualisieren
        try {
            UpdateResult result = bookCollection.updateOne(
                    Filters.eq("bookId", book.getBookId()),
                    new Document("$set", updatedDocument)
            );

            if (result.getMatchedCount() > 0) {
                System.out.println("Buch erfolgreich aktualisiert: " + book.getBookId());
            } else {
                System.out.println("Keine Übereinstimmung gefunden für Buch-ID: " + book.getBookId());
            }

        } catch (Exception e) {
            System.err.println("Fehler bei der Aktualisierung des Buches: " + e.getMessage());
        }
    }


    /**
     * Löscht ein Buch anhand seiner ID aus der MongoDB-Collection.
     */
    @Override
    public void deleteBookById(Long bookId) {
        try {
            // Suche das Buch anhand der bookId
            Bson filter = Filters.eq("bookId", bookId);
            Document bookDoc = bookCollection.find(filter).first();

            if (bookDoc != null) {
                // Extrahiere die keywordId(s) aus dem Buch-Dokument
                List<Document> keywords = (List<Document>) bookDoc.get("keywords");
                List<Integer> keywordIds = new ArrayList<>();

                if (keywords != null) {
                    for (Document keywordDoc : keywords) {
                        keywordIds.add(keywordDoc.getInteger("keywordId"));
                    }
                }

                // Lösche das Buch aus der Buch-Collection
                bookCollection.deleteOne(filter);
                System.out.println("Buch mit der ID " + bookId + " wurde erfolgreich gelöscht.");

                // Überprüfen, ob Keywords noch von anderen Büchern verwendet werden
                for (Integer keywordId : keywordIds) {
                    Bson keywordFilter = Filters.elemMatch("keywords", Filters.eq("keywordId", keywordId));
                    long count = bookCollection.countDocuments(keywordFilter);

                    if (count == 0) {
                        // Lösche das Keyword, wenn es nicht mehr verwendet wird
                        keywordCollection.deleteOne(Filters.eq("keyword_id", keywordId));
                        System.out.println("Keyword mit ID " + keywordId + " wurde gelöscht.");
                    } else {
                        System.out.println("Keyword mit ID " + keywordId + " wird noch verwendet und bleibt erhalten.");
                    }
                }
            } else {
                System.out.println("Kein Buch mit der ID " + bookId + " gefunden.");
            }
        } catch (Exception e) {
            System.err.println("Fehler beim Löschen des Buches mit der ID " + bookId + ": " + e.getMessage());
        }
    }

    /**
     * Diese Methode ermittelt die nächste eindeutige `bookId`, indem sie nach dem höchsten
     * aktuellen Wert in der `Book`-Collection sucht und diesen um 1 erhöht.
     * Der Zweck ist, sicherzustellen, dass jede neue Book eine eindeutige `bookId` erhält,
     * auch wenn Einträge in der Datenbank gelöscht wurden.
     *
     */
    public int getNextBookId() {
        Document maxUserIdDoc = bookCollection.find()
                .sort(new Document("bookId", -1))  // Absteigend sortieren
                .limit(1)
                .first();
        int maxUserId = (maxUserIdDoc != null && maxUserIdDoc.containsKey("bookId")) ?
                maxUserIdDoc.getInteger("bookId") : 0;  // Überprüfen, ob _id vorhanden ist
        return maxUserId + 1;
    }


    /**
     * Hilfsmethode: Mappt ein MongoDB-Dokument zu einem Book-Objekt.
     */
    private Book mapDocumentToBook(Document doc) {
        // Metadata extrahieren
        Document metadata = doc.get("metadata", Document.class);
        String title = metadata != null ? metadata.getString("title") : "Unknown";
        String author = metadata != null ? metadata.getString("author") : "Unknown";
        String publisher = metadata != null ? metadata.getString("publisher") : "Unknown";
        String description = metadata != null ? metadata.getString("description") : "No Description";

        int yearPublished = metadata != null && metadata.containsKey("yearPublished")
                ? metadata.getInteger("yearPublished") // Direkte Extraktion als Integer
                : 0;

        // ISBN extrahieren
        Document isbnDoc = doc.get("isbn", Document.class);
        String isbnLong = isbnDoc != null ? isbnDoc.getString("long") : "Unknown";
        String isbnShort = isbnDoc != null ? isbnDoc.getString("short") : "Unknown";

        // Keywords extrahieren
        List<Document> keywordDocs = doc.getList("keywords", Document.class);
        List<Keyword> keywords = new ArrayList<>();
        if (keywordDocs != null) {
            for (Document keywordDoc : keywordDocs) {
                Integer keywordId = keywordDoc.getInteger("keywordId");
                if (keywordId != null) {
                    keywords.add(new Keyword(keywordId, null)); // Keyword-Name ist hier nicht verfügbar
                }
            }
        }

        // Status aus dem Buch-Dokument lesen
        String status = doc.getString("status");


        // Konvertierung des Status-Strings in das Enum
        Status.BookStatus bookStatus = status != null
                ? Status.BookStatus.fromString(status)
                : Status.BookStatus.AVAILABLE;

        // Buch-ID, Kopien und KeywordId
        Integer bookId = doc.getInteger("bookId");
        Integer copies = doc.getInteger("copies");
        Integer mainKeywordId = !keywords.isEmpty() ? keywords.get(0).getKeywordId() : null; // Nimm die erste Keyword-ID als Haupt-Keyword

        // Book-Objekt erstellen
        return new Book(
                bookId,             // Buch-ID
                isbnLong,           // ISBN-13
                isbnShort,          // ISBN-10
                copies,             // Anzahl der Kopien
                title,              // Titel
                author,             // Autor
                publisher,          // Verlag
                yearPublished,      // Jahr der Veröffentlichung
                description,        // Beschreibung
                bookStatus,        // Status
                mainKeywordId,      // Haupt-Keyword-ID
                keywords            // Liste der Keywords
        );
    }



    /**
     * Hilfsmethode: Mappt ein Book-Objekt zu einem MongoDB-Dokument.
     */
    private Document mapBookToDocumentForInsert(Book book) {
        Document metadata = new Document()
                .append("title", book.getTitle())
                .append("author", book.getAuthor())
                .append("publisher", book.getPublisher())
                .append("yearPublished", book.getYearPublished())
                .append("description", book.getDescription());

        Document isbn = new Document()
                .append("isbn_long", book.getIsbnLong() != null ? book.getIsbnLong() : "")
                .append("isbn_short", book.getIsbnShort() != null ? book.getIsbnShort() : "");

        List<Document> keywordDocs = new ArrayList<>();
        for (Keyword keyword : book.getKeywords()) {
            int keywordId = getOrInsertKeyword(keyword.getKeyword());
            keyword.setKeywordId(keywordId);
            keywordDocs.add(new Document("keywordId", keywordId));
        }
        // Status automatisch setzen basierend auf der Anzahl der Exemplare
        String status;
        if (book.getCopies() > 0) {
            status = "available"; // Wenn Kopien vorhanden sind, ist das Buch verfügbar
        } else {
            status = "borrowed";
        }

        return new Document()
                .append("bookId", (int) book.getBookId())
                .append("isbn", isbn)
                .append("copies", book.getCopies())
                .append("metadata", metadata)
                .append("keywords", keywordDocs)
                .append("reviews", new ArrayList<>()) // Leere Reviewsliste
                .append("lendings", new ArrayList<>()) // Leere Lendingsliste
                .append("waitlist", new ArrayList<>()) // Leere Warteliste
                .append("status", status);
    }

    /**
     * Hilfsmethode: Mappt ein Book-Objekt zu einem MongoDB-Dokument.
     */
    private Document mapBookToDocumentForUpdate(Book book) {
        // Das vorhandene Buchdokument anhand der bookId aus der MongoDB abrufen
        Document existingBookDoc = bookCollection.find(Filters.eq("bookId", book.getBookId())).first();

        if (existingBookDoc == null) {
            System.out.println("Kein Buch mit der ID " + book.getBookId() + " gefunden.");
            return null;
        }

        // ISBN-Objekt extrahieren und aktualisieren
        Document isbn = existingBookDoc.get("isbn", Document.class);
        if (isbn == null) {
            isbn = new Document();
        }
        isbn.put("long", book.getIsbnLong() != null ? book.getIsbnLong() : isbn.getString("long"));
        isbn.put("short", book.getIsbnShort() != null ? book.getIsbnShort() : isbn.getString("short"));

        // Copies extrahieren oder aktualisieren
        int copies = book.getCopies() != null ? book.getCopies() : existingBookDoc.getInteger("copies", 0);

        // Metadata-Objekt extrahieren und aktualisieren
        Document metadata = existingBookDoc.get("metadata", Document.class);
        if (metadata == null) {
            metadata = new Document();
        }
        metadata.put("title", book.getTitle() != null ? book.getTitle() : metadata.getString("title"));
        metadata.put("author", book.getAuthor() != null ? book.getAuthor() : metadata.getString("author"));
        metadata.put("publisher", book.getPublisher() != null ? book.getPublisher() : metadata.getString("publisher"));
        metadata.put("description", book.getDescription() != null ? book.getDescription() : metadata.getString("description"));
        metadata.put("yearPublished", book.getYearPublished() != null ? book.getYearPublished() : metadata.getString("yearPublished"));

        // Keywords aktualisieren
        List<Document> keywordDocs = new ArrayList<>();
        if (book.getKeywords() != null) {
            for (Keyword keyword : book.getKeywords()) {
                keywordDocs.add(new Document("keywordId", keyword.getKeywordId()));
            }
        } else {
            keywordDocs = existingBookDoc.getList("keywords", Document.class, new ArrayList<>());
        }

        // Reviews aus dem bestehenden Dokument extrahieren
        List<Document> reviewDocs = new ArrayList<>();
        if (existingBookDoc.containsKey("reviews")) {
            List<Document> existingReviews = existingBookDoc.getList("reviews", Document.class);
            for (Document reviewDoc : existingReviews) {
                reviewDocs.add(new Document()
                        .append("reviewId", reviewDoc.getInteger("reviewId"))
                        .append("borrowerId", reviewDoc.getInteger("borrowerId"))
                        .append("text", reviewDoc.getString("text") != null ? reviewDoc.getString("text") : "")
                        .append("date", reviewDoc.getString("date") != null ? reviewDoc.getString("date") : "")
                        .append("rating", reviewDoc.getInteger("rating"))
                );
            }
        }

        // Lendings aus dem bestehenden Dokument extrahieren
        List<Document> lendingDocs = new ArrayList<>();
        if (existingBookDoc.containsKey("lendings")) {
            List<Document> existingLendings = existingBookDoc.getList("lendings", Document.class);
            for (Document lendingDoc : existingLendings) {
                lendingDocs.add(new Document()
                        .append("lendingId", lendingDoc.getInteger("lendingId"))
                        .append("borrowerId", lendingDoc.getInteger("borrowerId"))
                        .append("workerId", lendingDoc.getInteger("workerId"))
                        .append("status", lendingDoc.getString("status"))
                        .append("checkoutDate", lendingDoc.getString("checkoutDate"))
                        .append("dueDate", lendingDoc.getString("dueDate"))
                        .append("returnDate", lendingDoc.getString("returnDate"))
                );
            }
        }

        // Waitlist extrahieren
        List<Document> waitlistDocs = new ArrayList<>();
        if (existingBookDoc.containsKey("waitlist")) {
            List<Document> existingWaitlist = existingBookDoc.getList("waitlist", Document.class);
            for (Document waitlistDoc : existingWaitlist) {
                waitlistDocs.add(new Document()
                        .append("waitlistId", waitlistDoc.getInteger("waitlistId"))
                        .append("borrowerId", waitlistDoc.getInteger("borrowerId"))
                        .append("checkoutDate", waitlistDoc.getString("checkoutDate"))
                        .append("status", waitlistDoc.getString("status"))
                        .append("returnDate", waitlistDoc.getString("returnDate"))
                );
            }
        }

        // Anzahl der verfügbaren Kopien berechnen
        int currentCopies = existingBookDoc.getInteger("copies", 0);

        // Reduziere copies, wenn ein neues Lending oder eine neue Warteliste hinzugefügt wird
        boolean bookBorrowed = false;
        boolean bookInWaitlist = false;

        for (Document lending : lendingDocs) {
            String lendingStatus = lending.getString("status");
            if ("borrowed".equalsIgnoreCase(lendingStatus)) {
                bookBorrowed = true;
            }
        }

        for (Document waitlist : waitlistDocs) {
            String waitlistStatus = waitlist.getString("status");
            if ("waiting".equalsIgnoreCase(waitlistStatus)) {
                bookInWaitlist = true;
            }
        }

        if (bookBorrowed || bookInWaitlist) {
            currentCopies = Math.max(0, currentCopies - 1); // **Verhindere negative Werte**
        } else {
            currentCopies = Math.min(book.getCopies(), currentCopies + 1); // Falls zurückgegeben, Kopien erhöhen
        }

        String status;
        if (bookBorrowed) {
            status = "borrowed";
        } else if (bookInWaitlist) {
            status = "waiting";
        } else {
            status = currentCopies > 0 ? "available" : "waiting";
        }

        // Aktualisiertes Buchdokument zurückgeben
        return new Document()
                .append("bookId", book.getBookId())
                .append("isbn", isbn)
                .append("copies", copies)
                .append("metadata", metadata)
                .append("keywords", keywordDocs)
                .append("reviews", reviewDocs)
                .append("lendings", lendingDocs)
                .append("waitlist", waitlistDocs)
                .append("status", status);
    }




    /**
     * Fügt ein neues Keyword ein oder gibt die ID zurück, falls es bereits existiert.
     * @param keywordName Der Name des Keywords, das eingefügt oder gefunden werden soll.
     * @return Die ID des Keywords.
     */
    private int getOrInsertKeyword(String keywordName) {
        Document existingKeyword = keywordCollection.find(eq("keyword", keywordName)).first();

        if (existingKeyword != null) {
            System.out.println("Keyword bereits vorhanden: " + keywordName);
            return existingKeyword.getInteger("keyword_id");
        }

        int newKeywordId = generateNewKeywordId();
        Document newKeyword = new Document("keyword_id", newKeywordId)
                .append("keyword", keywordName);

        keywordCollection.insertOne(newKeyword);
        System.out.println("Neues Keyword hinzugefügt: " + newKeywordId + " - " + keywordName);
        return newKeywordId;
    }


    /**
     * Generiert eine neue eindeutige Keyword-ID, indem das höchste vorhandene Keyword gesucht wird.
     * @return Die nächste freie Keyword-ID.
     */
    private int generateNewKeywordId() {
        Document lastKeyword = keywordCollection.find().sort(new Document("keyword_id", -1)).first();
        int newId = (lastKeyword != null) ? lastKeyword.getInteger("keyword_id") + 1 : 1;
        System.out.println("Generated new keyword_id: " + newId);
        return newId;
    }
}