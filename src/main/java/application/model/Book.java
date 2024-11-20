package application.model;


import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

public class Book {
    private IntegerProperty bookId;
    private StringProperty isbn;
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
        this.isbn = new SimpleStringProperty();
        this.title = new SimpleStringProperty();
        this.author = new SimpleStringProperty();
        this.publisher = new SimpleStringProperty();
        this.yearPublished = new SimpleIntegerProperty();
        this.description = new SimpleStringProperty();
        this.status = new SimpleStringProperty();
        this.keywordId = new SimpleIntegerProperty();
    }

    public Book(Integer bookId, String isbn, String title, String author, String publisher,
                Integer yearPublished, String description, String status, Integer keywordId) {
        this.bookId = new SimpleIntegerProperty(bookId);
        this.isbn = new SimpleStringProperty(isbn);
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

    public StringProperty isbnProperty() {
        return isbn;
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

    public Integer getBookId() {
        return bookId.get();
    }

    public void setBookId(Integer bookId) {
        this.bookId.set(bookId);
    }

    public String getIsbn() {
        return isbn.get();
    }

    public void setIsbn(String isbn) {
        this.isbn.set(isbn);
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

    @Override
    public String toString() {
        return "Buch{" +
                "Titel='" + title + '\'' +
                ", Autor='" + author + '\'' +
                ", Status=" + status +
                '}';
    }
}
