package application.controller;
import application.model.Book;
import application.service.BookService;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;

public class BookAddController {

    @FXML
    private TextField isbn_long;
    @FXML
    private TextField isbn_short;
    @FXML
    private TextField title;
    @FXML
    private TextField author;
    @FXML
    private TextField publisher;
    @FXML
    private TextField year_published;
    @FXML
    private TextField description;
    @FXML
    private TextField status;
    @FXML
    private TextField keyword_id;
    @FXML
    private TextField copies;
    @FXML
    private Button addButton;
    private BookService bookService;

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }

    @FXML
    private void addBook(){

        Book bookToInsert = new Book();
        if (! checkTextFieldsValid()) {
            // one or more of the text fields are empty
            System.out.println("At least one Text Field is empty, please enter valid data into all fields.");
            System.out.println("Double check that you are not entering characters into the fields Year published and Keyword Id");

        } else {

            bookToInsert.setIsbnLong(isbn_long.getText().trim());
            bookToInsert.setIsbnShort(isbn_short.getText().trim());
            bookToInsert.setCopies(Integer.valueOf(copies.getText().trim()));
            bookToInsert.setTitle(title.getText().trim());
            bookToInsert.setAuthor(author.getText().trim());
            bookToInsert.setPublisher(publisher.getText().trim());
            bookToInsert.setYearPublished(Integer.valueOf(year_published.getText().trim()));
            bookToInsert.setDescription(description.getText().trim());
            bookToInsert.setStatus(status.getText().toLowerCase().trim());
            bookToInsert.setKeywordId(Integer.valueOf(keyword_id.getText().trim()));

            bookService.insertBook(bookToInsert);
            isbn_long.clear();
            isbn_short.clear();
            title.clear();
            author.clear();
            publisher.clear();
            year_published.clear();
            description.clear();
            status.clear();
            keyword_id.clear();
            copies.clear();
            System.out.println("Book was successfully added.");

        }

    }


    private boolean checkTextFieldsValid() {

        boolean validTextFields = true;

        if (isbn_long.getText().isEmpty()) {
            validTextFields = false;
        }
        if (isbn_short.getText().isEmpty()) {
            validTextFields = false;
        }

        if (title.getText().isEmpty()) {
            validTextFields = false;

        }

        if (author.getText().isEmpty()) {
            validTextFields = false;

        }
        if (publisher.getText().isEmpty()) {
            validTextFields = false;

        }
        if (year_published.getText().isEmpty() || !year_published.getText().matches("[0-9]+")) {
            validTextFields = false;

        }
        if (description.getText().isEmpty()) {
            validTextFields = false;

        }
        if (status.getText().isEmpty()) {
            validTextFields = false;

        }
        if (keyword_id.getText().isEmpty()|| !keyword_id.getText().matches("[0-9]+")) {
            validTextFields = false;

        }
        if (copies.getText().isEmpty()|| !copies.getText().matches("[0-9]+")) {
            validTextFields = false;

        }

        return validTextFields;
    }


}
