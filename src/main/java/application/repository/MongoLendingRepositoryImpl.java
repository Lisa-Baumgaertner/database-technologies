package application.repository;

import application.model.Lending;
import com.mongodb.client.MongoDatabase;

import java.time.LocalDate;
import java.util.List;

public class MongoLendingRepositoryImpl implements LendingRepository {
    private final MongoDatabase database;
    public MongoLendingRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    public List<Lending> getAllLendinglistEntries() {return null;}

    public void addToLending(Long userId, Long workerId, Long bookId, String status, LocalDate checkoutDate) { return;}

    public List<Lending> getLendingForBook(Long bookId) {return null;}

    public List<Lending> getLendingForUser(Long userId) {return null;}

    public  void updateStatus(Long lendingId, String status) {return ;}
    public  void removeFromLending(Long lendingId) {return ;}

    public Lending getLendingById(Long lendingId) {return null;}

    public  void updateDueDate(Long lendingId, LocalDate newDueDate) {return ;}

    public List<Lending> getFilteredLendings(String filter) {return null;}

    public int  calculateExtensionCount(Lending lending) {return 0;}

    public List<Lending> getLendingForUserByName(String userName) {return null;}

    public List<Lending> filterByDueDate(){return null;}
    public List<Lending> filterByCategory(String category){return null;}
    public List<Lending> filterByAvailability(String availabilityStatus){return null;}
    public List<String> getAllKeywords(){return null;}
}
