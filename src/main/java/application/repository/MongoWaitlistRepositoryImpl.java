package application.repository;

import application.model.Waitlist;
import com.mongodb.client.MongoDatabase;

import java.time.LocalDate;
import java.util.List;

public class MongoWaitlistRepositoryImpl implements WaitlistRepository {

    private final MongoDatabase database;

    public MongoWaitlistRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    public List<Waitlist> getAllWaitlistEntries() {
        return null;
    }

    public void addToWaitlist(Long userId, Long bookId, String status) {}

    public  List<Waitlist> getWaitlistForBook(Long bookId) {
        return null;
    }

    public  List<Waitlist> getWaitlistForUser(Long userId) {
        return null;
    }


    public void updateStatus(Long waitlistId, String status) {}

    public void removeFromWaitlist(Long waitlistId) {}

    public  List<Waitlist>  getPrioritizedWaitlistEntries() {
        return null;
    }


   public void updateCheckoutDate(Long waitlistId, LocalDate checkoutDate) {
    }
}
