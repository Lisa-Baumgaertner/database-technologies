package application.config;

import application.repository.BookRepository;
import application.repository.MongoBookRepositoryImpl;
import application.repository.PostgresBookRepositoryImpl;
import application.util.NoSQLDatabaseConnection;
import application.util.SQLDatabaseConnection;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ContextConfiguration;

@SpringBootTest
@ContextConfiguration(classes = DatabaseConfig.class) // Konfiguration angeben
public class DatabaseConfigTest {

    @Autowired
    private DatabaseConfig databaseConfig;

    @Autowired
    private SQLDatabaseConnection sqlDatabaseConnection;

    @Autowired
    private NoSQLDatabaseConnection noSQLDatabaseConnection;

    @Autowired
    private BookRepository bookRepository;

    @Test
    public void testUseMongoDB() {
        boolean useMongoDB = databaseConfig.useMongoDB;
        System.out.println("DEBUG: useMongoDB im Test = " + useMongoDB);

        // Verifizieren, ob der Wert korrekt aus der Konfiguration geladen wurde
        Assertions.assertFalse(useMongoDB, "useMongoDB sollte false sein (PostgreSQL wird verwendet)");
    }

    @Test
    public void testBookRepositoryBean() {
        boolean useMongoDB = databaseConfig.useMongoDB;

        if (useMongoDB) {
            // Prüfen, ob das Repository für MongoDB erstellt wurde
            Assertions.assertTrue(bookRepository instanceof MongoBookRepositoryImpl,
                    "BookRepository sollte eine Instanz von MongoBookRepositoryImpl sein, wenn MongoDB aktiv ist");
        } else {
            // Prüfen, ob das Repository für PostgreSQL erstellt wurde
            Assertions.assertTrue(bookRepository instanceof PostgresBookRepositoryImpl,
                    "BookRepository sollte eine Instanz von PostgresBookRepositoryImpl sein, wenn PostgreSQL aktiv ist");
        }
    }

    @Test
    public void testSQLDatabaseConnection() {
        // Testen, ob die SQL-Verbindung korrekt initialisiert wurde
        Assertions.assertNotNull(sqlDatabaseConnection.getConnection(), "SQL-Datenbankverbindung sollte nicht null sein");
    }

    @Test
    public void testNoSQLDatabaseConnection() {
        // Testen, ob die NoSQL-Verbindung korrekt initialisiert wurde
        Assertions.assertNotNull(noSQLDatabaseConnection.getDatabase(), "NoSQL-Datenbankverbindung sollte nicht null sein");
    }
}
