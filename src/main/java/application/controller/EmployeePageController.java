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
    public Button addBookButton;
    @FXML
    public Button editBookButton;
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
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookAddView.fxml"));
            Parent bookAddView = loader.load();

            Scene scene = new Scene(bookAddView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) addBookButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    @FXML
    private void handleBookEdit() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookEditView.fxml"));
            Parent bookEditView = loader.load();

            Scene scene = new Scene(bookEditView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) editBookButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }


}
