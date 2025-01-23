package application.repository;

import application.model.Keyword;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

/**
 * Implementierung des KeywordRepository für MongoDB.
 * Diese Klasse bietet Funktionen zum Abrufen von Keywords aus der MongoDB-Datenbank.
 */
public class MongoKeywordRepositoryImpl implements KeywordRepository {

    private final MongoCollection<Document> keywordCollection;
    private final MongoCollection<Document> bookCollection;

    /**
     * Konstruktor zur Initialisierung der "Keyword"-Sammlung.
     */
    public MongoKeywordRepositoryImpl(MongoDatabase database) {
        this.keywordCollection = database.getCollection(MongoCollectionNameRepository.getCollectionName("Keyword"));
        this.bookCollection = database.getCollection(MongoCollectionNameRepository.getCollectionName("Book"));
    }

    /**
     * Ruft alle Keywords ab, die einem Buch anhand der Buch-ID zugeordnet sind.
     *
     * @param bookId Die ID des Buches, für das die Keywords abgerufen werden sollen.
     * @return Eine Liste von Keywords, die dem Buch zugeordnet sind.
     */
    @Override
    public List<Keyword> getKeywordsForBook(long bookId) {
        List<Keyword> keywords = new ArrayList<>();
        try {
            // Buch mit der entsprechenden bookId abrufen
            Document bookDoc = bookCollection.find(Filters.eq("bookId", bookId)).first();
            if (bookDoc != null) {
                // Keywords-Array aus dem Buch-Dokument extrahieren
                List<Document> keywordDocs = bookDoc.getList("keywords", Document.class);

                if (keywordDocs != null) {
                    for (Document keywordDoc : keywordDocs) {
                        Integer keywordId = keywordDoc.getInteger("keywordId");

                        // Keyword aus der Keywords-Collection abrufen
                        Document keywordEntry = keywordCollection.find(Filters.eq("keyword_id", keywordId)).first();

                        if (keywordEntry != null) {
                            String keywordName = keywordEntry.getString("keyword");

                            // Keyword zur Liste hinzufügen
                            if (keywordId != null && keywordName != null) {
                                keywords.add(new Keyword(keywordId, keywordName));
                            }
                        }
                    }
                }
            } else {
                System.out.println("Kein Buch mit der ID " + bookId + " gefunden.");
            }
        } catch (Exception e) {
            System.err.println("Fehler beim Abrufen der Keywords für Buch-ID " + bookId + ": " + e.getMessage());
        }

        return keywords;
    }

    @Override
    public int getKeywordIdByName(String keywordName) {

        return 0;
    }

    @Override
    public int insertKeyword(String keywordName) {

        return 0;
    }
}
