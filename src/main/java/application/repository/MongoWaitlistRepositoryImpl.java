package application.repository;

import application.model.Book;
import application.model.Person;
import application.model.Waitlist;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import org.bson.conversions.Bson;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;


import static com.mongodb.client.model.Filters.eq;

public class MongoWaitlistRepositoryImpl implements WaitlistRepository {
    private final MongoCollection<Document> collection;
    private final MongoCollection<Document> personCollection;



    /**
     * Konstruktor zur Initialisierung der MongoDB-Collection.
     */
    public MongoWaitlistRepositoryImpl(MongoDatabase mongoDatabase) {
        this.collection = mongoDatabase.getCollection("Book"); // Verwende die Collection "books"
        this.personCollection = mongoDatabase.getCollection("Person");
    }


    /**
     * Funktion, um alle aktuellen Wartelisten zu bekommen.
     */
    @Override
    public List<Waitlist> getAllWaitlistEntries() {
        String firstName = "";
        String lastName = "";
        List<Waitlist> waitlistEntries = new ArrayList<>();

        // Retrieve all documents from the collection
        List<Document> documents = collection.find().into(new ArrayList<>());

        for (Document doc : documents) {
            List<Document> waitlistArray = (List<Document>) doc.get("waitlist");

            // Define the formatter for the expected date format
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

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

                    // Convert dates to LocalDate using the formatter
                    LocalDate checkoutDateDate = (checkoutDate != null && !checkoutDate.isEmpty())
                            ? LocalDate.parse(checkoutDate, formatter)
                            : null;

                    LocalDate returnDateDate = (returnDate != null && !returnDate.isEmpty())
                            ? LocalDate.parse(returnDate, formatter)
                            : null;

                    // Retrieve the book ID from the parent document
                    Long bookId = doc.get("bookId", Number.class) != null
                            ? doc.get("bookId", Number.class).longValue() : null;
                    String bookTitle = doc.get("metadata", Document.class) != null
                            ? doc.get("metadata", Document.class).getString("title") : null;

                    // Retrieve borrower details from the person collection
                    String borrowerName = null;
                    if (borrowerId != null) {
                        Document borrowerDoc = personCollection.find(new Document("userId", borrowerId)).first();
                        if (borrowerDoc != null) {
                            Document personalDetails = borrowerDoc.get("personalDetails", Document.class);
                            if (personalDetails != null) {
                                firstName = personalDetails.getString("firstName");
                                lastName = personalDetails.getString("lastName");
                                borrowerName = firstName + " " + lastName;
                            }
                        }
                    }

                    Waitlist waitlistEntry = new Waitlist();
                    Person waitlistPers = new Person();
                    waitlistPers.setUserId(Math.toIntExact(borrowerId));
                    waitlistPers.setFirstName(firstName);
                    waitlistPers.setLastName(lastName);
                    waitlistEntry.setUser(waitlistPers);
                    waitlistEntry.setWaitlistId(Math.toIntExact(waitlistId));
                    waitlistEntry.setCheckoutDate(checkoutDateDate); // Store LocalDate directly
                    waitlistEntry.setStatus(status);
                    waitlistEntry.setReturnDate(returnDateDate);
                    Book waitlistBook = new Book();
                    waitlistBook.setTitle(bookTitle);
                    waitlistBook.setBookId(bookId != null ? Math.toIntExact(bookId) : null);
                    waitlistEntry.setBook(waitlistBook);

                    waitlistEntries.add(waitlistEntry);
                }
            }
        }

        System.out.println(waitlistEntries);

        return waitlistEntries;
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
        List<Waitlist> waitlist = new ArrayList<>();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy"); // Matches '22-01-2025'

        // Retrieve all documents from the collection
        List<Document> documents = collection.find(eq("bookId", bookId)).into(new ArrayList<>());

        for (Document doc : documents) {
            List<Document> waitlistArray = (List<Document>) doc.get("waitlist");

            if (waitlistArray != null) {
                for (Document entry : waitlistArray) {
                    Long waitlistId = entry.get("waitlistId", Number.class) != null
                            ? entry.get("waitlistId", Number.class).longValue() : null;
                    Long borrowerId = entry.get("borrowerId", Number.class) != null
                            ? entry.get("borrowerId", Number.class).longValue() : null;

                    // Handle dates using LocalDate.parse directly
                    String checkoutDate = entry.getString("checkoutDate");
                    LocalDate parsedCheckoutDate = checkoutDate != null
                            ? LocalDate.parse(checkoutDate, dateFormatter)
                            : null;

                    String returnDate = entry.getString("returnDate");
                    LocalDate parsedReturnDate = returnDate != null
                            ? LocalDate.parse(returnDate, dateFormatter)
                            : null;

                    String status = entry.getString("status");

                    Waitlist waitlistEntry = new Waitlist();
                    Person waitlistPers = new Person();
                    waitlistPers.setUserId(Math.toIntExact(borrowerId));
                    waitlistEntry.setUser(waitlistPers);
                    waitlistEntry.setWaitlistId(Math.toIntExact(waitlistId));
                    waitlistEntry.setCheckoutDate(parsedCheckoutDate); // Store LocalDate directly
                    waitlistEntry.setStatus(status);
                    waitlistEntry.setReturnDate(parsedReturnDate); // Store LocalDate directly
                    waitlist.add(waitlistEntry);
                }
            }
        }

        System.out.println("In waitlist for book: " + waitlist);
        return waitlist;

    }


    /**
     * Funktion, um die Wartelisten zu retournieren, die für einen bestimmten Nutzer bestehen.
     */
    public List<Waitlist> getWaitlistForUser(Long userId) {
        List<Waitlist> userWaitlist = new ArrayList<>();

        // Define the filter for the MongoDB query
        Document filter = new Document();

        // We want to match the "waitlist" array with a "borrowerId" equal to the provided userId
        filter.put("waitlist.borrowerId", userId);

        // Retrieve the documents from the collection where the waitlist contains the userId
        FindIterable<Document> documents = collection.find(filter);

        // Define the DateTimeFormatter for parsing dates
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

        // Iterate through all the documents
        for (Document doc : documents) {
            // Extract the "waitlist" array from the document
            List<Document> waitlistArray = (List<Document>) doc.get("waitlist");

            if (waitlistArray != null) {
                // Iterate over each entry in the waitlist array
                for (Document entry : waitlistArray) {
                    Long borrowerId = entry.get("borrowerId", Number.class) != null
                            ? entry.get("borrowerId", Number.class).longValue()
                            : null;

                    if (borrowerId != null && borrowerId.equals(userId)) {
                        // Create a Waitlist object and populate it with data
                        Waitlist waitlistEntry = new Waitlist();
                        waitlistEntry.setWaitlistId((int) entry.get("waitlistId", Number.class).longValue());
                        Person entryPers = new Person();
                        entryPers.setUserId(Math.toIntExact(borrowerId));

                        // Handle checkoutDate safely: parse only if not null/empty
                        String checkoutDate = entry.getString("checkoutDate");
                        if (checkoutDate != null && !checkoutDate.isEmpty()) {
                            waitlistEntry.setCheckoutDate(LocalDate.parse(checkoutDate, dateFormatter)); // Store LocalDate directly
                        } else {
                            waitlistEntry.setCheckoutDate(null); // Set to null if no checkout date
                        }

                        // Handle returnDate safely: parse only if not null/empty
                        String returnDate = entry.getString("returnDate");
                        if (returnDate != null && !returnDate.isEmpty()) {
                            waitlistEntry.setReturnDate(LocalDate.parse(returnDate, dateFormatter)); // Store LocalDate directly
                        } else {
                            waitlistEntry.setReturnDate(null); // Set to null if no return date
                        }

                        waitlistEntry.setStatus(entry.getString("status"));

                        // Add to the user's waitlist
                        userWaitlist.add(waitlistEntry);
                    }
                }
            }
        }

        return userWaitlist;

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
        List<Waitlist> prioritizedWaitlist = new ArrayList<>();


            // Fetch documents with a waitlist field
            List<Document> books = collection.find(eq("waitlist.status", "waiting")).into(new ArrayList<>());

            // Current date for priority calculation
            LocalDate currentDate = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

            for (Document book : books) {
                List<Document> waitlist = book.getList("waitlist", Document.class);

                for (Document entry : waitlist) {
                    if ("waiting".equals(entry.getString("status"))) {
                        String checkoutDateStr = entry.getString("checkoutDate");
                        LocalDate checkoutDate = LocalDate.parse(checkoutDateStr, formatter);


                        long priority = ChronoUnit.DAYS.between(checkoutDate, currentDate);


                        Waitlist waitlistEntry = new Waitlist();
                        Person waitlistPers = new Person();
                        waitlistPers.setUserId(entry.getInteger("borrowerId"));
                        waitlistEntry.setUser(waitlistPers);
                        waitlistEntry.setWaitlistId(entry.getInteger("waitlistId"));
                        waitlistEntry.setCheckoutDate(checkoutDate); // Store LocalDate directly
                        waitlistEntry.setStatus(entry.getString("status"));
                        prioritizedWaitlist.add(waitlistEntry);
                    }
                }
            }

            // Sort waitlist by priority in descending order
            //prioritizedWaitlist.sort(Comparator.comparingLong(Waitlist::getPriority).reversed());
        //}

        System.out.println("prioritized waitlist " + prioritizedWaitlist);
        return prioritizedWaitlist;
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
