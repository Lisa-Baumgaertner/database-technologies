package application.repository;

import application.model.Book;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;



import java.util.ArrayList;
import java.util.List;

public class MongoBookRepositoryImpl implements BookRepository {
    private final MongoCollection<Document> bookCollection;

    public MongoBookRepositoryImpl(MongoDatabase mongoDatabase) {
        this.bookCollection = mongoDatabase.getCollection("books"); // Verwende die Collection "books"
    }
    @Override
    public List<Book> getAllBooks() {
        return new ArrayList<>();
    }

    @Override
    public List<Book> searchBooks(String title, String author, String isbn, String status) {
        return new ArrayList<>();
    }

    @Override
    public Book findBookById(Long id) {
        return null;
    }

    @Override
    public Book insertBook(Book book) {
        return book;
    }

    @Override
    public void updateBook(Book book) {
    }

    @Override
    public void deleteBookById(Long id) {
    }
}