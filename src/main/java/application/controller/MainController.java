package application.controller;

import application.service.BookService;
import application.service.LendingService;
import application.service.NotificationService;
import application.service.UserService;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Objects;

/**
 * Controller-Klasse des Hauptcontrollers.
 * Steuert Anzeige der Nutzeransicht und Mitarbeiteransicht.
 */
public class MainController {
    @FXML
    private VBox notificationPane;
    public Button navigateUserViewButton;
    public Button navigateEmployeeViewButton;

    private BookService bookService;
    private LendingService lendingService;
    private NotificationService notificationService;
    private UserService userService;
    private  NotificationController notificationController;

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }
    public void setUserService(UserService userService) {this.userService = userService;}
    public void setLendingService(LendingService lendingService) {this.lendingService = lendingService;}

    /**
     * Anzeige der Nutzeransicht.
     */
    @FXML
    private void showUserView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/UserLoginView.fxml"));
            Parent root = loader.load();

            UserLoginController controller = loader.getController();
            controller.setUserService(UserService.getInstance());
           // controller.setBookService(BookService.getInstance());
            Scene scene = new Scene(root, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) navigateUserViewButton.getScene().getWindow();
            stage.setScene(scene);
            stage.show();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Anzeige der Mitarbeiteransicht.
     */
    @FXML
    private void showEmployeeView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/EmployeeView.fxml"));
            Parent root = loader.load();

            EmployeePageController controller = loader.getController();
            controller.setBookService(BookService.getInstance());
            controller.setLendingService(LendingService.getInstance());

            Scene scene = new Scene(root, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) navigateEmployeeViewButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}