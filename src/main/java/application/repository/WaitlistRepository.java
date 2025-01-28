package application.repository;

import application.model.Waitlist;

import java.time.LocalDate;
import java.util.List;

public interface WaitlistRepository {
    List<Waitlist> getAllWaitlistEntries();
    List<Waitlist> getWaitlistForBook(Long bookId);
    List<Waitlist> getWaitlistForUser(Long userId);
    boolean updateStatus(Long waitlistId, String status);
    boolean removeFromWaitlist(Long waitlistId);
    List<Waitlist> getPrioritizedWaitlistEntries();
    void updateCheckoutDate(Long waitlistId, LocalDate checkoutDate);

    Waitlist addToWaitlist(Waitlist waitlist);
}
