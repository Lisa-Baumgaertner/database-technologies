package application.controller;

import application.model.Lending;
import application.service.BookService;
import application.service.LendingService;
import application.service.UserService;
import application.service.WaitlistService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;

import java.util.List;

public class UserWaitlistController {

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
    private WaitlistService waitlistService;


    public void setWaitlistService(WaitlistService waitlistService) {
        this.waitlistService = waitlistService;
    }


    @FXML
    private void handleSearchUserWaitlist() {

//        if (waitlistService == null) {
//            showAlert("Fehler", "Der LendingService wurde nicht initialisiert.");
//            return;
//        }
//
//        String userName = searchUserField.getText();
//        if (userName == null || userName.trim().isEmpty()) {
//            showAlert("Ungültige Eingabe", "Bitte geben Sie einen Benutzernamen ein.");
//            return;
//        }
//
//        try {
//            // Suche nach Benutzer basierend auf Namen
//            List<Lending> lendingList = waitlistService.getLendingForUserByName(userName);
//            if (lendingList.isEmpty()) {
//                showAlert("Keine Daten", "Keine Ausleihen für den Benutzer gefunden.");
//                lendingTable.setItems(FXCollections.observableArrayList()); // Tabelle leeren
//            } else {
//                lendingTable.setItems(FXCollections.observableArrayList(lendingList)); // Tabelle befüllen
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            showAlert("Fehler", "Es gab ein Problem bei der Suche nach Ausleihen.");
//        }
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
