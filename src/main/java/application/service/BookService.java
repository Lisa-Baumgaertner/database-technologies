package application.service;

import application.config.DatabaseConfig;
import application.model.Book;
import application.repository.BookRepository;


import java.io.IOException;
import java.util.List;
import java.util.Objects;

/**
 * Service-Klasse zur Verwaltung von Buchdaten.
 * Diese Klasse enthält Methoden zum Abrufen, Suchen, Hinzufügen, Aktualisieren und Löschen von Büchern.
 */
public class BookService {
    private static BookService instance;
    private final BookRepository bookRepository;


    public BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;

    }

    /**
     * Ruft alle Bücher aus der Datenbank ab.
     * @return Eine Liste aller Bücher.
     */
    public List<Book> getAllBooks() {
        return bookRepository.getAllBooks();
    }

    /**
     * Sucht Bücher basierend auf verschiedenen Attributen wie Titel, Autor, ISBN und Status.
     */
    public List<Book> searchBooks(String title, String author, String isbn, String status) {
        return bookRepository.searchBooks(title, author, isbn, status);
    }

    /**
     * Findet ein Buch anhand seiner ID.
     */
    public Book findBookById(Long id) {
        return bookRepository.findBookById(id);
    }

    /**
     * Findet ein Buch anhand seiner ISBN-Nummer.
     */
    public Book findBookByIsbn(String isbnLong, String isbnShort) {
        return bookRepository.findBookByIsbn(isbnLong, isbnShort);
    }

    /**
     * Findet ein Buchtitel anhand bookId.
     */
    public String getBookTitleById(int bookId) {
        return bookRepository.getBookTitleById(bookId);
    }


    /**
     * Fügt ein neues Buch in die Datenbank ein.
     **/
    public Book insertBook(Book book) {
        return bookRepository.insertBook(book);
    }


    /**
     * Aktualisiert die Daten eines bestehenden Buches in der Datenbank.
     * @param book Das Buch mit den aktualisierten Daten.
     */
    public void updateBook(Book book) {
        bookRepository.updateBook(book);
    }


    /**
     * Löscht ein Buch anhand seiner ID aus der Datenbank.
     * @param id Die ID des Buches, das gelöscht werden soll.
     */
    public void deleteBook(Long id) {
        bookRepository.deleteBookById(id);
    }


    /**
     * holt Keyword liste anhand bookId
     */
    public String getCategoryByBookId(int bookId) {
        return bookRepository.getCategoryByBookId(bookId);
    }

    /**
     * Überprüft, ob eine ISBN-Nummer bereits in der Datenbank vorhanden ist und nicht dem übergebenen Buch zugeordnet ist.
     * Diese Methode wird typischerweise verwendet, um Duplikate bei der Bucherfassung zu vermeiden.
     * @return true, wenn die ISBN bereits einem anderen Buch zugeordnet ist, sonst false.
     */
    public boolean isIsbnDuplicate(String isbnLong, String isbnShort, Long bookId) {
        Book foundBook = bookRepository.findBookByIsbn(isbnLong, isbnShort);
        return foundBook != null && !Objects.equals(foundBook.getBookId(), bookId);
    }

    /**
     * Singleton-Methode: Initialisiert BookService und stellt sicher, dass nur eine Instanz existiert.
     * @return Eine Instanz von BookService.
     */
    public static BookService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                // Verwende die Methode getBookRepository() der Instanz
                BookRepository repository = config.getBookRepository();
                instance = new BookService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des BookService", e);
            }
        }
        return instance;
    }
}
