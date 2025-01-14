package application.repository;

import application.model.Address;
import application.model.Contact;
import application.model.Person;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

import static com.mongodb.client.model.Filters.eq;


public class MongoUserRepositoryImpl implements UserRepository {
    private final MongoDatabase database;
    private final MongoCollection<Document> personCollection;

    public MongoUserRepositoryImpl(MongoDatabase database) {
        this.database = database;

        this.personCollection = database.getCollection("Person");

        long totalPersons = personCollection.countDocuments();
        System.out.println("Anzahl aller Einträge in der Collection: " + totalPersons);
        System.out.println("personCollection " + this.personCollection.countDocuments() );

    }

    public Person getFirstBorrower() {
        Document doc = personCollection.find(eq("role", "borrower")).first();
        if (doc != null) {
            System.out.println("Gefundener Borrower: " + doc.toJson());  // Debug-Ausgabe
            return mapToPerson(doc);  // Dokument in Person-Objekt umwandeln
        } else {
            System.out.println("Keine Person mit der Rolle 'borrower' gefunden.");
            return null;  // Rückgabe von null, falls keine Person gefunden wurde
        }
    }

    /**
     * Holt Name der Person anhand userId.
     */
    public  String getUserNameById(int userId) {
        return "Benutzername";
    }

    /**
     * Person hinzufügen.
     */
    public Person insertPerson(Person person) {
        System.out.println("Insert Person: " + person);
        MongoCollection<Document> collection = database.getCollection("person");
        return null;
    }
    public Address insertAddress(Address address) { return null;}
    public Contact insertContact(Contact contact) { return null;}

    public void deletePerson(Integer userId) {}
    public void updatePerson(Person Person) {}

    private Person mapToPerson(Document doc) {
        Integer userId = doc.getInteger("userId");
        String role = doc.getString("role");

        Document personalDetails = doc.get("personalDetails", Document.class);
        String firstName = personalDetails.getString("firstName");
        String lastName = personalDetails.getString("lastName");
        String birthDateString = personalDetails.getString("dateOfBirth");  // Date-Feld "dateOfBirth"
        char gender = personalDetails.getString("gender").charAt(0);

        LocalDate birthDate = null;
        if (birthDateString != null) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");  // Passendes Format
                birthDate = LocalDate.parse(birthDateString, formatter);
            } catch (DateTimeParseException e) {
                System.err.println("Fehler beim Parsen des Geburtsdatums: " + e.getMessage());
            }
        }

        return new Person(userId, firstName, lastName, birthDate, gender, role);
    }

}
