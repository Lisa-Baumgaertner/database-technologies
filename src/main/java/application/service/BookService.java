package application.service;

import application.model.Book;
import application.repository.BookRepository;


import java.util.List;
import java.util.Objects;


public class BookService {

    private final BookRepository bookRepository;


    public BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;

    }

    public List<Book> getAllBooks() {
        return bookRepository.getAllBooks();
    }

    public List<Book> searchBooks(String title, String author, String isbn, String status) {
        return bookRepository.searchBooks(title, author, isbn, status);
    }

    public Book findBookById(Long id) {
        return bookRepository.findBookById(id);
    }

    public Book findBookByIsbn(String isbnLong, String isbnShort) {
        return bookRepository.findBookByIsbn(isbnLong, isbnShort);
    }

    public Book insertBook(Book book) {
        return bookRepository.insertBook(book);
    }

    public void updateBook(Book book) {
        bookRepository.updateBook(book);
    }

    public void deleteBook(Long id) {
        bookRepository.deleteBookById(id);
    }

    public boolean isIsbnDuplicate(String isbnLong, String isbnShort, Long bookId) {
        Book foundBook = bookRepository.findBookByIsbn(isbnLong, isbnShort);
        return foundBook != null && !Objects.equals(foundBook.getBookId(), bookId);
    }

}
