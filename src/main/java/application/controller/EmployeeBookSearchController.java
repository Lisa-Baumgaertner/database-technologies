package application.controller;

import application.model.Book;
import application.service.BookService;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.control.*;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import javafx.scene.Scene;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller-Klasse für die Buchsuche aus Sicht eines Mitarbeiters
 */
public class EmployeeBookSearchController {

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

    private final ObservableList<Book> bookList = FXCollections.observableArrayList();

    private BookService bookService; // Service-Instanz

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }

    /**
     * Initialisierung.
     */
    @FXML
    public void initialize() {
        // Spalten mit Daten binden, wenn nötig
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


        statusColumn.setCellValueFactory(cellData -> cellData.getValue().statusProperty().asString());
        statusColumn.setCellValueFactory(cellData -> {
            String status = cellData.getValue().getStatus();
            // Status in Deutsch übersetzen
            return new SimpleStringProperty(Book.translateStatusToGerman(status));

        });
        // Deutsche Statuswerte aus der Map extrahieren (nur die Schlüssel)
        List<String> statusList = Book.STATUS_TRANSLATION_MAP.keySet()
                .stream()
                .sorted()
                .collect(Collectors.toList());
        // "Alle" als Option hinzufügen
        statusList.add(0, "Alle");

        // Die Statuswerte in die ComboBox setzen
        statusDropdown.setItems(FXCollections.observableArrayList(statusList));
        statusDropdown.setValue("Alle");

        resultTable.setFixedCellSize(-1);
        resultTable.setStyle("-fx-table-cell-border-color: transparent;");

        resultTable.setItems(bookList);
        searchButton.setOnAction(event -> searchBook());

        //Zeilenklick
        resultTable.setRowFactory(tv -> {
            TableRow<Book> row = new TableRow<>();
            row.setOnMouseClicked(event -> {
                if (event.getClickCount() == 2 && !row.isEmpty()) { // Bei Doppelklick
                    handleRowClick();
                }
            });
            return row;
        });
    }

    /**
     * Funktion, um ein Buch zu suchen.
     */
    @FXML
    private void searchBook() {
        String title = titleField.getText().trim().toLowerCase();
        String author = authorField.getText().trim().toLowerCase();
        String isbn = isbnField.getText().trim().toLowerCase();

        String selectedStatus = statusDropdown.getValue();
        selectedStatus = selectedStatus.trim();
        String status = (selectedStatus == null || selectedStatus.equals("Alle"))
                ? null
                : Book.translateStatusToEnglish(selectedStatus);

        List<Book> results = bookService.searchBooks(
                title.isEmpty() ? null : title,
                author.isEmpty() ? null : author,
                isbn.isEmpty() ? null : isbn,
                status
        );
        // Tabelle mit gefilterten Ergebnissen aktualisieren
        resultTable.setItems(FXCollections.observableArrayList(results));
    }

    /**
     * Funktion für das Handling eines Klicks.
     * Lädt die Detailansicht.
     */
    @FXML
    private void handleRowClick() {
        Book selectedBook = resultTable.getSelectionModel().getSelectedItem();

        if (selectedBook != null) {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookDetailsView.fxml"));
                Scene detailsScene = new Scene(loader.load());

                BookDetailsController controller = loader.getController();
                controller.setBookDetails(selectedBook);

                Stage detailsStage = new Stage();
                detailsStage.setTitle("Buchdetails");
                detailsStage.setScene(detailsScene);
                detailsStage.show();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
