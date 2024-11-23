package application.repository;

import application.model.Book;

import java.util.ArrayList;
import java.util.List;

public class MongoBookRepositoryImpl implements MongoBookRepository {
    @Override
    public List<Book> getAllBooks() {
        // Hier implementierst du die MongoDB-Logik, z. B. mit dem MongoDB-Client
        return new ArrayList<>(); // Beispiel: Rückgabe einer leeren Liste
    }

    @Override
    public List<Book> searchBooks(String title, String author, String isbn, String status) {
        // Implementiere hier die Suche für MongoDB
        return new ArrayList<>();
    }

    @Override
    public void insertBook(Book book) {
        // Implementiere das Hinzufügen eines Buchs in MongoDB
    }

    @Override
    public void updateBook(Book book) {
        // Implementiere die Aktualisierung eines Buchs in MongoDB
    }

    @Override
    public void deleteBookById(Long id) {
        // Implementiere das Löschen eines Buchs in MongoDB
    }
}
