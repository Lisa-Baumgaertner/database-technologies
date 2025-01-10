package application.service;

import application.config.DatabaseConfig;
import application.model.Review;
import application.repository.ReviewRepository;

import java.io.IOException;
import java.util.List;

/**
 * Service-Klasse zur Verwaltung von Rezensionen.
 * Diese Klasse bietet Methoden zur Manipulation und Abfrage von Rezensionsdaten.
 * Stellt sicher, dass nur eine Instanz von ReviewService existiert.
 */
public class ReviewService {
    private static ReviewService instance;
    private final ReviewRepository reviewRepository;

    /**
     * Konstruktor, der das ReviewRepository initialisiert.
     *
     * @param reviewRepository das Repository für Rezensionsdaten
     */
    public ReviewService(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    /**
     * Singleton-Methode: Initialisiert ReviewService und stellt sicher, dass nur eine Instanz existiert.
     *
     * @return Eine Instanz von ReviewService.
     */
    public static ReviewService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                // Hole das ReviewRepository aus der Konfiguration
                ReviewRepository repository = config.getReviewRepository();
                instance = new ReviewService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des ReviewService", e);
            }
        }
        return instance;
    }

    /**
     * Ruft alle Rezensionen für ein bestimmtes Buch ab.
     *
     * @param bookId ID des Buches
     * @return Liste der Rezensionen
     */
    public List<Review> getReviewsByBookId(int bookId) {
        return reviewRepository.getReviewsByBookId(bookId);
    }

    /**
     * Fügt eine neue Rezension hinzu.
     *
     * @param review Die Rezension, die hinzugefügt werden soll
     * @return true, wenn die Rezension erfolgreich hinzugefügt wurde, false sonst
     */
    public boolean addReview(Review review) {
        return reviewRepository.addReview(review);
    }

    /**
     * Entfernt eine Rezension basierend auf der ID.
     *
     * @param reviewId ID der zu entfernenden Rezension
     * @return true, wenn die Rezension erfolgreich entfernt wurde, false sonst
     */
    public boolean deleteReview(int reviewId) {
        return reviewRepository.deleteReview(reviewId);
    }

    /**
     * Aktualisiert den Text einer vorhandenen Rezension.
     *
     * @param reviewId  ID der Rezension
     * @param newReviewText Der neue Text für die Rezension
     * @return true, wenn die Rezension erfolgreich aktualisiert wurde, false sonst
     */
    public boolean updateReviewText(int reviewId, String newReviewText) {
        return reviewRepository.updateReviewText(reviewId, newReviewText);
    }
}
