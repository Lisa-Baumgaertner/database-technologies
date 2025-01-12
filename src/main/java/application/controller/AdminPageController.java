package application.controller;

import application.service.UserService;
import application.service.BackupService;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import javafx.scene.control.Alert;

import java.io.IOException;
import java.util.Objects;

public class AdminPageController {
    @FXML
    private BorderPane mainPane;
    public Button addWorkerButton;
    @FXML
    private Button backupPostgresButton;
    @FXML
    private Button backupMongoButton;

    private UserService userService;

    private final BackupService backupService = new BackupService();

    public void setUserService(UserService userService) { this.userService = userService; }

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

            Scene scene = new Scene(bookSearchView, 1100, 1000);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) addWorkerButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            System.err.println("Fehler beim Laden der MainView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }
    @FXML
    private void navigateToEmployeeAddView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/EmployeeAddView.fxml"));
            Parent employeeAddView = loader.load();

            mainPane.setCenter(employeeAddView);

            EmployeeAddController controller = loader.getController();
            controller.setUserService(UserService.getInstance());


        } catch (IOException e) {
            System.err.println("Fehler beim Laden der MainView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Führt das PostgreSQL Backup aus.
     */
    @FXML
    private void handlePostgresBackup() {
        backupService.backupPostgres();
        showAlert("PostgreSQL Backup", "Das PostgreSQL Backup wurde erfolgreich durchgeführt.");
    }

    /**
     * Führt das MongoDB Backup aus.
     */
    @FXML
    private void handleMongoBackup() {
        backupService.backupMongoDB();
        showAlert("MongoDB Backup", "Das MongoDB Backup wurde erfolgreich durchgeführt.");
    }

    /**
     * Zeigt eine einfache Informationsmeldung.
     */
    private void showAlert(String title, String content) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(content);
        alert.showAndWait();
    }
}
