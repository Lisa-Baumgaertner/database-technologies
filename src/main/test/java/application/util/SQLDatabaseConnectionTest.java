package application.util;

import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class SQLDatabaseConnectionTest {

    @Test
    public void testGetConnection() {
        try (Connection connection = SQLDatabaseConnection.getConnection()) {
            assertNotNull(connection, "Verbindung sollte nicht null sein");
            assertTrue(connection.isValid(2), "Verbindung sollte gültig sein");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Fehler beim Testen der Datenbankverbindung");
        }
    }
}
