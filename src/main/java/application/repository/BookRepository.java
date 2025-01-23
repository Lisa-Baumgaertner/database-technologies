package application.repository;

import application.model.Book;


import java.util.List;

public interface BookRepository {
    List<Book> getAllBooks(); // für alle Bücher
    List<Book> searchBooks(String title, String author, String isbn, String status);
    Book findBookById(Long id);
    Book findBookByIsbn(String isbnLong, String isbnShort);
    String getBookTitleById(int bookId);
    String getCategoryByBookId(int bookId);
    void insertBook(Book book);
    void insertBookKeyword(Long bookId, int keywordId);
    void updateBook(Book book);
    void deleteBookById(Long id);
}