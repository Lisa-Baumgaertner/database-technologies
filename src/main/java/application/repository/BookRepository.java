package application.repository;
import application.model.Book;

import java.util.ArrayList;
import java.util.List;

public class BookRepository {

    public List<Book> getAllBooks() {
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

    public void deleteBook(String title) {
     // TODO   String query = "DELETE FROM books WHERE title = ?";
    }
}
