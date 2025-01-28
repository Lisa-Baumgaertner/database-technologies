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
    private final MongoCollection<Document> bookCollection;
    private final MongoCollection<Document> personCollection;



    /**
     * Konstruktor zur Initialisierung der MongoDB-Collection.
     */
    public MongoWaitlistRepositoryImpl(MongoDatabase mongoDatabase) {
        this.bookCollection = mongoDatabase.getCollection("Book"); // Verwende die Collection "books"
        this.personCollection = mongoDatabase.getCollection("Person");
    }


    /**
     * Funktion, um alle aktuellen Wartelisten zu bekommen.
     */
    @Override
    public List<Waitlist> getAllWaitlistEntries() {
        List<Waitlist> waitlistEntries = new ArrayList<>();

        // Nur Bücher mit Wartelisteneinträgen und Status "waiting" abrufen
        List<Document> documents = bookCollection.find(Filters.elemMatch("waitlist", Filters.eq("status", "waiting"))).into(new ArrayList<>());

        // DateTimeFormatter für Datumsumwandlungen
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

        for (Document doc : documents) {
            List<Document> waitlistArray = doc.getList("waitlist", Document.class);

            if (waitlistArray != null) {
                for (Document entry : waitlistArray) {
                    try {
                        // Nur Einträge mit Status "waiting" hinzufügen
                        String status = entry.getString("status");
                        if (!"waiting".equalsIgnoreCase(status)) {
                            continue; // Überspringt Einträge, die nicht "waiting" sind
                        }

                        // Werte sicher extrahieren
                        Long waitlistId = entry.get("waitlistId", Number.class) != null
                                ? entry.get("waitlistId", Number.class).longValue()
                                : null;
                        Long borrowerId = entry.get("borrowerId", Number.class) != null
                                ? entry.get("borrowerId", Number.class).longValue()
                                : null;
                        String checkoutDate = entry.getString("checkoutDate");
                        String returnDate = entry.getString("returnDate");

                        // Datumsumwandlung
                        LocalDate checkoutDateDate = (checkoutDate != null && !checkoutDate.isEmpty())
                                ? LocalDate.parse(checkoutDate, formatter)
                                : null;
                        LocalDate returnDateDate = (returnDate != null && !returnDate.isEmpty())
                                ? LocalDate.parse(returnDate, formatter)
                                : null;

                        // Buchinformationen abrufen
                        Long bookId = doc.get("bookId", Number.class) != null
                                ? doc.get("bookId", Number.class).longValue()
                                : null;
                        String bookTitle = doc.get("metadata", Document.class) != null
                                ? doc.get("metadata", Document.class).getString("title")
                                : null;

                        // Borrower-Details aus der Person-Collection abrufen
                        String firstName = "";
                        String lastName = "";
                        if (borrowerId != null) {
                            Document borrowerDoc = personCollection.find(Filters.eq("userId", borrowerId)).first();
                            if (borrowerDoc != null) {
                                Document personalDetails = borrowerDoc.get("personalDetails", Document.class);
                                if (personalDetails != null) {
                                    firstName = personalDetails.getString("firstName");
                                    lastName = personalDetails.getString("lastName");
                                }
                            }
                        }

                        // Waitlist-Eintrag erstellen
                        Waitlist waitlistEntry = new Waitlist();
                        Person waitlistPers = new Person();
                        waitlistPers.setUserId(borrowerId != null ? Math.toIntExact(borrowerId) : null);
                        waitlistPers.setFirstName(firstName);
                        waitlistPers.setLastName(lastName);
                        waitlistEntry.setUser(waitlistPers);
                        waitlistEntry.setWaitlistId(waitlistId != null ? Math.toIntExact(waitlistId) : null);
                        waitlistEntry.setCheckoutDate(checkoutDateDate);
                        waitlistEntry.setStatus(status);
                        waitlistEntry.setReturnDate(returnDateDate);

                        // Buch setzen
                        Book waitlistBook = new Book();
                        waitlistBook.setBookId(bookId != null ? Math.toIntExact(bookId) : null);
                        waitlistBook.setTitle(bookTitle);
                        waitlistEntry.setBook(waitlistBook);

                        // Zur Liste hinzufügen
                        waitlistEntries.add(waitlistEntry);
                    } catch (Exception e) {
                        System.err.println("Fehler beim Verarbeiten eines Wartelisteneintrags: " + e.getMessage());
                    }
                }
            }
        }

        System.out.println("Alle Wartelisteneinträge mit Status 'waiting': " + waitlistEntries);

        return waitlistEntries;
    }

    /**
     * Funktion, um zu einer Warteliste hinzuzufügen.
     */
    public Waitlist addToWaitlist(Waitlist waitlist) {
        // Date formatter for the checkout date
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd-MM-uuuu");
        LocalDate localDate = LocalDate.now();
        String checkoutDate = dtf.format(localDate);

        Document found = (Document) bookCollection.find(new Document("bookId", waitlist.getBook().getBookId())).first();
        if(found != null){
            System.out.println("Found book");
            Bson updatedvalue = new Document("waitlistId", waitlist.getWaitlistId())
                    .append("borrowerId", waitlist.getUser().getUserId())
                    .append("checkoutDate",waitlist.getCheckoutDate())
                    .append("status", "borrowed")
                    .append("returnDate", null);


            // Objekt zur Warteliste hinzufügen
            Bson updateOperation = Updates.push("waitlist", updatedvalue);
            UpdateResult result = bookCollection.updateOne(eq("bookId", waitlist.getBook().getBookId()), updateOperation);

            Long updatedCount = bookCollection.updateOne(
                    eq("bookId", waitlist.getBook().getBookId()),
                    updateOperation
            ).getModifiedCount();

            if (result.getModifiedCount() > 0) {
                System.out.println("Warteliste erfolgreich aktualisiert.");
                // Status & Kopien aktualisieren
                updateBookStatusAndCopies(waitlist.getBook().getBookId());
            } else {
                System.out.println("Keine Aktualisierung erfolgt.");
            }
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
        List<Document> documents = bookCollection.find(eq("bookId", bookId)).into(new ArrayList<>());

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
        FindIterable<Document> documents = bookCollection.find(filter);

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

        return bookCollection.updateOne(filter, update).getModifiedCount() > 0;
    }


    /**
     * Funktion, um die priorisierten Wartelisteneinträge zu bekommen.
     */
    public List<Waitlist> getPrioritizedWaitlistEntries() {
        List<Waitlist> prioritizedWaitlist = new ArrayList<>();

        // Fetch documents with a waitlist field where status is "waiting"
        List<Document> books = bookCollection.find(eq("waitlist.status", "waiting")).into(new ArrayList<>());


            // Fetch documents with a waitlist field
            //List<Document> books = collection.find(eq("waitlist.status", "waiting")).into(new ArrayList<>());

        // Current date for priority calculation
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

            for (Document book : books) {
                List<Document> waitlist = book.getList("waitlist", Document.class);

                for (Document entry : waitlist) {
                    if ("waiting".equals(entry.getString("status"))) {
                        try {
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
                        catch (Exception e) {
                            System.err.println("Error processing waitlist entry: " + e.getMessage());
                        }
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
        UpdateResult bookResult = bookCollection.updateOne(
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
        Document book = bookCollection.find(Filters.elemMatch("waitlist", Filters.eq("waitlistId", waitlistId))).first();
        if (book == null) {
            System.out.println("Kein Eintrag in der Warteliste mit ID " + waitlistId + " gefunden.");
            return false;
        }

        Long bookId = book.getLong("bookId");

        Bson filter = Filters.elemMatch("waitlist", Filters.eq("waitlistId", waitlistId));
        Bson update = Updates.pull("waitlist", new Document("waitlistId", waitlistId));

        boolean modified = bookCollection.updateOne(filter, update).getModifiedCount() > 0;

        if (modified) {
            System.out.println("Eintrag aus Warteliste entfernt.");
            // **Status & Kopien erhöhen**
            updateBookStatusAndCopies(bookId);
        } else {
            System.out.println("Fehler beim Entfernen aus Warteliste.");
        }

        return modified;
    }
    private void updateBookStatusAndCopies(Long bookId) {
        Document book = bookCollection.find(Filters.eq("bookId", bookId)).first();
        if (book == null) {
            System.out.println("Kein Buch mit der ID " + bookId + " gefunden.");
            return;
        }

        int copies = book.getInteger("copies", 0);
        List<Document> lendings = book.getList("lendings", Document.class, new ArrayList<>());
        List<Document> waitlist = book.getList("waitlist", Document.class, new ArrayList<>());

        // Status und Kopien initialisieren
        int updatedCopies = copies;
        String newStatus = "available";

        // Verarbeitung der Lending-Liste
        for (Document lending : lendings) {
            String lendingStatus = lending.getString("status");
            if ("borrowed".equalsIgnoreCase(lendingStatus)) {
                updatedCopies--; // Reduziere Kopien, wenn ausgeliehen
            } else if ("returned".equalsIgnoreCase(lendingStatus)) {
                updatedCopies++; // Erhöhe Kopien, wenn zurückgegeben
            }
        }

        // Verarbeitung der Warteliste
        for (Document waitlistEntry : waitlist) {
            String waitlistStatus = waitlistEntry.getString("status");
            if ("waiting".equalsIgnoreCase(waitlistStatus)) {
                updatedCopies--; // Reduziere Kopien, wenn auf Warteliste
            } else if ("returned".equalsIgnoreCase(waitlistStatus)) {
                updatedCopies++; // Erhöhe Kopien, wenn zurückgegeben
            }
        }

        // Sicherstellen, dass die Kopienanzahl nicht negativ ist
        updatedCopies = Math.max(0, updatedCopies);

        // Status basierend auf den aktualisierten Kopien und Listen festlegen
        if (updatedCopies > 0) {
            newStatus = "available";
        } else {
            boolean isBorrowed = lendings.stream().anyMatch(l -> "borrowed".equalsIgnoreCase(l.getString("status")));
            boolean hasWaitlist = waitlist.stream().anyMatch(w -> "waiting".equalsIgnoreCase(w.getString("status")));
            if (isBorrowed) {
                newStatus = "borrowed";
            } else if (hasWaitlist) {
                newStatus = "waiting";
            }
        }

        // MongoDB-Dokument aktualisieren
        bookCollection.updateOne(Filters.eq("bookId", bookId),
                Updates.combine(
                        Updates.set("status", newStatus),
                        Updates.set("copies", updatedCopies)
                ));

        System.out.println("Status für Buch " + bookId + " gesetzt auf '" + newStatus + "', Verfügbare Exemplare: " + updatedCopies);
    }
}
