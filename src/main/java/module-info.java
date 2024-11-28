module application {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;
    requires spring.context;
    requires spring.beans;
    requires org.mongodb.driver.sync.client;
    requires org.mongodb.bson;
    requires org.mongodb.driver.core;

    opens application to javafx.fxml;
    opens application.controller to javafx.fxml;
    exports application;
    exports application.controller;
    exports application.service;
    exports application.repository;
    exports application.model;
}
