package application.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Diese Klasse implementiert das NotificationRepository-Interface für PostgreSQL.
 * Sie enthält Methoden, um Benachrichtigungen für fällige Rückgaben und verfügbare Bücher zu generieren.
 */
public class PostgresNotificationRepositoryImpl implements NotificationRepository{
    private final Connection connection;

    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     */
    public PostgresNotificationRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    /**
     * Gibt Benachrichtigungen für Bücher zurück, die in Kürze zurückgegeben werden müssen.
     */
    public List<String> getDueDateNotificationsForUser(Long userId) {
        String query = """
                    SELECT p.firstname, p.lastname, b.booktitle, l.due_date
                    FROM lending l
                    JOIN person p ON l.user_id_borrower = p.user_id
                    JOIN book b ON l.book_id = b.book_id
                    WHERE l.status = 'borrowed'
                   AND l.due_date <= CURRENT_DATE + INTERVAL '3 days'
                   AND p.user_id = ?;
                                                         
""";

        List<String> notifications = new ArrayList<>();

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    String notification = "Hallo " + rs.getString("firstname") + " " +
                            rs.getString("lastname") + ", das Buch '" +
                            rs.getString("booktitle") + "' muss bis zum " +
                            rs.getDate("due_date") + " zurückgegeben werden.";
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("notifications" + notifications);
        return notifications;
    }

    /**
     * Gibt Benachrichtigungen für verfügbare Bücher zurück, für die ein Nutzer auf der Warteliste steht.
     */
    public List<String> getAvailableBookNotificationsForUser( Long userId) {
        String query = """
        SELECT p.firstname, p.lastname, b.booktitle
        FROM waitlist w
        JOIN person p ON w.user_id = p.user_id
        JOIN book b ON w.book_id = b.book_id
        WHERE p.user_id = ?
        AND (b.status = 'available' OR b.copies > 0);
    """;

        List<String> notifications = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    String notification = "Hallo " + rs.getString("firstname") + " " +
                            rs.getString("lastname") + ", das Buch '" +
                            rs.getString("booktitle") + "' ist jetzt verfügbar.";
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }
}
