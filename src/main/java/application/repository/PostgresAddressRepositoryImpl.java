package application.repository;

import application.model.Address;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PostgresAddressRepositoryImpl implements AddressRepository {

    private final Connection connection;

    public PostgresAddressRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

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
}
