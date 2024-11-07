package application.util;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class NoSQLDatabaseConnection {

    @Value("${mongodb.uri}")
    private String uri;

    @Value("${mongodb.database}")
    private String databaseName;

    private MongoClient mongoClient;
    private MongoDatabase database;

    // Leerer Konstruktor ohne Initialisierung
    public NoSQLDatabaseConnection() {
    }

    @PostConstruct
    public void init() {
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
