package application.model;

import javafx.beans.property.LongProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

/**
 * Modellklasse für die Kontaktdaten einer Person in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Contact-Id, Email, Telefon und Handynummer.
 */
public class Contact {

    private LongProperty contactId;
    private LongProperty userId;
    private StringProperty email;
    private StringProperty phone;
    private StringProperty mobile;

    public Contact() {
        this.contactId = new SimpleLongProperty();
        this.userId = new SimpleLongProperty();
        this.email = new SimpleStringProperty();
        this.phone = new SimpleStringProperty();
        this.mobile = new SimpleStringProperty();
    }

    // Konstruktor für PostgreSQL (mit contactId)
    public Contact(long contactId, long userId, String email, String phone, String mobile) {
        this.contactId = new SimpleLongProperty(contactId);
        this.userId = new SimpleLongProperty(userId);
        this.email = new SimpleStringProperty(email);
        this.phone = new SimpleStringProperty(phone);
        this.mobile = new SimpleStringProperty(mobile);
    }

    // Konstruktor für MongoDB (ohne contactId)
    public Contact(long userId, String email, String phone, String mobile) {
        this.userId = new SimpleLongProperty(userId);
        this.email = new SimpleStringProperty(email);
        this.phone = new SimpleStringProperty(phone);
        this.mobile = new SimpleStringProperty(mobile);
    }

    public LongProperty contactIdProperty() {
        return contactId;
    }

    public LongProperty userIdProperty() {
        return userId;
    }

    public StringProperty emailProperty() {
        return email;
    }

    public StringProperty phoneProperty() {
        return phone;
    }

    public StringProperty mobileProperty() {
        return mobile;
    }

    public long getContactId() {
        return contactId.get();
    }

    public void setContactId(long contactId) {
        this.contactId.set(contactId);
    }

    public long getUserId() {
        return userId.get();
    }

    public void setUserId(long userId) {
        this.userId.set(userId);
    }

    public String getEmail() {
        return email.get();
    }

    public void setEmail(String email) {
        this.email.set(email);
    }

    public String getPhone() {
        return phone.get();
    }

    public void setPhone(String phone) {
        this.phone.set(phone);
    }

    public String getMobile() {
        return mobile.get();
    }

    public void setMobile(String mobile) {
        this.mobile.set(mobile);
    }

    @Override
    public String toString() {
        return "Contact{" +
                "contactId=" + getContactId() +
                ", userId=" + getUserId() +
                ", email='" + getEmail() + '\'' +
                ", phone='" + getPhone() + '\'' +
                ", mobile='" + getMobile() + '\'' +
                '}';
    }
}