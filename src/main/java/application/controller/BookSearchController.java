package application.controller;

import application.config.DatabaseConfig;
import application.model.Book;
import application.repository.MongoBookRepository;
import application.repository.MongoBookRepositoryImpl;
import application.repository.PostgresBookRepository;
import application.repository.PostgresBookRepositoryImpl;
import application.service.BookService;
import application.util.SQLDatabaseConnection;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.text.Text;

import java.sql.Connection;
import java.util.List;

public class BookSearchController {

    @FXML
    private TextField titleField;
    @FXML
    private TextField authorField;
    @FXML
    private TextField isbnField;
    @FXML
    private ComboBox<String> statusDropdown;
    @FXML
    private Button searchButton;
    @FXML
    private TableView<Book> resultTable;
    @FXML
    private TableColumn<Book, String> titleColumn;
    @FXML
    private TableColumn<Book, String> isbnColumn;
    @FXML
    private TableColumn<Book, String> authorColumn;
    @FXML
    private TableColumn<Book, String> statusColumn;

    private final BookService bookService;
    private ObservableList<Book> bookList = FXCollections.observableArrayList();

    public BookSearchController() {
        Connection postgresConnection = SQLDatabaseConnection.getConnection();

        PostgresBookRepository postgresBookRepository = new PostgresBookRepositoryImpl(postgresConnection);
        MongoBookRepository mongoBookRepository = new MongoBookRepositoryImpl();
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

        isbnColumn.setCellFactory(cellData -> new TableCell<>() {
            private final Text text = new Text();

            {
                text.wrappingWidthProperty().bind(this.widthProperty().subtract(10));
                text.setStyle("-fx-text-alignment: left;");
            }

            @Override
            protected void updateItem(String item, boolean empty) {
                super.updateItem(item, empty);

                if (empty || getTableRow() == null || getTableRow().getItem() == null) {
                    setText(null);
                    setGraphic(null);
                } else {
                    Book book = getTableRow().getItem();
                    String isbnLong = book.getIsbnLong();
                    String isbnShort = book.getIsbnShort();

                    StringBuilder displayText = new StringBuilder();
                    if (isbnLong != null && !isbnLong.isEmpty()) {
                        displayText.append("ISBN-13: ").append(isbnLong);
                    }
                    if (isbnShort != null && !isbnShort.isEmpty()) {
                        if (displayText.length() > 0) {
                            displayText.append("\n");
                        }
                        displayText.append("ISBN-10: ").append(isbnShort);
                    }

                    text.setText(displayText.toString());
                    setGraphic(text);
                }
            }
        });




        statusColumn.setCellValueFactory(cellData -> cellData.getValue().statusProperty());
        statusColumn.setCellValueFactory(cellData -> {
            String status = cellData.getValue().getStatus();
            // Status in Deutsch übersetzen
            switch (status) {
                case "available":
                    return new SimpleStringProperty("Verfügbar");
                case "borrowed":
                    return new SimpleStringProperty("Ausgeliehen");
                case "reserved":
                    return new SimpleStringProperty("Reserviert");
                default:
                    return new SimpleStringProperty(status);
            }
        });
        statusDropdown.setItems(FXCollections.observableArrayList("Alle", "Verfügbar", "Ausgeliehen", "Reserviert"));
        statusDropdown.setValue("Alle");
        resultTable.setFixedCellSize(-1);
        resultTable.setStyle("-fx-table-cell-border-color: transparent;");

        resultTable.setItems(bookList);
        searchButton.setOnAction(event -> searchBook());
    }

    // Suchmethode für Bücher
    @FXML
    private void searchBook() {
        String title = titleField.getText().trim().toLowerCase();
        String author = authorField.getText().trim().toLowerCase();
        String isbn = isbnField.getText().trim().toLowerCase();
        String status = statusDropdown.getValue();
        if ("Verfügbar".equals(status)) {
            status = "available";
        } else if ("Ausgeliehen".equals(status)) {
            status = "borrowed";
        } else if ("Reserviert".equals(status)) {
            status = "reserved";
        } else {
            status = null; // "Alle" wird ignoriert
        }

        List<Book> results = bookService.searchBooks(
                title.isEmpty() ? null : title,
                author.isEmpty() ? null : author,
                isbn.isEmpty() ? null : isbn,
                status
        );

        ObservableList<Book> filteredBooks = FXCollections.observableArrayList(results);
        resultTable.setItems(filteredBooks);
    }
}
