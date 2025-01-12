package application.model;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

import java.time.LocalDate;


/**
 * Modellklasse für eine Person in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Nutzer-Id, Namen, Geschlecht und Rolle.
 */
public class Person {

    private IntegerProperty userId;
    private StringProperty firstName;
    private StringProperty lastName;
    private LocalDate birthDate;
    private char gender;
    private StringProperty role;


    /**
     * Standardkonstruktor für Person.
     * Initialisiert alle Properties mit Standardwerten.
     */
    public Person() {
        this.userId = new SimpleIntegerProperty();
        this.firstName = new SimpleStringProperty();
        this.lastName = new SimpleStringProperty();
        this.birthDate = null;
        this.gender = 'M';
        this.role = new SimpleStringProperty();
    }

    /**
     * Konstruktor für Person mit allen Attributen.
     * @param userId
     * @param firstName
     * @param lastName
     * @param birthDate
     * @param gender
     * @param role
     */
    public Person(Integer userId, String firstName, String lastName, LocalDate birthDate, char gender, String role) {
        this.userId = new SimpleIntegerProperty(userId);
        this.firstName = new SimpleStringProperty(firstName);
        this.lastName = new SimpleStringProperty(lastName);
        this.birthDate = birthDate;
        this.gender = gender;
        this.role = new SimpleStringProperty(role);
    }

    // Getter und Setter für Properties

    public IntegerProperty userIdProperty() {
        return userId;
    }

    /**
     * Holt die Nutzer-Id
     * @return userId
     */
    public Long getUserId() {
        return (long) userId.get();
    }

    public void setUserId(int userId) {
        this.userId.set(userId);
    }

    public StringProperty firstNameProperty() {
        return firstName;
    }

    /**
     * Holt den Vornamen
     * @return firstName
     */
    public String getFirstName() {
        return firstName.get();
    }

    public void setFirstName(String firstName) {
        this.firstName.set(firstName);
    }


    public StringProperty lastNameProperty() {
        return lastName;
    }

    /**
     * Holt den Nachnamen
     * @return lastName
     */
    public String getLastName() {
        return lastName.get();
    }

    public void setLastName(String lastName) {
        this.lastName.set(lastName);
    }

    /**
     * Holt das Geburtsdatum
     * @return bithDate
     */
    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    /**
     * Holt das Geschlecht
     * @return gender
     */
    public char getGender() {
        return gender;
    }

    public void setGender(char gender) {
        if (gender == 'M' || gender == 'F') {
            this.gender = gender;
        } else {
            throw new IllegalArgumentException("Gender must be 'M' or 'F'.");
        }
    }
    public StringProperty roleProperty() {
        return role;
    }

    /**
     * Holt die Rolle
     * @return role
     */
    public String getRole() {
        return role.get();
    }

    public void setRole(String role) {
        this.role.set(role);
    }
}
