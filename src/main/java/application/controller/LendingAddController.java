package application.controller;
import application.model.Book;
import application.model.Lending;
import application.model.Person;
import application.service.BookService;
import application.service.LendingService;
import application.service.UserService;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.DatePicker;
import javafx.scene.control.TextField;
import javafx.util.StringConverter;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;


/**
 * Controller-Klasse für Ausleihe starten aus Sicht eines Mitarbeiters
 */
public class LendingAddController {

    @FXML
    private ComboBox<Book> bookComboBox;

    @FXML
    private ComboBox<Person> userComboBox;

    @FXML
    private TextField statusTextField;

    @FXML
    private DatePicker checkoutDatePicker;
    private Map<String, Person> nameToPersonMap;

    private LendingService lendingService;
    private UserService userService;
    private BookService bookService;

    public void setLendingService(LendingService lendingService) {
        this.lendingService = lendingService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
        loadPersonData();
    }
    public void setBookService(BookService bookService) {
        this.bookService = bookService;
        loadBookData();
    }

    /**
     * Initialisierungsmethode für Bücher
     * alle verfügbare Bücher
     */

    private void loadBookData() {
        // Bücher laden
        List<Book> books = bookService.getAllBooks();
        bookComboBox.setItems(FXCollections.observableArrayList(books));

        // Konverter, um nur den Titel des Buchs anzuzeigen
        bookComboBox.setConverter(new StringConverter<Book>() {
            @Override
            public String toString(Book book) {
                return book != null ? book.getTitle() : "";
            }

            @Override
            public Book fromString(String string) {
                return null; // Nicht benötigt
            }
        });
    }

    /**
     * Initialisierungsmethode für Bücher
     * alle verfügbare Bücher
     */

    private void loadPersonData() {
        // Benutzer laden
        List<Person> users = userService.getAllPersons();
        userComboBox.setItems(FXCollections.observableArrayList(users));

        // Konverter, um Vor- und Nachname des Benutzers anzuzeigen
        userComboBox.setConverter(new StringConverter<Person>() {
            @Override
            public String toString(Person person) {
                return person != null ? person.getFirstName() + " " + person.getLastName() : "";
            }

            @Override
            public Person fromString(String string) {
                return null; // Nicht benötigt
            }
        });
    }


    @FXML
    public void handleStartLending() {
        try {
            // Ausgewählte Werte abrufen
            Book selectedBook = bookComboBox.getValue();
            Person selectedUser = userComboBox.getValue();
            String selectedStatus = statusTextField.getText();
            LocalDate checkoutDate = checkoutDatePicker.getValue();

            // Validierung
            if (selectedBook == null || selectedUser == null || selectedStatus == null || checkoutDate == null) {
                showAlert("Fehler", "Bitte alle Felder ausfüllen.");
                return;
            }

            // IDs abrufen
            Long userId = (long) selectedUser.getUserId();
            Long bookId = (long) selectedBook.getBookId();
            Long workerId = 1L; // Beispiel: Mitarbeiter-ID kann dynamisch gesetzt werden

            // Ausleihe starten
            lendingService.addToLending(userId, workerId, bookId, selectedStatus, checkoutDate);

            // Erfolgsbenachrichtigung
            showAlert("Erfolg", "Ausleihe erfolgreich gestartet.");
        } catch (Exception e) {
            System.err.println("Ein Fehler ist aufgetreten beim Lending Starten: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setContentText(message);
        alert.showAndWait();
    }
}
