package application.repository;

import application.model.Book;
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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static com.mongodb.client.model.Filters.eq;

public class MongoWaitlistRepositoryImpl implements WaitlistRepository {
    private final MongoCollection<Document> collection;



    /**
     * Konstruktor zur Initialisierung der MongoDB-Collection.
     */
    public MongoWaitlistRepositoryImpl(MongoDatabase mongoDatabase) {
        this.collection = mongoDatabase.getCollection("Book"); // Verwende die Collection "books"
    }


    /**
     * Funktion, um alle aktuellen Wartelisten zu bekommen.
     */
    @Override
    public List<Waitlist> getAllWaitlistEntries() {
        List<String> waitlistEntries = new ArrayList<>();

        // Retrieve all documents from the collection
        List<Document> documents = collection.find().into(new ArrayList<>());

        for (Document doc : documents) {
            List<Document> waitlistArray = (List<Document>) doc.get("waitlist");

            if (waitlistArray != null) {
                for (Document entry : waitlistArray) {
                    // Safely retrieve values and convert to Long where necessary
                    Long waitlistId = entry.get("waitlistId", Number.class) != null
                            ? entry.get("waitlistId", Number.class).longValue() : null;
                    Long borrowerId = entry.get("borrowerId", Number.class) != null
                            ? entry.get("borrowerId", Number.class).longValue() : null;
                    String checkoutDate = entry.getString("checkoutDate");
                    String status = entry.getString("status");
                    String returnDate = entry.getString("returnDate");

                    // Prepare array representation
                    String[] arr = {
                            String.valueOf(waitlistId),
                            String.valueOf(borrowerId),
                            checkoutDate,
                            status,
                            returnDate
                    };

                    waitlistEntries.add(Arrays.toString(arr));
                }
            }
        }

        System.out.println(waitlistEntries);

        return null;
    }


    /**
     * Funktion, um zu einer Warteliste hinzuzufügen.
     */
    public boolean addToWaitlist(Long userId, Long bookId, String status) {
        return true;
    }

    /**
     * Funktion, um zu einer Warteliste hinzuzufügen.
     */
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

    /**
     * Funktion, um die Warteliste für ein Buch zu retournieren.
     */
    public List<Waitlist> getWaitlistForBook(Long bookId) {
        return null;
    }

    /**
     * Funktion, um die Wartelisten zu retournieren, die für einen bestimmten Nutzer bestehen.
     */
    public List<Waitlist> getWaitlistForUser(Long userId) {
        return null;
    }


    /**
     * Funktion, um den Status in einer Warteliste zu ändern.
     */
    public boolean updateStatus(Long waitlistId, String status) {

        Bson filter = Filters.elemMatch("waitlist", Filters.eq("waitlistId", waitlistId));
        Bson update = Updates.set("waitlist.$.text", status);

        return collection.updateOne(filter, update).getModifiedCount() > 0;
    }


    /**
     * Funktion, um die priorisierten Wartelisteneinträge zu bekommen.
     */
    public List<Waitlist> getPrioritizedWaitlistEntries() {
        return null;
    }

    /**
     * Funktion, um das Checkoutdatum zu ändern.
     */
    @Override
    public void updateCheckoutDate(Long waitlistId, LocalDate checkoutDate) {

        // Formatieren des Datums für MongoDB als String im Format "dd-MM-yyyy"
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        String formattedDate = checkoutDate.format(formatter);

        // Update in der Book-Kollektion
        UpdateResult bookResult = collection.updateOne(
                eq("waitlist.waitlistId", waitlistId),
                new Document("$set", new Document("waitlist.$.checkoutDate", formattedDate))
        );

        // Falls die ID in keiner der Kollektionen gefunden wurde
        if (bookResult.getModifiedCount() == 0 && bookResult.getModifiedCount() == 0) {
            System.out.println("Lending mit ID " + waitlistId + " nicht gefunden. Aktualisierung fehlgeschlagen.");
        }

    }

    /**
     * Funktion, um rinrn Wartelisteneintrag zu löschen.
     */
    @Override
    public boolean removeFromWaitlist(Long waitlistId) {
        Bson filter = Filters.elemMatch("waitlist", Filters.eq("waitlistId", waitlistId));
        Bson update = Updates.pull("waitlist", new Document("waitlistId", waitlistId));

        return collection.updateOne(filter, update).getModifiedCount() > 0;

    }
}
