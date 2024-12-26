
package application.model;

import javafx.beans.property.*;
import java.time.LocalDate;

public class Review {
    private IntegerProperty reviewId;
    private IntegerProperty bookId;
    private IntegerProperty userId;
    private StringProperty reviewText;
    private ObjectProperty<LocalDate> reviewDate;
    private StringProperty reviewRating;

    public Review() {
        this.reviewId = new SimpleIntegerProperty();
        this.bookId = new SimpleIntegerProperty();
        this.userId = new SimpleIntegerProperty();
        this.reviewText = new SimpleStringProperty();
        this.reviewDate = new SimpleObjectProperty<>();
        this.reviewRating = new SimpleStringProperty();
    }

    public int getReviewId() {
        return reviewId.get();
    }

    public void setReviewId(int reviewId) {
        this.reviewId.set(reviewId);
    }

    public IntegerProperty reviewIdProperty() {
        return reviewId;
    }

    public int getBookId() {
        return bookId.get();
    }

    public void setBookId(int bookId) {
        this.bookId.set(bookId);
    }

    public IntegerProperty bookIdProperty() {
        return bookId;
    }

    public int getUserId() {
        return userId.get();
    }

    public void setUserId(int userId) {
        this.userId.set(userId);
    }

    public IntegerProperty userIdProperty() {
        return userId;
    }

    public String getReviewText() {
        return reviewText.get();
    }

    public void setReviewText(String reviewText) {
        this.reviewText.set(reviewText);
    }

    public StringProperty reviewTextProperty() {
        return reviewText;
    }

    public LocalDate getReviewDate() {
        return reviewDate.get();
    }

    public void setReviewDate(LocalDate reviewDate) {
        this.reviewDate.set(reviewDate);
    }

    public ObjectProperty<LocalDate> reviewDateProperty() {
        return reviewDate;
    }

    public String getReviewRating() {
        return reviewRating.get();
    }

    public void setReviewRating(String reviewRating) {
        this.reviewRating.set(reviewRating);
    }

    public StringProperty reviewRatingProperty() {
        return reviewRating;
    }
}
