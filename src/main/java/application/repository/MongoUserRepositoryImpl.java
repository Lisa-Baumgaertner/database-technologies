package application.repository;

import application.model.Person;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

/**
 * Diese Klasse stellt die Implementierung des `UserRepository` für MongoDB bereit.
 */
public class MongoUserRepositoryImpl implements UserRepository {
    private final MongoDatabase database;
    private final MongoCollection<Document> personCollection;

    /**
     * Konstruktor zur Initialisierung der MongoDB-Datenbankverbindung und Collection.
     */
    public MongoUserRepositoryImpl(MongoDatabase database) {
        this.database = database;

        this.personCollection = database.getCollection(MongoCollectionNameRepository.getCollectionName("Person"));

    }

    /**
     * Ruft alle Personen aus der MongoDB-Collection ab und gibt eine Liste von `Person`-Objekten zurück.
     * @return Liste aller Personen.
     */
    public List<Person> getAllPersons() {
        List<Person> persons = new ArrayList<>();
        try (MongoCursor<Document> cursor = personCollection.find().iterator()) {
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                persons.add(mapToPerson(doc));
            }
        } catch (Exception e) {
            System.err.println("Fehler beim Abrufen der Personen: " + e.getMessage());
        }

        return persons;
    }

    /**
     * Findet die erste Person, die die Rolle "borrower" (Ausleiher) hat.
     */
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
     * Holt den Namen einer Person anhand der `userId`.
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
     * Fügt eine neue Person in die MongoDB-Collection ein.
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

    /**
     * Löscht eine Person anhand der `userId` aus der MongoDB-Collection.
     */
    public void deletePerson(Integer userId) {
        try {
            // Erstelle den Filter für die zu löschende Person anhand der `userId`
            Document filter = new Document("userId", userId);

            // Führe die Löschoperation durch
            long deletedCount = personCollection.deleteOne(filter).getDeletedCount();

            if (deletedCount > 0) {
                System.out.println("Person mit userId " + userId + " wurde erfolgreich gelöscht.");
            } else {
                System.out.println("Keine Person mit userId " + userId + " gefunden.");
            }
        } catch (Exception e) {
            System.err.println("Fehler beim Löschen der Person mit userId " + userId + ": " + e.getMessage());
        }
    }


    /**
     * Aktualisiert die Daten einer vorhandenen Person in der MongoDB-Collection.
     */
    public void updatePerson(Person person) {
        try {
            // Filter erstellen, um die Person zu finden
            Document filter = new Document("userId", person.getUserId());

            // Prüfe, ob die Person existiert
            Document existingPerson = personCollection.find(filter).first();
            if (existingPerson == null) {
                System.out.println("Keine Person mit userId " + person.getUserId() + " gefunden.");
                return;
            }

            // Aktualisierte persönliche Details
            Document personalDetails = new Document()
                    .append("firstName", person.getFirstName())
                    .append("lastName", person.getLastName())
                    .append("dateOfBirth", person.getBirthDate() != null ? person.getBirthDate().toString() : "")
                    .append("gender", String.valueOf(person.getGender()));

            // Aktualisierte Adresse
            Document addressDoc = new Document("street", person.getAddress().getStreet())
                    .append("houseNumber", person.getAddress().getHouseNumber())
                    .append("city", person.getAddress().getCity())
                    .append("zipCode", person.getAddress().getZipCode());

            // Aktualisierte Kontaktdaten
            Document contactDoc = new Document("email", person.getContact().getEmail())
                    .append("phone", person.getContact().getPhone())
                    .append("mobile", person.getContact().getMobile());

            // Erstelle das Update-Dokument, um nur die persönlichen Daten, Adresse und Kontakt zu aktualisieren
            Document updateDoc = new Document("$set", new Document()
                    .append("role", person.getRole())
                    .append("personalDetails", personalDetails)
                    .append("address", addressDoc)
                    .append("contact", contactDoc)
            );

            // Führe das Update aus
            personCollection.updateOne(filter, updateDoc);

            System.out.println("Person mit userId " + person.getUserId() + " erfolgreich aktualisiert.");
        } catch (Exception e) {
            System.err.println("Fehler beim Aktualisieren der Person mit userId " + person.getUserId() + ": " + e.getMessage());
        }
    }

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
