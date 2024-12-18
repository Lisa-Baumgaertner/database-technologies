package application.controller;

import application.service.NotificationService;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;

public class NotificationController {
    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    public void showNotificationsForUser(VBox notificationPane, Long userId) {
        notificationPane.getChildren().clear();

        notificationService.getDueDateNotificationsForUser(userId).forEach(message -> {
            Label label = new Label(message);
            label.setStyle("-fx-background-color: #ffcc00; -fx-padding: 10px;");
            notificationPane.getChildren().add(label);
        });

        notificationService.getAvailableBookNotificationsForUser(userId).forEach(message -> {
            Label label = new Label(message);
            label.setStyle("-fx-background-color: #99ccff; -fx-padding: 10px;");
            notificationPane.getChildren().add(label);
        });
    }
}
