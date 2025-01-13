package application.repository;

import application.model.Person;
import application.model.Waitlist;
import com.mongodb.client.MongoDatabase;

import java.time.LocalDate;
import java.util.List;

public class MongoWaitlistRepositoryImpl implements WaitlistRepository {

    private final MongoDatabase database;


    public MongoWaitlistRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    public Person getFirstBorrower() {
        return null;
    }

    public String getUserNameById(int userId) {
        return "Benutzername";
    }

    @Override
    public List<Waitlist> getAllWaitlistEntries() {
        return null;
    }

    public boolean addToWaitlist(Long userId, Long bookId, String status) {
        return false;
    }

    public List<Waitlist> getWaitlistForBook(Long bookId) {
        return null;
    }

    public List<Waitlist> getWaitlistForUser(Long userId) {
        return null;
    }


    public void updateStatus(Long waitlistId, String status) {
    }

    //public void removeFromWaitlist(Long waitlistId) {}

    public List<Waitlist> getPrioritizedWaitlistEntries() {
        return null;
    }

    @Override
    public void updateCheckoutDate(Long waitlistId, LocalDate checkoutDate) {

    }

    @Override
    public void removeFromWaitlist(Long waitlistId) {

    //public void updateCheckoutDate(Long waitlistId, LocalDate checkoutDate) {}
    }
}
