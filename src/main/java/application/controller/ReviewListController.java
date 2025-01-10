package application.controller;

import application.model.Review;
import application.repository.ReviewRepository;
import application.service.ReviewService;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.stage.Stage;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

/**
 * Controller-Klasse für Bewertungen.
 * Ermöglicht Laden, Hinzufügen und Löschen von Bewertungen.
 */
public class ReviewListController {

    @FXML
    private TableView<Review> reviewTable;

    @FXML
    private TableColumn<Review, String> userColumn;

    @FXML
    private TableColumn<Review, String> reviewColumn;

    @FXML
    private TableColumn<Review, LocalDate> dateColumn;

    @FXML
    private TableColumn<Review, String> ratingColumn;

    @FXML
    private TextField reviewTextField;

    @FXML
    private TextField ratingTextField;

    @FXML
    private Button addButton;

    @FXML
    private Button deleteButton;

    private ObservableList<Review> reviews = FXCollections.observableArrayList();
    private ReviewRepository reviewRepository;
    private Stage stage;

    private int bookId;
    private ReviewService reviewService;

    public void setReviewService(ReviewService reviewService) {
        this.reviewService = reviewService;  // Die Service-Instanz zuweisen
    }

    public void setReviewRepository(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    /**
     * Initialisiert die Zellen in der Tabellen-Ansicht.
     */
    @FXML
    public void initialize() {
        userColumn.setCellValueFactory(cellData -> cellData.getValue().userIdProperty().asString());
        reviewColumn.setCellValueFactory(cellData -> cellData.getValue().reviewTextProperty());
        dateColumn.setCellValueFactory(cellData -> cellData.getValue().reviewDateProperty());
        ratingColumn.setCellValueFactory(cellData -> cellData.getValue().reviewRatingProperty());

        reviewTable.setItems(reviews);

        addButton.setOnAction(event -> handleAddReview());
        deleteButton.setOnAction(event -> handleDeleteReview());
    }

    /**
     * Lädt die Bewertungen des ausgewählten Buches.
     */
    public void loadReviews() {
        try {
            List<Review> reviewList = reviewService.getReviewsByBookId(bookId);
            reviews.setAll(reviewList);

            // Falls keine Bewertungen vorhanden sind, zeige eine entsprechende Meldung an
            if (reviewList.isEmpty()) {
                showAlert(Alert.AlertType.INFORMATION, "Keine Bewertungen", "Es sind noch keine Bewertungen für dieses Buch vorhanden.");
            }

        } catch (Exception e) {
            // Eine allgemeine Ausnahmebehandlung für alle Fehler, die beim Laden auftreten können
            showAlert(Alert.AlertType.ERROR, "Fehler", "Fehler beim Laden der Bewertungen: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Funktion zum Hinzufügen von Bewertungen.
     */
    private void handleAddReview() {
        try {
            String reviewText = reviewTextField.getText().trim();
            String rating = ratingTextField.getText().trim();

            if (reviewText.isEmpty() || rating.isEmpty()) {
                showAlert(Alert.AlertType.WARNING, "Ungültige Eingabe", "Bitte alle Felder ausfüllen.");
                return;
            }

            // Test ob die Bewertung im gültigen Bereich (1-5) liegt
            if (!isValidRating(rating)) {
                showAlert(Alert.AlertType.ERROR, "Ungültige Bewertung", "Die Bewertung muss zwischen 1 und 5 liegen.");
                return;
            }

            Review review = new Review();
            review.setBookId(bookId);
            review.setUserId(1);  // TODO: Benutzer-ID noch fest auf 1 gesetzt
            review.setReviewText(reviewText);
            review.setReviewDate(LocalDate.now());
            review.setReviewRating(rating);

            // Prüfen ob die Bewertung erfolgreich hinzugefügt wurde
            if (reviewService.addReview(review)) {
                loadReviews();
                showAlert(Alert.AlertType.INFORMATION, "Erfolg", "Bewertung hinzugefügt.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            showAlert(Alert.AlertType.ERROR, "Fehler", "Bewertung konnte nicht hinzugefügt werden.");
        }
    }


    /**
     * Funktion zum Löschen einer Bewertung.
     */
    private void handleDeleteReview() {
        Review selectedReview = reviewTable.getSelectionModel().getSelectedItem();

        if (selectedReview == null) {
            showAlert(Alert.AlertType.WARNING, "Keine Auswahl", "Bitte eine Bewertung auswählen.");
            return;
        }

        try {
            // Prüfen, ob die Bewertung erfolgreich gelöscht wurde
            if (reviewService.deleteReview(selectedReview.getReviewId())) {
                loadReviews();
                showAlert(Alert.AlertType.INFORMATION, "Erfolg", "Bewertung gelöscht.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            showAlert(Alert.AlertType.ERROR, "Fehler", "Bewertung konnte nicht gelöscht werden.");
        }
    }

    /**
     * Validiert, ob die Bewertung eine gültige Zahl zwischen 1 und 5 ist.
     */
    private boolean isValidRating(String rating) {
        try {
            int ratingValue = Integer.parseInt(rating);
            return ratingValue >= 1 && ratingValue <= 5;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Funktion für den Zurück Button.
     */
    @FXML
    private void handleBack() {
        if (stage != null) {
            stage.close();
        }
    }

    /**
     * Öffnen eines Alert Dialogs.
     */
    private void showAlert(Alert.AlertType alertType, String title, String content) {
        Alert alert = new Alert(alertType);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(content);
        alert.showAndWait();
    }
}
