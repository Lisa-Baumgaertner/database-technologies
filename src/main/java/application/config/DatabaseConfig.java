package application.config;

import application.repository.*;
import application.util.NoSQLDatabaseConnection;
import application.util.SQLDatabaseConnection;

import java.io.IOException;
import java.util.Properties;

public class DatabaseConfig {
    private final boolean useMongoDB;

    /**
     * Konstruktor: Liest die Datenbankeinstellungen aus der Konfigurationsdatei.
     * @throws IOException Falls die Datei nicht geladen werden kann.
     */
    public DatabaseConfig() throws IOException {
        Properties properties = new Properties();
        properties.load(getClass().getResourceAsStream("/application.properties"));
        this.useMongoDB = Boolean.parseBoolean(properties.getProperty("database.useMongoDB", "false"));
    }

    /**
     * Gibt ein BookRepository zurück, abhängig von der Datenbankkonfiguration.
     * @return BookRepository-Instanz.
     */

    public BookRepository getBookRepository() {
        if (useMongoDB) {
            return new MongoBookRepositoryImpl(new NoSQLDatabaseConnection("application.properties").getDatabase());
        } else {
            return new PostgresBookRepositoryImpl(new SQLDatabaseConnection().getConnection());
        }
    }
    /**
     * Gibt ein NotificationRepository zurück, abhängig von der Datenbankkonfiguration.
     * @return NotificationRepository-Instanz.
     */
    public NotificationRepository getNotificationRepository() {
        if (useMongoDB) {
            return new MongoNotificationRepositoryImpl(new NoSQLDatabaseConnection("application.properties").getDatabase());
        } else {
            return new PostgresNotificationRepositoryImpl(new SQLDatabaseConnection().getConnection());
        }
    }
    /**
     * Gibt ein UserRepository zurück, abhängig von der Datenbankkonfiguration.
     * @return UserRepository-Instanz.
     */

    public  UserRepository getUserRepository() {
        if (useMongoDB) {
            return new MongoUserRepositoryImpl(new NoSQLDatabaseConnection("application.properties").getDatabase());
        } else {
            return new PostgresUserRepositoryImpl(new SQLDatabaseConnection().getConnection());
        }
    }

    /**
     * Gibt ein LendingRepository zurück, abhängig von der Datenbankkonfiguration.
     * @return LendingRepository-Instanz.
     */

    public  LendingRepository getLendingRepository() {
        if (useMongoDB) {
            return new MongoLendingRepositoryImpl(new NoSQLDatabaseConnection("application.properties").getDatabase());
        } else {
            return new PostgresLendingRepositoryImpl(new SQLDatabaseConnection().getConnection());
        }
    }

    /**
     * Gibt das ReviewRepository zurück, um auf Bewertungen zuzugreifen.
     * @return das ReviewRepository
     */
    public ReviewRepository getReviewRepository() {
        if (useMongoDB) {
            return new MongoReviewRepositoryImpl(new NoSQLDatabaseConnection("application.properties").getDatabase());
        } else {
            return new PostgresReviewRepositoryImpl(new SQLDatabaseConnection().getConnection());
        }
    }
}
