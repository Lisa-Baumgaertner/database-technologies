package application.model;

import javafx.beans.property.*;

import java.time.LocalDate;

public class Waitlist {

    private IntegerProperty waitlistId;
    private ObjectProperty<Person> user;
    private ObjectProperty<Book> book;
    private ObjectProperty<LocalDate> checkoutDate;
    private ObjectProperty<LocalDate> returnDate;
    private StringProperty status;


    public Waitlist() {
        this.waitlistId = new SimpleIntegerProperty();
        this.user = new SimpleObjectProperty<>();
        this.book = new SimpleObjectProperty<>();
        this.checkoutDate = new SimpleObjectProperty<>();
        this.returnDate = new SimpleObjectProperty<>();
        this.status = new SimpleStringProperty("waiting");
    }

    public Waitlist(Person user, Book book, LocalDate checkoutDate, LocalDate returnDate, String status) {
        this.waitlistId = new SimpleIntegerProperty();
        this.user = new SimpleObjectProperty<>(user);
        this.book = new SimpleObjectProperty<>(book);
        this.checkoutDate = new SimpleObjectProperty<>(checkoutDate);
        this.returnDate = new SimpleObjectProperty<>(returnDate);
        this.status = new SimpleStringProperty(status);
    }

    // Getter und Setter für Properties

    public IntegerProperty waitlistIdProperty() {
        return waitlistId;
    }

    public int getWaitlistId() {
        return waitlistId.get();
    }

    public void setWaitlistId(int waitlistId) {
        this.waitlistId.set(waitlistId);
    }

    public ObjectProperty<Person> userProperty() {
        return user;
    }

    public Person getUser() {
        return user.get();
    }

    public void setUser(Person user) {
        this.user.set(user);
    }

    public ObjectProperty<Book> bookProperty() {
        return book;
    }

    public Book getBook() {
        return book.get();
    }

    public void setBook(Book book) {
        this.book.set(book);
    }

    public ObjectProperty<LocalDate> checkoutDateProperty() {
        return checkoutDate;
    }

    public LocalDate getCheckoutDate() {
        return checkoutDate.get();
    }

    public void setCheckoutDate(LocalDate checkoutDate) {
        this.checkoutDate.set(checkoutDate);
    }

    public ObjectProperty<LocalDate> returnDateProperty() {
        return returnDate;
    }

    public LocalDate getReturnDate() {
        return returnDate.get();
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate.set(returnDate);
    }

    public StringProperty statusProperty() {
        return status;
    }

    public String getStatus() {
        return status.get();
    }

    public void setStatus(String status) {
        this.status.set(status);
    }
}
