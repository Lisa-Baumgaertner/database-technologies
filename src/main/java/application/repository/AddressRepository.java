package application.repository;

import application.model.Address;

public interface AddressRepository {
    Address getAddressByUserId(long userId);
    Address insertAddress(Address address);
}
