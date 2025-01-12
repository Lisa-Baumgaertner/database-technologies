package application.controller;

import application.model.Person;
import application.service.UserService;
import javafx.fxml.FXML;
import javafx.scene.control.Label;

public class UserDetailsController {

    @FXML
    private Label nameLabel;       // Label für den Namen
    @FXML
    private Label birthDateLabel;  // Label für das Geburtsdatum
    @FXML
    private Label genderLabel;     // Label für das Geschlecht
    @FXML
    private Label roleLabel;       // Label für die Rolle

    @FXML
    private Label streetLabel;
    @FXML
    private Label houseNumberLabel;
    @FXML
    private Label cityLabel;
    @FXML
    private Label zipCodeLabel;

    @FXML
    private Label emailLabel;
    @FXML
    private Label phoneLabel;
    @FXML
    private Label mobileLabel;


    private UserService userService;

    /**
     * Setze den UserService und die Person, um die Details anzuzeigen.
     */
    public void initialize(Person person) {
        if (person != null) {
            nameLabel.setText("Name: " + person.getFirstName() + " " + person.getLastName());
            birthDateLabel.setText("Geburtsdatum: "
                    + (person.getBirthDate() != null ? person.getBirthDate().toString() : "-"));
            genderLabel.setText("Geschlecht: " + (person.getGender() == 'M' ? "Männlich" : "Weiblich"));
            roleLabel.setText("Rolle: " + person.getRole());

            // Adresse
            if (person.getAddress() != null) {
                streetLabel.setText("Straße: " + person.getAddress().getStreet());
                houseNumberLabel.setText("Hausnummer: " + person.getAddress().getHouseNumber());
                cityLabel.setText("Stadt: " + person.getAddress().getCity());
                zipCodeLabel.setText("PLZ: " + person.getAddress().getZipCode());
            }

            // Kontaktdaten
            if (person.getContact() != null) {
                emailLabel.setText("Email: " + person.getContact().getEmail());
                phoneLabel.setText("Telefon: " + person.getContact().getPhone());
                mobileLabel.setText("Mobil: " + person.getContact().getMobile());
            }
        } else {
            // Falls kein user da ist
            nameLabel.setText("Name: -");
            birthDateLabel.setText("Geburtsdatum: -");
            genderLabel.setText("Geschlecht: -");
            roleLabel.setText("Rolle: -");
        }
    }
}
