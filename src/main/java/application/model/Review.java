
package application.model;

import javafx.beans.property.*;
import java.time.LocalDate;

/**
 * Modellklasse für eine Bewertung in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Bewertungs-Id, Bewertungstext, Bewertungsdatum und Rating.
 */
public class Review {
    private IntegerProperty reviewId;
    private IntegerProperty bookId;
    private IntegerProperty userId;
    private StringProperty reviewText;
    private ObjectProperty<LocalDate> reviewDate;
    private IntegerProperty reviewRating;

    /**
     * Standardkonstruktor für Bewertungen.
     * Initialisiert alle Properties mit Standardwerten.
     */
    public Review() {
        this.reviewId = new SimpleIntegerProperty();
        this.bookId = new SimpleIntegerProperty();
        this.userId = new SimpleIntegerProperty();
        this.reviewText = new SimpleStringProperty();
        this.reviewDate = new SimpleObjectProperty<>();
        this.reviewRating = new SimpleIntegerProperty();
    }

    /**
     * Konstruktor mit Parametern.
     */
    public Review(int reviewId, int bookId, int userId, String reviewText, LocalDate reviewDate, int reviewRating) {
        this.reviewId = new SimpleIntegerProperty(reviewId);
        this.bookId = new SimpleIntegerProperty(bookId);
        this.userId = new SimpleIntegerProperty(userId);
        this.reviewText = new SimpleStringProperty(reviewText);
        this.reviewDate = new SimpleObjectProperty<>(reviewDate);
        this.reviewRating = new SimpleIntegerProperty(reviewRating);
    }

    // Getter und Setter für Properties

    /**
     * Holt die ID der Bewertung.
     *
     * @return Die ID der Bewertung.
     */
    public int getReviewId() {
        return reviewId.get();
    }

    public void setReviewId(int reviewId) {
        this.reviewId.set(reviewId);
    }

    public IntegerProperty reviewIdProperty() {
        return reviewId;
    }

    /**
     * Holt die ID des Buches.
     *
     * @return Die ID der Buches.
     */
    public int getBookId() {
        return bookId.get();
    }

    public void setBookId(int bookId) {
        this.bookId.set(bookId);
    }

    public IntegerProperty bookIdProperty() {
        return bookId;
    }

    /**
     * Holt die ID des Nutzers.
     *
     * @return Die ID des Nutzers.
     */
    public int getUserId() {
        return userId.get();
    }

    public void setUserId(int userId) {
        this.userId.set(userId);
    }

    public IntegerProperty userIdProperty() {
        return userId;
    }

    /**
     * Holt den Text der Bewertung.
     *
     * @return Den Text der Bewertung.
     */
    public String getReviewText() {
        return reviewText.get();
    }

    public void setReviewText(String reviewText) {
        this.reviewText.set(reviewText);
    }

    public StringProperty reviewTextProperty() {
        return reviewText;
    }

    /**
     * Holt das Datum der Bewertung.
     *
     * @return Das Datum der Bewertung.
     */
    public LocalDate getReviewDate() {
        return reviewDate.get();
    }

    public void setReviewDate(LocalDate reviewDate) {
        this.reviewDate.set(reviewDate);
    }

    public ObjectProperty<LocalDate> reviewDateProperty() {
        return reviewDate;
    }

    /**
     * Holt das Rating der Bewertung.
     *
     * @return Das Rating der Bewertung.
     */
    public int getReviewRating() {
        return reviewRating.get();
    }

    public void setReviewRating(int reviewRating) {
        this.reviewRating.set(reviewRating);
    }

    public IntegerProperty reviewRatingProperty() {
        return reviewRating;
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + getReviewId() +
                ", bookId=" + getBookId() +
                ", borrowerId=" + getUserId() +
                ", reviewText='" + getReviewText() + '\'' +
                ", reviewDate=" + getReviewDate() +
                ", reviewRating=" + getReviewRating() +
                '}';
    }
}
