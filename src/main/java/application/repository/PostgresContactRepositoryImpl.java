package application.repository;

import application.model.Contact;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PostgresContactRepositoryImpl implements ContactRepository {

    private final Connection connection;

    public PostgresContactRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public Contact getContactByUserId(long userId) {
        String sql = "SELECT * FROM CONTACT WHERE USER_ID = ? LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Contact(
                        rs.getLong("contact_id"),
                        rs.getLong("user_id"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("mobile")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
