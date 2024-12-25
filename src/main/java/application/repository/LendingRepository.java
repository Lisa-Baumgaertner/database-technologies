package application.repository;

import application.model.Lending;


import java.time.LocalDate;
import java.util.List;

public interface LendingRepository {
    List<Lending> getAllLendinglistEntries();
    void addToLending(Long userId, Long workerId, Long bookId, String status, LocalDate checkoutDate);
    List<Lending> getLendingForBook(Long bookId);
    List<Lending> getLendingForUser(Long userId);
    void updateStatus(Long lendingId, String status);
    void removeFromLending(Long lendingId);
    Lending getLendingById(Long lendingId);
    void updateDueDate(Long lendingId, LocalDate newDueDate);
    int calculateExtensionCount(Lending lending);
    List<Lending> getLendingForUserByName(String userName);
    List<Lending> filterByDueDate();
    List<Lending> filterByCategory(String category);
    List<Lending> filterByAvailability(String availabilityStatus);
    List<String> getAllKeywords();
}
