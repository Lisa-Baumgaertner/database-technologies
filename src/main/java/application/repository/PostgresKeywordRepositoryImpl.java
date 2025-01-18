package application.repository;

import application.model.Keyword;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PostgresKeywordRepositoryImpl implements KeywordRepository {

    private final Connection connection;
    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     */
    public PostgresKeywordRepositoryImpl(Connection connection) {
        this.connection = connection;
    }



    @Override
   public List<Keyword> getKeywordsForBook(long bookId) {
        List<Keyword> keywords = new ArrayList<>();

        String query =  "SELECT K.KEYWORD_ID, K.KEYWORD " +
                "FROM KEYWORD K " +
                "JOIN BOOK_KEYWORD BK ON K.KEYWORD_ID = BK.KEYWORD_ID " +
                "WHERE BK.BOOK_ID = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, bookId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    keywords.add(new Keyword(
                            resultSet.getInt("KEYWORD_ID"),
                            resultSet.getString("KEYWORD")
                    ));
                }
            }

        } catch (SQLException e) {
            System.err.println("Fehler beim Abrufen des Buchtitels: " + e.getMessage());
            e.printStackTrace();
        }
        return keywords;
    }
}
