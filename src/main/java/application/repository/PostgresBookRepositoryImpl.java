package application.repository;

import application.model.Book;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostgresBookRepositoryImpl implements PostgresBookRepository {

    private final Connection connection;

    public PostgresBookRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM book";

        try (Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            while (resultSet.next()) {
                Book book = mapResultSetToBook(resultSet);
                books.add(book);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    @Override
    public Book findBookById(Long id) {
        String query = "SELECT * FROM book WHERE book_id = ?";
        Book book = null;

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                book = mapResultSetToBook(resultSet);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return book;
    }

    @Override
    public Book insertBook(Book book) {
        String query = "INSERT INTO book (isbn, booktitle, bookauthor, publisher, year_published, description, status, keyword_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, book.getIsbn());
            statement.setString(2, book.getTitle());
            statement.setString(3, book.getAuthor());
            statement.setString(4, book.getPublisher());
            statement.setInt(5, book.getYearPublished());
            statement.setString(6, book.getDescription());
            statement.setString(7, book.getStatus());
            statement.setObject(8, book.getKeywordId(), Types.INTEGER);

            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        book.setBookId(generatedKeys.getInt(1));
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return book;
    }

    public void updateBook(Book book) {
        String query = "UPDATE book SET isbn = ?, booktitle = ?, bookauthor = ?, publisher = ?, year_published = ?, " +
                "description = ?, status = ?, keyword_id = ? WHERE book_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, book.getIsbn());
            statement.setString(2, book.getTitle());
            statement.setString(3, book.getAuthor());
            statement.setString(4, book.getPublisher());
            statement.setInt(5, book.getYearPublished());
            statement.setString(6, book.getDescription());
            statement.setString(7, book.getStatus());
            statement.setObject(8, book.getKeywordId(), Types.INTEGER);
            statement.setLong(9, book.getBookId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteBookById(Long id) {
        String query = "DELETE FROM book WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, id);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Hilfsmethode zum Konvertieren des ResultSet in ein Book-Objekt
    private Book mapResultSetToBook(ResultSet resultSet) throws SQLException {
        Book book = new Book();
        book.setBookId(resultSet.getInt("book_id"));
        book.setIsbn(resultSet.getString("isbn"));
        book.setTitle(resultSet.getString("booktitle"));
        book.setAuthor(resultSet.getString("bookauthor"));
        book.setPublisher(resultSet.getString("publisher"));
        book.setYearPublished(resultSet.getInt("year_published"));
        book.setDescription(resultSet.getString("description"));
        book.setStatus(resultSet.getString("status"));
        book.setKeywordId(resultSet.getInt("keyword_id"));
        return book;
    }
}