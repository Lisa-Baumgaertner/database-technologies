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

    public  String getUserNameById(int userId) {
        return "Benutzername";
    }

    public Person insertPerson(Person person) {
        return null;
    }
    public void deletePerson(Integer userId) {}
    public void updatePerson(Person Person) {}
}
