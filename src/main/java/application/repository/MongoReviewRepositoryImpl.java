package application.repository;

import application.model.Review;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.util.List;

/**
 * Implementierung des BewertungsRepository für MongoDB.
 */
public class MongoReviewRepositoryImpl implements ReviewRepository {
    private final MongoCollection<Document> collection;
    private final MongoDatabase database;

    public MongoReviewRepositoryImpl(MongoDatabase database) {
        this.database = database;
        this.collection = database.getCollection("reviews");
    }

    @Override
    public List<Review> getReviewsByBookId(int bookId) {
        // Hier könntest du Code hinzufügen, um die Reviews aus MongoDB zu laden
        return null;
    }

    @Override
    public boolean addReview(Review review) {
        // Code zum Hinzufügen einer Review in MongoDB
        return false;
    }

    @Override
    public boolean deleteReview(int reviewId) {
        // Code zum Löschen einer Review in MongoDB
        return false;
    }

    @Override
    public boolean updateReviewText(int reviewId, String newReviewText) {
        MongoCollection<Document> reviewsCollection = database.getCollection("reviews");

        Document query = new Document("reviewId", reviewId);
        Document update = new Document("$set", new Document("reviewText", newReviewText));

        long modifiedCount = reviewsCollection.updateOne(query, update).getModifiedCount();
        return modifiedCount > 0;
    }
}
