package application.repository;

import application.model.Book;

import java.util.List;

public interface PostgresBookRepository {
    List<Book> getAllBooks(); // für alle Bücher
    List<Book> searchBooks(String title, String author, String isbn, String status);
    Book findBookById(Long id);
    Book insertBook(Book book);
    void updateBook(Book book);
    void deleteBookById(Long id);
}
