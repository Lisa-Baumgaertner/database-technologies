package application.controller;
import application.model.Book;
import application.service.BookService;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;

public class BookDeleteController {

    @FXML
    public TextField bookIdField;
    private BookService bookService;


    public void setBookService(BookService bookService) {
        this.bookService = bookService;
    }


    /**
     * Löschung eines Buches, in dem Id des Book-Objektes zuerst gesetzt wird
     */
    @FXML
    private void deleteBook(){

        Book bookToDelete = new Book();
        if (! checkTextFieldsValid()) {
            // one or more of the text fields are empty
            System.out.println("At least one Text Field is empty, please enter valid data into all fields.");
            System.out.println("Double check that you are not entering characters into the fields Year published and Keyword Id");

        } else {
            bookToDelete.setBookId(Integer.valueOf(bookIdField.getText()));
            bookService.deleteBook(Long.valueOf(bookToDelete.getBookId()));
            bookIdField.clear();
            System.out.println("Book was successfully deleted.");

        }


    }


    /**
     * Prüfung, ob das Feld einen Wert enthält / nicht leer ist
     * und, ob dieser Wert numerisch ist
     * @return
     */
    private boolean checkTextFieldsValid() {

        boolean validTextFields = true;

        if (bookIdField.getText().isEmpty() || !bookIdField.getText().matches("[0-9]+")) {
            validTextFields = false;

        }

        return validTextFields;
    }

}
