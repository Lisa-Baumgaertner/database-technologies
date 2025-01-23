package application.model;

import application.model.Status.BookStatus;
import javafx.beans.property.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Modellklasse für ein Buch in der Büchereianwendung.
 * Enthält alle relevanten Informationen wie Buch-Id, ISBNs, Anzahl der Ausgaben, Titel, Autor, Verlag, Jahr der Veröffentlichung,
 * Beschreibung, Keyword-Id, Status.
 */
public class Book {
    private IntegerProperty bookId;
    private StringProperty isbn_long;
    private StringProperty isbn_short;
    private IntegerProperty copies;
    private StringProperty title;
    private StringProperty author;
    private StringProperty publisher;
    private IntegerProperty yearPublished;
    private StringProperty description;
    private ObjectProperty<Status.BookStatus> status;
    private IntegerProperty keywordId; // (KEYWORD_ID in der BOOK-Tabelle)
    private List<Keyword> keywords; // Liste der Keywords (über BOOK_KEYWORD)


    /**
     * Standardkonstruktor für Book.
     * Initialisiert alle Properties mit Standardwerten.
     */
    public Book() {
        this.bookId = new SimpleIntegerProperty();
        this.isbn_long = new SimpleStringProperty();
        this.isbn_short = new SimpleStringProperty();
        this.copies = new SimpleIntegerProperty();
        this.title = new SimpleStringProperty();
        this.author = new SimpleStringProperty();
        this.publisher = new SimpleStringProperty();
        this.yearPublished = new SimpleIntegerProperty();
        this.description = new SimpleStringProperty();
        this.status = new SimpleObjectProperty<>(Status.BookStatus.AVAILABLE);
        this.keywordId = new SimpleIntegerProperty();
        this.keywords = new ArrayList<Keyword>();
    }

    /**
     * Konstruktor mit Parametern
     * @param bookId
     * @param isbnLong
     * @param isbnShort
     * @param copies
     * @param title
     * @param author
     * @param publisher
     * @param yearPublished
     * @param description
     * @param status
     * @param keywordId
     * @param keywords
     */
    public Book(Integer bookId, String isbnLong, String isbnShort, Integer copies, String title, String author, String publisher,
                Integer yearPublished, String description, Status.BookStatus status, Integer keywordId, List<Keyword> keywords) {
        this.bookId = new SimpleIntegerProperty(bookId);
        this.isbn_long = new SimpleStringProperty(isValidIsbn13(isbnLong) ? isbnLong : "");
        this.isbn_short = new SimpleStringProperty(isValidIsbn10(isbnShort) ? isbnShort : "");
        this.copies = new SimpleIntegerProperty(copies);
        this.title = new SimpleStringProperty(title);
        this.author = new SimpleStringProperty(author);
        this.publisher = new SimpleStringProperty(publisher);
        this.yearPublished = new SimpleIntegerProperty(yearPublished);
        this.description = new SimpleStringProperty(description);
        this.status =  new SimpleObjectProperty<>(status);
        this.keywordId = new SimpleIntegerProperty(keywordId);
        this.keywords = keywords;
    }


    /**
     * Getter und Setter für Properties
     */
    public IntegerProperty bookIdProperty() {
        return bookId;
    }

    public StringProperty isbnLongProperty() {
        return isbn_long;
    }

    public StringProperty isbnShortProperty() {
        return isbn_short;
    }

    public IntegerProperty copiesProperty() {
        return copies;
    }

    public StringProperty titleProperty() {
        return title;
    }

    public StringProperty authorProperty() {
        return author;
    }

    public StringProperty publisherProperty() {
        return publisher;
    }

    public IntegerProperty yearPublishedProperty() {
        return yearPublished;
    }

    public StringProperty descriptionProperty() {
        return description;
    }

    public SimpleObjectProperty<Status.BookStatus> statusProperty() {
        return (SimpleObjectProperty<BookStatus>) status;
    }




    /**
     * Getter und Setter für Werte
     */

    /**
     * Holt die Buch-Id
     */
    public long getBookId() {
        return (int) bookId.get();
    }

    public void setBookId(Integer bookId) {
        this.bookId.set(bookId);
    }

    /**
     * Holt die lange Version der ISBN (13-stellig)
     */
    public String getIsbnLong() {
        return isbn_long.get();
    }

    public void setIsbnLong(String isbnLong) {
        if (isbnLong != null) {
            this.isbn_long.set(isbnLong);
        }
    }

    /**
     * Holt die kurze Version der ISBN (10-stellig)
     */
    public String getIsbnShort() {
        return isbn_short.get();
    }

    public void setIsbnShort(String isbnShort) {
        if (isbnShort != null) {
            this.isbn_short.set(isbnShort);
        }
    }

    /**
     * Holt die Anzahl der Exemplare eines Buches, die in der Bücherei vorhanden sind
     */
    public Integer getCopies() {
        return copies.get();
    }

    public void setCopies(Integer copies) {
        this.copies.set(copies);
    }

    /**
     * Holt den Titel des Buches
     */
    public String getTitle() {
        return title.get();
    }

    public void setTitle(String title) {
        this.title.set(title);
    }

    /**
     * Holt den Autor des Buches
     */
    public String getAuthor() {
        return author.get();
    }

    public void setAuthor(String author) {
        this.author.set(author);
    }

    /**
     * Holt den Verlag
     */
    public String getPublisher() {
        return publisher.get();
    }

    public void setPublisher(String publisher) {
        this.publisher.set(publisher);
    }

    /**
     * Holt das Jahr der Veröffentlichung
     */
    public Integer getYearPublished() {
        return yearPublished.get();
    }

    public void setYearPublished(Integer yearPublished) {
        this.yearPublished.set(yearPublished);
    }

    /**
     * Holt die Beschreibung des Buches
     */
    public String getDescription() {
        return description.get();
    }

    public void setDescription(String description) {
        this.description.set(description);
    }

    /**
     * Holt den Status des Buches
     */
    public String getStatus() {
        return status.get().getStatus();
    }

    public void setStatus(BookStatus status) {
        this.status.set(status);
    }

    /**
     * Holt die Id des Keywords, welches dem Buch zugeordnet wurde
     */
    public IntegerProperty getKeywordId() {
        return keywordId;
    }

    public void setKeywordId(Integer keywordId) {
        this.keywordId.set(keywordId);
    }







    /**
     * Holt die des Keywords, welches dem Buch zugeordnet wurde
     */
    public List<Keyword> getKeywords() {
        return keywords;
    }

    public void setKeywords(List<Keyword> keywords) {
        this.keywords = keywords;
    }


    /**
     * Prüft die Validität der long ISBN
     * @param isbn
     * @return length
     */
    public boolean isValidIsbn13(String isbn) {
        if (isbn == null) return false;
        isbn = isbn.replace("-", "");
        return isbn.length() == 13;
    }

    /**
     * Prüft die Validität der short ISBN
     * @param isbn
     * @return length
     */
    public boolean isValidIsbn10(String isbn) {
        if (isbn == null) return false;

        isbn = isbn.replace("-", "");
       return isbn.length() == 10;
    }

    /**
     * Funktionen, um den Status eines Buches zu übersetzen
     */
    public static final Map<String, String> STATUS_TRANSLATION_MAP = Map.of(
            "Verfügbar", "available",
            "Ausgeliehen", "borrowed",
            "Reserviert", "reserved",
            "Wartend", "waiting",
            "Verloren", "lost",
            "Beschädigt", "damaged",
            "Ausgecheckt", "checked out",
            "In Wartung", "in_maintenance"
    );

    public static String translateStatusToEnglish(String germanStatus) {
        System.out.println("germanStatus," + germanStatus);
        return STATUS_TRANSLATION_MAP.entrySet().stream()
                .filter(entry -> entry.getKey().trim().equalsIgnoreCase(germanStatus.trim()))
                .map(Map.Entry::getValue)
                .findFirst()
                .orElse(null);
    }


    public static String translateStatusToGerman(String englishStatus) {
        return STATUS_TRANSLATION_MAP.entrySet().stream()
                .filter(entry -> entry.getValue().equals(englishStatus))
                .map(Map.Entry::getKey)
                .findFirst()
                .orElse(null);
    }

    /**
     * To String Funktion für Book
     * @return
     */
    @Override
    public String toString() {
        return "Book{" +
                "bookId=" + bookId +
                ", title='" + title.get() + '\'' +
                ", author='" + author.get() + '\'' +
                ", isbn_long='" + isbn_long.get() + '\'' +
                ", isbn_short='" + isbn_short.get() + '\'' +
                ", status='" + status.get() + '\'' +
                '}';
    }
}
