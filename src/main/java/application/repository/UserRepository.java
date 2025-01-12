package application.repository;

import application.model.Person;


public interface UserRepository {
    Person getFirstBorrower();
    String getUserNameById(int userId);
    Person insertPerson(Person Person);
    void deletePerson(Integer userId);
    void updatePerson(Person Person);
}
