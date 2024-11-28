package application.controller;
import application.service.BookService;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import application.model.Book;


public class BookEditController {
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
    private TextField bookIdField;
    @FXML
    private TextField isbn_short;
    @FXML
    private TextField isbn_long;
    @FXML
    private TextField copies;

    @FXML
    private Button editButton;

    private BookService bookService;

    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }


    @FXML
    private void editBook(){

        Book bookToEdit = new Book();
        if (! checkTextFieldsValid()) {
            // one or more of the text fields are empty
            System.out.println("At least one Text Field is empty, please enter valid data into all fields.");
            System.out.println("Double check that you are not entering characters into the fields Year published and Keyword Id");

        } else {
            bookToEdit.setBookId(Integer.valueOf(bookIdField.getText().trim()));
            if(bookToEdit.isValidIsbn13(String.valueOf(isbn_long))!= false){
                bookToEdit.setIsbnLong(isbn_long.getText().trim());
            }
            if(bookToEdit.isValidIsbn10(String.valueOf(isbn_short))!= false){
                bookToEdit.setIsbnShort(isbn_short.getText().trim());
            }
            bookToEdit.setTitle(title.getText().trim());
            bookToEdit.setAuthor(author.getText().trim());
            bookToEdit.setAuthor(author.getText().trim());
            bookToEdit.setPublisher(publisher.getText().trim());
            bookToEdit.setYearPublished(Integer.valueOf(year_published.getText().trim()));
            bookToEdit.setDescription(description.getText().trim());
            bookToEdit.setDescription(description.getText().trim());
            bookToEdit.setStatus(status.getText().toLowerCase().trim());
            bookToEdit.setKeywordId(Integer.valueOf(keyword_id.getText().trim()));
            bookToEdit.setCopies(Integer.valueOf(copies.getText().trim()));
            bookService.updateBook(bookToEdit);
            bookIdField.clear();
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
            System.out.println("Book was successfully updated.");

        }


    }







    private boolean checkTextFieldsValid() {

        boolean validTextFields = true;

        if (bookIdField.getText().isEmpty() || !bookIdField.getText().matches("[0-9]+")) {
            validTextFields = false;

        }
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
        if (copies.getText().isEmpty()) {
            validTextFields = false;
        }

        return validTextFields;
    }
}
