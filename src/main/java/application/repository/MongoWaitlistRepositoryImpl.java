package application.repository;

import application.model.Contact;
import application.model.Person;
import application.model.Waitlist;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.util.List;

import static com.mongodb.client.model.Filters.eq;

public class MongoWaitlistRepositoryImpl implements WaitlistRepository {
    private final MongoCollection<Document> collection;



    /**
     * Konstruktor zur Initialisierung der MongoDB-Collection.
     */
    public MongoWaitlistRepositoryImpl(MongoDatabase mongoDatabase) {
        this.collection = mongoDatabase.getCollection("Book"); // Verwende die Collection "books"
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
        return true;
    }

    public Waitlist addToWaitlist(Waitlist waitlist) {
        System.out.println("MOngoooooo Waitlist: " + waitlist);
        System.out.println("MOngoooooo");
        // Date formatter for the checkout date
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd-MM-uuuu");
        LocalDate localDate = LocalDate.now();
        String checkoutDate = dtf.format(localDate);
        System.out.println("Mongo Date: " + checkoutDate);
        System.out.println("Mongo BookId: " + waitlist.getBook().getBookId());

        Document found = (Document) collection.find(new Document("bookId", waitlist.getBook().getBookId())).first();
        if(found != null){
            System.out.println("Found book");
            Bson updatedvalue = new Document("waitlistId", waitlist.getWaitlistId())
                    .append("borrowerId", waitlist.getUser().getUserId())
                    .append("checkoutDate",waitlist.getCheckoutDate())
                    .append("status", "borrowed")
                    .append("returnDate", null);

            System.out.println("updatedvalue" + updatedvalue);

            // Objekt zur Warteliste hinzufügen
            Bson updateOperation = Updates.push("waitlist", updatedvalue);

            UpdateResult result = collection.updateOne(eq("bookId", waitlist.getBook().getBookId()), updateOperation);


            Long updatedCount = collection.updateOne(
                    eq("bookId", waitlist.getBook().getBookId()),
                    updateOperation
            ).getModifiedCount();

            if (updatedCount > 0) {
                System.out.println("Waitlist updated successfully.");
            } else {
                System.out.println("No documents were updated.");
            }

            System.out.println("Waitlist updated");


        }

        return waitlist;

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
    public boolean removeFromWaitlist(Long waitlistId) {
        Bson filter = Filters.elemMatch("waitlist", Filters.eq("waitlistId", waitlistId));
        Bson update = Updates.pull("waitlist", new Document("waitlistId", waitlistId));

        return collection.updateOne(filter, update).getModifiedCount() > 0;

    }
}
