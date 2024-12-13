package application.model;

import javafx.beans.property.*;

import java.time.LocalDate;

public class Lending {

    private final IntegerProperty lendingId;
    private final ObjectProperty<Person> user;
    private final ObjectProperty<Person> role;
    private final ObjectProperty<Book> book;
    private final ObjectProperty<LocalDate> checkoutDate;
    private final ObjectProperty<LocalDate> returnDate;
    private final StringProperty status;


    public Lending() {
        this.role =new SimpleObjectProperty<>();
        this.lendingId = new SimpleIntegerProperty();
        this.user = new SimpleObjectProperty<>();
        this.book = new SimpleObjectProperty<>();
        this.checkoutDate = new SimpleObjectProperty<>();
        this.returnDate = new SimpleObjectProperty<>();
        this.status = new SimpleStringProperty("borrowed");
    }

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

    public int getLendinglistId() {
        return lendingId.get();
    }

    public void setLendinglistId(int waitlistId) {
        this.lendingId.set(waitlistId);
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

    public Person getRole() {
        return role.get();
    }

    public void setRole(Person role) {
        this.role.set(role);
    }

}
