package application.model;

public class Book {
    private String title;
    private String author;
    private String status;

    // Konstruktor
    public Book(String title, String author, String status) {
        this.title = title;
        this.author = author;
        this.status = status;
    }

    // Getter-Methoden
    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public String getStatus() {
        return status;
    }


    public void setTitle(String title) {
        this.title = title;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setStatus(int year) {
        this.status = status;
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
