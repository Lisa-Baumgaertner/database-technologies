package application.repository;

import application.model.Address;
import application.model.Contact;
import application.model.Person;

import java.util.List;


public interface UserRepository {
    List<Person> getAllPersons();
    Person getFirstBorrower();
    String getUserNameById(int userId);
    Person insertPerson(Person Person);
    void deletePerson(Integer userId);
    void updatePerson(Person Person);
}
