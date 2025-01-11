package application.repository;

import application.model.Person;
import application.model.Waitlist;
import com.mongodb.client.MongoDatabase;

import java.util.List;

public class MongoWaitlistRepositoryImpl implements WaitlistRepository {
    private final MongoDatabase database;
    public MongoWaitlistRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    public Person getFirstBorrower() {
        return null;
    }

    public  String getUserNameById(int userId) {
        return "Benutzername";
    }

    @Override
    public List<Waitlist> getAllWaitlistEntries() {
        return List.of();
    }

    @Override
    public boolean addToWaitlist(Long userId, Long bookId, String status) {
        return true; // Änderung
    }

    @Override
    public List<Waitlist> getWaitlistForBook(Long bookId) {
        return List.of();
    }

    @Override
    public List<Waitlist> getWaitlistForUser(Long userId) {
        return List.of();
    }

    @Override
    public void updateStatus(Long waitlistId, String status) {

    }

    @Override
    public void removeFromWaitlist(Long waitlistId) {

    }
}
