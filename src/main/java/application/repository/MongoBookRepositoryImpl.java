package application.repository;

import static com.mongodb.client.model.Filters.eq;
import application.model.Book;
import application.model.Keyword;
import application.model.Status;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
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
        if (status != null && !status.equalsIgnoreCase("Alle") && !status.isEmpty()) {
            filters.add(Filters.elemMatch("waitlist", Filters.eq("status", status)));
        } else {
            // Kein spezifischer Statusfilter: Alle Bücher anzeigen
            System.out.println("Kein spezifischer Statusfilter. Alle Bücher mit ihrem gespeicherten Status anzeigen.");
            // Kein Filter für die Warteliste anwenden, um alle gespeicherten Status zurückzugeben.
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
        return null;
    }

    /**
     * Findet ein Buch anhand seiner ISBN (entweder 13-stellig oder 10-stellig).
     */
    @Override
    public Book findBookByIsbn(String isbnLong, String isbnShort) {
        return null;
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
        Document bookDoc = mapBookToDocument(book);

        System.out.println("Einfügen des Buches mit ID: " + newBookId);
        System.out.println("Einzufügendes Dokument: " + bookDoc.toJson());

        bookCollection.insertOne(bookDoc);
    }

    @Override
    public void insertBookKeyword(Long bookId, int keywordId) {

    }
    /**
     * Aktualisiert ein vorhandenes Buch in der MongoDB-Collection.
     */
    @Override
    public void updateBook(Book book) {
    }

    /**
     * Löscht ein Buch anhand seiner ID aus der MongoDB-Collection.
     */
    @Override
    public void deleteBookById(Long id) {
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
        int yearPublished = metadata != null && metadata.getString("yearPublished") != null
                ? Integer.parseInt(metadata.getString("yearPublished").split("-")[0])
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

        // Status aus der Warteliste extrahieren
        List<Document> waitlist = doc.getList("waitlist", Document.class);
        String finalStatus = null;

        if (waitlist != null && !waitlist.isEmpty()) {
            for (Document entry : waitlist) {
                String entryStatus = entry.getString("status");
                if (entryStatus != null) {
                    finalStatus = entryStatus;
                    break;
                }
            }
        }
        // Konvertierung des Status-Strings in das Enum
        Status.BookStatus bookStatus = (finalStatus != null)
                ? Status.BookStatus.fromString(finalStatus)
                : Status.BookStatus.AVAILABLE; // Fallback zu einem Standardwert

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
    private Document mapBookToDocument(Book book) {
        System.out.println("mapBookToDocument => " + book.getKeywords());
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


        return new Document()
                .append("bookId", (int) book.getBookId())
                .append("isbn", isbn)
                .append("copies", book.getCopies())
                .append("metadata", metadata)
                .append("keywords", keywordDocs)
                .append("reviews", new ArrayList<>()) // Leere Reviewsliste
                .append("lendings", new ArrayList<>()) // Leere Lendingsliste
                .append("waitlist", new ArrayList<>()); // Leere Warteliste
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