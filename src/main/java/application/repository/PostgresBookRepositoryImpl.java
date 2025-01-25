package application.repository;

import application.model.Book;
import application.model.Status;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Diese Klasse implementiert das BookRepository-Interface für PostgreSQL.
 * Sie enthält Methoden zum Abrufen, Hinzufügen, Aktualisieren und Löschen von Büchern aus der Datenbank.
 */
public class PostgresBookRepositoryImpl implements BookRepository {

    private final Connection connection;
    private final PostgresKeywordRepositoryImpl keywordRepository;

    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     */
    public PostgresBookRepositoryImpl(Connection connection, PostgresKeywordRepositoryImpl keywordRepository) {
        this.connection = connection;
        this.keywordRepository = keywordRepository;
    }

    /**
     * Holt alle Bücher aus der Datenbank.
     */
    @Override
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    // Keywords abrufen
                    book.setKeywords(keywordRepository.getKeywordsForBook(book.getBookId()));
                    books.add(book);
                }
            }
        } catch (SQLException e) {
            System.err.println("Fehler beim Laden der Bücher : " + e.getMessage());
            e.printStackTrace();
        }
        return books;
    }


    /**
     * Sucht Bücher basierend auf Titel, Autor, ISBN oder Status.
     */
    public List<Book> searchBooks(String title, String author, String isbn, String status) {
        List<Book> books = new ArrayList<>();
        System.out.println("ausgewählte Status," + status);
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

    /**
     * Findet ein Buch anhand der ID.
     */
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

    /**
     * Findet ein Buch anhand der ISBN.
     */
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

                String germanStatus = resultSet.getString("status");
                System.out.println("Status English => " + Status.BookStatus.fromString(germanStatus));
                book.setStatus(Status.BookStatus.fromString(germanStatus));
                return book;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Kein Buch gefunden

    }

    @Override
    public String getBookTitleById(int bookId) {
        String query = "SELECT booktitle FROM book WHERE book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("booktitle");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Fehler beim Abrufen des Buchtitels: " + e.getMessage());
        }
        return null;
    }

    /**
     * Fügt ein neues Buch zur Datenbank hinzu.
     */
    @Override
    public void insertBook(Book book) {
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
            statement.setObject(10, book.getKeywordId().get(), Types.INTEGER);

            statement.executeUpdate();
            ResultSet rs = statement.getGeneratedKeys();
            if (rs.next()) {
                book.setBookId(rs.getInt(1));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Aktualisiert ein bestehendes Buch in der Datenbank.
     */
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
            statement.setObject(10, book.getKeywordId().get(), Types.INTEGER);
            statement.setLong(11, book.getBookId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Holt Keywords ein Buch Titel anhand Id.
     */
    @Override
    public String getCategoryByBookId(int bookId) {
        String query = "SELECT STRING_AGG(k.keyword, ', ') AS keywords " +
                "FROM book_keyword bk " +
                "JOIN keyword k ON bk.keyword_id = k.keyword_id " +
                "WHERE bk.book_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, bookId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("keywords");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    @Override
    public void insertBookKeyword(Long bookId, int keywordId) {
        String query = "INSERT INTO book_keyword (book_id, keyword_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, (int) bookId.longValue());
            stmt.setInt(2, keywordId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Löscht ein Buch anhand der ID.
     * @param id Buch-ID.
     */
    @Override
    public void deleteBookById(Long id) {
        String query = "DELETE FROM book WHERE book_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, id);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Hilfsmethode zur Umwandlung eines ResultSet in ein Book-Objekt.
     */
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
        book.setStatus(Status.BookStatus.fromString(resultSet.getString("status").trim()));
        book.setKeywordId(resultSet.getInt("keyword_id"));
        book.setKeywords(new ArrayList<>()); // Keywords werden separat geladen
        return book;
    }
}
