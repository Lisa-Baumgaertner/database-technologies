package application.repository;

import application.model.Lending;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementierung des LendingRepository für MongoDB.
 * Diese Klasse bietet Methoden zum Verwalten von Ausleiheinträgen.
 */
public class MongoLendingRepositoryImpl implements LendingRepository {
    // Verbindung zur MongoDB-Datenbank
    private final MongoDatabase database;

    /**
     * Konstruktor zur Initialisierung der MongoDB-Datenbank.
     * @param database Verbindung zur MongoDB-Datenbank.
     */
    public MongoLendingRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    /**
     * Holt alle Ausleiheinträge aus der Datenbank.
     */
    public List<Lending> getAllLendinglistEntries() {
        List<Lending> lendings = new ArrayList<>();
        MongoCollection<Document> collection = database.getCollection("Person");
        try (MongoCursor<Document> cursor = collection.find().iterator()) {
            while (cursor.hasNext()) {
                Document personDoc = cursor.next();
                List<Document> lendingDocs = personDoc.getList("lendings", Document.class);
                if (lendingDocs != null) {
                    for (Document lendingDoc : lendingDocs) {
                        lendings.add(documentToLending(lendingDoc));
                    }
                }
            }
        }
        return lendings;
    }

    /**
     * Fügt einen neuen Ausleiheintrag hinzu.
     */
    public void addToLending(Long userId, Long workerId, Long bookId, String status, LocalDate checkoutDate) { return;}

    /**
     * Holt alle Ausleiheinträge zu einem bestimmten Buch.
     */
    public List<Lending> getLendingForBook(Long bookId) {return null;}

    /**
     * Holt alle Ausleiheinträge für einen bestimmten Nutzer.
     */
    public List<Lending> getLendingForUser(Long userId) {return null;}

    /**
     * Aktualisiert den Status einer Ausleihe (z. B. von "ausgeliehen" auf "zurückgegeben").
     */
    public  void updateStatus(Long lendingId, String status) {return ;}

    /**
     * Entfernt einen Ausleiheintrag aus der Datenbank.
     */
    public  void removeFromLending(Long lendingId) {return ;}

    /**
     * Holt einen Ausleiheintrag anhand seiner ID.
     */
    public Lending getLendingById(Long lendingId) {return null;}

    /**
     * Aktualisiert das Rückgabedatum einer Ausleihe.
     */
    public  void updateDueDate(Long lendingId, LocalDate newDueDate) {return ;}

    /**
     * Filtert Ausleiheinträge basierend auf einem bestimmten Filterkriterium.
     */
    public List<Lending> getFilteredLendings(String filter) {return null;}

    /**
     * Berechnet, wie oft eine Ausleihe verlängert wurde.
     */
    public int  calculateExtensionCount(Lending lending) {return 0;}

    /**
     * Holt Ausleiheinträge für einen Nutzer basierend auf seinem Namen.
     */
    public List<Lending> getLendingForUserByName(String userName) {return null;}

    /**
     * Filtert Ausleihen basierend auf dem Fälligkeitsdatum.
     */
    public List<Lending> filterByDueDate(){return null;}

    /**
     * Filtert Ausleihen basierend auf der Kategorie.
     */
    public List<Lending> filterByCategory(String category){return null;}

    /**
     * Filtert Ausleihen basierend auf der Verfügbarkeit.
     */
    public List<Lending> filterByAvailability(String availabilityStatus){return null;}

    /**
     * Holt alle Schlüsselwörter Keywords.
     */
    public List<String> getAllKeywords(){return null;}



    private Lending documentToLending(Document doc) {
        Lending lending = new Lending();
        lending.setLendingId(doc.getInteger("lendingId"));
        lending.setBookId(doc.getInteger("lendingId"));
        lending.setUserIdBorrower(doc.getInteger("userId"));
        lending.setBookId(doc.getInteger("bookId"));
        lending.setStatus(doc.getString("status"));
        lending.setCheckoutDate(LocalDate.parse(doc.getString("checkoutDate")));
        lending.setReturnDate(LocalDate.parse(doc.getString("returnDate")));
        lending.setDueDate(LocalDate.parse(doc.getString("dueDate")));
        return lending;
    }

}
