package application.repository;

import application.model.Contact;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * Implementierung des ContactRepository für PostreSQL.
 */
public class PostgresContactRepositoryImpl implements ContactRepository {

    private final Connection connection;

    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     *
     * @param connection Die PostgreSQL-Datenbankverbindung.
     */
    public PostgresContactRepositoryImpl(Connection connection) {
        this.connection = connection;
    }


    /**
     * Sucht den Kontakt anhand der User-ID.
     *
     * @param userId Die ID des Benutzers.
     * @return Das zugehörige Contact-Objekt oder null, wenn nicht gefunden.
     */
    @Override
    public Contact getContactByUserId(long userId) {
        String sql = "SELECT * FROM CONTACT WHERE USER_ID = ? LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Contact(
                        rs.getLong("contact_id"),
                        rs.getLong("user_id"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("mobile")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * Fügt einen neuen Kontakt in die Datenbank ein.
     *
     * @param contact Das Contact-Objekt, das eingefügt werden soll.
     * @return Das eingefügte Contact-Objekt.
     */
    public Contact insertContact(Contact contact) {
        String query = "INSERT INTO Contact (user_id, email, phone, mobile) VALUES (?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setLong(1, contact.getUserId());
            preparedStatement.setString(2, contact.getEmail());
            preparedStatement.setString(3, contact.getPhone());
            preparedStatement.setString(4, contact.getMobile());
            int rowsInserted = preparedStatement.executeUpdate();

            if (rowsInserted > 0) {
                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int contactId = generatedKeys.getInt(1);  // Automatisch generierte ID abrufen
                        contact.setContactId(contactId);  // In das Objekt setzen
                        return contact;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Fehler beim Einfügen der Adresse: " + e.getMessage());
        }
        return null;
    }

}
