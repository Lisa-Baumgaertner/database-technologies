package application.service;

import application.config.DatabaseConfig;
import application.model.Address;
import application.model.Keyword;
import application.repository.KeywordRepository;

import java.io.IOException;
import java.util.List;

public class KeywordService {

    private static KeywordService instance;
    private final KeywordRepository keywordRepository;

    public KeywordService(KeywordRepository keywordRepository) {
        this.keywordRepository = keywordRepository;
    }

    /**
     * Holt KeywordNames anhand der  bookId.
     */
    public List<Keyword> getKeywordsForBook(Long bookId) {
        return keywordRepository.getKeywordsForBook(bookId);
    }

    /**
     * Holt KeywordId anhand der  keyword.
     */
    public int getKeywordIdByName(String keywordName) {
        return keywordRepository.getKeywordIdByName(keywordName);
    }

    /**
     * fügt eine Keyword hinzu.
     */
    public int insertKeyword(String keywordName) {
        return keywordRepository.insertKeyword(keywordName);
    }



    /**
     * Singleton-Methode: Initialisiert BookService und stellt sicher, dass nur eine Instanz existiert.
     * @return Eine Instanz von BookService.
     */
    public static KeywordService getInstance() {
        if (instance == null) {
            try {
                // Erstelle eine neue Instanz von DatabaseConfig
                DatabaseConfig config = new DatabaseConfig();

                  KeywordRepository repository = config.getKeywordRepository();
                  instance = new KeywordService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des ContactService", e);
            }
        }
        return instance;
    }
}
