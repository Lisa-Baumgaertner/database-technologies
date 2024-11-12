module application {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;
    requires org.mongodb.driver.sync.client;
    requires spring.beans;
    requires spring.context;
    requires org.mongodb.driver.core;
    requires spring.boot.autoconfigure;
    requires spring.boot;
    requires jakarta.annotation;

    exports application;
    opens application.config to spring.beans;
    opens application.util to spring.beans, spring.context, spring.core;
    opens application.controller to javafx.fxml;
    opens view to javafx.fxml;
}
