package application.controller;

import application.model.Waitlist;
import application.service.BookService;
import application.service.UserService;
import application.service.WaitlistService;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;

public class WaitlistController {

    private UserService userService;
    private BookService bookService;
    private WaitlistService waitlistService;

    @FXML
    private TableView<Waitlist> waitlistTable;
    @FXML
    private TableColumn<Waitlist, Long> columnWaitlistId;
    @FXML
    private TableColumn<Waitlist, String> columnBookTitle;
    @FXML
    private TableColumn<Waitlist, String> columnUserName;
    @FXML
    private TableColumn<Waitlist, LocalDate> columnCheckoutDate;
    @FXML
    private TableColumn<Waitlist, Integer> columnPriority;
    @FXML
    private TableColumn<Waitlist, String> columnStatus;
    @FXML
    private Button btnRemoveUser;


    private ObservableList<Waitlist> waitlistData = FXCollections.observableArrayList();

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }

    public void setWaitlistService(WaitlistService waitlistService) {
        this.waitlistService = waitlistService;
        if (this.waitlistService != null) {
            loadWaitlistData();  // Erst hier die Daten laden
        }
        System.out.println("WaitlistService gesetzt: " + waitlistService);
    }

    /**
     * Initialisierungsmethode
     */
    public void initialize() {
        System.out.println("Initialize aufgerufen: WaitlistService = " + waitlistService);

        columnWaitlistId.setCellValueFactory(data ->
                new SimpleObjectProperty<>(data.getValue().getWaitlistId()));

        columnBookTitle.setCellValueFactory(data -> new SimpleStringProperty(data.getValue().getBook().getTitle()));
        columnUserName.setCellValueFactory(data -> new SimpleStringProperty(
                data.getValue().getUser().getFirstName() + " " + data.getValue().getUser().getLastName())
        );
        columnPriority.setCellValueFactory(cellData -> {
            Waitlist entry = cellData.getValue();
            int priority = calculatePriority(entry);
            return new SimpleObjectProperty<>(priority);
        });
        columnCheckoutDate.setCellValueFactory(data -> new SimpleObjectProperty<>(data.getValue().getCheckoutDate()));
        columnStatus.setCellValueFactory(data -> new SimpleStringProperty(data.getValue().getStatus()));
    }

    /**
     * Berechnet die Priorität basierend auf dem Ausleihdatum
     */
    private int calculatePriority(Waitlist entry) {
        //Alle Wartelisteinträge für dasselbe Buch
        List<Waitlist> sortedWaitlist = waitlistService.getWaitlistForBook(entry.getBook().getBookId());
        System.out.println("Sorted Waitlist: " + sortedWaitlist.toString());
        // Sortiere die Einträge nach dem Ausleihdatum (checkoutDate) aufsteigend

        sortedWaitlist.sort(Comparator.comparing(Waitlist::getCheckoutDate));

        // Durchlaufe die sortierte Liste und finde die Position des aktuellen Eintrags
        for (int i = 0; i < sortedWaitlist.size(); i++) {
            // Vergleiche die IDs direkt (bei primitiven long kannst du == verwenden)
            if (sortedWaitlist.get(i).getWaitlistId().equals(entry.getWaitlistId())) {
                return i + 1;  // Position als Priorität (1-basiert)
            }
        }

        return -1;  // Falls der Eintrag nicht gefunden wird
    }


    /**
     * Methode zum Laden der Warteliste-Daten in die Tabelle
     */
    private void loadWaitlistData() {
        if (waitlistService == null) {
            System.err.println("Fehler: waitlistService ist null.");
            return;
        }
        System.out.println("Result feom controller= " + waitlistService.getAllWaitlistEntries());
        waitlistTable.getItems().setAll(waitlistService.getAllWaitlistEntries());
    }


    /**
     * Methode zum Entfernen eines Benutzers aus der Warteliste
     */
    @FXML
    private void removeUserFromWaitlist() {
        Waitlist selectedEntry = waitlistTable.getSelectionModel().getSelectedItem();
        if (selectedEntry != null) {
            waitlistService.removeFromWaitlist(selectedEntry.getWaitlistId());
            loadWaitlistData();  // Aktualisiere die Tabelle nach dem Entfernen
        } else {
            showErrorAlert("Bitte wählen Sie einen Eintrag aus der Liste.");
        }
    }

    /**
     * Methode zum Erhöhen der Priorität (Ausleihdatum älter machen)
     */
    @FXML
    private void increasePriority() {
        Waitlist selectedEntry = waitlistTable.getSelectionModel().getSelectedItem();
        if (selectedEntry != null) {
            LocalDate oldCheckoutDate = selectedEntry.getCheckoutDate();
            LocalDate newCheckoutDate = oldCheckoutDate.minusDays(1);  // Datum um einen Tag älter machen

            selectedEntry.setCheckoutDate(newCheckoutDate);
            waitlistService.updateCheckoutDate(selectedEntry.getWaitlistId(), newCheckoutDate);

            loadWaitlistData();  // Tabelle aktualisieren
            showInfoAlert("Priorität wurde erhöht (Datum älter gemacht).");
        } else {
            showErrorAlert("Bitte wählen Sie einen Eintrag aus der Liste aus.");
        }
    }

    /**
     * Methode zum Verringern der Priorität (Ausleihdatum neuer machen)
     */
    @FXML
    private void decreasePriority() {
        Waitlist selectedEntry = waitlistTable.getSelectionModel().getSelectedItem();
        if (selectedEntry != null) {
            LocalDate oldCheckoutDate = selectedEntry.getCheckoutDate();
            LocalDate newCheckoutDate = oldCheckoutDate.plusDays(1);  // Datum um einen Tag neuer machen

            selectedEntry.setCheckoutDate(newCheckoutDate);
            waitlistService.updateCheckoutDate(selectedEntry.getWaitlistId(), newCheckoutDate);

            loadWaitlistData();  // Tabelle aktualisieren
            showInfoAlert("Priorität wurde verringert (Datum neuer gemacht).");
        } else {
            showErrorAlert("Bitte wählen Sie einen Eintrag aus der Liste aus.");
        }
    }

    /**
     * Hilfsmethode zur Anzeige einer Fehlermeldung
     */
    private void showErrorAlert(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Fehler");
        alert.setContentText(message);
        alert.showAndWait();
    }

    /**
     * Hilfsmethode zur Anzeige einer Info-Meldung
     */
    private void showInfoAlert(String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Information");
        alert.setContentText(message);
        alert.showAndWait();
    }
}
