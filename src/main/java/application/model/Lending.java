package application.model;

import javafx.beans.property.*;

import java.time.LocalDate;

/**
 * Modellklasse für eine Ausleihe in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Benutzer, Buch, Status und Termine.
 */
public class Lending {

    private final IntegerProperty lendingId;
    private final ObjectProperty<Person> user;
    private final ObjectProperty<Person> role;
    private final ObjectProperty<Book> book;
    private final ObjectProperty<LocalDate> checkoutDate;
    private final ObjectProperty<LocalDate> returnDate;
    private final StringProperty status;


    /**
     * Standardkonstruktor für Lending.
     * Initialisiert alle Properties mit Standardwerten.
     */
    public Lending() {
        this.role =new SimpleObjectProperty<>();
        this.lendingId = new SimpleIntegerProperty();
        this.user = new SimpleObjectProperty<>();
        this.book = new SimpleObjectProperty<>();
        this.checkoutDate = new SimpleObjectProperty<>();
        this.returnDate = new SimpleObjectProperty<>();
        this.status = new SimpleStringProperty("borrowed");
    }

    /**
     * Konstruktor für Lending mit allen Attributen.
     *
     * @param user         Der Benutzer, der die Ausleihe tätigt.
     * @param role         Die Rolle des Benutzers.
     * @param book         Das ausgeliehene Buch.
     * @param checkoutDate Das Datum der Ausleihe.
     * @param returnDate   Das Datum der Rückgabe.
     * @param status       Der Status der Ausleihe.
     */
    public Lending(Person user, Person role, Book book, LocalDate checkoutDate, LocalDate returnDate, String status) {
        this.role = new SimpleObjectProperty<>(role);
        this.lendingId = new SimpleIntegerProperty();
        this.user = new SimpleObjectProperty<>(user);
        this.book = new SimpleObjectProperty<>(book);
        this.checkoutDate = new SimpleObjectProperty<>(checkoutDate);
        this.returnDate = new SimpleObjectProperty<>(returnDate);
        this.status = new SimpleStringProperty(status);
    }

    // Getter und Setter für Properties

    public IntegerProperty lendingIdProperty() {
        return lendingId;
    }

    /**
     * Holt die ID der Ausleihe.
     *
     * @return Die ID der Ausleihe.
     */

    public int getLendinglistId() {
        return lendingId.get();
    }

    public void setLendinglistId(int waitlistId) {
        this.lendingId.set(waitlistId);
    }
    public ObjectProperty<Person> userProperty() {
        return user;
    }
    /**
     * Holt den Benutzer, der die Ausleihe tätigt.
     *
     * @return Der Benutzer der Ausleihe.
     */


    public Person getUser() {
        return user.get();
    }

    public void setUser(Person user) {
        this.user.set(user);
    }
    public ObjectProperty<Book> bookProperty() {
        return book;
    }

    /**
     * Holt das Buch, das ausgeliehen wurde.
     *
     * @return Das Buch der Ausleihe.
     */
    public Book getBook() {
        return book.get();
    }

    public void setBook(Book book) {
        this.book.set(book);
    }
    /**
     * Holt das Datum der Ausleihe.
     *
     * @return Das Datum der Ausleihe.
     */
    public ObjectProperty<LocalDate> checkoutDateProperty() {
        return checkoutDate;
    }

    public LocalDate getCheckoutDate() {
        return checkoutDate.get();
    }

    public void setCheckoutDate(LocalDate checkoutDate) {
        this.checkoutDate.set(checkoutDate);
    }

    /**
     * Holt das Datum der Rückgabe.
     *
     * @return Das Datum der Rückgabe.
     */
    public ObjectProperty<LocalDate> returnDateProperty() {
        return returnDate;
    }

    public LocalDate getReturnDate() {
        return returnDate.get();
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate.set(returnDate);
    }

    /**
     * Holt den Status der Ausleihe.
     *
     * @return Der Status der Ausleihe.
     */
    public StringProperty statusProperty() {
        return status;
    }

    public String getStatus() {
        return status.get();
    }

    public void setStatus(String status) {
        this.status.set(status);
    }

    /**
     * Holt die Role der Nutzer, der einen Buch ausgeliehen hat.
     * @return Der Role der Nutzer.
     */
    public Person getRole() {
        return role.get();
    }

    public void setRole(Person role) {
        this.role.set(role);
    }



}
