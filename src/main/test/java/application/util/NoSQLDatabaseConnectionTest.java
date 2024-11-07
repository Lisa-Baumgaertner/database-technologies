package application.util;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class NoSQLDatabaseConnectionTest {

    private static final Logger logger = LoggerFactory.getLogger(NoSQLDatabaseConnectionTest.class);

    @Autowired
    private NoSQLDatabaseConnection noSQLDatabaseConnection;

    @Test
    public void testConnectionNotNull() {
        logger.info("Starting NoSQLDatabaseConnection test to verify connectivity.");

        assertNotNull(noSQLDatabaseConnection, "The NoSQLDatabaseConnection bean should not be null.");
        assertNotNull(noSQLDatabaseConnection.getDatabase(), "The MongoDatabase object should not be null.");

        logger.info("Successfully connected to the database: {}", noSQLDatabaseConnection.getDatabase().getName());
        logger.info("NoSQLDatabaseConnection test completed successfully.");
    }
}
