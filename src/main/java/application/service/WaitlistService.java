package application.service;

import application.model.Waitlist;
import application.repository.WaitlistRepository;

import java.util.List;

/**
 * Service-Klasse zur Verwaltung von Wartelisteneinträgen.
 * Diese Klasse bietet Methoden, um Wartelisten für Bücher und Nutzer zu verwalten, Einträge hinzuzufügen, zu aktualisieren oder zu entfernen.
 */
public class WaitlistService {

    private final WaitlistRepository waitlistRepository;
    /**
     * Konstruktor zur Initialisierung des WaitlistService mit einem WaitlistRepository.
     */
    public WaitlistService(WaitlistRepository waitlistRepository) {
        this.waitlistRepository = waitlistRepository;
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
    public void addToWaitlist(Long userId, Long bookId, String status) {
         waitlistRepository.addToWaitlist(userId, bookId, status);
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
}
