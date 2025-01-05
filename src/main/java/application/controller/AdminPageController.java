package application.controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Objects;

public class AdminPageController {

    public Button addWorkerButton;

    /**
     * Wechselt zur Ansicht "MainView" und initialisiert deren Controller.
     * Zurück Button wird bereitgestellt.
     */
    @FXML
    private void navigateToMainView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/MainView.fxml"));
            Parent bookSearchView = loader.load();

            MainController controller = loader.getController();
         //   controller.setBookService(bookService);

            Scene scene = new Scene(bookSearchView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) addWorkerButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            System.err.println("Fehler beim Laden der MainView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
