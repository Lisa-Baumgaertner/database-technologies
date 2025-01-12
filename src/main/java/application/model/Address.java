package application.model;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.beans.property.LongProperty;
import javafx.beans.property.SimpleLongProperty;

/**
 * Modellklasse für eine Adresse in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Address-Id, Straße, Hausnummer, Stadt
 * und Postleitzahl
 */
public class Address {

    private LongProperty addressId;
    private LongProperty userId;
    private StringProperty street;
    private StringProperty houseNumber;
    private StringProperty city;
    private StringProperty zipCode;

    public Address() {
        this.addressId = new SimpleLongProperty();
        this.userId = new SimpleLongProperty();
        this.street = new SimpleStringProperty();
        this.houseNumber = new SimpleStringProperty();
        this.city = new SimpleStringProperty();
        this.zipCode = new SimpleStringProperty();
    }

    public Address(long addressId, long userId, String street, String houseNumber, String city, String zipCode) {
        this.addressId = new SimpleLongProperty(addressId);
        this.userId = new SimpleLongProperty(userId);
        this.street = new SimpleStringProperty(street);
        this.houseNumber = new SimpleStringProperty(houseNumber);
        this.city = new SimpleStringProperty(city);
        this.zipCode = new SimpleStringProperty(zipCode);
    }

    // Property Getter
    public LongProperty addressIdProperty() {
        return addressId;
    }

    public LongProperty userIdProperty() {
        return userId;
    }

    public StringProperty streetProperty() {
        return street;
    }

    public StringProperty houseNumberProperty() {
        return houseNumber;
    }

    public StringProperty cityProperty() {
        return city;
    }

    public StringProperty zipCodeProperty() {
        return zipCode;
    }

    // Klassische Getter/Setter
    public long getAddressId() {
        return addressId.get();
    }

    public void setAddressId(long addressId) {
        this.addressId.set(addressId);
    }

    public long getUserId() {
        return userId.get();
    }

    public void setUserId(long userId) {
        this.userId.set(userId);
    }

    public String getStreet() {
        return street.get();
    }

    public void setStreet(String street) {
        this.street.set(street);
    }

    public String getHouseNumber() {
        return houseNumber.get();
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber.set(houseNumber);
    }

    public String getCity() {
        return city.get();
    }

    public void setCity(String city) {
        this.city.set(city);
    }

    public String getZipCode() {
        return zipCode.get();
    }

    public void setZipCode(String zipCode) {
        this.zipCode.set(zipCode);
    }
}