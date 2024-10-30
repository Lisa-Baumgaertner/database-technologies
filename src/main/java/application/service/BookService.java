package application.service;

import application.model.Book;
import application.repository.BookRepository;

import java.util.List;

public class BookService {

    private final BookRepository bookRepository;

    public BookService() {
        this.bookRepository = new BookRepository();
    }

    public List<Book> getAllBooks() {
        return bookRepository.getAllBooks();
    }

    public void addBook(Book book) {
        // Zum Beispiel Validierung der Eingaben
        if (book.getTitle() != null && !book.getTitle().isEmpty()) {
            bookRepository.insertBook(book);
        } else {
            throw new IllegalArgumentException("Der Buchtitel darf nicht leer sein");
        }
    }

    public void updateBook(Book book) {
        bookRepository.updateBook(book);
    }

    public void deleteBook(String title) {
        bookRepository.deleteBook(title);
    }
}
