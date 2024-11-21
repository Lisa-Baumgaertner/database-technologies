package application.controller;

import application.config.DatabaseConfig;
import application.model.Book;
import application.repository.MongoBookRepository;
import application.repository.PostgresBookRepository;
import application.repository.PostgresBookRepositoryImpl;
import application.service.BookService;
import application.util.SQLDatabaseConnection;
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

public class BookDeleteController {

    @FXML
    public Button navigateBackToEmployeeButton;
    @FXML
    public TextField bookIdField;
    private final BookService bookService;



    public BookDeleteController() {
        Connection postgresConnection = SQLDatabaseConnection.getConnection();

        PostgresBookRepository postgresBookRepository = new PostgresBookRepositoryImpl(postgresConnection);
        MongoBookRepository mongoBookRepository = new MongoBookRepository();
        DatabaseConfig databaseConfig = new DatabaseConfig();

        // Initialisiere BookService mit den benötigten Abhängigkeiten
        this.bookService = new BookService(postgresBookRepository, mongoBookRepository, databaseConfig);
    }



    @FXML
    private void deleteBook(){

        Book bookToDelete = new Book();
        if (! checkTextFieldsValid()) {
            // one or more of the text fields are empty
            System.out.println("At least one Text Field is empty, please enter valid data into all fields.");
            System.out.println("Double check that you are not entering characters into the fields Year published and Keyword Id");

        } else {
            bookToDelete.setBookId(Integer.valueOf(bookIdField.getText()));
            bookService.deleteBook(Long.valueOf(bookToDelete.getBookId()));
            bookIdField.clear();
            System.out.println("Book was successfully deleted.");

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

        if (bookIdField.getText().isEmpty() || !bookIdField.getText().matches("[0-9]+")) {
            validTextFields = false;

        }

        return validTextFields;
    }



}
