package application.repository;

import application.model.Address;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Implementierung des AddressRepository für PostgreSQL.
 * Diese Klasse bietet Methoden zum Abrufen und Einfügen von Adressen in der PostgreSQL-Datenbank.
 */
public class PostgresAddressRepositoryImpl implements AddressRepository {

    private final Connection connection;

    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     *
     * @param connection Die PostgreSQL-Datenbankverbindung.
     */
    public PostgresAddressRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    /**
     * Ruft die Adresse eines Benutzers anhand der User-ID ab.
     *
     * @param userId Die ID des Benutzers.
     * @return Die Adresse des Benutzers oder null, falls keine gefunden wurde.
     */
    @Override
    public Address getAddressByUserId(long userId) {
        String sql = "SELECT * FROM ADDRESS WHERE USER_ID = ? LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Address(
                        rs.getLong("address_id"),
                        rs.getLong("user_id"),
                        rs.getString("street"),
                        rs.getString("housenumber"),
                        rs.getString("city"),
                        rs.getString("zip_code")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Fügt eine neue Adresse in die Datenbank ein.
     */
    public Address insertAddress(Address address) {
        String query = "INSERT INTO address (user_id, street, housenumber, city, zip_code) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setLong(1, address.getUserId());
            preparedStatement.setString(2, address.getStreet());
            preparedStatement.setString(3, address.getHouseNumber());
            preparedStatement.setString(4, address.getCity());
            preparedStatement.setString(5, address.getZipCode());
            int rowsInserted = preparedStatement.executeUpdate();

            if (rowsInserted > 0) {
                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int addressId = generatedKeys.getInt(1);  // Automatisch generierte ID abrufen
                        address.setAddressId(addressId);  // In das Objekt setzen
                        return address;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Fehler beim Einfügen der Adresse: " + e.getMessage());
        }
        return null; // Fehler beim Einfügen
    }
}
