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
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.Connection;
import java.util.Objects;

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
    @FXML
    private Button addButton;
    @FXML
    private Button navigateBackToEmployeeButton;
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

        Book bookToInsert = new Book();
        if (! checkTextFieldsValid()) {
            // one or more of the text fields are empty
            System.out.println("At least one Text Field is empty, please enter valid data into all fields.");
            System.out.println("Double check that you are not entering characters into the fields Year published and Keyword Id");

        } else {
            bookToInsert.setIsbn(isbn.getText().trim());
            bookToInsert.setTitle(title.getText().trim());
            bookToInsert.setAuthor(author.getText().trim());
            bookToInsert.setAuthor(author.getText().trim());
            bookToInsert.setPublisher(publisher.getText().trim());
            bookToInsert.setYearPublished(Integer.valueOf(year_published.getText().trim()));
            bookToInsert.setDescription(description.getText().trim());
            bookToInsert.setDescription(description.getText().trim());
            bookToInsert.setStatus(status.getText().toLowerCase().trim());
            bookToInsert.setKeywordId(Integer.valueOf(keyword_id.getText().trim()));
            bookService.addBook(bookToInsert);
            isbn.clear();
            title.clear();
            author.clear();
            publisher.clear();
            year_published.clear();
            description.clear();
            status.clear();
            keyword_id.clear();
            System.out.println("Book was successfully added.");

        }


    }

    @FXML
    private void navigateToEmployeeView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/EmployeeView.fxml"));
            Parent bookSearchView = loader.load();

            Scene scene = new Scene(bookSearchView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) navigateBackToEmployeeButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    private boolean checkTextFieldsValid() {

        boolean validTextFields = true;

        if (isbn.getText().isEmpty()) {
            validTextFields = false;
        }

        if (title.getText().isEmpty()) {
            validTextFields = false;

        }

        if (author.getText().isEmpty()) {
            validTextFields = false;

        }
        if (publisher.getText().isEmpty()) {
            validTextFields = false;

        }
        if (year_published.getText().isEmpty() || !year_published.getText().matches("[0-9]+")) {
            validTextFields = false;

        }
        if (description.getText().isEmpty()) {
            validTextFields = false;

        }
        if (status.getText().isEmpty()) {
            validTextFields = false;

        }
        if (keyword_id.getText().isEmpty()|| !keyword_id.getText().matches("[0-9]+")) {
            validTextFields = false;

        }

        return validTextFields;
    }


}
