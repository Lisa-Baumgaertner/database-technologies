package application.repository;

import application.model.Contact;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import static com.mongodb.client.model.Filters.eq;

/**
 * Implementierung des ContactRepository für MongoDB.
 */
public class MongoContactRepositoryImpl implements ContactRepository {

    private final MongoCollection<Document> collection;

    /**
     * Konstruktor zur Initialisierung der "Personen"-Sammlung.
     */
    public MongoContactRepositoryImpl(MongoDatabase database) {
        this.collection = database.getCollection(MongoCollectionNameRepository.getCollectionName("Person"));
    }

    /**
     * Sucht den Kontakt anhand der User-ID.
     *
     * @param userId Die ID des Benutzers.
     * @return Das zugehörige Contact-Objekt oder null, wenn nicht gefunden.
     */
    @Override
    public Contact getContactByUserId(long userId) {
        Document doc = collection.find(eq("userId", userId)).first();

        if (doc != null && doc.containsKey("contact")) {
            Document contactDoc = (Document) doc.get("contact");
            return new Contact(
                    userId,
                    contactDoc.getString("email"),
                    contactDoc.getString("phone"),
                    contactDoc.getString("mobile")
            );
        }
        return null;
    }

    /**
     * Fügt einen neuen Kontakt in die Datenbank ein.
     *
     * @param contact Das Contact-Objekt, das eingefügt werden soll.
     * @return Das eingefügte Contact-Objekt.
     */
    @Override
    public Contact insertContact(Contact contact) {
        Document contactDoc = new Document("email", contact.getEmail())
                .append("phone", contact.getPhone())
                .append("mobile", contact.getMobile());

        collection.insertOne(new Document("contact", contactDoc));
        return contact;
    }
}
