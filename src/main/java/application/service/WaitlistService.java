package application.service;

import application.model.Waitlist;
import application.repository.WaitlistRepository;

import java.util.List;

public class WaitlistService {

    private final WaitlistRepository waitlistRepository;

    public WaitlistService(WaitlistRepository waitlistRepository) {
        this.waitlistRepository = waitlistRepository;
    }
    public List<Waitlist> getWaitlistForBook(long id) {
      return waitlistRepository.getWaitlistForBook(id);
    }
    public List<Waitlist> getWaitlistForUser(long id) {
        return waitlistRepository.getWaitlistForUser(id);
    }

    public List<Waitlist> getAllWaitlistEntries() {
        return waitlistRepository.getAllWaitlistEntries();
    }
    public void addToWaitlist(Long userId, Long bookId, String status) {
         waitlistRepository.addToWaitlist(userId, bookId, status);
    }

    public void updateStatus(Long waitlistId, String status) {
        waitlistRepository.updateStatus(waitlistId, status);
    }

    public void removeFromWaitlist(long waitlistId) {
        waitlistRepository.removeFromWaitlist(waitlistId);
    }
}
