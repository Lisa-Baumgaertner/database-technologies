package application.service;

import application.config.DatabaseConfig;
import application.model.Person;
import application.model.Address;
import application.model.Contact;
import application.repository.UserRepository;
import application.repository.AddressRepository;
import application.repository.ContactRepository;

import java.io.IOException;

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


    public UserService(UserRepository userRepository,
                       AddressRepository addressRepository,
                       ContactRepository contactRepository) {

        this.userRepository = userRepository;
        this.addressRepository = addressRepository;
        this.contactRepository = contactRepository;
    }


    public  String getUserNameById(int id) {
        return userRepository.getUserNameById(id);
    }

    /**
     * Fügt Person hinzu.
     */
    public  Person insertPerson(Person Person) {
        return userRepository.insertPerson(Person);
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
                UserRepository repository = config.getUserRepository();
                AddressRepository addressRepo = config.getAddressRepository();
                ContactRepository contactRepo = config.getContactRepository();
                instance = new UserService(repository, addressRepo, contactRepo);
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
