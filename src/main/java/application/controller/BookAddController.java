package application.controller;

import application.config.DatabaseConfig;
import application.model.Book;
import application.repository.MongoBookRepository;
import application.repository.PostgresBookRepository;
import application.repository.PostgresBookRepositoryImpl;
import application.service.BookService;
import application.util.SQLDatabaseConnection;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;

import java.sql.Connection;

public class BookAddController {

    @FXML
    private TextField isbn;
    @FXML
    private TextField title;
    @FXML
    private TextField author;
    @FXML
    private TextField publisher;
    @FXML
    private TextField year_published;
    @FXML
    private TextField description;
    @FXML
    private TextField status;
    @FXML
    private TextField keyword_id;
    private final BookService bookService;

    public BookAddController() {
        Connection postgresConnection = SQLDatabaseConnection.getConnection();

        PostgresBookRepository postgresBookRepository = new PostgresBookRepositoryImpl(postgresConnection);
        MongoBookRepository mongoBookRepository = new MongoBookRepository();
        DatabaseConfig databaseConfig = new DatabaseConfig();

        // Initialisiere BookService mit den benötigten Abhängigkeiten
        this.bookService = new BookService(postgresBookRepository, mongoBookRepository, databaseConfig);
    }



    @FXML
    private void addBook(){
        String isbnText = isbn.getText().toLowerCase();
        String titleText = title.getText().toLowerCase();
        String authorText = author.getText().toLowerCase();
        String publisherText = publisher.getText().toLowerCase();
        String year_publishedText = year_published.getText().toLowerCase();
        String descriptionText = description.getText().toLowerCase();
        String statusText = status.getText().toLowerCase();
        String keyword_idText = keyword_id.getText().toLowerCase();



    }
    //@FXML
    /*private void addBook() {

        String searchText = searchField.getText().toLowerCase();
        System.out.println("Search query: " + searchText);
        if (!searchText.isEmpty()) {
            ObservableList<Book> filteredBooks = FXCollections.observableArrayList(bookService.searchBooks(searchText).stream()
                    .filter(book -> book.getTitle().toLowerCase().contains(searchText) ||
                            book.getAuthor().toLowerCase().contains(searchText) ||
                            book.getIsbn().toLowerCase().contains(searchText)||
                            book.getStatus().toLowerCase().contains(searchText))
                    .toList());
            resultTable.setItems(filteredBooks);
        } else {
            resultTable.setItems(bookList);
        }
    }*/
}
