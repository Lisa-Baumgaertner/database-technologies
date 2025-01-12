package application.repository;
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
        MongoCollection<Document> personCollection = database.getCollection("Person");   // Collection-Name
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
        MongoCollection<Document> personCollection = database.getCollection("Person");  // Collection "Person"

        // Document bookDocument = bookCollection.find(new Document("bookId", bookId)).first();

        Document userDoc = personCollection.find(new Document("userId", userId)).first();
        if (userDoc == null) {
            System.out.println("Nutzer nicht gefunden!");
            return notifications;
        }

        List<Document> waitlist = (List<Document>) userDoc.get("waitlist");
        if (waitlist == null || waitlist.isEmpty()) {
            System.out.println("Nutzer hat keine Bücher auf der Warteliste.");
            return notifications;
        }

        // Überprüfe, ob die Bücher auf der Warteliste verfügbar sind

        for (Document waitlistEntry : waitlist) {
            int bookId = waitlistEntry.getInteger("bookId");
            Document bookDoc = bookCollection.find(new Document("bookId", bookId)).first();

            if (bookDoc != null) {
                int totalCopies = bookDoc.getInteger("copies");
                List<Document> lendings = (List<Document>) bookDoc.get("lendings");

                long borrowedCount = lendings.stream().filter(l -> l.getString("status").equals("borrowed")).count();
                if (borrowedCount < totalCopies) {
                    // Benachrichtigung erstellen, wenn das Buch verfügbar ist
                    String bookTitle = ((Document) bookDoc.get("metadata")).getString("title");
                    String notification = "Das Buch '" + bookTitle + "' ist jetzt verfügbar!";
                    notifications.add(notification);
                }
            }
        }

            return notifications;

    }

}
