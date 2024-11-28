package application.controller;

import application.service.BookService;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Objects;


public class MainController {
    public Button navigateUserViewButton;
    public Button navigateEmployeeViewButton;

    private BookService bookService;

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }


    @FXML
    private void showUserView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/UserView.fxml"));
            Parent bookSearchView = loader.load();

            BookSearchController controller = loader.getController();
            controller.setBookService(bookService);

            Scene scene = new Scene(bookSearchView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) navigateUserViewButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    @FXML
    private void showEmployeeView() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/EmployeeView.fxml"));
            Parent bookSearchView = loader.load();

            EmployeePageController controller = loader.getController();
            controller.setBookService(bookService);

            Scene scene = new Scene(bookSearchView, 800, 600);
            scene.getStylesheets().add(Objects.requireNonNull(getClass().getResource("/styles/style.css")).toExternalForm());
            Stage stage = (Stage) navigateEmployeeViewButton.getScene().getWindow();
            stage.setScene(scene);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}