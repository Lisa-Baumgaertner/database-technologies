package application.service;

import application.config.DatabaseConfig;
import application.model.Book;
import application.repository.MongoBookRepository;
import application.repository.PostgresBookRepository;

import java.util.List;

public class BookService {

    private final PostgresBookRepository postgresBookRepository;
    private final MongoBookRepository mongoBookRepository;
    private final DatabaseConfig databaseConfig;

    public BookService(PostgresBookRepository postgresBookRepository,
                       MongoBookRepository mongoBookRepository,
                       DatabaseConfig databaseConfig) {
        this.postgresBookRepository = postgresBookRepository;
        this.mongoBookRepository = mongoBookRepository;
        this.databaseConfig = databaseConfig;
    }

    private boolean isUsingMongoDB() {
        return databaseConfig.isUseMongoDB();
    }

    public List<Book> getAllBooks() {
        return isUsingMongoDB() ? mongoBookRepository.getAllBooks() : postgresBookRepository.getAllBooks();
    }

    public void addBook(Book book) {

        if (book.getTitle() != null && !book.getTitle().isEmpty()) {
            if (isUsingMongoDB()) {
                mongoBookRepository.insertBook(book);
            } else {
                postgresBookRepository.insertBook(book);
            }
        } else {
            throw new IllegalArgumentException("Der Buchtitel darf nicht leer sein");
        }
    }

    public void updateBook(Book book) {
        if (isUsingMongoDB()) {
            mongoBookRepository.updateBook(book);
        } else {
            postgresBookRepository.updateBook(book);
        }
    }

    public void deleteBook(Long id) {
        if (isUsingMongoDB()) {
            mongoBookRepository.deleteBookById(id);
        } else {
            postgresBookRepository.deleteBookById(id);
        }
    }
}
