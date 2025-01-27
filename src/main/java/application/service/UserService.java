package application.service;

import application.config.DatabaseConfig;
import application.model.Person;
import application.model.Address;
import application.model.Contact;
import application.repository.UserRepository;
import application.repository.AddressRepository;
import application.repository.ContactRepository;

import java.io.IOException;
import java.util.List;

/**
 * Diese Serviceklasse bietet Geschäftslogik für Benutzeroperationen.
 * Der Service agiert als Vermittler zwischen dem Repository (Datenbankzugriff) und dem Controller.
 * Stellt sicher, dass nur eine Instanz von UserService existiert.
 */

public class UserService {
    private static UserService instance;
    private final UserRepository userRepository;
    private final AddressRepository addressRepository;
    private final ContactRepository contactRepository;



    public UserService(UserRepository userRepository, AddressRepository addressRepository,
                       ContactRepository contactRepository) {

        this.userRepository = userRepository;
        this.addressRepository = addressRepository;
        this.contactRepository = contactRepository;
    }


    /**
     *
     */
    public List<Person> getAllPersons() {
        return userRepository.getAllPersons();
    }
    /**
     * Holt Name der Peron anhand userID.
     */
    public  String getUserNameById(int id) {
        return userRepository.getUserNameById(id);
    }


    /**
     * Fügt Person hinzu.
     */
    public Person insertPerson(Person person) {
        // Beginne den Transaktionsblock
        try {
            // Person in die Datenbank einfügen und userId abfragen
            Person insertedPerson = userRepository.insertPerson(person);
            if (insertedPerson == null || insertedPerson.getUserId() == 0) {
                System.err.println("Fehler: Keine gültige userId zurückgegeben!");
                return null;
            }

            int userId = insertedPerson.getUserId().intValue();
            System.out.println("Generierte userId: " + userId);

            // Adresse speichern, falls vorhanden
            if (person.getAddress() != null) {
                try {
                    System.out.println("Adresse wird hinzugefügt: " + person.getAddress().getCity());
                    Address address = person.getAddress();
                    address.setUserId(userId);  // Setze die userId für die Adresse
                    addressRepository.insertAddress(address);
                } catch (Exception e) {
                    System.err.println("Fehler beim Hinzufügen der Adresse: " + e.getMessage());
                    throw new RuntimeException("Datenbank-Transaktion fehlgeschlagen: Adresse konnte nicht gespeichert werden.");
                }
            }

            // Kontakt speichern, falls vorhanden
            if (person.getContact() != null) {
                try {
                    System.out.println("Kontakt wird hinzugefügt: " + person.getContact().getEmail());
                    Contact contact = person.getContact();
                    contact.setUserId(userId);  // Setze die userId für den Kontakt
                    contactRepository.insertContact(contact);
                } catch (Exception e) {
                    System.err.println("Fehler beim Hinzufügen des Kontakts: " + e.getMessage());
                    throw new RuntimeException("Datenbank-Transaktion fehlgeschlagen: Kontakt konnte nicht gespeichert werden.");
                }
            }

            System.out.println("Person mit Adresse und Kontakt wurde erfolgreich hinzugefügt.");
            return insertedPerson;

        } catch (Exception e) {
            System.err.println("Fehler beim Hinzufügen der Person: " + e.getMessage());
            e.printStackTrace();
            return null;  // Gib null zurück, wenn etwas fehlschlägt
        }
    }



    /**
     * Aktualisiert Person
     */
    public  void updatePerson(Person Person) {
        userRepository.updatePerson(Person);
    }

    /**
     * Löscht Person
     */
    public  void deletePerson(Integer userId) {
        userRepository.deletePerson(userId);
    }


    /**
     * Singleton-Methode: Initialisiert UserService und stellt sicher, dass nur eine Instanz existiert.
     * @return Eine Instanz von UserService.
     */
    public static UserService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                // Verwende die Methode getUserRepository() der Instanz
                UserRepository userRepo = config.getUserRepository();
                AddressRepository addressRepo = config.getAddressRepository();
                ContactRepository contactRepo = config.getContactRepository();

                instance = new UserService(userRepo, addressRepo, contactRepo);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des UserService", e);
            }
        }
        return instance;
    }

    /**
     * Findet den ersten Benutzer mit der Rolle "Borrower".
     *
     * @return Die erste Person mit der Rolle "Borrower", falls vorhanden.
     */
    public Person getFirstBorrower() {

        Person p = userRepository.getFirstBorrower();
        if (p == null) return null;

        // Address & Contact laden
        Address address = addressRepository.getAddressByUserId(p.getUserId());
        Contact contact = contactRepository.getContactByUserId(p.getUserId());
        p.setAddress(address);
        p.setContact(contact);

        return p;
    }

}
