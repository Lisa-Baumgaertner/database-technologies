package application.repository;

import application.model.Contact;

public interface ContactRepository {
    Contact getContactByUserId(long userId);
}
