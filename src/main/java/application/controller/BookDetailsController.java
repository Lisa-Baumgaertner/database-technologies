package application.controller;

import application.model.Book;
import application.model.Keyword;
import application.model.Person;
import application.model.Waitlist;
import application.repository.WaitlistRepository;
import application.service.*;
import javafx.fxml.FXML;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.stage.Stage;
import application.repository.ReviewRepository;
import application.util.SQLDatabaseConnection;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.layout.StackPane;

import java.io.IOException;
import java.text.BreakIterator;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import application.service.WaitlistService;

//import static jdk.javadoc.internal.doclets.formats.html.markup.HtmlStyle.title;


/**
 * Controller-Klasse für Details eines Buches
 */
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
    private Label keywordsLabel;
    @FXML
    private TextArea descriptionArea;
    @FXML
    private Button buttonBackToSearch;

    private int bookId;
    private Long userId;
    private Long myBookId;

    private final ReviewService reviewService;
    private WaitlistService waitlistService;
    private final KeywordService keywordService;

    public BookDetailsController() {
        this.reviewService = ReviewService.getInstance(); // Singleton-Instanz des ReviewService
        this.waitlistService = WaitlistService.getInstance();
        this.keywordService = KeywordService.getInstance();
    }

    private Stage stage;

    /**
     * Setzen der Details eines Buches, um sie dem Nutzer anzuzeigen
     * @param book
     */
    public void setBookDetails(Book book) {
        this.bookId = (int) book.getBookId();
        this.myBookId = book.getBookId();
        bookIdLabel.setText(String.valueOf(book.getBookId()));
        titleLabel.setText(book.getTitle());
        authorLabel.setText(book.getAuthor());
        isbnLongLabel.setText(book.getIsbnLong());
        isbnShortLabel.setText(book.getIsbnShort());
        publisherLabel.setText(book.getPublisher());
        yearPublishedLabel.setText(String.valueOf(book.getYearPublished()));
        statusLabel.setText(book.getStatus());
        copiesLabel.setText(String.valueOf(book.getCopies()));
        descriptionArea.setText(book.getDescription());

        // Keywords Liste anzeigen
        List<Keyword> keywords = keywordService.getKeywordsForBook(book.getBookId());
        if (keywords != null && !keywords.isEmpty()) {
            String keywordsText = keywords.stream()
                    .map(Keyword::getKeyword) // Extrahiere den Keyword-Namen
                    .collect(Collectors.joining(", ")); // Kombiniere die Keywords mit Kommas
            System.out.println(keywordsText);
            keywordsLabel.setText(keywordsText);
        } else {
            keywordsLabel.setText("Keine Keywords verfügbar");
        }

    }


    public void setUserIdBookDetails(Long userId) {
        this.userId = userId;
    };

    public Long getUserIdBookDetails(){
        return userId;
    }


    /**
     * Funktion für Handhabung von Zurückgehen.
     */
    @FXML
    private void handleBack() {
        // Get the current stage (popup)
        Stage stage = (Stage) buttonBackToSearch.getScene().getWindow();

        // Get the owner stage (underlying view) if available
        Stage ownerStage = (Stage) stage.getOwner();

        if (ownerStage != null) {
            // Show the underlying view (owner stage)
            ownerStage.show();
        }

        // Close the current popup
        stage.close();
    }


    /**
     * Funktion für das Anzeigen der Bewertungen
     */
    @FXML
    private void showReviews() {
        try {
            // Bewertungsansicht laden
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/ReviewListView.fxml"));
            Parent reviewsView = loader.load();

            // Konfigurieren des ReviewListController
            ReviewListController reviewController = loader.getController();
            reviewController.setReviewService(reviewService); // Service übergeben
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


    public void setWaitlistService(WaitlistService waitlistService) {
        this.waitlistService = waitlistService;
    }




    @FXML
    private void registerWaitlist() throws IOException {

        Waitlist resultAdd;
        String mystatus = statusLabel.getText();

        if (!mystatus.equals("available")){

            UserPageController uspController = new UserPageController();
            this.userId = uspController.getUserId();

            Person testPers = new Person();
            testPers.setUserId(userId.intValue());
            Book testBook = new Book();
            testBook.setBookId(bookId);
            Waitlist waitlist = new Waitlist();
            waitlist.setUser(testPers);
            waitlist.setBook(testBook);
            LocalDate date = LocalDate.of(2024,1, 8);
            waitlist.setCheckoutDate(date);
            waitlist.setStatus("waiting");
            waitlist.setWaitlistId(2);

            //resultAdd = waitlistService.addToWaitlist(userId, myBookId , mystatus);
            resultAdd = waitlistService.addToWaitlist(waitlist);
            if (resultAdd != null) {
                // Anzeige einer Meldung, wenn Nutzer erfolgreich auf Warteliste aufgenommen wurde
                showAlert("Success", "You have been placed on the waitlist successfully!");
            } else {
                // Anzeige einer Meldung, dass Nutzer schon auf Warteliste
                showAlert("Failure", "You are already on the waitlist!");

            }



        } else {

            // Anzeige einer Meldung, wenn Buch vorhanden und direkt ausleihbar
            showAlert("Book Available", "The book is available for checkout!");
        }

        }

    /**
     * Zeige eine Alertbox an.
     *
     * @param title   Titel des Alertes.
     * @param message Inhalt.
     */
    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setContentText(message);
        alert.showAndWait();

    }




    public void setStage(Stage stage) {
        this.stage = stage;
    }
}
