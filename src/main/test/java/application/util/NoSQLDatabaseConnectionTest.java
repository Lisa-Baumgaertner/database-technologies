package application.util;

import com.mongodb.client.MongoDatabase;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class NoSQLDatabaseConnectionTest {

    @Test
    public void testConnectionNotNull() {
        NoSQLDatabaseConnection connection = new NoSQLDatabaseConnection("application.properties");
        MongoDatabase database = connection.getDatabase();

        assertNotNull(database, "MongoDatabase sollte nicht null sein.");
        assertEquals("librarymanagement", database.getName(), "Die Datenbanknamen sollten übereinstimmen.");

        connection.close();
    }
}
