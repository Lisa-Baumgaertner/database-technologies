package application.controller;
import application.model.Book;
import application.model.Keyword;
import application.model.Status;
import application.service.BookService;
import application.service.KeywordService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;

import javax.swing.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller-Klasse für das Hinzufügen eines Buches
 */
public class BookAddController {

    @FXML
    private TextField isbn_long;
    @FXML
    private TextField isbn_short;
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
    private TextField keywordField;
    @FXML
    private TextField copies;
    @FXML
    private Button addKeywordButton;
    @FXML
    private ListView<String> keywordListView;
    @FXML
    private Button addButton;
    private BookService bookService;
    private  KeywordService keywordService;

    private ObservableList<Keyword> keywordList = FXCollections.observableArrayList();

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }
    public void setKeywordService(KeywordService keywordService) {
        this.keywordService = keywordService;
    }

    @FXML
    private void addKeyword() {
        String keywordText = keywordField.getText().trim();
        if (!keywordText.isEmpty() && keywordList.stream().noneMatch(k -> k.getKeyword().equalsIgnoreCase(keywordText))) {
            Keyword newKeyword = new Keyword(0, keywordText);  // ID wird später von der DB generiert
            keywordList.add(newKeyword);
            keywordListView.getItems().add(newKeyword.getKeyword());
            keywordField.clear();
        } else {
            showAlert("Fehler", "Das Stichwort ist leer oder bereits vorhanden.");
        }
    }

    /**
     * Funktion, um Felder zu prüfen und anschließend die Informationen zum Book-Objekt hinzuzufügen
     */
    @FXML
    private void addBook(){

        Book bookToInsert = new Book();
        if (!checkTextFieldsValid(bookToInsert)) {
            System.out.println("Validierung fehlgeschlagen. Bitte Eingaben überprüfen.");
            return;

        }
        try {
            bookToInsert.setIsbnLong(isbn_long.getText().trim());

            if (!isbn_short.getText().trim().isEmpty()) {
                bookToInsert.setIsbnShort(isbn_short.getText().trim());
            }

            bookToInsert.setCopies(Integer.parseInt(copies.getText().trim()));
            bookToInsert.setTitle(title.getText().trim());
            bookToInsert.setAuthor(author.getText().trim());
            bookToInsert.setPublisher(publisher.getText().trim());
            bookToInsert.setYearPublished(Integer.parseInt(year_published.getText().trim()));
            bookToInsert.setDescription(description.getText().trim());
            bookToInsert.setStatus(Status.BookStatus.valueOf(status.getText().trim().toUpperCase()));

            // Keywords verarbeiten über KeywordService
            List<Keyword> keywordObjects = new ArrayList<>();
            for (String keywordText : keywordListView.getItems()) {
                int keywordId = keywordService.getKeywordIdByName(keywordText.trim());
                if (keywordId == -1) {
                    keywordId = keywordService.insertKeyword(keywordText.trim());
                }
                keywordObjects.add(new Keyword(keywordId, keywordText.trim()));
            }

            bookToInsert.setKeywords(keywordObjects);

            // Setze das erste Keyword als Haupt-Keyword
            if (!keywordObjects.isEmpty()) {
                bookToInsert.setKeywordId(keywordObjects.get(0).getKeywordId());
            }

            // Buch in die Datenbank einfügen
            bookService.insertBook(bookToInsert);


            showAlert("Erfolg", "Buch wurde erfolgreich hinzugefügt.");
            clearAllFields();
        } catch (NumberFormatException e) {
            showAlert("Eingabefehler", "Bitte geben Sie gültige numerische Werte ein.");
        } catch (IllegalArgumentException e) {
            showAlert("Eingabefehler", "Ungültiger Statuswert.");
        }
    }

    /**
     * Prüfung, ob alle Textfelder gefüllt sind
     * und, ob die Felder, die numerische Werte enthalten müssen, diese tatsächlich enthalten
     *
     * @return boolean validTextFields
     */
    private boolean checkTextFieldsValid(Book book) {
        StringBuilder errorMessage = new StringBuilder();
        boolean validTextFields = true;

        if (isbn_long.getText().trim().isEmpty()) {
            showAlert("Fehler", "Das ISBN-13-Feld darf nicht leer sein.\n");
            validTextFields = false;
        }

        // ISBN-10 wird nur geprüft, wenn sie eingegeben wurde
        if (!isbn_short.getText().trim().isEmpty() && !book.isValidIsbn10(isbn_short.getText().trim())) {
            showAlert("Fehler", "Die eingegebene ISBN-10 ist ungültig.\n");
            validTextFields = false;
        }

        if (title.getText().trim().isEmpty()) {
            showAlert("Fehler","Das Titel-Feld darf nicht leer sein.\n");
            validTextFields = false;
        }

        if (author.getText().trim().isEmpty()) {
            showAlert("Fehler","Das Autor-Feld darf nicht leer sein.\n");
            validTextFields = false;
        }

        if (publisher.getText().trim().isEmpty()) {
            showAlert("Fehler","Das Verlags-Feld darf nicht leer sein.\n");
            validTextFields = false;
        }

        if (year_published.getText().trim().isEmpty() || !year_published.getText().trim().matches("\\d{4}")) {
            showAlert("Fehler","Das Veröffentlichungsjahr muss vier Zahlen enthalten.\n");
            validTextFields = false;
        }

        if (description.getText().trim().isEmpty()) {
            showAlert("Fehler","Das Beschreibungsfeld darf nicht leer sein.\n");
            validTextFields = false;
        }

        if (status.getText().trim().isEmpty()) {
            showAlert("Fehler","Das Statusfeld darf nicht leer sein.\n");
            validTextFields = false;
        }

        if (copies.getText().trim().isEmpty() || !copies.getText().trim().matches("\\d+")) {
            showAlert("Fehler","Das Kopien-Feld darf nur Zahlen enthalten.\n");
            validTextFields = false;
        }


        return validTextFields;
    }


    /**
     * Löschung aller Inhalte in den Textfeldern
     */
    private void clearAllFields(){
        isbn_long.clear();
        isbn_short.clear();
        title.clear();
        author.clear();
        publisher.clear();
        year_published.clear();
        description.clear();
        status.clear();
        copies.clear();

    }

    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }


}
