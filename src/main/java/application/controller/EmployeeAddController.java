package application.controller;

import application.model.Person;
import application.service.UserService;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.DatePicker;
import javafx.scene.control.TextField;

import java.time.LocalDate;

public class EmployeeAddController {

    @FXML
    private TextField firstNameField;
    @FXML
    private TextField lastNameField;
    @FXML
    private DatePicker birthDateField;
    @FXML
    private ComboBox<String> genderComboBox;
    @FXML
    private TextField roleField;
    private UserService userService;
    public void setUserService(UserService userService) {
        this.userService = userService;
    }


    @FXML
    public void initialize() {

    }

    /**
     * Methode zum Hinzufügen eines Mitarbeiters (Insert)
     */
    @FXML
    public void handleAddMitarbeiter() {
        Person personToInsert = new Person();
        personToInsert.setFirstName(firstNameField.getText().trim());
        personToInsert.setLastName(lastNameField.getText().trim());
        personToInsert.setBirthDate(birthDateField.getValue());
        personToInsert.setGender(genderComboBox.getSelectionModel().getSelectedItem());
        personToInsert.setRole("Worker");

        userService.insertPerson(personToInsert);
        System.out.println("Person was successfully added.");
        this.clearFields();
    }

    /**
     * Methode zum Aktualisieren eines Mitarbeiters (Update)
     */
    @FXML
    public void handleUpdateMitarbeiter() {
        String firstName = firstNameField.getText();
        String lastName = lastNameField.getText();
        LocalDate birthDate = birthDateField.getValue();
        String gender = genderComboBox.getValue();
        String role = roleField.getText();

        // Beispiel-ID: 1 (kann dynamisch gesetzt werden)
        int userId = 1; // Dies sollte durch eine Auswahl in der GUI dynamisch gesetzt werden.

        if (firstName.isEmpty() || lastName.isEmpty() || birthDate == null || gender == null || role.isEmpty()) {
            showAlert("Fehler", "Bitte alle Felder ausfüllen!", Alert.AlertType.ERROR);
            return;
        }

        Person mitarbeiter = new Person(userId, firstName, lastName, birthDate, gender.charAt(0), role);
        userService.updatePerson(mitarbeiter);
        showAlert("Erfolg", "Mitarbeiter erfolgreich aktualisiert!", Alert.AlertType.INFORMATION);
    }

    /**
     * Methode zum Löschen eines Mitarbeiters (Delete)
     */
    @FXML
    public void handleDeleteMitarbeiter() {
        // Beispiel-ID: 1 (kann dynamisch gesetzt werden)
        int userId = 1; // Dies sollte durch eine Auswahl in der GUI dynamisch gesetzt werden.

        userService.deletePerson(userId);
        showAlert("Erfolg", "Mitarbeiter erfolgreich gelöscht!", Alert.AlertType.INFORMATION);
        clearFields();
    }

    /**
     * Methode zum Anzeigen einer Benachrichtigung
     */
    private void showAlert(String title, String message, Alert.AlertType type) {
        Alert alert = new Alert(type);
        alert.setTitle(title);
        alert.setContentText(message);
        alert.showAndWait();
    }

    /**
     * Leert alle Felder nach einer erfolgreichen Aktion
     */
    private void clearFields() {
        firstNameField.clear();
        lastNameField.clear();
        birthDateField.setValue(null);
        genderComboBox.setValue(null);
    }
}
