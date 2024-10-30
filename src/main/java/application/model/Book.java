package application.model;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

public class Book {
    private final StringProperty title;
    private final StringProperty author;
    private final StringProperty status;

    public Book(String title, String author, String status) {
        this.title = new SimpleStringProperty(title);
        this.author = new SimpleStringProperty(author);
        this.status = new SimpleStringProperty(status);
    }

    public String getTitle() {
        return title.get();
    }

    public void setTitle(String title) {
        this.title.set(title);
    }

    public StringProperty titleProperty() {
        return title;
    }

    public String getAuthor() {
        return author.get();
    }

    public void setAuthor(String author) {
        this.author.set(author);
    }

    public StringProperty authorProperty() {
        return author;
    }

    public String getStatus() {
        return status.get();
    }

    public void setStatus(String status) {
        this.status.set(status);
    }

    public StringProperty statusProperty() {
        return status;
    }

    // toString-Methode (für Debugging und Darstellung in der UI nützlich)
    @Override
    public String toString() {
        return "Buch{" +
                "Titel='" + title + '\'' +
                ", Autor='" + author + '\'' +
                ", Status=" + status +
                '}';
    }
}
