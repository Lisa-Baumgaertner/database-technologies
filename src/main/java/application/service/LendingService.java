package application.service;

import application.model.Lending;
import application.repository.LendingRepository;

import java.time.LocalDate;
import java.util.List;

/**
 * Service-Klasse zur Verwaltung von Ausleihvorgänge
 * die Klasse bietet Methoden zur Manipulation und Abfrage von Ausleihdaten.
 */
public class LendingService {

    // Repository für den Zugriff auf Ausleihe-Daten
    private final LendingRepository lendingRepository;

    /**
     * Konstruktor, der das LendingRepository initialisiert.
     * @param lendingRepository das Repository, das für Datenzugriffe verwendet wird
     */
    public LendingService(LendingRepository lendingRepository) {
        this.lendingRepository = lendingRepository;
    }

    /**
     * Ruft alle Lending-Einträge aus der Datenbank ab.
     * @return Liste aller Ausleihen.
     */
    public List<Lending> getAllLendinglistEntries() {
        return lendingRepository.getAllLendinglistEntries();
    }
    /**
     * Ruft alle Lending-Einträge für ein bestimmtes Buch ab.
     * @param bookId ID des Buches.
     * @return Liste der Ausleihen für das Buch.
     */
    public List<Lending> getLendingForBook(long bookId) {
        return lendingRepository.getLendingForBook(bookId);
    }
    /**
     * Ruft alle Lending-Einträge für einen bestimmten Nutzer ab.
     * @param userId ID des Nutzers.
     * @return Liste der Ausleihen des Nutzers.
     */
    public List<Lending> getLendingForUser(long userId) {
        return lendingRepository.getLendingForUser(userId);
    }

    /**
     * Fügt einen neuen Lending-Eintrag hinzu.
     * @param userId ID des Nutzers.
     * @param workerId ID des Mitarbeiters.
     * @param bookId ID des Buches.
     * @param status Status der Ausleihe.
     * @param checkoutDate Datum der Ausleihe.
     */
    public void addToLending(Long userId, Long workerId, Long bookId, String status, LocalDate checkoutDate) {
        lendingRepository.addToLending(userId, workerId,  bookId, status, checkoutDate);
    }

    /**
     * Aktualisiert den Status einer Ausleihe.
     * @param lendingId ID der Ausleihe.
     * @param status Neuer Status.
     */
    public void updateStatus(Long lendingId, String status) {
        lendingRepository.updateStatus(lendingId, status);
    }
    /**
     * Entfernt eine Ausleihe aus der Datenbank.
     * @param lendingId ID der Ausleihe.
     */
    public void removeFromLending(long lendingId) {
        lendingRepository.removeFromLending(lendingId);
    }

    /**
     * Verlängert die Rückgabefrist einer Ausleihe um maximal 4 Wochen.
     * @param lendingId ID der Ausleihe.
     * @return true, wenn die Verlängerung erfolgreich war, false, wenn das Maximum erreicht wurde.
     */

    public boolean extendDueDate(long lendingId) {
        Lending lending = lendingRepository.getLendingById(lendingId);
        if (lending == null) {
            System.out.println("Keine Ausleihe mit der angegebenen ID gefunden.");
            return false;
        }

        // Prüfen, ob der Status 'returned' ist
        if ("returned".equalsIgnoreCase(lending.getStatus())) {
            System.out.println("Die Ausleihe wurde bereits zurückgegeben. Eine Verlängerung ist nicht möglich.");
            return false;
        }

        // Anzahl der bisherigen Verlängerungen berechnen
        int extensionCount = lendingRepository.calculateExtensionCount(lending);
        if (extensionCount >= 3) {
            System.out.println("Die Rückgabefrist wurde bereits dreimal verlängert.");
            return false;
        }
        LocalDate newDueDate = lending.getReturnDate().plusWeeks(4);
        lendingRepository.updateDueDate(lendingId, newDueDate);
        System.out.println("Die Rückgabefrist wurde erfolgreich verlängert.");
        return true;
    }

    /**
     * Sucht die Ausleihen basierend auf dem Namen.
     * @return Liste der gefilterten Ausleihen
     */
    public List<Lending> getLendingForUserByName(String userName) {
        return lendingRepository.getLendingForUserByName(userName);
    }

    /**
     * Filtert die Ausleihen basierend auf dem Rückgabedatum.
     * @return Liste der gefilterten Ausleihen
     */
    public List<Lending> filterByDueDate() {
        return lendingRepository.filterByDueDate();
    }


    /**
     * Filtert die Ausleihen basierend auf einer Buchkategorie.
     * @param category die Kategorie des Buches
     * @return Liste der gefilterten Ausleihen
     */
    public List<Lending> filterByCategory(String category) {
        return lendingRepository.filterByCategory(category);
    }

    /**
     * Filtert die Ausleihen basierend auf der Verfügbarkeit (z. B. "ausgeliehen", "verfügbar").
     *
     * @param availability der Verfügbarkeitsstatus
     * @return Liste der gefilterten Ausleihen
     */
    public List<Lending> filterByAvailability(String availability) {
        return lendingRepository.filterByAvailability(availability);
    }

    /**
     * Ruft alle Keywords aus der Datenbank ab
     * @return Liste der Keywords
     */
    public  List<String> getAllKeywords() {
        return lendingRepository.getAllKeywords();
    }
}
