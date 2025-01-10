package application.repository;

import application.model.Review;
import java.util.List;

public interface ReviewRepository {
    List<Review> getReviewsByBookId(int bookId);

    // Die Methoden sollen den Erfolg der Operation zurückmelden (boolean)
    boolean addReview(Review review);

    boolean deleteReview(int reviewId);

    boolean updateReviewText(int reviewId, String newReviewText);  // Hier bleibt die Methode gleich
}
