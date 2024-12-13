package application.controller;

import application.service.BookService;
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

@Controller
public class EmployeePageController {


    public Button navigateBookSearchButton;
    @FXML
    public Button addBookButton;
    @FXML
    private BorderPane mainPane; // Bindet das BorderPane aus MainView.fxml

    private  BookService bookService;

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }

    @FXML
    public Button editBookButton;
    @FXML
    public Button deleteBookButton;
    @FXML
    private void handleBookSearch() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookSearchView.fxml"));
            Parent bookSearchView = loader.load();

            mainPane.setCenter(bookSearchView);

            BookSearchController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
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
            e.printStackTrace();
        }
    }

    @FXML
    private void handleBookAdd() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookAddView.fxml"));
            Parent bookAddView = loader.load();

            mainPane.setCenter(bookAddView);

            BookAddController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    @FXML
    private void handleBookEdit() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookEditView.fxml"));
            Parent bookEditView = loader.load();

            mainPane.setCenter(bookEditView);

            BookEditController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    @FXML
    private void handleBookDelete() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/BookDeleteView.fxml"));
            Parent bookDeleteView = loader.load();

            mainPane.setCenter(bookDeleteView);

            BookDeleteController controller = loader.getController();
            controller.setBookService(bookService);

        } catch (IOException e) {
            e.printStackTrace();
        }

    }


}
