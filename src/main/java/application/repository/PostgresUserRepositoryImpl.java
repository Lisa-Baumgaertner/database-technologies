package application.repository;

import application.model.Person;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 * Diese Klasse bietet Methode zum Zugriff auf die Person-Tabelle
 * Sie implementiert das Interface `UserRepository` für PostgreSQL.
 */

public class PostgresUserRepositoryImpl implements UserRepository {

    private final Connection connection;

    /**
     * Konstruktor zur Initialisierung der Verbindung.
     */
    public PostgresUserRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    /**
     * Lädt den ersten Benutzer mit der Rolle 'borrower' aus der Datenbank.
     * @return Ein `Person`-Objekt oder `null`, falls kein Nutzer gefunden wurde.
     */
    public Person getFirstBorrower(){
        String query = """
        SELECT * FROM person WHERE LOWER(role) = 'borrower'
       ORDER BY user_id ASC LIMIT 1;
       """;

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                System.out.println("Benutzer gefunden: " + rs.getString("firstname") + " " + rs.getString("lastname"));
                return mapToPerson(rs);
            }
        } catch (SQLException e) {
            System.err.println("Fehler beim Laden des ersten Borrowers: " + e.getMessage());
        }
        System.out.println("Kein Benutzer mit der Rolle 'borrower' gefunden.");
        return null; // Kein Benutzer gefunden oder Fehler aufgetreten
    }

    /**
     * Hilfsmethode zur Konvertierung eines ResultSets in ein `Person`-Objekt.
     */
    private Person mapToPerson(ResultSet rs) throws SQLException {
        int userId = rs.getInt("user_id");
        String firstName = rs.getString("firstname");
        String lastName = rs.getString("lastname");
        LocalDate birthDate = rs.getDate("birthdate") != null ? rs.getDate("birthdate").toLocalDate() : null;
        char gender = rs.getString("gender").charAt(0);
        String role = rs.getString("role");

        return new Person(userId, firstName, lastName, birthDate, gender, role);
    }
}
