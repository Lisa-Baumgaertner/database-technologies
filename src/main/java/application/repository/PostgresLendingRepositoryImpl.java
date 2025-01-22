package application.repository;

import application.model.Book;
import application.model.Person;
import application.model.Lending;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementierung des LendingRepository für eine PostgreSQL-Datenbank.
 * Diese Klasse bietet konkrete Implementierungen für die Methoden zum Zugriff auf Ausleihdaten in einer PostgreSQL-Datenbank.
 */
public class PostgresLendingRepositoryImpl implements LendingRepository {

    private final Connection connection;

    /**
     * Konstruktor, der die Datenbankverbindung initialisiert.
     */
    public PostgresLendingRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    /**
     * Ruft alle Ausleihen aus der Datenbank ab, die noch nicht zurückgegeben wurden.
     */
    @Override
    public List<Lending> getAllLendinglistEntries() {
        List<Lending> lendingList = new ArrayList<>();
        String query =  "SELECT b.booktitle, p.lastname, p.role FROM LENDING AS l " +
                        "JOIN BOOK AS b ON l.book_id = b.book_id " +
                        "JOIN PERSON AS p ON l.user_id_borrower = p.user_id " +
                        "WHERE l.status = 'borrowed'";

        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    lendingList.add(mapToLending(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return lendingList;
    }
    /**
     * Fügt eine neue Ausleihe in die Datenbank ein.
     **/
    @Override
    public void addToLending(Long userId, Long workerId, Long bookId, String status, LocalDate checkoutDate) {
        String query = "INSERT INTO LENDING (user_id_borrower, user_id_worker, book_id, status, checkout_date) VALUES (?, ?, ?, 'borrowed', CURRENT_DATE)";
        try (PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            statement.setLong(1, userId);
            statement.setLong(2, workerId);
            statement.setLong(3, bookId);
            statement.setString(4, status);
            statement.executeUpdate();

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Holt eine Liste aller Ausleihen für ein bestimmtes Buch.
     */
    @Override
    public List<Lending> getLendingForBook(Long bookId) {
        List<Lending> lending = new ArrayList<>();
        String query = "SELECT l.lending_id, b.book_id, p.user_id, l.status, l.checkout_date, " +
                "l.return_date, l.due_date, b.booktitle, p.firstname, p.lastname " +
                "FROM LENDING l " +
                "JOIN BOOK b ON l.book_id = b.book_id " +
                "JOIN PERSON p ON l.user_id_borrower = p.user_id " +
                "WHERE b.book_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, bookId);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                lending.add(mapToLending(rs));
            }

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return lending;
    }

    /**
     * Holt eine Liste aller Ausleihen für einen bestimmten Benutzer.
     */
    @Override
    public List<Lending> getLendingForUser(Long userId) {
        List<Lending> lending = new ArrayList<>();
        String query = "SELECT l.lending_id, b.book_id, p.user_id, l.status, l.checkout_date, " +
                "l.return_date, l.due_date, b.booktitle, p.firstname, p.lastname " +
                "FROM LENDING l " +
                "JOIN BOOK b ON l.book_id = b.book_id " +
                "JOIN PERSON p ON l.user_id_borrower = p.user_id " +
                "WHERE p.user_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, userId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                lending.add(mapToLending(rs));

            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return lending;
    }


    /**
     * Aktualisiert den Status eines Lending-Eintrags in der Datenbank.
     */
    @Override
    public void updateStatus(Long lendingId, String newStatus) {
        String query = "UPDATE LENDING SET status = ?, return_date = CURRENT_DATE WHERE lending_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, newStatus);
            statement.setLong(2, lendingId);
            statement.executeUpdate();

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Entfernt einen Lending-Eintrag aus der Datenbank.
     */
    @Override
    public void removeFromLending(Long lendingId) {
        String query = "DELETE FROM LENDING AS l WHERE l.lending_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, lendingId);
            statement.executeUpdate();

        }  catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
    }



    @Override
    public Lending getLendingById(Long lendingId) {
        String query = """
    SELECT l.lending_id, l.status, l.checkout_date, l.return_date, l.due_date, p.firstname, p.lastname,
                l.book_id, b.booktitle, l.user_id_borrower, l.user_id_worker, k.keyword AS keywordName
    FROM lending l
    JOIN person p ON l.user_id_borrower = p.user_id
    JOIN book b ON l.book_id = b.book_id
    LEFT JOIN keyword k ON b.keyword_id = k.keyword_id
    WHERE l.lending_id = ?;
""";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, lendingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("Eintrag gefunden: " + rs.getInt("lending_id"));
                    return mapToLending(rs);
                } else {
                    System.out.println("Kein Eintrag gefunden für lending_id: " + lendingId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    /**
     * Berechnet die Anzahl der Verlängerungen eines Lending-Eintrags anhand der Fristverlängerungen.
     */
    @Override
    public int calculateExtensionCount(Lending lending) {

        LocalDate originalDueDate = lending.getCheckoutDate().plusDays(28); // Standardfrist: 28 Tage
        LocalDate currentDate = LocalDate.now(); // Heutiges Datum für den Vergleich verwenden, wenn returnDate null ist

        LocalDate effectiveReturnDate = lending.getDueDate() != null ? lending.getDueDate() : currentDate;

        // Berechnen, wie viele 4-Wochen-Intervalle hinzugefügt wurden
        if (effectiveReturnDate.isAfter(originalDueDate)) {
            // Berechnen, wie viele 4-Wochen-Intervalle hinzugefügt wurden
            return (int) (java.time.temporal.ChronoUnit.DAYS.between(originalDueDate, effectiveReturnDate) / 28);
        }
      return 0; // Keine Verlängerungen, wenn das Rückgabedatum vor oder am ursprünglichen Fälligkeitsdatum liegt
    }

    /**
     * Aktualisiert das Fälligkeitsdatum eines Lending-Eintrags in der Datenbank.
     */
    @Override
    public void updateDueDate(Long lendingId, LocalDate newDueDate) {
        String query = "UPDATE lending SET due_date = ? WHERE lending_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setDate(1, Date.valueOf(newDueDate));
            statement.setLong(2, lendingId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Sucht Lending-Einträge nach einem Benutzernamen.
     */
    @Override
    public List<Lending> getLendingForUserByName(String name) {
        String query = """
        SELECT l.lending_id, l.status, l.checkout_date, l.return_date, l.due_date, p.firstname, p.lastname,
           l.book_id, b.booktitle, l.user_id_borrower, l.user_id_worker, k.keyword AS keywordName
        FROM lending l
        JOIN person p ON l.user_id_borrower = p.user_id
        JOIN book b ON l.book_id = b.book_id
        LEFT JOIN keyword k ON b.keyword_id = k.keyword_id
        WHERE p.firstname ILIKE ? OR p.lastname ILIKE ? OR CONCAT(p.firstname, ' ', p.lastname) ILIKE ?;
    """;

        List<Lending> lendingList = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            String likePattern = "%" + name + "%";
            statement.setString(1, likePattern);
            statement.setString(2, likePattern);
            statement.setString(3, likePattern);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
    System.out.println("Eintrag gefunden: " + resultSet.getInt("lending_id"));
                    Lending lending = mapToLending(resultSet);

                    lendingList.add(lending);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lendingList;
    }

    /**
     * Filtert ausgeliehene Bücher nach Fälligkeitsdatum
     */

    @Override
    public List<Lending> filterByReturnDate() {
        List<Lending> lendingList = new ArrayList<>();

        String query = """
        SELECT  l.lending_id, l.status, l.checkout_date, l.due_date, l.return_date,
               b.book_id, b.booktitle,
              l.user_id_borrower, l.user_id_worker, p.firstname, p.lastname,
               k.keyword AS keywordName
        FROM lending l
        JOIN book b ON l.book_id = b.book_id
        JOIN person p ON l.user_id_borrower = p.user_id
        LEFT JOIN keyword k ON b.keyword_id = k.keyword_id
        WHERE l.return_date <= CURRENT_DATE + INTERVAL '7 days';
    """;

        try (PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Lending lending = mapToLending(resultSet);
                lendingList.add(lending);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lendingList;
    }

    /**
     * Filtert ausgeliehene Bücher nach Buchkategorie basierend auf Keyword
     */
    @Override
    public List<Lending> filterByCategory(String category) {
        List<Lending> lendingList = new ArrayList<>();

        String query = """
        SELECT l.lending_id, l.status, l.checkout_date, l.due_date, l.return_date,
               b.book_id, b.booktitle, 
               l.user_id_borrower, l.user_id_worker, p.firstname, p.lastname,
               k.keyword AS keywordName
        FROM lending l
        JOIN book b ON l.book_id = b.book_id
        JOIN person p ON l.user_id_borrower = p.user_id
        LEFT JOIN keyword k ON b.keyword_id = k.keyword_id
        WHERE k.keyword = ?;
    """;

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, category);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Lending lending = mapToLending(resultSet);
                    lendingList.add(lending);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lendingList;
    }

    /**
     * Filtert insgesamt ausgeliehene Bücher nach aktueller Verfügbarkeit
     */
    @Override
    public List<Lending> filterByAvailability(String availabilityStatus) {
        List<Lending> lendingList = new ArrayList<>();
        String query = """
        SELECT l.lending_id, l.status, l.checkout_date, l.due_date, l.return_date,
               b.book_id, b.booktitle,
             l.user_id_borrower, l.user_id_worker, p.firstname, p.lastname,
                            k.keyword AS keywordName
        FROM lending l
        JOIN book b ON l.book_id = b.book_id
        JOIN person p ON l.user_id_borrower = p.user_id
        LEFT JOIN keyword k ON b.keyword_id = k.keyword_id
        WHERE l.status = ?;
    """;

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, availabilityStatus);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Lending lending = mapToLending(resultSet);
                    lendingList.add(lending);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lendingList;
    }


    /**
     * Returniert alle Keywords
     */
    @Override
    public  List<String> getAllKeywords() {
        List<String> keywords = new ArrayList<>();
        String query = "SELECT keyword FROM keyword";
        try (PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                keywords.add(resultSet.getString("keyword"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return keywords;
    }

    /**
     * Hilfsmethode zum Zuordnen eines ResultSet zu einem Lending-Objekt.
     */
    private Lending mapToLending(ResultSet rs) throws SQLException {
        Lending lending = new Lending();

        lending.setLendingId(rs.getInt("lending_id"));
        lending.setBookId(rs.getInt("book_id")); // Setzt die Buch-ID
        lending.setUserIdBorrower(rs.getInt("user_id_borrower")); // Setzt die Benutzer-ID des Entleihers
        lending.setUserIdWorker(rs.getInt("user_id_worker")); // Setzt die Benutzer-ID des Arbeiters
        lending.setStatus(rs.getString("status")); // Setzt den Status der Ausleihe

        Date checkoutDate = rs.getDate("checkout_date");
        if (checkoutDate != null) {
            lending.setCheckoutDate(checkoutDate.toLocalDate()); // Setzt das Ausleihdatum
        }

        Date returnDate = rs.getDate("return_date");
        if (returnDate != null) {
            lending.setReturnDate(returnDate.toLocalDate());
        }

        Date dueDate = rs.getDate("due_date");
        if (dueDate != null) {
            lending.setDueDate(dueDate.toLocalDate());
        }

        return lending;
    }
}
