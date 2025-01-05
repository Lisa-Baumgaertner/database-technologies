package application.util;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;


/**
 * Utility-Klasse für die Verwaltung der Verbindung zur MongoDB-Datenbank.
 * Die Verbindung wird durch die Konfigurationseigenschaften aus einer Properties-Datei hergestellt.
 */
public class NoSQLDatabaseConnection {
    private final MongoClient mongoClient;
    private final MongoDatabase database;

    /**
     * Konstruktor, der die MongoDB-Verbindung anhand einer Properties-Datei initialisiert.
     */
    public NoSQLDatabaseConnection(String propertiesFileName) {
        // Lese die Properties
        PropertyReader propertyReader = new PropertyReader(propertiesFileName);
        String uri = propertyReader.getProperty("mongodb.uri");
        String databaseName = propertyReader.getProperty("mongodb.database");

        // Erstelle die Verbindung
        this.mongoClient = MongoClients.create(uri);
        this.database = mongoClient.getDatabase(databaseName);
    }

    /**
     * Gibt die Datenbankinstanz zurück.
     */
    public MongoDatabase getDatabase() {
        return database;
    }

    /**
     * Schließt die Verbindung zur MongoDB-Datenbank.
     */
    public void close() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("Die Verbindung zur MongoDB wurde geschlossen.");
        }
    }
}
