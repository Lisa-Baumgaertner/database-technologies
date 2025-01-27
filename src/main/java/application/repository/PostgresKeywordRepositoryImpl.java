package application.repository;

import application.model.Keyword;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementierung des KeywordRepository für PostgreSQL.
 * Diese Klasse bietet Funktionen zum Abrufen von Keywords aus der PostgreSQL-Datenbank.
 */
public class PostgresKeywordRepositoryImpl implements KeywordRepository {

    private final Connection connection;
    /**
     * Konstruktor zur Initialisierung der Datenbankverbindung.
     */
    public PostgresKeywordRepositoryImpl(Connection connection) {
        this.connection = connection;
    }



/**
 * Ruft alle Keywords ab, die einem Buch anhand der Buch-ID zugeordnet sind.
 *
 * @param bookId Die ID des Buches, für das die Keywords abgerufen werden sollen.
 * @return Eine Liste von Keywords, die dem Buch zugeordnet sind.
 */
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
                while (resultSet.next()) {
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

    /**
     * Holt Keyword_ID mit Keywordname
     */
    @Override
    public int getKeywordIdByName(String keyword) {
        String query = "SELECT keyword_id FROM keyword WHERE keyword = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, keyword);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("keyword_id");
            }
        } catch (SQLException e) {
            System.err.println("Fehler beim Abrufen des KeywordId: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Fügt Keyword hinzu
     */
    @Override
    public int insertKeyword(String keyword) {
        String query = "INSERT INTO keyword (keyword) VALUES (?) RETURNING keyword_id";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, keyword);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("keyword_id");
            }
        } catch (SQLException e) {
            System.err.println("Fehler beim Hinzufügen des Keyword: " + e.getMessage());
            e.printStackTrace();
        }
        return -1; // Falls das Einfügen fehlschlägt
    }

}
