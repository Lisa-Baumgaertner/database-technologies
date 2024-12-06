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

        if (! checkTextFieldsValid(bookToInsert)) {
            System.out.println("At least one Text Field is empty, please enter valid data into all fields.");
            System.out.println("Double check that you are not entering characters into the fields Year published, Keyword Id and Copies");
            System.out.println("Also check that the isbns have the correct format");

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
            System.out.println("Book was successfully added.");
            clearAllFields();

        }

    }


    private boolean checkTextFieldsValid(Book book) {

        boolean validTextFields = true;

        if (isbn_long.getText().isEmpty() || isbn_short.getText().isEmpty() || title.getText().isEmpty() || author.getText().isEmpty() || publisher.getText().isEmpty() || year_published.getText().isEmpty() || !year_published.getText().matches("[0-9]+") || description.getText().isEmpty() || status.getText().isEmpty() || keyword_id.getText().isEmpty()|| !keyword_id.getText().matches("[0-9]+") || copies.getText().isEmpty()|| !copies.getText().matches("[0-9]+") || !book.isValidIsbn13(isbn_long.getText().trim()) || !book.isValidIsbn10(isbn_short.getText().trim())) {
            validTextFields = false;
        }

        return validTextFields;
    }

    private void clearAllFields(){
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

    }




}
