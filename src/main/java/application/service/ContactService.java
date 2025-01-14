package application.service;

import application.config.DatabaseConfig;
import application.model.Address;
import application.model.Contact;
import application.repository.AddressRepository;
import application.repository.ContactRepository;

import java.io.IOException;

public class ContactService {
    private static ContactService instance;
    private final ContactRepository contactRepository;



    public ContactService(ContactRepository contactRepository) {

        this.contactRepository = contactRepository;
    }



    /**
     * Fügt Adresse hinzu.
     */
    public Contact insertContact(Contact contact) {
        return contactRepository.insertContact(contact);
    }

    public Contact getContactByUserId(Long userId) {
        return contactRepository.getContactByUserId(userId);
    }


    /**
     * Singleton-Methode: Initialisiert BookService und stellt sicher, dass nur eine Instanz existiert.
     * @return Eine Instanz von BookService.
     */
    public static ContactService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                // Verwende die Methode getAddressRepository() der Instanz
                ContactRepository repository = config.getContactRepository();
                instance = new ContactService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des ContactService", e);
            }
        }
        return instance;
    }
}
