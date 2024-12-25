package application.service;

import application.model.Book;
import application.repository.BookRepository;


import java.util.List;
import java.util.Objects;

/**
 * Service-Klasse zur Verwaltung von Buchdaten.
 * Diese Klasse enthält Methoden zum Abrufen, Suchen, Hinzufügen, Aktualisieren und Löschen von Büchern.
 */
public class BookService {

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
     * Überprüft, ob eine ISBN-Nummer bereits in der Datenbank vorhanden ist und nicht dem übergebenen Buch zugeordnet ist.
     * Diese Methode wird typischerweise verwendet, um Duplikate bei der Bucherfassung zu vermeiden.
     * @return true, wenn die ISBN bereits einem anderen Buch zugeordnet ist, sonst false.
     */
    public boolean isIsbnDuplicate(String isbnLong, String isbnShort, Long bookId) {
        Book foundBook = bookRepository.findBookByIsbn(isbnLong, isbnShort);
        return foundBook != null && !Objects.equals(foundBook.getBookId(), bookId);
    }

}
