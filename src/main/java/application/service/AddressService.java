package application.service;

import application.config.DatabaseConfig;
import application.model.Address;
import application.repository.AddressRepository;

import java.io.IOException;

/**
 * Diese Serviceklasse bietet Geschäftslogik für Benutzeroperationen.
 * Der Service agiert als Vermittler zwischen dem Repository (Datenbankzugriff) und dem Controller.
 * Stellt sicher, dass nur eine Instanz von UserService existiert.
 */

public class AddressService {
    private static AddressService instance;
    private final AddressRepository addressRepository;



    public AddressService(AddressRepository addressRepository) {
        this.addressRepository = addressRepository;
    }

    /**
     * Holt Adresse anhand der  userId.
     */
    public Address getAddressByUserId(Long userId) {
        return addressRepository.getAddressByUserId(userId);
    }

    /**
     * Fügt Adresse hinzu.
     */
    public  Address insertAddress(Address address) {
           return addressRepository.insertAddress(address);
    }




    /**
     * Singleton-Methode: Initialisiert BookService und stellt sicher, dass nur eine Instanz existiert.
     * @return Eine Instanz von BookService.
     */
    public static AddressService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                // Verwende die Methode getAddressRepository() der Instanz
                AddressRepository repository = config.getAddressRepository();
                instance = new AddressService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des ContactService", e);
            }
        }
        return instance;
    }
}
