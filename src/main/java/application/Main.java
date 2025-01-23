package application;

import application.config.DatabaseConfig;
import application.service.*;
import application.controller.MainController;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

/**
 * Hauptklasse der JavaFX-Anwendung.
 * Initialisiert und startet die Anwendung sowie die zugehörigen Dienste.
 */
public class Main extends Application {

    // Instanzen der Services für Bücher, Nutzer und Ausleihen
    private final BookService bookService;
    private final UserService userService;
    private final LendingService lendingService;
    private final WaitlistService waitlistService;
    private final KeywordService keywordService;


    /**
     * Konstruktor, der die Services initialisiert, indem die Repositories über die Datenbankkonfiguration abgerufen werden.
     */
    public Main() throws IOException {
        DatabaseConfig config = new DatabaseConfig();
        this.bookService = new BookService(new DatabaseConfig().getBookRepository());
        this.userService = new UserService(
                config.getUserRepository(),
                config.getAddressRepository(),
                config.getContactRepository()
        );
        this.lendingService = new LendingService(new DatabaseConfig().getLendingRepository());
        this.waitlistService = new WaitlistService(new DatabaseConfig().getWaitlistRepository());
        this.keywordService = new KeywordService(new DatabaseConfig().getKeywordRepository());
    }

    /**
     * Startmethode für die JavaFX-Anwendung.
     * Lädt das Hauptfenster (MainView) und setzt die zugehörigen Services.
     */
    @Override
    public void start(Stage primaryStage) throws Exception {

        // Lade die Hauptansicht aus der FXML-Datei
        FXMLLoader loader = new FXMLLoader(getClass().getResource("/view/MainView.fxml"));
        Parent root = loader.load();

        // Hole den MainController und setze die Services
        MainController mainController = loader.getController();

        mainController.setBookService(bookService);
        mainController.setUserService(userService);
        mainController.setLendingService(lendingService);
        mainController.setWaitlistService(waitlistService);
        mainController.setKeywordService(keywordService);

        // Erstelle die Szene mit einer Größe von 1100 x 1000 Pixeln
        Scene scene = new Scene(root, 1100, 1000);
        scene.getStylesheets().add(getClass().getResource("/styles/style.css").toExternalForm());

        primaryStage.setTitle("Library Management");
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    /**
     * Hauptmethode, um die Anwendung zu starten.
     */
    public static void main(String[] args) {
        launch(args);
    }
}
