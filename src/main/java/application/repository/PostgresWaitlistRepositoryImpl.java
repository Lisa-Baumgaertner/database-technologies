package application.repository;

import application.model.Book;
import application.model.Person;
import application.model.Waitlist;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostgresWaitlistRepositoryImpl implements WaitlistRepository {

    private final Connection connection;

    public PostgresWaitlistRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

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

    @Override
    public void addToWaitlist(Long userId, Long bookId, String status) {
        String query = "INSERT INTO WAITLIST (user_id, book_id, checkout_date, status) VALUES (?, ?, CURRENT_DATE, ?)";
        try (PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            statement.setLong(1, userId);
            statement.setLong(2, bookId);
            statement.setString(3, status);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

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
