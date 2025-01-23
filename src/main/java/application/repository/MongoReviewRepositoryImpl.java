package application.repository;

import application.model.Review;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.conversions.Bson;

import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Implementierung des BewertungsRepository für MongoDB.
 */
public class MongoReviewRepositoryImpl implements ReviewRepository {
    private final MongoCollection<Document> collection;

    /**
     * Konstruktor, der die MongoDB-Verbindung initialisiert.
     */
    public MongoReviewRepositoryImpl(MongoDatabase database) {
        this.collection = database.getCollection(MongoCollectionNameRepository.getCollectionName("Book"));
    }

    /**
     * Holt alle Bewertungen zu einer bestimmten Buch-ID.
     */
    @Override
    public List<Review> getReviewsByBookId(int bookId) {
        List<Review> reviews = new ArrayList<>();

        // Finde das Buch mit der angegebenen bookId
        Document bookDoc = collection.find(Filters.eq("bookId", bookId)).first();

        if (bookDoc != null && bookDoc.containsKey("reviews")) {
            List<Document> reviewDocs = (List<Document>) bookDoc.get("reviews");

            for (Document reviewDoc : reviewDocs) {
                Review review = new Review();

                // Werte aus dem Review-Dokument extrahieren
                review.setReviewId(reviewDoc.getInteger("reviewId"));
                review.setUserId(reviewDoc.getInteger("borrowerId"));  // borrowerId als userId
                review.setReviewText(reviewDoc.getString("text"));

                // Datum sicher konvertieren
                String dateString = reviewDoc.getString("date");
                if (dateString != null && !dateString.isEmpty()) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                    review.setReviewDate(LocalDate.parse(dateString, formatter));
                }

                // Rating als Integer setzen
                Integer rating = reviewDoc.getInteger("rating");
                if (rating != null) {
                    review.setReviewRating(rating);
                }
                
                reviews.add(review);
            }
        }

        return reviews;
    }

    /**
     * Fügt eine neue Bewertung zu einem Buch hinzu.
     */
    @Override
    public boolean addReview(Review review) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

        // Neues Review-Dokument erstellen
        Document newReview = new Document()
                .append("reviewId", review.getReviewId())
                .append("borrowerId", review.getUserId())
                .append("text", review.getReviewText())
                .append("date", review.getReviewDate() != null ? review.getReviewDate().format(formatter) : null)
                .append("rating", review.getReviewRating());

        // Suche das Buch anhand der bookId und füge die Review hinzu
        Bson filter = Filters.eq("bookId", review.getBookId());
        Bson update = Updates.push("reviews", newReview);

        return collection.updateOne(filter, update).getModifiedCount() > 0;
    }

    /**
     * Löscht eine Bewertung anhand der Review-ID.
     */
    @Override
    public boolean deleteReview(int reviewId) {
        Bson filter = Filters.elemMatch("reviews", Filters.eq("reviewId", reviewId));
        Bson update = Updates.pull("reviews", new Document("reviewId", reviewId));

        return collection.updateOne(filter, update).getModifiedCount() > 0;
    }

    /**
     * Aktualisiert den Text einer Bewertung.
     */
    @Override
    public boolean updateReviewText(int reviewId, String newReviewText) {
        Bson filter = Filters.elemMatch("reviews", Filters.eq("reviewId", reviewId));
        Bson update = Updates.set("reviews.$.text", newReviewText);

        return collection.updateOne(filter, update).getModifiedCount() > 0;
    }
}
