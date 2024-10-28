module application {
        requires javafx.controls;
        requires javafx.fxml;
        requires java.sql;

        exports application;
        opens application.controller to javafx.fxml;
        opens view to javafx.fxml;
}