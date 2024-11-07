package application.util;

import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.SQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class SQLDatabaseConnectionTest {
    private static final Logger logger = LoggerFactory.getLogger(SQLDatabaseConnectionTest.class);


    @Test
    public void testGetConnection() {
        logger.info("Starting SQLDatabaseConnection test to verify connectivity.");
        try (Connection connection = SQLDatabaseConnection.getConnection()) {
            assertNotNull(connection, "The SQLDatabaseConnection bean should not be null.");
            assertTrue(connection.isValid(2), "Connection should be valid!");
            logger.info("SQLDatabaseConnection test completed successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error while testing the database connection");
        }
    }
}
