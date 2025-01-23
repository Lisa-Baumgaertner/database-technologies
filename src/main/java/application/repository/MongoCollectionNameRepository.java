package application.repository;

public class MongoCollectionNameRepository {

    // Konstanten für die Collection-Namen in MongoDB (korrekte Schreibweise)
    public static final String PERSON_COLLECTION = "Person";
    public static final String BOOK_COLLECTION = "Book";
    public static final String KEYWORD_COLLECTION = "Keyword";

    /**
     * Methode zur einheitlichen Formatierung von Collection-Namen.
     * Sie stellt sicher, dass die richtige Groß- und Kleinschreibung verwendet wird.
     *
     * @param collectionName Der Collection-Name (beliebige Schreibweise).
     * @return Der standardisierte Collection-Name mit korrekter Schreibweise.
     */

    public static String getCollectionName(String collectionName) {
        if (collectionName == null || collectionName.trim().isEmpty()) {
            throw new IllegalArgumentException("Collection-Name darf nicht leer sein.");
        }

        switch (collectionName.trim().toLowerCase()) {
            case "person":
                return PERSON_COLLECTION;
            case "book":
                return BOOK_COLLECTION;
            case "keyword":
                return KEYWORD_COLLECTION;
            default:
                throw new IllegalArgumentException("Unbekannte Collection: " + collectionName);
        }
    }
}
