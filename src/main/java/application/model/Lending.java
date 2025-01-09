package application.model;

import javafx.beans.property.*;

import java.time.LocalDate;

/**
 * Modellklasse für eine Ausleihe in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Benutzer, Buch, Status und Termine.
 */
public class Lending {

    private final IntegerProperty lendingId;
    private final IntegerProperty bookId;
    private final IntegerProperty userIdBorrower;
    private final IntegerProperty userIdWorker;
    private final StringProperty status;
    private final ObjectProperty<LocalDate> checkoutDate;
    private final ObjectProperty<LocalDate> returnDate;
    private final ObjectProperty<LocalDate> dueDate;


    /**
     * Standardkonstruktor für Lending.
     * Initialisiert alle Properties mit Standardwerten.
     */
    public Lending() {
        this.lendingId = new SimpleIntegerProperty();
        this.bookId = new SimpleIntegerProperty();
        this.userIdBorrower = new SimpleIntegerProperty();
        this.userIdWorker = new SimpleIntegerProperty();
        this.status = new SimpleStringProperty("borrowed");
        this.checkoutDate = new SimpleObjectProperty<>();
        this.returnDate = new SimpleObjectProperty<>();
        this.dueDate = new SimpleObjectProperty<>();

    }

    /**
     * Konstruktor für Lending mit allen Attributen.
     *
     * @param bookId       Das ausgeliehene Buch ID.
     * @param checkoutDate Das Datum der Ausleihe.
     * @param returnDate   Das Datum der Rückgabe.
     * @param status       Der Status der Ausleihe.
     */
    public Lending(Integer lendingId, Integer bookId, Integer userIdBorrower, Integer userIdWorker, String status, LocalDate checkoutDate, LocalDate returnDate, LocalDate dueDate) {
        this.lendingId = new SimpleIntegerProperty(lendingId);
        this.bookId = new SimpleIntegerProperty(bookId);
        this.userIdBorrower = new SimpleIntegerProperty(userIdBorrower);
        this.userIdWorker = new SimpleIntegerProperty(userIdWorker);
        this.status = new SimpleStringProperty(status);
        this.checkoutDate = new SimpleObjectProperty<>(checkoutDate);
        this.returnDate = new SimpleObjectProperty<>(returnDate);
        this.dueDate = new SimpleObjectProperty<>(dueDate);
    }


    // Getter und Setter für Properties

    /**
     * Holt die ID der Ausleihe.
     *
     * @return Die ID der Ausleihe.
     */

    public int getLendingId() {
        return lendingId.get();
    }

    public void setLendingId(int waitlistId) {
        this.lendingId.set(waitlistId);
    }
    public IntegerProperty lendingIdProperty() {
        return lendingId;
    }

    /**
     * Holt das Buch, das ausgeliehen wurde.
     *
     * @return Das Buch der Ausleihe.
     */
    public Integer getBookId() {
        return bookId.get();
    }

    public void setBookId(int bookId) {
        this.bookId.set(bookId);
    }
    public IntegerProperty bookIdProperty() {
        return bookId;
    }

    /**
     * Holt den userIdBorrower, der die Ausleihe tätigt.
     *
     * @return Der Benutzer der Ausleihe.
     */
    public int getUserIdBorrower() {
        return userIdBorrower.get();
    }

    public void setUserIdBorrower(int userId) {
        this.userIdBorrower.set(userId);
    }
    public IntegerProperty userIdBorrowerProperty() {
        return userIdBorrower;
    }

    /**
     * Holt den userIdWorker
     *
     * @return Der Mitarbeiter der die Ausleihe getan hat.
     */
    public int getUserIdWorker() {
        return userIdWorker.get();
    }

    public void setUserIdWorker(int userId) {
        this.userIdWorker.set(userId);
    }

    public IntegerProperty userIdWorkerProperty() {
        return userIdWorker;
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


    // Getter und Setter für dueDate
    public LocalDate getDueDate() {
        return dueDate.get();
    }

    public void setDueDate(LocalDate date) {
        this.dueDate.set(date);
    }

    public ObjectProperty<LocalDate> dueDateProperty() {
        return dueDate;
    }

}
