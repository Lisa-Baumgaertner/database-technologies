package application.config;

import application.repository.BookRepository;
import application.repository.MongoBookRepositoryImpl;
import application.repository.PostgresBookRepositoryImpl;
import application.util.NoSQLDatabaseConnection;
import application.util.SQLDatabaseConnection;

import java.io.IOException;
import java.util.Properties;

public class DatabaseConfig {
    private final boolean useMongoDB;

    public DatabaseConfig() throws IOException {
        Properties properties = new Properties();
        properties.load(getClass().getResourceAsStream("/application.properties"));
        this.useMongoDB = Boolean.parseBoolean(properties.getProperty("database.useMongoDB", "false"));
    }

    public BookRepository getBookRepository() {
        if (useMongoDB) {
            return new MongoBookRepositoryImpl(new NoSQLDatabaseConnection("application.properties").getDatabase());
        } else {
            return new PostgresBookRepositoryImpl(new SQLDatabaseConnection().getConnection());
        }
    }
}
