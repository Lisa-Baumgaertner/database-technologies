package application.controller;
import application.config.DatabaseConfig;
import application.model.Person;
import application.repository.NotificationRepository;
import application.repository.UserRepository;
import application.service.BookService;
import application.service.NotificationService;
import application.service.UserService;
import javafx.collections.ObservableList;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.fxml.FXML;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

import java.awt.event.ActionEvent;
import java.io.IOException;
import java.util.Objects;

/**
 * Controller-Klasse für Login eines Nutzers.
 */
public class UserLoginController {
    @FXML
    private BorderPane mainPane;
    @FXML
    private TextField usernameField;

    @FXML
    private TextField passwordField;

    @FXML
    private Button loginButton;
    private UserService userService;
    NotificationRepository notificationRepository;

    /**
     * Setter für UserService.
     * @param userService
     */
    public void setUserService(UserService userService) {
        this.userService = userService;
        if (userService == null) {
            System.out.println("UserService ist tatsächlich null!");
        } else {
            System.out.println("UserService ist nicht null: " + userService);
        }
        loadFirstBorrower();
    }

    /**
     * Funktion zum Laden des ersten Benutzers mit der Rolle "Borrower".
     */
    private void loadFirstBorrower() {
        if (userService == null) {
            System.out.println("UserService nicht initialisiert.");
            return;
        }

        Person borrower = userService.getFirstBorrower();
       System.out.println(borrower);
        if (borrower != null) {
            // Benutzername anzeigen
            String fullName = borrower.getFirstName() + " " + borrower.getLastName();
            usernameField.setText(fullName);
            usernameField.setEditable(false);

            // Passwortfeld mit Sternen füllen
            passwordField.setText("********");
            passwordField.setEditable(false);
        } else {
            // Kein Benutzer gefunden
            usernameField.setText("Kein Benutzer gefunden");
            usernameField.setEditable(false);
            passwordField.setText("");
            passwordField.setEditable(false);
        }
    }

    /**
     * Funktion zur Handhabung von Klick auf den Login-Button.
     */
    @FXML
    private void handleLoginButtonAction() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/UserView.fxml"));
            Parent root = loader.load();

            // Zeige die neue Ansicht im Center-Bereich
          //  mainPane.setCenter(root);

             UserPageController userPageController = loader.getController();

            // NotificationRepository aus DatabaseConfig laden
            DatabaseConfig databaseConfig = new DatabaseConfig();
            NotificationRepository notificationRepository = databaseConfig.getNotificationRepository();

            // NotificationService erstellen
            NotificationService notificationService = new NotificationService(notificationRepository);

            // Übergabe der NotificationService-Instanz und der Benutzer-ID
            Long userId = UserService.getInstance().getFirstBorrower().getUserId(); // Testperson
            userPageController.initializeUser(notificationService, UserService.getInstance(), userId);

            Scene scene = new Scene(root, 1100, 1000);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) loginButton.getScene().getWindow();
            stage.setScene(scene);

        }  catch (IOException e) {
            e.printStackTrace();
            System.out.println("Fehler beim Laden von UserView.fxml.");
        }
    }
}
