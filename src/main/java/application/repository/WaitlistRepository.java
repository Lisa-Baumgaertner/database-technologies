package application.repository;

import application.model.Waitlist;

import java.util.List;

public interface WaitlistRepository {
    List<Waitlist> getAllWaitlistEntries();
    boolean addToWaitlist(Long userId, Long bookId, String status);
    List<Waitlist> getWaitlistForBook(Long bookId);
    List<Waitlist> getWaitlistForUser(Long userId);
    void updateStatus(Long waitlistId, String status);
    void removeFromWaitlist(Long waitlistId);
}
