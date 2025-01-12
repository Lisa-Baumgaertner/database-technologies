package application.repository;

import application.model.Book;
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

    public  String getUserNameById(int userId) {
        String query = "SELECT firstname, lastname FROM person WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String firstname = rs.getString("firstname");
                    String lastname = rs.getString("lastname");
                    return firstname + " " + lastname;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Fehler beim Abrufen des Benutzernamens: " + e.getMessage());
        }
        return null; // Rückgabe null, falls kein Benutzer gefunden oder ein Fehler aufgetreten ist.
    }

    /**
     * Person hinzufügen.
     */
    public Person  insertPerson(Person person) {
        String query = "INSERT INTO Person (firstname, lastname, birthdate, gender, role) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setString(1, person.getFirstName());
            preparedStatement.setString(2, person.getLastName());
            preparedStatement.setObject(3, person.getBirthDate());
            preparedStatement.setString(4, String.valueOf(person.getGender()));
            preparedStatement.setString(5,person.getRole());

            int rowsInserted = preparedStatement.executeUpdate();
            if (rowsInserted > 0) {
                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        person.setUserId(generatedKeys.getInt(1));
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Fehler beim hinzufügen von Person: " + e.getMessage());
            e.printStackTrace();
        }
        return person;
    }

    /**
     * Person löschen
     */
    public void  deletePerson(Integer userId) {
        String query = "DELETE FROM Person WHERE user_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, userId);
            statement.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Fehler vbeim löschen von Person: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Mitarbeiter aktualisieren (UPDATE)
     */
    public void updatePerson(Person person) {
        String query = "UPDATE mitarbeiter SET vorname = ?, nachname = ?, geburtsdatum = ?, geschlecht = ?, rolle = ? WHERE mitarbeiter_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, person.getFirstName());
            statement.setString(2, person.getLastName());
            statement.setObject(3, person.getBirthDate());
            statement.setString(4, String.valueOf(person.getGender()));
            statement.setString(5, person.getRole());
            statement.setInt(6, person.getUserId().intValue());

            statement.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Fehler beim Aktualisieren von Person: " + e.getMessage());
            e.printStackTrace();
        }
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
