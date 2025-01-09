package application.controller;

import application.service.BookService;
import application.service.LendingService;
import application.service.UserService;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import org.springframework.stereotype.Controller;

import java.io.IOException;
import java.util.Objects;

/**
 * Controller-Klasse für die Mitarbeiteransicht
 */
@Controller
public class EmployeePageController {


    public Button navigateBookSearchButton;
    @FXML
    public Button addBookButton;
    @FXML
    private BorderPane mainPane; // Bindet das BorderPane aus MainView.fxml

    private  BookService bookService;
    private LendingService lendingService;
    private UserService userService;

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }
     public void setLendingService(LendingService lendingService) {
        this.lendingService = lendingService;
    }
     public void setUserService(UserService userService) { this.userService = userService; }

    @FXML
    public Button editBookButton;
    @FXML
    public Button deleteBookButton;


    /**
     * Wechselt zur Ansicht "BookSearchView" und initialisiert deren Controller.
     */
    @FXML
    private void handleBookSearch() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/EmployeeBookSearchView.fxml"));
            Parent bookSearchView = loader.load();

            mainPane.setCenter(bookSearchView);

            EmployeeBookSearchController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            System.err.println("Fehler beim Laden der EmployeeBookSearchView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }


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
            controller.setBookService(bookService);

            Scene scene = new Scene(bookSearchView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) navigateBookSearchButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            System.err.println("Fehler beim Laden der MainView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }


    /**
     * Wechselt zur Ansicht "BookAddView" und initialisiert deren Controller.
     */
    @FXML
    private void handleBookAdd() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookAddView.fxml"));
            Parent bookAddView = loader.load();

            mainPane.setCenter(bookAddView);

            BookAddController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            System.err.println("Fehler beim Laden der BookAddView.fxml: " + e.getMessage());
            e.printStackTrace();
        }


    }


    /**
     * Wechselt zur Ansicht "BookEditView" und initialisiert deren Controller.
     */
    @FXML
    private void handleBookEdit() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookEditView.fxml"));
            Parent bookEditView = loader.load();

            mainPane.setCenter(bookEditView);

            BookEditController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            System.err.println("Fehler beim Laden der BookEditView.fxml: " + e.getMessage());
            e.printStackTrace();
        }


    }


    /**
     * Wechselt zur Ansicht "BookDeleteView" und initialisiert deren Controller.
     */
    @FXML
    private void handleBookDelete() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookDeleteView.fxml"));
            Parent bookDeleteView = loader.load();

            mainPane.setCenter(bookDeleteView);

            BookDeleteController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            System.err.println("Fehler beim Laden der BookDeleteView.fxml: " + e.getMessage());
            e.printStackTrace();
        }

    }


    /**
     * Wechselt zur Ansicht "LendingView" und initialisiert deren Controller.
     */
    @FXML
    private void handleLendingView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/LendingView.fxml"));
            Parent lendingView = loader.load();

            mainPane.setCenter(lendingView);

            LendingController controller = loader.getController();
            controller.setLendingService(LendingService.getInstance());
            controller.setUserService(UserService.getInstance());
            controller.setBookService(BookService.getInstance());

        } catch (IOException e) {
            System.err.println("Fehler beim Laden der LendingView.fxml: " + e.getMessage());
            e.printStackTrace();
        }
    }


}
