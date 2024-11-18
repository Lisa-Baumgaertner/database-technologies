package application.repository;

import application.model.Book;

import java.util.ArrayList;
import java.util.List;

public class MongoBookRepository {
    public List<Book> getAllBooks() {
        // String query = "SELECT * FROM books";
        // TODO
        return new ArrayList<>();
    }

    public List<Book> searchBooks() {
        // String query = "SELECT * FROM books";
        // TODO
        return new ArrayList<>();
    }


    public void insertBook(Book book) {
        //  String query = "INSERT INTO books ...;
        // TODO
    }

    public void updateBook(Book book) {
        // TODO   String query = "UPDATE books SET author = ?, status = ? WHERE title = ?";
    }

    public void deleteBookById(Long id) {
        // TODO   String query = "DELETE FROM books WHERE title = ?";
    }
}
