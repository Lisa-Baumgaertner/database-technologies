package application.repository;



import application.model.Person;


public interface UserRepository {
    Person getFirstBorrower();
    String getUserNameById(int userId);
}
