package application.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class SQLDatabaseConnection {
    private static Connection connection;

    static {
        try {
            Properties properties = new Properties();
            properties.load(new FileInputStream("src/main/resources/application.properties"));

            String driver = properties.getProperty("database.driver");
            String url = properties.getProperty("database.url");
            String username = properties.getProperty("database.username");
            String password = properties.getProperty("database.password");

            // Treiber laden
            Class.forName(driver);

            // Verbindung herstellen
            connection = DriverManager.getConnection(url, username, password);
        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Fehler beim Laden der Datenbankverbindung");
        }
    }

    public static Connection getConnection() {
        return connection;
    }
}
