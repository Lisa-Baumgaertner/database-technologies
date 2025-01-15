package application.repository;

import application.model.Address;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;

import static com.mongodb.client.model.Filters.eq;

/**
 * Implementierung des AddressRepository für MongoDB.
 * Diese Klasse ermöglicht das Abrufen und Einfügen von Adressdaten für Benutzer.
 */
public class MongoAddressRepositoryImpl implements AddressRepository {

  //  private final MongoDatabase database;
    private final MongoCollection<Document> collection;

    /**
     * Konstruktor, der die MongoDB-Collection für "persons" initialisiert.
     *
     * @param database Die MongoDB-Datenbankinstanz.
     */
    public MongoAddressRepositoryImpl(MongoDatabase database) {
        this.collection = database.getCollection("Person");
    }


    /**
     * Holt die Adresse eines Benutzers basierend auf der userId.
     *
     * @param userId Die ID des Benutzers.
     * @return Die Adresse des Benutzers oder null, wenn keine Adresse gefunden wurde.
     */
    @Override
    public Address getAddressByUserId(long userId) {
        // Suche das Dokument des Benutzers basierend auf der userId
        Document doc = collection.find(eq("userId", userId)).first();

        // Überprüfen, ob das Dokument und das Adressfeld vorhanden sind
        if (doc != null && doc.containsKey("address")) {
            Document addressDoc = (Document) doc.get("address");
            String houseNumber = String.valueOf(addressDoc.get("houseNumber"));
            String zipCode = String.valueOf(addressDoc.get("zipCode"));

            // Rückgabe des Address-Objekts mit den extrahierten Werten
            return new Address(
                    0L,  // addressId (MongoDB speichert keine ID, daher 0L)
                    userId,  // userId aus der Methode
                    addressDoc.getString("street"),
                    houseNumber,
                    addressDoc.getString("city"),
                    zipCode
            );
        }
        return null;
    }

    @Override
    public Address insertAddress(Address address) {
        // Erstellen des Address-Dokuments für MongoDB
        Document addressDoc = new Document("street", address.getStreet())
                .append("houseNumber", parseNumber(address.getHouseNumber()))
                .append("city", address.getCity())
                .append("zipCode", parseNumber(address.getZipCode()));

        // Einfügen des Address-Dokuments in die Collection
        collection.insertOne(new Document("address", addressDoc));

        return address;
    }

    /**
     * Hilfsmethode zum dynamischen Parsen von Zahlenwerten.
     * Versucht, einen String in einen Integer zu konvertieren.
     * Falls nicht möglich, wird der String zurückgegeben.
     *
     * @param value Der Wert als String.
     * @return Der Wert als Integer oder String.
     */
    private Object parseNumber(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return value;
        }
    }
}
