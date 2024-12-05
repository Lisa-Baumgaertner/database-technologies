package application.controller;

import application.model.Book;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.stage.Stage;

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

    private Stage stage;

    public void setBookDetails(Book book) {
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

    public void setStage(Stage stage) {
        this.stage = stage;
    }
}
