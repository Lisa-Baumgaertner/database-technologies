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
    //private final MongoDatabase database;


    /**
     * Konstruktor zur Initialisierung der MongoDB-Collection.
     */
    public MongoWaitlistRepositoryImpl(MongoDatabase mongoDatabase) {
        this.collection = mongoDatabase.getCollection("Book"); // Verwende die Collection "books"
    }

    /*public MongoWaitlistRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }*/

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

    /*public boolean addToWaitlist(Long userId, Long bookId, String status) {
        boolean bSuccess = true;

        Document doc = collection.find(eq("bookId", bookId)).first();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd-MM-uuuu");
        LocalDate localDate = LocalDate.now();
        String checkout = dtf.format(localDate);

        //if (doc != null && doc.containsKey("waitlist")) {
            Document contactDoc = new Document("borrowerId", userId)
                    .append("checkoutDate", checkout)
                    .append("status", status)
                    .append("returnDate", null);

            collection.insertOne(new Document("waitlist", contactDoc));
        //}
        return bSuccess;
        *//*Document contactDoc = new Document("borrowerId", userId)
                .append("checkoutDate", checkout)
                .append("status", status)
                .append("returnDate", null);

        collection.insertOne(new Document("waitlist", contactDoc));
        return bSuccess;*//*
    }*/




    public boolean addToWaitlist(Long userId, Long bookId, String status) {
//        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd-MM-uuuu");
//        LocalDate localDate = LocalDate.now();
//        String checkout = dtf.format(localDate);
//
//        // Neues Review-Dokument erstellen
//        Document newWaitlist = new Document()
//                .append("borrowerId", userId)
//                .append("checkoutDate", checkout)
//                .append("status", status)
//                .append("returnDate",  null);
//
//
//        // Suche das Buch anhand der bookId und füge die Review hinzu
//        Bson filter = Filters.eq("bookId", bookId);
//        Bson update = Updates.push("waitlist", newWaitlist);
//
//        collection.updateOne(filter, update).getModifiedCount();
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
            Bson updateoperation = new Document("$set", updatedvalue);
            collection.updateOne(found, updateoperation);
            System.out.println("Waitlist updated");


        }
        /*Document contactDoc = new Document("waitlistId", waitlist.getWaitlistId())
                .append("borrowerId", waitlist.getUser().getUserId())
                .append("checkoutDate",waitlist.getCheckoutDate())
                .append("status", "borrowed")
                .append("returnDate", null);

        //System.out.println("Mongo Waitlist Doc: " + contactDoc);
        Bson update = Updates.push("waitlist", contactDoc);
        //System.out.println("Mongo Waitlist Update: " + update);
        Bson filter = Filters.eq("bookId", waitlist.getBook().getBookId());
        //System.out.println("Mongo Waitlist Filter: " + filter);
        UpdateResult result = collection.updateOne(filter, update);*/
        //System.out.println("Mongo Waitlist Result: " + result);
    //    collection.insertOne(new Document("waitlist", contactDoc));

        // Generate a new waitlistId (e.g., based on timestamp or UUID)
        /*long waitlistId = System.currentTimeMillis(); // Example ID generation

        Document doc = collection.find(eq("bookId", bookId)).first();
        // New waitlist document
        Document newWaitlist = new Document()
                //.append("waitlistId", )
                .append("borrowerId", userId)
                .append("checkoutDate", checkoutDate)
                .append("status", status)
                .append("returnDate", null);


        System.out.println("Waitlist Document: " + newWaitlist);
        // Filter to find the book by bookId
        //Bson filter = Filters.eq("bookId", bookId); // Ensure bookId matches the schema type
        Bson update = Updates.push("waitlist", newWaitlist);
        collection.insertOne(new Document("waitlist", newWaitlist));*/
        //System.out.println("Waitlist Update: " + update);
        return waitlist;
        // Perform the update
        /*try {
            UpdateResult result = collection.updateOne(filter, update);

            // Log for debugging
            System.out.println("Filter: " + filter.toBsonDocument());
            System.out.println("Update: " + update.toBsonDocument());

            // Check if the document was modified
            return result.getModifiedCount() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }*/
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
