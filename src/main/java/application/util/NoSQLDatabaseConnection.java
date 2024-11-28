package application.util;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;



public class NoSQLDatabaseConnection {
    private final MongoClient mongoClient;
    private final MongoDatabase database;

    public NoSQLDatabaseConnection(String propertiesFileName) {
        // Lese die Properties
        PropertyReader propertyReader = new PropertyReader(propertiesFileName);
        String uri = propertyReader.getProperty("mongodb.uri");
        String databaseName = propertyReader.getProperty("mongodb.database");

        // Initialisiere die Verbindung
        this.mongoClient = MongoClients.create(uri);
        this.database = mongoClient.getDatabase(databaseName);
    }

    public MongoDatabase getDatabase() {
        return database;
    }

    public void close() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
