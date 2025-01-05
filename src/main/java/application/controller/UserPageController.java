package application.controller;

import application.service.BookService;
import application.service.NotificationService;
import application.service.UserService;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import org.springframework.stereotype.Controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

/**
 * Controller-Klasse für die Benutzeransicht
 */

@Controller
public class UserPageController {

    public Button navigateBookSearchButton;
    @FXML
    private VBox notificationPane; // Bereich für Benachrichtigungen
    @FXML
    private BorderPane mainPane;
    private NotificationService notificationService;
    private Long currentUserId;
    private final Set<String> dismissedNotifications = new HashSet<>(); // Geschlossene Benachrichtigungen

    /**
     * Setter für den NotificationService und Benutzer-ID.
     */
    public void initializeUser(NotificationService notificationService, Long userId) {
        this.notificationService = notificationService;
        this.currentUserId = userId;
        loadNotifications(); // Lade Benachrichtigungen beim Initialisieren
    }

    /**
     * Lädt und zeigt Benachrichtigungen für den aktuellen Benutzer an.
     */
    public void loadNotifications() {
        if (notificationService == null || currentUserId == null) {
            System.out.println("NotificationService oder Benutzer-ID nicht initialisiert.");
            return;
        }

        notificationPane.getChildren().clear(); // Alte Benachrichtigungen entfernen

        // Lade Benachrichtigungen für Fälligkeit
        notificationService.getDueDateNotificationsForUser(currentUserId).forEach(message -> addNotification(message, "#ffcc00"));

        // Lade Benachrichtigungen für verfügbare Bücher
        notificationService.getAvailableBookNotificationsForUser(currentUserId).forEach(message -> addNotification(message, "#99ccff"));
    }

    /**
     * Fügt eine einzelne Benachrichtigung hinzu, wenn sie noch nicht geschlossen wurde.
     */
    private void addNotification(String message, String color) {
        if (dismissedNotifications.contains(message)) {
            return; // Nachricht wurde bereits geschlossen
        }

        // Erstelle die Nachricht
        Label label = new Label(message);
        label.setStyle("-fx-background-color: " + color + "; -fx-padding: 10px;");

        // "Schließen"-Button hinzufügen
        Button closeButton = new Button("X");
        closeButton.setStyle("-fx-background-color: red; -fx-text-fill: white;");
        closeButton.setOnAction(e -> {
            notificationPane.getChildren().remove(label); // Entferne Nachricht
            dismissedNotifications.add(message); // Speichere sie als geschlossen
        });

        // Nachricht und Button zusammenführen
        label.setGraphic(closeButton);
        label.setContentDisplay(javafx.scene.control.ContentDisplay.RIGHT);

        // Nachricht anzeigen
        notificationPane.getChildren().add(label);
    }

    /**
     * Funktion zur Navigation zur Loginansicht.
     */
    @FXML
    private void navigateToLoginView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/UserLoginView.fxml"));
            Parent loginView = loader.load();

            UserLoginController controller = loader.getController();
            controller.setUserService(UserService.getInstance());

            Scene scene = new Scene(loginView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
           Stage stage = (Stage) navigateBookSearchButton.getScene().getWindow();
           stage.setScene(scene);
        } catch (IOException e) {
            System.err.println("Fehler beim Laden der MainView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Funktion zum Laden der Buchsuchenansicht für Nutzer.
     */
    @FXML
    private void handleBookSearch() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/UserBookSearchView.fxml"));
            Parent bookSearchView = loader.load();

            mainPane.setCenter(bookSearchView);

            UserBookSearchController controller = loader.getController();
            controller.setBookService(BookService.getInstance());

        } catch (IOException e) {
            System.err.println("Fehler beim Laden der EmployeeBookSearchView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
