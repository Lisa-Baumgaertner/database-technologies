package application.repository;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementierung des NotificationRepository für MongoDB.
 */
public class MongoNotificationRepositoryImpl implements NotificationRepository {

    // Verbindung zur MongoDB-Datenbank
    private final MongoDatabase database;

    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     *
     * @param database Verbindung zur MongoDB-Datenbank.
     */
    public MongoNotificationRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    /**
     * Holt Benachrichtigungen für ein fälliges Rückgabedatum eines Nutzers.
     * Diese Benachrichtigung informiert den Nutzer, wenn Bücher bald zurückgegeben werden müssen.
     */
    @Override
    public List<String> getDueDateNotificationsForUser(Long userId) {
        MongoCollection<Document> personCollection = database.getCollection(MongoCollectionNameRepository.getCollectionName("Person"));   // Collection-Name
        List<String> notifications = new ArrayList<>();
        Document userDoc = personCollection.find(new Document("userId", userId)).first();  // Abfrage nach userId
        if (userDoc != null) {
            String firstName = userDoc.get("personalDetails", Document.class).getString("firstName");
            String lastName = userDoc.get("personalDetails", Document.class).getString("lastName");
            List<Document> lendings = (List<Document>) userDoc.get("lendings");


            if (lendings != null) {
                LocalDate currentDate = LocalDate.now();
                LocalDate dateLimit = currentDate.plusDays(3);  // Fälligkeitsdatum in 3 Tagen

                for (Document lending : lendings) {
                    String dueDateString = lending.getString("dueDate");
                    LocalDate dueDate = LocalDate.parse(dueDateString, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
                    String status = lending.getString("status");

                    if ("borrowed".equals(status) && !dueDate.isAfter(dateLimit)) {
                        String bookTitle = getBookTitleById(lending.getInteger("bookId"));  // Methode für Buch-Details
                        String notification = "Hallo " + firstName + " " + lastName + ", das Buch '" +
                                bookTitle + "' muss bis zum " + dueDate + " zurückgegeben werden.";
                        System.out.println("notification" + notification);
                        notifications.add(notification);
                    }
                }
            }
        }

        return notifications;
    }

    private String getBookTitleById(int bookId) {
        MongoCollection<Document> bookCollection = database.getCollection("Book");// Collection "Book"
        Document bookDocument = bookCollection.find(new Document("bookId", bookId)).first();  // Holt das erste passende Dokument

        if (bookDocument != null) {
            // Hole das `metadata`-Feld als verschachteltes Dokument
            Document metadata = bookDocument.get("metadata", Document.class);
            if (metadata != null) {
                return metadata.getString("title");  // Titel des Buches aus `metadata` holen
            }
        }
        return "Buchtitel nicht gefunden";
    }

    /**
     * Holt Benachrichtigungen über verfügbare Bücher für einen Nutzer.
     * Diese Benachrichtigung informiert den Nutzer, wenn ein Buch, das er reserviert hat, verfügbar ist.
     */
    @Override
    public List<String> getAvailableBookNotificationsForUser(Long userId) {
        List<String> notifications = new ArrayList<>();
        MongoCollection<Document> bookCollection = database.getCollection("Book");

        // Suche nach Büchern, in denen der Nutzer auf der Warteliste steht
        FindIterable<Document> booksWithWaitlist = bookCollection.find(new Document("waitlist.borrowerId", userId));
        for (Document bookDoc : booksWithWaitlist) {
            Integer bookId = bookDoc.getInteger("bookId");
            if (bookId == null) continue;  // Sicherheit gegen Null-Werte

            Integer totalCopies = bookDoc.getInteger("copies", 0);
            if (totalCopies == 0) continue;  // Falls keine Exemplare existieren

            // Prüfe die Anzahl der ausgeliehenen Exemplare
            List<Document> lendings = bookDoc.getList("lendings", Document.class);
            long borrowedCount = (lendings != null) ? lendings.stream()
                    .filter(l -> "borrowed".equalsIgnoreCase(l.getString("status"))).count() : 0;

            // Wenn noch Exemplare verfügbar sind, soll der Nutzer benachrichtigt werden
            if (borrowedCount < totalCopies) {
                String bookTitle = "";
                Document metadata = bookDoc.get("metadata", Document.class);
                if (metadata != null) {
                    bookTitle = metadata.getString("title");
                }

                String notification = "Das Buch '" + bookTitle + "' ist jetzt verfügbar!";
                notifications.add(notification);
            }
        }

        return notifications;

    }

}
