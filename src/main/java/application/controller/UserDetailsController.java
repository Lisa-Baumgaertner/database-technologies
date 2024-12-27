package application.controller;

import application.service.UserService;
import application.model.Person;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;

import java.io.IOException;

public class UserDetailsController {

    @FXML
    private Label userIdLabel;
    @FXML
    private Label firstNameLabel;
    @FXML
    private Label lastNameLabel;
    @FXML
    private Label emailLabel;
    @FXML
    private Label birthDateLabel;
    @FXML
    private Label genderLabel;
    @FXML
    private Label roleLabel;

    private UserService userService;
    private Person currentUser;

    @FXML
    private BorderPane mainPane;

    public UserDetailsController() {
        userService = UserService.getInstance();
    }

     //Initialisiert die Ansicht und setzt Benutzerinformationen
    public void initialize() {
        // Aktuell eingeloggten Benutzer holen
        currentUser = userService.getCurrentlyLoggedInUser();

        if (currentUser != null) {
            // Die Labels mit den Daten des aktuellen Benutzers füllen
            userIdLabel.setText(String.valueOf(currentUser.getUserId()));
            firstNameLabel.setText(currentUser.getFirstName());
            lastNameLabel.setText(currentUser.getLastName());
            birthDateLabel.setText(currentUser.getBirthDate().toString());
            genderLabel.setText(String.valueOf(currentUser.getGender()));
            roleLabel.setText(currentUser.getRole());
        } else {
            // Fehlerfall, falls kein Benutzer eingeloggt ist
            userIdLabel.setText("Nicht angemeldet");
            firstNameLabel.setText("Unbekannt");
            lastNameLabel.setText("Unbekannt");
            emailLabel.setText("Unbekannt");
            birthDateLabel.setText("Unbekannt");
            genderLabel.setText("Unbekannt");
            roleLabel.setText("Unbekannt");
        }
    }

    /**
     * Stellt die Standardansicht wieder her.
     */
    public void showDefaultView() {
        try {
            // Standardansicht zurücksetzen
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/UserView.fxml"));
            Node defaultView = loader.load();

            // Die zentrale Ansicht des BorderPane mit der Standardansicht ersetzen
            mainPane.setCenter(defaultView);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
