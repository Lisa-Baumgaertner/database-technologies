package application.repository;

import application.model.Book;
import application.model.Person;
import application.model.Waitlist;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementierung des WaitlistRepository für PostgreSQL-Datenbank.
 * Diese Klasse bietet CRUD-Operationen für die Warteliste an.
 */
public class PostgresWaitlistRepositoryImpl implements WaitlistRepository {

    private final Connection connection;

    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     */
    public PostgresWaitlistRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    /**
     * Gibt alle Einträge der Warteliste zurück.
     */
    @Override
    public List<Waitlist> getAllWaitlistEntries() {
        List<Waitlist> waitlist = new ArrayList<>();
        String query = "SELECT w.waitlist_id, w.user_id, w.book_id, w.checkout_date, w.return_date, w.status, " +
                "p.firstname, p.nachname, b.booktitle " +
                "FROM waitlist w " +
                "JOIN person p ON w.user_id = p.user_id " +
                "JOIN book b ON w.book:id = b.book_id";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    Waitlist entry = new Waitlist();
                    entry.setWaitlistId(rs.getInt("waitlist_id"));

                    Person user = new Person();
                    user.setFirstName(rs.getString("firstname"));
                    user.setLastName(rs.getString("lastname"));
                    entry.setUser(user);

                    Book book = new Book();
                    book.setTitle(rs.getString("booktitle"));
                    entry.setBook(book);

                    entry.setCheckoutDate(rs.getDate("checkout_dtae").toLocalDate());
                    entry.setReturnDate(rs.getDate("return_date") != null ? rs.getDate("RETURN_DATE").toLocalDate() : null);
                    entry.setStatus(rs.getString("status"));

                    waitlist.add(entry);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return waitlist;
    }

    /**
     * Fügt einen Eintrag in die Warteliste hinzu.
     */
    @Override
    public boolean addToWaitlist(Long userId, Long bookId, String status) {
        int size = 0;
        boolean bSuccess = true;
        // Corrected SQL query with the WHERE clause
        String query = "SELECT * FROM WAITLIST WHERE user_id = ? AND book_id = ? AND return_date IS NULL ";

        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setLong(1, userId);
            preparedStatement.setLong(2, bookId);
            ResultSet rs = preparedStatement.executeQuery();

            // Check if any row was returned by the query
            if (rs.next()) {
                size = 1; // A matching row was found
                bSuccess = false;
            } else {
                size = 0; // No matching row found
                bSuccess = true;
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }

        if (size == 0) {
            String query2 = "INSERT INTO WAITLIST (user_id, book_id, checkout_date, status) VALUES (?, ?, CURRENT_DATE, ?)";

            try (PreparedStatement statement = connection.prepareStatement(query2, Statement.RETURN_GENERATED_KEYS)) {

                statement.setLong(1, userId);
                statement.setLong(2, bookId);
                statement.setString(3, status);
                statement.executeUpdate();

                bSuccess = true;

            } catch (SQLException e) {
                e.printStackTrace();
            }

        } else {
            System.out.println("Du stehst schon auf der Warteliste!");
            bSuccess = false;
        }
        return bSuccess;
    }

//    @Override
//    public void addToWaitlist(Long userId, Long bookId, String status)  {
//        int size = 0;
//        String query = "SELECT * FROM WAITLIST user_id = ? AND book_id = ?";
//
//        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
//            preparedStatement.setLong(1, userId);
//            preparedStatement.setLong(2, bookId);
//            ResultSet rs = preparedStatement.executeQuery();
//            //size = rs.getFetchSize();
//            size = 0;
//        } catch (SQLException e) {
//            System.err.println("SQL Error: " + e.getMessage());
//            e.printStackTrace();
//        }
//        try (PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
//            statement.setLong(1, userId);
//            statement.setLong(2, bookId);
//            statement.executeQuery();
//            size = statement.getResultSet().getFetchSize();
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        if (size == 0) {
//            String query2 = "INSERT INTO WAITLIST (user_id, book_id, checkout_date, status) VALUES (?, ?, CURRENT_DATE, ?)";
//
//            try (PreparedStatement statement = connection.prepareStatement(query2, Statement.RETURN_GENERATED_KEYS)) {
//
//                statement.setLong(1, userId);
//                statement.setLong(2, bookId);
//                statement.setString(3, status);
//                statement.executeUpdate();
//
//            } catch (SQLException e) {
//                e.printStackTrace();
//            }
//
//        } else {
//            System.out.println("Du stehst schon auf der Warteliste!");
//        }
//
//
//
//    }

    /**
     * Gibt die Wartelisteinträge für ein bestimmtes Buch zurück.
     */
    @Override
    public List<Waitlist> getWaitlistForBook(Long bookId) {
        List<Waitlist> waitlist = new ArrayList<>();
        String query = "SELECT w.waitlist_id, w.user_id, w.book_id, w.checkout_date, w.return_date, w.status, " +
                "p.firstname, p.lastname " +
                "FROM waitlist w " +
                "JOIN person p ON w.user_id = p.user_id " +
                "WHERE w.book_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, bookId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Waitlist entry = mapToWaitlist(rs);
                waitlist.add(entry);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return waitlist;
    }

    /**
     * Gibt die Wartelisteinträge für einen bestimmten Benutzer zurück.
     */
    @Override
    public List<Waitlist> getWaitlistForUser(Long userId) {
        List<Waitlist> waitlist = new ArrayList<>();
        String query = "SELECT w.waitlist_id, w,user_id, w.book_id, w.checkout_date, w.return_date, w.status, " +
                "p.firstname, p.lastname, b.booktitle " +
                "FROM waitlist w " +
                "JOIN person p ON w.user_id = p.user_id " +
                "JOIN book b ON w.book_id = b.book_id " +
                "WHERE w.user_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
        statement.setLong(1, userId);
        ResultSet rs = statement.executeQuery();

        while (rs.next()) {
           Waitlist entry = mapToWaitlist(rs);
            waitlist.add(entry);

        }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return waitlist;
    }

    /**
     * Aktualisiert den Status eines Eintrags in der Warteliste.
     */
    @Override
    public void updateStatus(Long waitlistId, String status) {
        String query = "UPDATE WAITLIST SET status = ? WHERE waitlist_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, status);
            statement.setLong(2, waitlistId);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Entfernt einen Eintrag aus der Warteliste.
     */
    @Override
    public void removeFromWaitlist(Long waitlistId) {
        String query = "DELETE FROM waitlist WHERE waitlist_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setLong(1, waitlistId);
            statement.executeUpdate();

        }  catch (SQLException e) {
            e.printStackTrace();
        }

    }

    /**
     * Hilfsmethode zur Konvertierung eines ResultSet in ein `Waitlist`-Objekt.
     */
    private Waitlist mapToWaitlist(ResultSet rs) throws SQLException {
        Waitlist entry = new Waitlist();

        entry.setWaitlistId(rs.getInt("waitlist_id"));
        entry.setCheckoutDate(rs.getDate("checkout_date").toLocalDate());
        entry.setReturnDate(rs.getDate("return_date") != null ? rs.getDate("return_date").toLocalDate() : null);
        entry.setStatus(rs.getString("status"));

        Person user = new Person();
        user.setFirstName(rs.getString("firstname"));
        user.setLastName(rs.getString("lastname"));
        entry.setUser(user);

        Book book = new Book();
        book.setTitle(rs.getString("booktitle"));
        entry.setBook(book);

        return entry;
    }



}
