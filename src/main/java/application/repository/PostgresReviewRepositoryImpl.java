package application.repository;

import application.model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Diese Klasse implementiert das ReviewRepository-Interface für PostgreSQL.
 * Sie enthält Methoden, um Bewertungen für Bücher zu laden, hinzuzufügen und zu löschen.
 */
public class PostgresReviewRepositoryImpl implements ReviewRepository {

    private final Connection connection;

    public PostgresReviewRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    /**
     * Laden aller vorhandenen Bewertungen
     */
    @Override
    public List<Review> getReviewsByBookId(int bookId) {
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
                review.setReviewRating(rs.getInt("REVIEW_RATING"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Fehler beim Abrufen der Rezensionen", e);
        }

        return reviews;
    }

    /**
     * Hinzufügen einer Bewertung
     */
    @Override
    public boolean addReview(Review review) {
        String query = "INSERT INTO REVIEW (BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, review.getBookId());
            stmt.setInt(2, review.getUserId());
            stmt.setString(3, review.getReviewText());
            stmt.setDate(4, Date.valueOf(review.getReviewDate()));
            stmt.setInt(5, review.getReviewRating());
            return stmt.executeUpdate() > 0;  // Gibt true zurück, wenn erfolgreich
        } catch (SQLException e) {
            throw new RuntimeException("Fehler beim Hinzufügen der Rezension", e);
        }
    }

    /**
     * Löschen einer Bewertung
     */
    @Override
    public boolean deleteReview(int reviewId) {
        String query = "DELETE FROM REVIEW WHERE REVIEW_ID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Fehler beim Löschen der Rezension", e);
        }
    }

    /**
     * Bearbeitet eine Bewertung
     */
    @Override
    public boolean updateReviewText(int reviewId, String newReviewText) {
        String query = "UPDATE REVIEW SET REVIEW_TEXT = ? WHERE REVIEW_ID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, newReviewText);
            stmt.setInt(2, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Fehler beim Aktualisieren des Rezensionstextes", e);
        }
    }
}
