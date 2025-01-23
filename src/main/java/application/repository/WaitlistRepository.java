package application.repository;

import application.model.Waitlist;

import java.time.LocalDate;
import java.util.List;

public interface WaitlistRepository {
    List<Waitlist> getAllWaitlistEntries();
    boolean addToWaitlist(Long userId, Long bookId, String status);
    List<Waitlist> getWaitlistForBook(Long bookId);
    List<Waitlist> getWaitlistForUser(Long userId);
    void updateStatus(Long waitlistId, String status);
    boolean removeFromWaitlist(Long waitlistId);
    List<Waitlist> getPrioritizedWaitlistEntries();
    void updateCheckoutDate(Long waitlistId, LocalDate checkoutDate);

    Waitlist addToWaitlist(Waitlist waitlist);
}
