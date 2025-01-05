package application.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Utility-Klasse zum Lesen von Konfigurationswerten aus einer Properties-Datei.
 * Diese Klasse wird verwendet, um Eigenschaften wie Datenbank-URLs, Benutzer und andere Einstellungen zu laden.
 */
public class PropertyReader {
    private final Properties properties = new Properties();

    /**
     * Konstruktor, der die Properties-Datei liest und lädt.
     */
    public PropertyReader(String fileName) {
        // Lade die Datei aus dem Ressourcen-Ordner
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(fileName)) {
            if (input == null) {
                throw new RuntimeException("Property file not found: " + fileName);
            }
            properties.load(input); // Lade die Properties aus dem InputStream
        } catch (IOException e) {
            throw new RuntimeException("Failed to load properties file: " + fileName, e);
        }
    }

    /**
     * Gibt den Wert der angegebenen Eigenschaft zurück.
     */
    public String getProperty(String key) {
        return properties.getProperty(key);
    }
}
