package application.model;


import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

import java.util.Map;

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
    private StringProperty status;
    private IntegerProperty keywordId;



    // Leerer Konstruktor
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
        this.status = new SimpleStringProperty();
        this.keywordId = new SimpleIntegerProperty();
    }

    public Book(Integer bookId, String isbnLong, String isbnShort, Integer copies, String title, String author, String publisher,
                Integer yearPublished, String description, String status, Integer keywordId) {
        this.bookId = new SimpleIntegerProperty(bookId);
        this.isbn_long = new SimpleStringProperty(isValidIsbn13(isbnLong) ? isbnLong : "");
        this.isbn_short = new SimpleStringProperty(isValidIsbn10(isbnShort) ? isbnShort : "");
        this.copies = new SimpleIntegerProperty(copies);
        this.title = new SimpleStringProperty(title);
        this.author = new SimpleStringProperty(author);
        this.publisher = new SimpleStringProperty(publisher);
        this.yearPublished = new SimpleIntegerProperty(yearPublished);
        this.description = new SimpleStringProperty(description);
        this.status = new SimpleStringProperty(status);
        this.keywordId = new SimpleIntegerProperty(keywordId);
    }

    // Getter und Setter für Properties

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

    public StringProperty statusProperty() {
        return status;
    }

    public IntegerProperty keywordIdProperty() {
        return keywordId;
    }

    // Getter und Setter für Werte

    public int getBookId() {
        return (int) bookId.get();
    }

    public void setBookId(Integer bookId) {
        this.bookId.set(bookId);
    }

    public String getIsbnLong() {
        return isbn_long.get();
    }

    public void setIsbnLong(String isbnLong) {
        if (isbnLong != null) {
            this.isbn_long.set(isbnLong);
        }
    }

    public String getIsbnShort() {
        return isbn_short.get();
    }

    public void setIsbnShort(String isbnShort) {
        if (isbnShort != null) {
            this.isbn_short.set(isbnShort);
        }
    }

    public Integer getCopies() {
        return copies.get();
    }

    public void setCopies(Integer copies) {
        this.copies.set(copies);
    }

    public String getTitle() {
        return title.get();
    }

    public void setTitle(String title) {
        this.title.set(title);
    }

    public String getAuthor() {
        return author.get();
    }

    public void setAuthor(String author) {
        this.author.set(author);
    }

    public String getPublisher() {
        return publisher.get();
    }

    public void setPublisher(String publisher) {
        this.publisher.set(publisher);
    }

    public Integer getYearPublished() {
        return yearPublished.get();
    }

    public void setYearPublished(Integer yearPublished) {
        this.yearPublished.set(yearPublished);
    }

    public String getDescription() {
        return description.get();
    }

    public void setDescription(String description) {
        this.description.set(description);
    }

    public String getStatus() {
        return status.get();
    }

    public void setStatus(String status) {
        this.status.set(status);
    }

    public Integer getKeywordId() {
        return keywordId.get();
    }

    public void setKeywordId(Integer keywordId) {
        this.keywordId.set(keywordId);
    }

    public boolean isValidIsbn13(String isbn) {
        if (isbn == null) return false;
        isbn = isbn.replace("-", "");
        return isbn.length() == 13;
    }

    public boolean isValidIsbn10(String isbn) {
        if (isbn == null) return false;

        isbn = isbn.replace("-", "");
       return isbn.length() == 10;
    }

    private static final Map<String, String> STATUS_TRANSLATION_MAP = Map.of(
            "Verfügbar", "available",
            "Ausgeliehen", "borrowed",
            "Reserviert", "reserved"
    );
    public static String translateStatusToEnglish(String germanStatus) {
        return STATUS_TRANSLATION_MAP.getOrDefault(germanStatus, null);
    }

    public static String translateStatusToGerman(String englishStatus) {
        return STATUS_TRANSLATION_MAP.entrySet().stream()
                .filter(entry -> entry.getValue().equals(englishStatus))
                .map(Map.Entry::getKey)
                .findFirst()
                .orElse(null);
    }

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
