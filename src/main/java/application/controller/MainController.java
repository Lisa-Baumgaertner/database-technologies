package application.controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Objects;

public class MainController {

    public Button navigateBookSearchButton;

    @FXML
    private void showBookSearchView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookSearchView.fxml"));
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
    private void showLendingManagementView() {
        // TODO: Implementierung für die Verwaltung der Ausleihe, falls nötig ist
    }
}
