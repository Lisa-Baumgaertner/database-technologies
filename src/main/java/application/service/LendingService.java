package application.service;

import application.model.Lending;
import application.repository.LendingRepository;

import java.time.LocalDate;
import java.util.List;

public class LendingService {

    private final LendingRepository lendingRepository;

    public LendingService(LendingRepository lendingRepository) {
        this.lendingRepository = lendingRepository;
    }
    public List<Lending> getAllLendinglistEntries() {
        return lendingRepository.getAllLendinglistEntries();
    }
    public List<Lending> getLendingForBook(long bookId) {
        return lendingRepository.getLendingForBook(bookId);
    }

    public List<Lending> getLendingForUser(long userId) {
        return lendingRepository.getLendingForUser(userId);
    }
    public void addToLending(Long userId, Long workerId, Long bookId, String status, LocalDate checkoutDate) {
        lendingRepository.addToLending(userId, workerId,  bookId, status, checkoutDate);
    }

    public void updateStatus(Long lendingId, String status) {
        lendingRepository.updateStatus(lendingId, status);
    }

    public void removeFromLending(long lendingId) {
        lendingRepository.removeFromLending(lendingId);
    }
}
