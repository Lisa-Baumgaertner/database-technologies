package application;

import application.config.DatabaseConfig;
import application.service.BookService;
import application.controller.MainController;
import application.service.UserService;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;


public class Main extends Application {

    private final BookService bookService;
    private final UserService userService;

    public Main() throws IOException {
        this.bookService = new BookService(new DatabaseConfig().getBookRepository());
        this.userService = new UserService(new DatabaseConfig().getUserRepository());
    }

    @Override
    public void start(Stage primaryStage) throws Exception {

        FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/MainView.fxml"));
        Parent root = loader.load();

        MainController mainController = loader.getController();
        mainController.setBookService(bookService);
        mainController.setUserService(userService);

        Scene scene = new Scene(root, 800, 600);
        scene.getStylesheets().add(getClass().getResource("/styles/style.css").toExternalForm());

        primaryStage.setTitle("Library Management");
        primaryStage.setScene(scene);
        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }
}
