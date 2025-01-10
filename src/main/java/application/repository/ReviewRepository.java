
package application.repository;

import application.model.Review;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReviewRepository {

    private final Connection connection;

    public ReviewRepository(Connection connection) {
        this.connection = connection;
    }

    public List<Review> getReviewsByBookId(int bookId) throws SQLException {
        String query = "SELECT * FROM REVIEW WHERE BOOK_ID = ?";
        List<Review> reviews = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, bookId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("REVIEW_ID"));
                review.setBookId(rs.getInt("BOOK_ID"));
                review.setUserId(rs.getInt("USER_ID"));
                review.setReviewText(rs.getString("REVIEW_TEXT"));
                review.setReviewDate(rs.getDate("REVIEW_DATE").toLocalDate());
                review.setReviewRating(rs.getString("REVIEW_RATING"));

                reviews.add(review);
            }
        }

        return reviews;
    }

    public boolean addReview(Review review) throws SQLException {
        String query = "INSERT INTO REVIEW (BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, review.getBookId());
            stmt.setInt(2, review.getUserId());
            stmt.setString(3, review.getReviewText());
            stmt.setDate(4, Date.valueOf(review.getReviewDate()));
            stmt.setString(5, review.getReviewRating());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteReview(int reviewId) throws SQLException {
        String query = "DELETE FROM REVIEW WHERE REVIEW_ID = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, reviewId);
            return stmt.executeUpdate() > 0;
        }
    }
}