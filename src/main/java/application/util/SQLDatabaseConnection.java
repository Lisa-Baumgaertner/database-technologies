package application.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utility-Klasse für die Verwaltung der Verbindung zur SQL-Datenbank.
 * Die Verbindungseinstellungen werden aus einer `application.properties`-Datei geladen.
 */
public class SQLDatabaseConnection {
    private  Connection connection;

    /**
     * Konstruktor, der eine Verbindung zur SQL-Datenbank herstellt.
     * Liest die Datenbankkonfiguration aus einer Properties-Datei ein.
     */
    public SQLDatabaseConnection() {
        try {
            Properties properties = new Properties();
            // Lese die Eigenschaften aus der Properties-Datei
            properties.load(new FileInputStream("src/main/resources/application.properties"));

            String driver = properties.getProperty("database.driver");
            String url = properties.getProperty("database.url");
            String username = properties.getProperty("database.username");
            String password = properties.getProperty("database.password");

            // JDBC-Treiber laden
            Class.forName(driver);

            // Verbindung herstellen
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Fehler beim Laden der Datenbankverbindung");
        }
    }

    /**
     * Gibt die aktuelle Datenbankverbindung zurück.
     */
    public  Connection getConnection() {
        return connection;
    }
}
