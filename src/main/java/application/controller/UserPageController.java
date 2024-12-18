package application.controller;

import application.service.NotificationService;
import application.service.UserService;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import org.springframework.stereotype.Controller;

import java.util.HashSet;
import java.util.Set;

@Controller
public class UserPageController {
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
}
