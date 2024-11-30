package application.controller;
import application.service.BookService;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import application.model.Book;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;

import java.util.List;


public class BookEditController {
    @FXML
    private TextField editBookIdField;
    @FXML
    private TextField editTitleField;
    @FXML
    private TextField editAuthorField;
    @FXML
    private TextField editIsbnLongField;
    @FXML
    private TextField editIsbnShortField;
    @FXML
    private TextField editCopiesField;
    @FXML
    private TextField editPublisherField;
    @FXML
    private TextField editYearPublisherField;
    @FXML
    private TextField editDescriptionField;
    @FXML
    private ComboBox<String> editStatusDropdown;
    @FXML
    private TextField titleField;
    @FXML
    private TextField authorField;
    @FXML
    private TextField isbnField;
    @FXML
    private ComboBox<String> statusDropdown;

    @FXML
    private TableColumn<Book, String> titleColumn;

    @FXML
    private TableColumn<Book, String> isbnColumn;

    @FXML
    private TableColumn<Book, String> authorColumn;

    @FXML
    private TableColumn<Book, String> statusColumn;


    @FXML
    private TableView<Book> resultsTable;
    @FXML
    private TableColumn<Book, Void> actionColumn;
       @FXML
    private VBox editFields;
    private Book selectedBook;

    private final ObservableList<Book> bookList = FXCollections.observableArrayList();

    private BookService bookService;


    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }

    @FXML
    public void initialize() {
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
        actionColumn.setCellFactory(param -> new TableCell<>() {
            private final Button editButton = new Button("Bearbeiten");

            {

                editButton.setOnAction(event -> {
                    Book book = getTableView().getItems().get(getIndex());
                    loadBookDetails(book);
                });
            }

            @Override
            protected void updateItem(Void item, boolean empty) {
                super.updateItem(item, empty);
                if (empty) {
                    setGraphic(null);
                } else {
                    setGraphic(editButton);
                }
            }
        });

        statusColumn.setCellValueFactory(cellData -> cellData.getValue().statusProperty());
        statusColumn.setCellValueFactory(cellData -> {
            String status = cellData.getValue().getStatus();
            return new SimpleStringProperty(Book.translateStatusToGerman(status));
        });

        statusDropdown.setItems(FXCollections.observableArrayList("Alle", "Verfügbar", "Ausgeliehen", "Reserviert"));
        statusDropdown.setValue("Alle");

        resultsTable.setItems(bookList);
    }

    @FXML
    private  void searchBook() {
        String title = titleField.getText().trim().toLowerCase();
        String author = authorField.getText().trim().toLowerCase();
        String isbn = isbnField.getText().trim().toLowerCase();
        String status = statusDropdown.getValue();
        String translatedStatus = "Alle".equals(status) ? null : Book.translateStatusToEnglish(status);


        List<Book> results = bookService.searchBooks(
                title.isEmpty() ? null : title,
                author.isEmpty() ? null : author,
                isbn.isEmpty() ? null : isbn,
                translatedStatus
        );

        bookList.setAll(results);
    }

    private boolean checkTextFieldsValid() {
        StringBuilder errorMessage = new StringBuilder();

        if (editBookIdField.getText() == null || editBookIdField.getText().trim().isEmpty()) {
            errorMessage.append("Buch-ID darf nicht leer sein.\n");
        }

        if (editTitleField.getText() == null || editTitleField.getText().trim().isEmpty()) {
            errorMessage.append("Titel darf nicht leer sein.\n");
        }

        if (editAuthorField.getText() == null || editAuthorField.getText().trim().isEmpty()) {
            errorMessage.append("Autor darf nicht leer sein.\n");
        }

        String isbnLong = editIsbnLongField.getText();
        if (isbnLong == null || isbnLong.trim().isEmpty()) {
            errorMessage.append("ISBN-13 darf nicht leer sein.\n");
        } else if (!new Book().isValidIsbn13(isbnLong)) {
            errorMessage.append("Ungültige ISBN-13.\n");
        }

        String isbnShort = editIsbnShortField.getText();
        if (isbnShort != null && !isbnShort.trim().isEmpty()) {
            if (!new Book().isValidIsbn10(isbnShort)) {
                errorMessage.append("Ungültige ISBN-10.\n");
            }
        }

        try {
            int copies = Integer.parseInt(editCopiesField.getText().trim());
            if (copies <= 0) {
                errorMessage.append("Exemplare müssen eine positive Zahl sein.\n");
            }
        } catch (NumberFormatException e) {
            errorMessage.append("Exemplare müssen eine gültige Zahl sein.\n");
        }

        if (editPublisherField.getText() == null || editPublisherField.getText().trim().isEmpty()) {
            errorMessage.append("Verlag darf nicht leer sein.\n");
        }

        try {
            int year = Integer.parseInt(editYearPublisherField.getText().trim());
            int currentYear = java.time.Year.now().getValue();
            if (year < 1000 || year > currentYear) {
                errorMessage.append("Jahr muss zwischen 1000 und ").append(currentYear).append(" liegen.\n");
            }
        } catch (NumberFormatException e) {
            errorMessage.append("Jahr muss eine gültige Zahl sein.\n");
        }

        if (editDescriptionField.getText() == null || editDescriptionField.getText().trim().isEmpty()) {
            errorMessage.append("Beschreibung darf nicht leer sein.\n");
        }

        if (!errorMessage.isEmpty()) {
            showErrorDialog("Ungültige Eingaben", errorMessage.toString());
            return false;
        }

        return true;
    }


    private void loadBookDetails(Book book) {
        if (book != null) {
            selectedBook = book;

            editBookIdField.setText(String.valueOf(book.getBookId()));
            editTitleField.setText(book.getTitle());
            editAuthorField.setText(book.getAuthor());
            editIsbnLongField.setText(book.getIsbnLong());
            editIsbnShortField.setText(book.getIsbnShort());
            editCopiesField.setText(String.valueOf(book.getCopies()));
            editPublisherField.setText(book.getPublisher());
            editYearPublisherField.setText(String.valueOf(book.getYearPublished()));
            editDescriptionField.setText(book.getDescription());
            editStatusDropdown.setValue(Book.translateStatusToGerman(book.getStatus()));

            editFields.setVisible(true);
            editFields.setManaged(true);
        }
    }

    @FXML
    private void saveChanges() {
        if (!checkTextFieldsValid()) {
            return;
        }

        if (bookService.isIsbnDuplicate(
                editIsbnLongField.getText().trim(),
                editIsbnShortField.getText().trim(),
                selectedBook.getBookId()
        )) {
            showErrorDialog("Duplikat gefunden", "ISBN-13 oder ISBN-10 existiert bereits in der Datenbank.");
            return;
        }

        selectedBook.setTitle(editTitleField.getText());
        selectedBook.setAuthor(editAuthorField.getText());
        selectedBook.setIsbnLong(editIsbnLongField.getText());
        selectedBook.setIsbnShort(editIsbnShortField.getText());
        selectedBook.setCopies(Integer.parseInt(editCopiesField.getText()));
        selectedBook.setPublisher(editPublisherField.getText());
        selectedBook.setYearPublished(Integer.parseInt(editYearPublisherField.getText()));
        selectedBook.setDescription(editDescriptionField.getText());

        String germanStatus = editStatusDropdown.getValue();
        String englishStatus = Book.translateStatusToEnglish(germanStatus);
        selectedBook.setStatus(englishStatus);

        bookService.updateBook(selectedBook);
        resultsTable.refresh();
        cancelEdit();

        System.out.println("Änderungen wurden erfolgreich gespeichert.");

    }

    @FXML
    private void cancelEdit() {
        editFields.setVisible(false);
        editFields.setManaged(false);
        selectedBook = null;
    }

    private void showErrorDialog(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }


}
