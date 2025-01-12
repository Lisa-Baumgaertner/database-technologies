package application.service;

import application.config.DatabaseConfig;
import application.model.Person;
import application.repository.UserRepository;

import java.io.IOException;

/**
 * Diese Serviceklasse bietet Geschäftslogik für Benutzeroperationen.
 * Der Service agiert als Vermittler zwischen dem Repository (Datenbankzugriff) und dem Controller.
 * Stellt sicher, dass nur eine Instanz von UserService existiert.
 */

public class UserService {
    private static UserService instance;
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    /**
     * Findet den ersten Benutzer mit der Rolle "Borrower".
     *
     * @return Die erste Person mit der Rolle "Borrower", falls vorhanden.
     */
    public Person getFirstBorrower() {
        return userRepository.getFirstBorrower();
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
                instance = new UserService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des UserService", e);
            }
        }
        return instance;
    }

}
