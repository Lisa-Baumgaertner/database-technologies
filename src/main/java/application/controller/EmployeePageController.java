package application.controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Objects;

public class EmployeePageController {

    public Button navigateBookSearchButton;
    @FXML
    private BorderPane mainPane; // Bindet das BorderPane aus MainView.fxml
    @FXML
    private void handleBookSearch() {
        try {
            Parent bookSearchView = FXMLLoader.load(getClass().getResource("/view/BookSearchView.fxml"));
            mainPane.setCenter(bookSearchView); // Setzt die Buchsuche in den Center-Bereich
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    @FXML
    private void navigateToMainView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/MainView.fxml"));
            Parent bookSearchView = loader.load();

            Scene scene = new Scene(bookSearchView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) navigateBookSearchButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void handleBookAdd() {
        try {
            Parent bookAddView = FXMLLoader.load(getClass().getResource("/view/BookAddView.fxml"));
            mainPane.setCenter(bookAddView); // Setzt die Buchinsertion in den Center-Bereich
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


}
