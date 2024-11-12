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
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.Connection;
import java.util.Objects;

public class BookSearchController {

    @FXML
    private TextField searchField;
    @FXML
    private Button searchButton;
    @FXML
    private Button backButton;
    @FXML
    private TableView<Book> resultTable;
    @FXML
    private TableColumn<Book, String> titleColumn;
    @FXML
    private TableColumn<Book, String> authorColumn;
    @FXML
    private TableColumn<Book, String> statusColumn;

    private final BookService bookService;
    private ObservableList<Book> bookList = FXCollections.observableArrayList();

    public BookSearchController() {
        Connection postgresConnection = SQLDatabaseConnection.getConnection();

        PostgresBookRepository postgresBookRepository = new PostgresBookRepositoryImpl(postgresConnection);
        MongoBookRepository mongoBookRepository = new MongoBookRepository();
        DatabaseConfig databaseConfig = new DatabaseConfig();

        // Initialisiere BookService mit den benötigten Abhängigkeiten
        this.bookService = new BookService(postgresBookRepository, mongoBookRepository, databaseConfig);
    }



    // Initialisierungslogik für die Ansicht
    @FXML
    public void initialize() {
        // Spalten mit Daten binden , wenn nötig
        titleColumn.setCellValueFactory(cellData -> cellData.getValue().titleProperty());
        authorColumn.setCellValueFactory(cellData -> cellData.getValue().authorProperty());
        statusColumn.setCellValueFactory(cellData -> cellData.getValue().statusProperty());

        // Zunächst keine Bücher anzeigen
        resultTable.setItems(bookList);

        searchButton.setOnAction(event -> searchBook());
    }

    // Suchmethode für Bücher
    @FXML
    private void searchBook() {
        String searchText = searchField.getText().toLowerCase();
        if (!searchText.isEmpty()) {
            ObservableList<Book> filteredBooks = FXCollections.observableArrayList(bookService.getAllBooks().stream()
                    .filter(book -> book.getTitle().toLowerCase().contains(searchText) ||
                            book.getAuthor().toLowerCase().contains(searchText))
                    .toList());
            resultTable.setItems(filteredBooks);
        } else {
            resultTable.setItems(bookList);
        }
    }

    @FXML
    private void goBackToMainView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/MainView.fxml"));
            Parent mainView = loader.load();
            Scene scene = new Scene(mainView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) backButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
