package application.repository;

import application.model.Person;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;


public class MongoUserRepositoryImpl implements UserRepository {
    private final MongoDatabase database;
    private final MongoCollection<Document> personCollection;

    public MongoUserRepositoryImpl(MongoDatabase database) {
        this.database = database;

        this.personCollection = database.getCollection(MongoCollectionNameRepository.getCollectionName("Person"));

    }

    public List<Person> getAllPersons() { return null;}

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
        Document query = new Document("userId", userId);
        Document result = personCollection.find(query).first();
        if (result != null) {
            Document personalDetails = (Document) result.get("personalDetails");
            if (personalDetails != null) {
                String firstName = personalDetails.getString("firstName");
                String lastName = personalDetails.getString("lastName");

                if (firstName != null && lastName != null) {
                    return firstName + " " + lastName;
                }
            }
        }
        return "Benutzer nicht gefunden";
    }

    /**
     * Person hinzufügen.
     */
    public Person insertPerson(Person person) {
        try {

            int newUserId = getNextUserId();
            person.setUserId(newUserId);

            // Adresse und Kontakt als Dokument erstellen
            Document addressDoc = new Document("street", person.getAddress().getStreet())
                    .append("houseNumber", person.getAddress().getHouseNumber())
                    .append("city", person.getAddress().getCity())
                    .append("zipCode", person.getAddress().getZipCode());

            Document contactDoc = new Document("email", person.getContact().getEmail())
                    .append("phone", person.getContact().getPhone())
                    .append("mobile", person.getContact().getMobile());

            // Person-Dokument erstellen
            Document personDoc = new Document("userId", newUserId)
                    .append("role", person.getRole())// Benutzerdefinierte `userId`
                    .append("personalDetails", new Document()
                            .append("firstName", person.getFirstName())
                            .append("lastName", person.getLastName())
                            .append("dateOfBirth", person.getBirthDate().toString())
                            .append("gender", String.valueOf(person.getGender())))
                    .append("address", addressDoc)
                    .append("contact", contactDoc)
                    .append("reviews", new ArrayList<>())  // Leeres Array für Reviews
                    .append("lendings", new ArrayList<>());  // Leeres Array für Lendings

            // Dokument in die Collection einfügen
            personCollection.insertOne(personDoc);

            System.out.println("Mitarbeiter erfolgreich hinzugefügt mit userId: " + newUserId);
            return person;

        } catch (Exception e) {
            System.err.println("Fehler beim Hinzufügen des Mitarbeiters in MongoDB: " + e.getMessage());
            return null;
        }
    }

    /**
     * Diese Methode ermittelt die nächste eindeutige `userId`, indem sie nach dem höchsten
     * aktuellen Wert in der `person`-Collection sucht und diesen um 1 erhöht.
     * Der Zweck ist, sicherzustellen, dass jede neue Person eine eindeutige `userId` erhält,
     * auch wenn Einträge in der Datenbank gelöscht wurden.
     *
     */
    public int getNextUserId() {
        Document maxUserIdDoc = personCollection.find()
                .sort(new Document("userId", -1))  // Absteigend sortieren
                .limit(1)
                .first();
        int maxUserId = (maxUserIdDoc != null && maxUserIdDoc.containsKey("userId")) ?
                maxUserIdDoc.getInteger("userId") : 0;  // Überprüfen, ob _id vorhanden ist
        return maxUserId + 1;
    }


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
