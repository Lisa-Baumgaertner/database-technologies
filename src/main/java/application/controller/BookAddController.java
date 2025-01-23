package application.controller;
import application.model.Book;
import application.model.Status;
import application.service.BookService;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;

import javax.swing.*;

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
    private TextField keyword_id;
    @FXML
    private TextField copies;
    @FXML
    private Button addButton;
    private BookService bookService;

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
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
            bookToInsert.getKeywordId().set(Integer.parseInt(keyword_id.getText().trim()));
          //  bookToInsert.setKeywordId(Integer.parseInt(keyword_id.getText().trim()));

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

        if (keyword_id.getText().trim().isEmpty() || !keyword_id.getText().trim().matches("\\d+")) {
            showAlert("Fehler","Die Keyword-ID darf nur Zahlen enthalten.\n");
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
        keyword_id.clear();
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
