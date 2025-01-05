package application.repository;
import com.mongodb.client.MongoDatabase;
import java.util.List;

/**
 * Implementierung des NotificationRepository für MongoDB.
 */
public class MongoNotificationRepositoryImpl implements NotificationRepository {

    // Verbindung zur MongoDB-Datenbank
    private final MongoDatabase database;

    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
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
        return null;
    }


    /**
     * Holt Benachrichtigungen über verfügbare Bücher für einen Nutzer.
     * Diese Benachrichtigung informiert den Nutzer, wenn ein Buch, das er reserviert hat, verfügbar ist.
     */
    @Override
    public List<String> getAvailableBookNotificationsForUser(Long userId) {
       return null;
    }
}
