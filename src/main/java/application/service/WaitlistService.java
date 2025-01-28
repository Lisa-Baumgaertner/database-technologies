package application.service;

import application.config.DatabaseConfig;
import application.model.Waitlist;
import application.repository.ReviewRepository;
import application.repository.WaitlistRepository;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Service-Klasse zur Verwaltung von Wartelisteneinträgen.
 * Diese Klasse bietet Methoden, um Wartelisten für Bücher und Nutzer zu verwalten, Einträge hinzuzufügen, zu aktualisieren oder zu entfernen.
 */
public class WaitlistService {
    private static WaitlistService instance;
    private final WaitlistRepository waitlistRepository;



//    /**
//     * Konstruktor, der das ReviewRepository initialisiert.
//     *
//     * @param WaitlistRepository das Repository für Rezensionsdaten
//     */
//    public WaitlistService(WaitlistRepository waitlistRepository) {
//        this.waitlistRepository = waitlistRepository;
//    }
//
//    /**
//     * Singleton-Methode: Initialisiert ReviewService und stellt sicher, dass nur eine Instanz existiert.
//     *
//     * @return Eine Instanz von ReviewService.
//     */
//    public static ReviewService getInstance() {
//        if (instance == null) {
//            try {
//                // Erstelle eine neue Instanz von DatabaseConfig
//                DatabaseConfig config = new DatabaseConfig();
//
//                // Hole das ReviewRepository aus der Konfiguration
//                ReviewRepository repository = config.getReviewRepository();
//                instance = new WaitlistService(repository);
//            } catch (IOException e) {
//                throw new RuntimeException("Fehler bei der Initialisierung des ReviewService", e);
//            }
//        }
//        return instance;
//    }

    //private final WaitlistRepository waitlistRepository;
    /**
     * Konstruktor zur Initialisierung des WaitlistService mit einem WaitlistRepository.
     */
    public WaitlistService(WaitlistRepository waitlistRepository) {
        this.waitlistRepository = waitlistRepository;
    }

    /**
     * Singleton-Methode: Initialisiert ReviewService und stellt sicher, dass nur eine Instanz existiert.
     *
     * @return Eine Instanz von ReviewService.
     */
    public static WaitlistService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                // Hole das ReviewRepository aus der Konfiguration
                WaitlistRepository repository = config.getWaitlistRepository();
                instance = new WaitlistService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des ReviewService", e);
            }
        }
        return instance;
    }

    /**
     * Ruft alle Wartelisteneinträge für ein spezifisches Buch ab.
     */
    public List<Waitlist> getWaitlistForBook(long id) {
        return waitlistRepository.getWaitlistForBook(id);
    }

    /**
     * Ruft alle Wartelisteneinträge für einen spezifischen Benutzer ab.
     */
    public List<Waitlist> getWaitlistForUser(long id) {
        return waitlistRepository.getWaitlistForUser(id);
    }

    /**
     * Ruft alle Wartelisteneinträge aus der Datenbank ab.
     */
    public List<Waitlist> getAllWaitlistEntries() {
        return waitlistRepository.getAllWaitlistEntries();
    }

    /**
     * Fügt einen Benutzer zu der Warteliste für ein bestimmtes Buch hinzu.
     */
    public Waitlist addToWaitlist(Waitlist waitlist) {
        return waitlistRepository.addToWaitlist(waitlist);
    }

    /**
     * Aktualisiert den Status eines bestehenden Wartelisteneintrags.
     */
    public void updateStatus(Long waitlistId, String status) {
        waitlistRepository.updateStatus(waitlistId, status);
    }

    /**
     * Entfernt einen Eintrag aus der Warteliste.
     */
    public void removeFromWaitlist(long waitlistId) {
        waitlistRepository.removeFromWaitlist(waitlistId);
    }

    /**
    * Aktualisiert der CheckoutDate
     */
    public void updateCheckoutDate(Long waitlistId, LocalDate newCheckoutDate) {
        waitlistRepository.updateCheckoutDate(waitlistId, newCheckoutDate);
    }
    /**
     * Singleton-Methode: Initialisiert WaitlistService und stellt sicher, dass nur eine Instanz existiert.
     * @return Eine Instanz von WaitlistService.
     */
    /*public static WaitlistService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                // Verwende die Methode getWaitlistRepository() der Instanz
                WaitlistRepository repository = config.getWaitlistRepository();
                System.out.println("Waitlist Repository: " + repository);
                instance = new WaitlistService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des WaitlistService", e);
            }
        }
        return instance;
    }*/
}
