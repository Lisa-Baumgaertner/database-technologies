package application.controller;

import application.model.Book;
import javafx.fxml.FXML;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.stage.Stage;
import application.repository.ReviewRepository;
import application.util.SQLDatabaseConnection;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.layout.StackPane;

import java.io.IOException;

public class BookDetailsController {

    @FXML
    private Label bookIdLabel;
    @FXML
    private Label titleLabel;
    @FXML
    private Label authorLabel;
    @FXML
    private Label isbnLongLabel;
    @FXML
    private Label isbnShortLabel;
    @FXML
    private Label publisherLabel;
    @FXML
    private Label yearPublishedLabel;
    @FXML
    private Label statusLabel;
    @FXML
    private Label copiesLabel;
    @FXML
    private Label keywordIdLabel;
    @FXML
    private TextArea descriptionArea;

    private int bookId;

    private Stage stage;

    public void setBookDetails(Book book) {
        this.bookId = (int) book.getBookId();
        bookIdLabel.setText(String.valueOf(book.getBookId()));
        titleLabel.setText(book.getTitle());
        authorLabel.setText(book.getAuthor());
        isbnLongLabel.setText(book.getIsbnLong());
        isbnShortLabel.setText(book.getIsbnShort());
        publisherLabel.setText(book.getPublisher());
        yearPublishedLabel.setText(String.valueOf(book.getYearPublished()));
        statusLabel.setText(book.getStatus());
        copiesLabel.setText(String.valueOf(book.getCopies()));
        keywordIdLabel.setText(String.valueOf(book.getKeywordId()));
        descriptionArea.setText(book.getDescription());
    }

    @FXML
    private void handleBack() {
        if (stage != null) {
            stage.close();
        }
    }

    @FXML
    private void showReviews() {
        try {
            // Bewertungsansicht
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/ReviewListView.fxml"));
            Parent reviewsView = loader.load();

            // Konfigurieren des ReviewListController
            ReviewListController reviewController = loader.getController();
            reviewController.setReviewRepository(new ReviewRepository(new SQLDatabaseConnection().getConnection()));
            reviewController.setBookId(bookId); // Buch-ID übergeben
            reviewController.loadReviews();    // Bewertungen laden

            // Bewertungsansicht anzeigen
            Stage stage = (Stage) titleLabel.getScene().getWindow();
            Scene scene = new Scene(reviewsView);
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public void setStage(Stage stage) {
        this.stage = stage;
    }
}
