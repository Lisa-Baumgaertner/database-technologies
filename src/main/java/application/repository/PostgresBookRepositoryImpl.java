package application.repository;

import application.model.Book;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class PostgresBookRepositoryImpl implements BookRepository {

    private final Connection connection;

    public PostgresBookRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(new Book(
                            rs.getInt("book_id"),
                            rs.getString("isbn_long"),
                            rs.getString("isbn_short"),
                            rs.getInt("copies"),
                            rs.getString("booktitle"),
                            rs.getString("bookauthor"),
                            rs.getString("publisher"),
                            rs.getInt("year_published"),
                            rs.getString("description"),
                            rs.getString("status"),
                            rs.getInt("keyword_id")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public List<Book> searchBooks(String title, String author, String isbn, String status) {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM BOOK WHERE " +
                "(LOWER(BOOKTITLE) LIKE ? OR ? IS NULL) AND " +
                "(LOWER(BOOKAUTHOR) LIKE ? OR ? IS NULL) AND " +
                "(LOWER(ISBN_LONG) LIKE ? OR LOWER(ISBN_SHORT) LIKE ? OR ? IS NULL) AND " +
                "(LOWER(STATUS) LIKE ? OR ? IS NULL)";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, title != null ? "%" + title.toLowerCase() + "%" : null);
            stmt.setString(2, title);
            stmt.setString(3, author != null ? "%" + author.toLowerCase() + "%" : null);
            stmt.setString(4, author);
            stmt.setString(5, isbn != null ? "%" + isbn.toLowerCase() + "%" : null);
            stmt.setString(6, isbn != null ? "%" + isbn.toLowerCase() + "%" : null);
            stmt.setString(7, isbn);
            stmt.setString(8, status != null ? "%" + status.toLowerCase() + "%" : null);
            stmt.setString(9, status);

            try (ResultSet resultSet = stmt.executeQuery()) {
                while (resultSet.next()) {
                    books.add(mapResultSetToBook(resultSet));
                }
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
    public Book findBookByIsbn(String isbnLong, String isbnShort)  {
        String query = "SELECT * FROM book WHERE isbn_long = ? OR isbn_short = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, isbnLong);
            statement.setString(2, isbnShort);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Book book = new Book();
                book.setBookId(resultSet.getInt("book_id"));
                book.setTitle(resultSet.getString("booktitle"));
                book.setAuthor(resultSet.getString("bookauthor"));
                book.setIsbnLong(resultSet.getString("isbn_long"));
                book.setIsbnShort(resultSet.getString("isbn_short"));
                book.setCopies(resultSet.getInt("copies"));
                book.setPublisher(resultSet.getString("publisher"));
                book.setYearPublished(resultSet.getInt("year_published"));
                book.setDescription(resultSet.getString("description"));
                book.setStatus(resultSet.getString("status"));
                return book;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Kein Buch gefunden

    }

    @Override
    public Book insertBook(Book book) {
        String query = "INSERT INTO book (isbn_long, isbn_short, copies, booktitle, bookauthor, publisher, year_published, description, status, keyword_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, book.getIsbnLong());
            statement.setString(2, book.getIsbnShort());
            statement.setObject(3, book.getCopies(), Types.INTEGER);
            statement.setString(4, book.getTitle());
            statement.setString(5, book.getAuthor());
            statement.setString(6, book.getPublisher());
            statement.setInt(7, book.getYearPublished());
            statement.setString(8, book.getDescription());
            statement.setString(9, book.getStatus());
            statement.setObject(10, book.getKeywordId(), Types.INTEGER);

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
        String query = "UPDATE book SET isbn_long = ?, isbn_short = ?, copies = ?, booktitle = ?, bookauthor = ?, publisher = ?, year_published = ?, " +
                "description = ?, status = ?, keyword_id = ? WHERE book_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, book.getIsbnLong());
            statement.setString(2, book.getIsbnShort());
            statement.setObject(3, book.getCopies(), Types.INTEGER);
            statement.setString(4, book.getTitle());
            statement.setString(5, book.getAuthor());
            statement.setString(6, book.getPublisher());
            statement.setInt(7, book.getYearPublished());
            statement.setString(8, book.getDescription());
            statement.setString(9, book.getStatus());
            statement.setObject(10, book.getKeywordId(), Types.INTEGER);
            statement.setLong(11, book.getBookId());

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
        book.setIsbnLong(resultSet.getString("isbn_long"));
        book.setIsbnShort(resultSet.getString("isbn_short"));
        book.setCopies(resultSet.getInt("copies"));
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
