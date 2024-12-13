package application.repository;

import application.model.Book;
import application.model.Person;
import application.model.Lending;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PostgresLendingRepositoryImpl implements LendingRepository {

    private final Connection connection;

    public PostgresLendingRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

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
                    Lending entry = new Lending();

                    Person user = new Person();
                    user.setFirstName(rs.getString("firstname"));
                    user.setLastName(rs.getString("lastname"));
                    entry.setUser(user);

                    Book book = new Book();
                    book.setTitle(rs.getString("booktitle"));
                    entry.setBook(book);

                    lendingList.add(entry);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return lendingList;
    }

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
            e.printStackTrace();
        }
    }

    @Override
    public List<Lending> getLendingForBook(Long bookId) {
        List<Lending> lending = new ArrayList<>();
        String query = "SELECT b.booktitle, p.firstname, p.lastname FROM LENDING AS l " +
                "JOIN BOOK AS b ON l.book_id = b.book_id " +
                "JOIN PERSON AS p ON l.user_id_borrower = p.user_id " +
                "WHERE w.book_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, bookId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Lending entry = mapToLending(rs);
                lending.add(entry);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lending;
    }

    @Override
    public List<Lending> getLendingForUser(Long userId) {
        List<Lending> waitlist = new ArrayList<>();
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
                Lending entry = mapToLending(rs);
                waitlist.add(entry);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return waitlist;
    }

    @Override
    public void updateStatus(Long lendingId, String status) {
        String query = "UPDATE LENDING AS l SET status = ?, return_date = CURRENT_DATE " +
                       "WHERE l.lending_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, status);
            statement.setLong(2, lendingId);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void removeFromLending(Long lendingId) {
        String query = "DELETE FROM LENDING AS l WHERE l.lending_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, lendingId);
            statement.executeUpdate();

        }  catch (SQLException e) {
            e.printStackTrace();
        }

    }

    private Lending mapToLending(ResultSet rs) throws SQLException {
        Lending entry = new Lending();

        entry.setLendinglistId(rs.getInt("lending_id"));
        entry.setCheckoutDate(rs.getDate("checkout_date").toLocalDate());
        entry.setReturnDate(rs.getDate("return_date") != null ? rs.getDate("return_date").toLocalDate() : null);
        entry.setStatus(rs.getString("status"));

        Person user = new Person();
        user.setFirstName(rs.getString("firstname"));
        user.setLastName(rs.getString("lastname"));
        user.setUserId(rs.getInt("user_id_borrower"));
        entry.setUser(user);

        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        entry.setBook(book);

        return entry;
    }



}
