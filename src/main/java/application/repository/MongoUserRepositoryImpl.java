package application.repository;

import application.model.Person;
import com.mongodb.client.MongoDatabase;

public class MongoUserRepositoryImpl implements UserRepository {
    private final MongoDatabase database;
    public MongoUserRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    public Person getFirstBorrower() {
        return null;
    }
}
