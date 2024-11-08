-- Table: KEYWORD
CREATE TABLE KEYWORD (
                         KEYWORD_ID SERIAL PRIMARY KEY,
                         KEYWORD VARCHAR(100) NOT NULL
);

-- Table: BOOK
CREATE TABLE BOOK (
                      BOOK_ID SERIAL PRIMARY KEY,
                      ISBN VARCHAR(64) NOT NULL,
                      BOOKTITLE VARCHAR(500) NOT NULL,
                      BOOKAUTHOR VARCHAR(200) NOT NULL,
                      PUBLISHER VARCHAR(400) NOT NULL,
                      YEAR_PUBLISHED INTEGER NOT NULL,
                      DESCRIPTION VARCHAR(10000),
                      STATUS VARCHAR(100),
                      KEYWORD_ID INTEGER REFERENCES KEYWORD(KEYWORD_ID)
);

-- Table: PERSON
CREATE TABLE PERSON (
                        USER_ID SERIAL PRIMARY KEY,
                        FIRSTNAME VARCHAR(200) NOT NULL,
                        LASTNAME VARCHAR(200) NOT NULL,
                        BIRTHDATE DATE NOT NULL,
                        GENDER CHAR(1) NOT NULL,
                        ROLE CHAR(50) NOT NULL
);

-- Table: WAITLIST
CREATE TABLE WAITLIST (
                          WAITLIST_ID SERIAL PRIMARY KEY,
                          USER_ID INTEGER REFERENCES PERSON(USER_ID),
                          BOOK_ID INTEGER REFERENCES BOOK(BOOK_ID),
                          CHECKOUT_DATE DATE NOT NULL,
                          RETURN_DATE DATE,
                          STATUS VARCHAR(100) NOT NULL
);

-- Table: REVIEW
CREATE TABLE REVIEW (
                        REVIEW_ID SERIAL PRIMARY KEY,
                        BOOK_ID INTEGER REFERENCES BOOK(BOOK_ID),
                        USER_ID INTEGER REFERENCES PERSON(USER_ID),
                        REVIEW_TEXT VARCHAR(1000) NOT NULL,
                        REVIEW_DATE DATE NOT NULL,
                        REVIEW_RATING VARCHAR(10) NOT NULL
);

-- Table: LENDING
CREATE TABLE LENDING (
                         LENDING_ID SERIAL PRIMARY KEY,
                         BOOK_ID INTEGER REFERENCES BOOK(BOOK_ID),
                         USER_ID_BORROWER INTEGER REFERENCES PERSON(USER_ID),
                         USER_ID_WORKER INTEGER REFERENCES PERSON(USER_ID),
                         STATUS VARCHAR(100) NOT NULL,
                         CHECKOUT_DATE DATE NOT NULL,
                         RETURN_DATE DATE,
                         DUE_DATE DATE
);

-- Table: CONTACT
CREATE TABLE CONTACT (
                         CONTACT_ID SERIAL PRIMARY KEY,
                         USER_ID INTEGER REFERENCES PERSON(USER_ID),
                         EMAIL VARCHAR(200) NOT NULL,
                         PHONE VARCHAR(50),
                         MOBILE VARCHAR(50)
);

-- Table: ADDRESS
CREATE TABLE ADDRESS (
                         ADDRESS_ID SERIAL PRIMARY KEY,
                         USER_ID INTEGER REFERENCES PERSON(USER_ID),
                         STREET VARCHAR(200),
                         HOUSENUMBER VARCHAR(50),
                         CITY VARCHAR(90),
                         ZIP_CODE VARCHAR(50)
);

-- Add Trigger for LENDING due date
CREATE OR REPLACE FUNCTION set_due_date() RETURNS TRIGGER AS $$
BEGIN
    NEW.DUE_DATE := NEW.CHECKOUT_DATE + INTERVAL '28 days';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_due_date
    BEFORE INSERT ON LENDING
    FOR EACH ROW
EXECUTE FUNCTION set_due_date();

-- Add Trigger for RETURN_DATE when STATUS changes
CREATE OR REPLACE FUNCTION set_return_date() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.STATUS = 'returned' AND OLD.STATUS = 'borrowed' THEN
        NEW.RETURN_DATE := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_return_date
    BEFORE UPDATE ON LENDING
    FOR EACH ROW
EXECUTE FUNCTION set_return_date();
