package application.repository;

import application.model.Address;
import com.mongodb.client.MongoDatabase;

import static com.mongodb.client.model.Filters.eq;

public class MongoAddressRepositoryImpl implements AddressRepository {

    private final MongoDatabase database;

    public MongoAddressRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }

    @Override
    public Address getAddressByUserId(long userId) {
        return null;
    }
}
