package application.model;

import javafx.beans.property.*;

import java.time.LocalDate;

/**
 * Modellklasse für eine Warteliste in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Wartelisten-Id, Benutzer, Buch, Ausleihdatum, Rückgabedatum, Status.
 */
public class Waitlist {

    private final LongProperty waitlistId;
    private final ObjectProperty<Person> user;
    private final ObjectProperty<Book> book;
    private final ObjectProperty<LocalDate> checkoutDate;
    private final ObjectProperty<LocalDate> returnDate;
    private final StringProperty status;


    /**
     * Standardkonstruktor für Waitlist.
     * Initialisiert alle Properties mit Standardwerten.
     */
    public Waitlist() {
        this.waitlistId = new SimpleLongProperty();
        this.user = new SimpleObjectProperty<>();
        this.book = new SimpleObjectProperty<>();
        this.checkoutDate = new SimpleObjectProperty<>();
        this.returnDate = new SimpleObjectProperty<>();
        this.status = new SimpleStringProperty("borrowed");
    }

    /**
     * Konstruktor für Waitlist mit allen Attributen.
     *
     * @param waitlistId
     * @param user
     * @param book
     * @param checkoutDate
     * @param returnDate
     * @param status
     */
    public Waitlist(Long waitlistId, Person user, Book book, LocalDate checkoutDate, LocalDate returnDate, String status) {
        this.waitlistId = new SimpleLongProperty();
        this.user = new SimpleObjectProperty<>(user);
        this.book = new SimpleObjectProperty<>(book);
        this.checkoutDate = new SimpleObjectProperty<>(checkoutDate);
        this.returnDate = new SimpleObjectProperty<>(returnDate);
        this.status = new SimpleStringProperty(status);
    }

    // Getter und Setter für Properties

    public LongProperty waitlistIdProperty() {
        return waitlistId;
    }

    /**
     * Holt die Wartelisten-Id
     * @return waitlistId
     */
    public Long getWaitlistId() {
        return waitlistId.get();
    }

    public void setWaitlistId(int waitlistId) {
        this.waitlistId.set(waitlistId);
    }

    public ObjectProperty<Person> userProperty() {
        return user;
    }

    /**
     * Holt den Nutzer
     * @return user
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
     * Holt das Buch
     * @return book
     */
    public Book getBook() {
        return book.get();
    }

    public void setBook(Book book) {
        this.book.set(book);
    }

    public ObjectProperty<LocalDate> checkoutDateProperty() {
        return checkoutDate;
    }

    /**
     * Holt das Ausleihdatum
     * @return checkoutDate
     */
    public LocalDate getCheckoutDate() {
        return checkoutDate.get();
    }

    public void setCheckoutDate(LocalDate checkoutDate) {
        this.checkoutDate.set(checkoutDate);
    }

    public ObjectProperty<LocalDate> returnDateProperty() {
        return returnDate;
    }

    /**
     * Holt das Rückgabedatum
     * @return returnDate
     */
    public LocalDate getReturnDate() {
        return returnDate.get();
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate.set(returnDate);
    }

    public StringProperty statusProperty() {
        return status;
    }

    /**
     * Holt den Status des Buches
     * @return status
     */
    public String getStatus() {
        return status.get();
    }

    public void setStatus(String status) {
        this.status.set(status);
    }
}
