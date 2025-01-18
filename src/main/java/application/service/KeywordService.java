package application.service;

import application.config.DatabaseConfig;
import application.model.Address;
import application.model.Keyword;
import application.repository.AddressRepository;
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
     * Holt Adresse anhand der  userId.
     */
    public List<Keyword> getKeywordsForBook(Long bookId) {
        return keywordRepository.getKeywordsForBook(bookId);
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

                // Verwende die Methode getAddressRepository() der Instanz
                //  KeywordRepository repository = config.getAddressRepository();
             //   instance = new KeywordService(repository);
            } catch (IOException e) {
                throw new RuntimeException("Fehler bei der Initialisierung des ContactService", e);
            }
        }
        return instance;
    }
}
