package application.controller;

import application.model.Lending;
import application.service.BookService;
import application.service.LendingService;
import application.service.UserService;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;

import java.util.List;

/**
 * Controller-Klasse zur Verwaltung der Ansicht für ausgeliehene Bücher.
 * Ermöglicht Suchen, Filtern und die Verlängerung der Rückgabefrist.
 */

public class LendingController {

    private LendingService lendingService;
    private UserService userService;
    private BookService bookService;

    @FXML
    private TableView<Lending> lendingTable;

    @FXML
    private TableColumn<Lending, String> bookTitleColumn;

    @FXML
    private TableColumn<Lending, String> userNameColumn;

    @FXML
    private TableColumn<Lending, String> statusColumn;

    @FXML
    private TableColumn<Lending, String> dueDateColumn;
    @FXML
    private TableColumn<Lending, String> categoryColumn;

    @FXML
    private TableColumn<Lending, String> checkoutDateColumn;
    @FXML
    private TextField searchUserField;

    @FXML
    private ComboBox<String> filterComboBox;

    @FXML
    private ComboBox<String> categoryComboBox;
    @FXML
    private ComboBox<String> availabilityComboBox;

    private final ObservableList<Lending> lendingData = FXCollections.observableArrayList();


    public void setLendingService(LendingService lendingService) {
        this.lendingService = lendingService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }


    /**
     * Initialisiert die Spalten in der Tabelle.
     */
    @FXML
    private void initialize() {
        // Benutzername (firstname + lastname) anzeigen
        if (userNameColumn == null) {
            System.out.println("userNameColumn ist null");
        } else {
            userNameColumn.setCellValueFactory(cellData -> new SimpleStringProperty(userService.getUserNameById(cellData.getValue().getUserIdBorrower())));
        }
       // Buchtitel anzeigen (book -> title)

        if (bookTitleColumn == null) {
            System.out.println("bookTitleColumn ist null");
        } else {
            bookTitleColumn.setCellValueFactory(cellData -> new SimpleStringProperty(bookService.getBookTitleById(cellData.getValue().getBookId())));
        }


        // Status direkt anzeigen
        if (statusColumn == null) {
            System.out.println("statusColumn ist null");
        } else {
            statusColumn.setCellValueFactory(new PropertyValueFactory<>("status"));
        }



        // Ausleihdatum anzeigen
        checkoutDateColumn.setCellValueFactory(cellData -> {
            if (cellData.getValue().getCheckoutDate() != null) {
                return new SimpleStringProperty(cellData.getValue().getCheckoutDate().toString());
            }
            return null;
        });

        // Rückgabedatum anzeigen
        dueDateColumn.setCellValueFactory(cellData -> {
            if (cellData.getValue().getReturnDate() != null) {
                return new SimpleStringProperty(cellData.getValue().getReturnDate().toString());
            }
            return null;
        });

        if (categoryColumn == null) {
            System.out.println("categoryColumn ist null");
        } else {
            categoryColumn.setCellValueFactory(cellData -> new SimpleStringProperty(bookService.getCategoryByBookId(cellData.getValue().getBookId())));
        }

        // Kategorie-Dropdown anzeigen
        filterComboBox.valueProperty().addListener((observable, oldValue, newValue) -> {
            if ("Kategorie".equals(newValue)) {
                // Zeige die Kategorie-Dropdown-Liste an und lade Keywords
                categoryComboBox.setVisible(true);
                loadCategoryDropdown();
            } else {
                categoryComboBox.setVisible(false);
            }

            // Zeige die Kategorie-Dropdown-Liste an und lade Keywords
            if ("Verfügbarkeit".equals(newValue)) {
                categoryComboBox.setVisible(false);
                availabilityComboBox.setVisible(true);
                availabilityComboBox.setItems(FXCollections.observableArrayList("borrowed", "returned"));
            }

        });
        // Verfügbarkeit-Dropdown anzeigen
        lendingTable.setItems(lendingData);
    }

    /**
     * Wird aufgerufen, wenn der Mitarbeiter den "Anzeigen"-Button klickt.
     * Ruft die Ausleihen eines Benutzers aus der Datenbank ab und zeigt sie in der Tabelle an.
     */
    @FXML
    private void handleSearchUser() {

        if (lendingService == null) {
            showAlert("Fehler", "Der LendingService wurde nicht initialisiert.");
            return;
        }

        String userName = searchUserField.getText();
        if (userName == null || userName.trim().isEmpty()) {
            showAlert("Ungültige Eingabe", "Bitte geben Sie einen Benutzernamen ein.");
            return;
        }

        try {
            // Suche nach Benutzer basierend auf Namen
            List<Lending> lendingList = lendingService.getLendingForUserByName(userName);
            if (lendingList.isEmpty()) {
                showAlert("Keine Daten", "Keine Ausleihen für den Benutzer gefunden.");
                lendingTable.setItems(FXCollections.observableArrayList()); // Tabelle leeren
            } else {
                lendingTable.setItems(FXCollections.observableArrayList(lendingList)); // Tabelle befüllen
            }
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Fehler", "Es gab ein Problem bei der Suche nach Ausleihen.");
        }
    }
    /**
     * Wird aufgerufen, wenn der Mitarbeiter die Rückgabefrist eines Buches verlängern möchte.
     * Überprüft die Bedingungen und verlängert die Frist, falls zulässig.
     */
    @FXML
    private void handleExtendDueDate() {
        Lending selectedLending = lendingTable.getSelectionModel().getSelectedItem();
        if (selectedLending == null) {
            showAlert("Fehler", "Bitte wählen Sie eine Ausleihe aus der Tabelle aus.");
            return;
        }

        try {
            boolean extended = lendingService.extendDueDate(selectedLending.getLendingId());
            if (extended) {
                showAlert("Erfolg", "Die Rückgabefrist wurde erfolgreich verlängert.");
               lendingTable.refresh();
            } else {
                showAlert("Fehler", "Die Rückgabefrist kann nicht weiter verlängert werden.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Fehler", "Es gab ein Problem bei der Verlängerung der Rückgabefrist.");
        }
    }

    /**
     * Wird aufgerufen, wenn der Mitarbeiter einen Filter anwenden möchte.
     * Wendet den ausgewählten Filter auf die Ausleihen-Daten in der Tabelle an.
     */
    @FXML
    private void handleFilter() {
    String selectedFilter = filterComboBox.getSelectionModel().getSelectedItem();
        if (selectedFilter == null || selectedFilter.trim().isEmpty()) {
            showAlert("Ungültige Auswahl", "Bitte wählen Sie ein Filterkriterium aus.");
            return;
        }

        try {
            List<Lending> filteredList;
            switch (selectedFilter) {
                case "Rückgabedatum":
                    filteredList = lendingService.filterByDueDate();
                    break;
                case "Kategorie":
                    String selectedCategory = categoryComboBox.getSelectionModel().getSelectedItem();
                    if (selectedCategory == null || selectedCategory.trim().isEmpty()) {
                        showAlert("Ungültige Auswahl", "Bitte wählen Sie eine Kategorie aus.");
                        return;
                    }
                    filteredList = lendingService.filterByCategory(selectedCategory);
                    break;
                case "Verfügbarkeit":
                    String selectedAvailability = availabilityComboBox.getSelectionModel().getSelectedItem();
                    if (selectedAvailability == null || selectedAvailability.trim().isEmpty()) {
                        showAlert("Ungültige Auswahl", "Bitte wählen Sie einen Verfügbarkeitsstatus aus.");
                        return;
                    }
                    filteredList = lendingService.filterByAvailability(selectedAvailability);
                    break;
                default:
                    showAlert("Fehler", "Ungültiges Filterkriterium.");
                    return;
            };

            lendingTable.setItems(FXCollections.observableArrayList(filteredList));
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Fehler", "Es gab ein Problem beim Anwenden des Filters.");
        }

    }

    /**
     * Lade alle Keywords in die Kategorie-Dropdown-Liste
     */
    private void loadCategoryDropdown() {
        if (lendingService == null) {
            showAlert("Fehler", "Der LendingService wurde nicht initialisiert.");
            return;
        }

        try {
            List<String> keywords = lendingService.getAllKeywords();
            categoryComboBox.setItems(FXCollections.observableArrayList(keywords));
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Fehler", "Es gab ein Problem beim Laden der Kategorien.");
        }
    }


    /**
     * Zeigt eine Alert-Box an.
     *
     * @param title   Titel des Alerts.
     * @param message  Header des Alerts.
     */
    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setContentText(message);
        alert.showAndWait();
    }
}
