package application.repository;

import application.model.Book;

import java.util.List;

public interface MongoBookRepository {
    List<Book> getAllBooks();
    List<Book> searchBooks(String title, String author, String isbn, String status);
    void insertBook(Book book);
    void updateBook(Book book);
    void deleteBookById(Long id);
}