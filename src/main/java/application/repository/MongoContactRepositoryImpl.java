package application.repository;

import application.model.Contact;
import com.mongodb.client.MongoDatabase;

import static com.mongodb.client.model.Filters.eq;

public class MongoContactRepositoryImpl implements ContactRepository {

    private final MongoDatabase database;

    public MongoContactRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    @Override
    public Contact getContactByUserId(long userId) {
        return null;
    }
}
