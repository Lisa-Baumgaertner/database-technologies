-- Entfernen bestehender Trigger, falls sie existieren
DROP TRIGGER IF EXISTS trigger_set_due_date ON LENDING;
DROP TRIGGER IF EXISTS trigger_set_return_date ON LENDING;

-- Entfernen bestehender Funktionen, falls sie existieren
DROP FUNCTION IF EXISTS set_due_date();
DROP FUNCTION IF EXISTS set_return_date();

-- Trigger für lending
CREATE OR REPLACE FUNCTION set_due_date() RETURNS TRIGGER AS $$
BEGIN
    NEW.DUE_DATE := NEW.CHECKOUT_DATE + INTERVAL '28 days';
RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Fehler beim Setzen des Fälligkeitsdatums: %', SQLERRM;
RETURN NEW; -- oder RETURN NULL, um das Einfügen zu verhindern
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_due_date
    BEFORE INSERT ON LENDING
    FOR EACH ROW
    EXECUTE FUNCTION set_due_date();


CREATE OR REPLACE FUNCTION set_return_date() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.STATUS = 'returned' AND OLD.STATUS = 'borrowed' THEN
        NEW.RETURN_DATE := CURRENT_DATE;
END IF;
RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Fehler beim Setzen des Rückgabedatums: %', SQLERRM;
RETURN NEW; -- oder RETURN NULL, um die Aktualisierung zu verhindern,
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_return_date
    BEFORE UPDATE ON LENDING
    FOR EACH ROW
    EXECUTE FUNCTION set_return_date();


-- Testdaten


-- Keywords

INSERT INTO KEYWORD (KEYWORD_ID, KEYWORD) VALUES
                                              (DEFAULT, 'Science Fiction'),
                                              (DEFAULT, 'Fantasy'),
                                              (DEFAULT, 'Romance'),
                                              (DEFAULT, 'Mystery'),
                                              (DEFAULT, 'Thriller'),
                                              (DEFAULT, 'Horror'),
                                              (DEFAULT, 'Historical Fiction'),
                                              (DEFAULT, 'Adventure'),
                                              (DEFAULT, 'Young Adult'),
                                              (DEFAULT, 'Dystopian'),
                                              (DEFAULT, 'Paranormal'),
                                              (DEFAULT, 'Contemporary Fiction'),
                                              (DEFAULT, 'Biography'),
                                              (DEFAULT, 'Memoir'),
                                              (DEFAULT, 'Non-fiction'),
                                              (DEFAULT, 'Self-help'),
                                              (DEFAULT, 'Business'),
                                              (DEFAULT, 'Health & Wellness'),
                                              (DEFAULT, 'Cookbook'),
                                              (DEFAULT, 'Art'),
                                              (DEFAULT, 'Poetry'),
                                              (DEFAULT, 'Classic'),
                                              (DEFAULT, 'Humor'),
                                              (DEFAULT, 'Children''s Fiction'),
                                              (DEFAULT, 'Literary Fiction'),
                                              (DEFAULT, 'Crime'),
                                              (DEFAULT, 'True Crime'),
                                              (DEFAULT, 'Science'),
                                              (DEFAULT, 'Nature'),
                                              (DEFAULT, 'Technology'),
                                              (DEFAULT, 'Philosophy'),
                                              (DEFAULT, 'Psychology'),
                                              (DEFAULT, 'Religion'),
                                              (DEFAULT, 'Spirituality'),
                                              (DEFAULT, 'Travel'),
                                              (DEFAULT, 'Music'),
                                              (DEFAULT, 'Sports'),
                                              (DEFAULT, 'Graphic Novel'),
                                              (DEFAULT, 'Manga'),
                                              (DEFAULT, 'Urban Fantasy'),
                                              (DEFAULT, 'Steampunk'),
                                              (DEFAULT, 'Cyberpunk'),
                                              (DEFAULT, 'Fairy Tale'),
                                              (DEFAULT, 'Western'),
                                              (DEFAULT, 'Military Fiction'),
                                              (DEFAULT, 'Historical Romance'),
                                              (DEFAULT, 'Erotica'),
                                              (DEFAULT, 'Short Stories'),
                                              (DEFAULT, 'Anthology'),
                                              (DEFAULT, 'New Adult'),
                                              (DEFAULT, 'Dark Fantasy'),
                                              (DEFAULT, 'Apocalyptic'),
                                              (DEFAULT, 'Post-apocalyptic'),
                                              (DEFAULT, 'Magical Realism'),
                                              (DEFAULT, 'Psychological Thriller'),
                                              (DEFAULT, 'Romantic Comedy'),
                                              (DEFAULT, 'Action'),
                                              (DEFAULT, 'Spy Fiction'),
                                              (DEFAULT, 'Legal Thriller'),
                                              (DEFAULT, 'Medical Fiction'),
                                              (DEFAULT, 'Eco-fiction'),
                                              (DEFAULT, 'Mythology'),
                                              (DEFAULT, 'Family Drama'),
                                              (DEFAULT, 'Satire'),
                                              (DEFAULT, 'Coming-of-age'),
                                              (DEFAULT, 'LGBTQ+ Fiction'),
                                              (DEFAULT, 'Regency Romance'),
                                              (DEFAULT, 'Courtroom Drama'),
                                              (DEFAULT, 'Space Opera'),
                                              (DEFAULT, 'Time Travel'),
                                              (DEFAULT, 'Superhero Fiction'),
                                              (DEFAULT, 'Alien Fiction'),
                                              (DEFAULT, 'Vampire Fiction'),
                                              (DEFAULT, 'Werewolf Fiction'),
                                              (DEFAULT, 'Zombie Fiction'),
                                              (DEFAULT, 'Witch Fiction'),
                                              (DEFAULT, 'Shapeshifter Fiction'),
                                              (DEFAULT, 'Detective Fiction'),
                                              (DEFAULT, 'Espionage'),
                                              (DEFAULT, 'Sea Adventure'),
                                              (DEFAULT, 'Cooking Fiction'),
                                              (DEFAULT, 'Language Learning');



-- Book

INSERT INTO BOOK (BOOK_ID, ISBN_LONG, ISBN_SHORT, COPIES, BOOKTITLE, BOOKAUTHOR, PUBLISHER, YEAR_PUBLISHED, DESCRIPTION, STATUS, KEYWORD_ID) VALUES
                                                                                                                                                 (DEFAULT, '978-3-16-148410-0', '9517534862',2, 'Datenbanken Grundlagen', 'Max Mustermann', 'Fachverlag', 2020, 'Einführung in Datenbanken', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-1-23-456789-7', '7539514862',3, 'Programmieren für Einsteiger', 'Julia Muster', 'TechBooks', 2019, 'Grundlagen der Programmierung', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-0-14-312547-1', '5639464648',4,'Big Data und NoSQL', 'Hannes Krieger', 'TechWorld', 2021, 'Einführung in NoSQL und Big Data Technologien', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-0-16-148410-2', '9513574862', 5,'Machine Learning Grundlagen', 'Maria Schmidt', 'AI Books', 2020, 'Einführung in Machine Learning Konzepte', 'available', 4),
                                                                                                                                                 (DEFAULT, '978-1-50-117321-8', '2468135790', 1, 'Algorithmen und Datenstrukturen', 'Thomas Lange', 'CompSci Verlag', 2015, 'Grundlagen der Algorithmen und Datenstrukturen', 'borrowed', 2),
                                                                                                                                                 (DEFAULT, '978-1-43-026778-0', '1238765743', 1,'Datenbanken für Fortgeschrittene 2', 'Markus Müller', 'Informatik Verlag', 2017, 'Erweiterte Datenbanktechniken', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-0-12-374979-9', '1234567890', 3,'Python für Anfänger 1', 'Lena Braun', 'CodeBooks', 2022, 'Python-Programmierung für Einsteiger', 'checked out', 2),
                                                                                                                                                 (DEFAULT, '978-1-84-800003-6', '4445554444', 4,'Java und OOP', 'Kurt Keller', 'DeveloperPress', 2016, 'Objektorientierte Programmierung mit Java', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148110-3', '1065478974', 3, 'Webentwicklung mit HTML und CSS', 'Nina Fischer', 'WebTech', 2021, 'Grundlagen der Webentwicklung', 'available', 4),
                                                                                                                                                 (DEFAULT, '978-0-13-708107-3', '7899999999', 1, 'JavaScript für Einsteiger', 'Lucas Herrmann', 'Frontend Verlag', 2020, 'Einsteigerkurs in JavaScript', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-0-13-708107-4', '1593574862', 1,'Statistik für Data Science', 'Clara Berger', 'DataWorld', 2021, 'Einführung in statistische Konzepte', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-248410-5', '9981776522',2, 'Grundlagen der Netzwerksicherheit', 'Philipp Maier', 'Security Press', 2019, 'Netzwerksicherheitskonzepte', 'borrowed', 5),
                                                                                                                                                 (DEFAULT, '978-0-13-708107-6', '9802345768', 1,'Künstliche Intelligenz', 'Daniel Kaiser', 'TechBooks', 2018, 'Überblick über Künstliche Intelligenz', 'available', 4),
                                                                                                                                                 (DEFAULT, '978-0-13-708107-7', '2763837484', 6,'Systemarchitektur für IT', 'Sandra Frank', 'IT Pro', 2020, 'Architekturen für moderne IT-Systeme', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-3-26-148410-6', '6555554444', 9,'Objektorientierte Analyse und Design', 'Bernd Klein', 'OOAD Verlag', 2015, 'Grundlagen der objektorientierten Analyse', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-1-63-322710-1', '1999999999', 10,'SQL für Einsteiger', 'Anna Lehmann', 'SQL Press', 2017, 'Einsteigerkurs für SQL', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-1-16-148410-8', '2999999999', 3, 'Data Science Konzepte', 'Mara Hoffmann', 'DataBooks', 2019, 'Wichtige Konzepte für Data Science', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-142410-9', '4444445554', 7,'Visualisierung mit Tableau', 'Kevin Schmitt', 'Tableau Press', 2021, 'Einführung in die Datenvisualisierung mit Tableau', 'borrowed', 2),
                                                                                                                                                 (DEFAULT, '978-0-12-374968-3', '6667776666', 2,'Einführung in Datenanalyse', 'Leon Schwarz', 'Analytics Verlag', 2018, 'Grundlagen der Datenanalyse', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-0-16-148410-0', '9333333337', 10,'Cloud Computing Grundlagen', 'Paul Steiner', 'CloudTech', 2020, 'Konzepte des Cloud Computing', 'borrowed', 5),
                                                                                                                                                 (DEFAULT, '978-1-23-456789-8', '2333444278', 5, 'Deep Learning Basics', 'Sabrina Weber', 'AI Books', 2019, 'Grundlagen des Deep Learning', 'available', 4),
                                                                                                                                                 (DEFAULT, '978-0-14-312547-2', '1239800049', 8,'Cybersecurity Essentials', 'Johanna Kurz', 'Security Verlag', 2021, 'Grundlagen der Cybersicherheit', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-1-47-321678-1', '2122211121', 9,'Datenmanagement in der Praxis', 'Tobias Schmid', 'Data Verlag', 2016, 'Praktische Datenmanagement-Konzepte', 'borrowed', 1),
                                                                                                                                                 (DEFAULT, '978-1-23-456789-9', '1000030001', 14, 'Frontend-Entwicklung', 'Karl Zimmer', 'WebWorks', 2020, 'Grundlagen für die Frontend-Entwicklung', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-0-13-708107-8', '2111221111', 3, 'Backend-Programmierung mit Node.js', 'Lisa Bauer', 'BackendBooks', 2019, 'Node.js für Backend-Entwicklung', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-1-16-148410-1', '9111222834', 9,'DevOps für Einsteiger', 'Finn Seidel', 'TechFlow', 2018, 'Grundlagen der DevOps-Praxis', 'available', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148430-7', '1209876543', 9,'Programmieren mit C++', 'Moritz Winter', 'TechPress', 2022, 'C++ Programmierung für Einsteiger', 'borrowed', 2),
                                                                                                                                                 (DEFAULT, '978-1-63-322710-2', '9645364563', 11,'Einführung in R', 'Susanne Sommer', 'DataWorks', 2017, 'R-Programmierung für Data Science', 'available', 4),
                                                                                                                                                 (DEFAULT, '978-1-23-456789-0', '7223889873', 1,'Konzepte der Datenbankoptimierung', 'Hanna Weigel', 'DB Verlag', 2016, 'Optimierungstechniken für Datenbanken', 'borrowed', 1),
                                                                                                                                                 (DEFAULT, '978-0-14-312547-3', '1111131111', 4,'Software Engineering Basics', 'Marco Vogel', 'Software Verlag', 2021, 'Grundlagen des Software Engineerings', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-1-47-321678-2', '3333333323', 5,'Fortgeschrittene Web-Technologien', 'Claudia Lang', 'Web Innovators', 2019, 'Fortgeschrittene Themen für die Webentwicklung', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-1-63-322710-3', '7773337467', 13,'Blockchain und Kryptowährungen', 'Tom Kühn', 'CryptoPress', 2018, 'Einführung in Blockchain-Technologie', 'borrowed', 5),
                                                                                                                                                 (DEFAULT, '978-0-12-374968-4', '3434343434', 4, 'Agiles Projektmanagement', 'Rita Stark', 'PM Verlag', 2020, 'Agile Methoden für Projektmanagement', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-0-16-148410-3', '9173954735', 9,'Datenbanken für Fortgeschrittene 1', 'Uwe Schmidt', 'DB Verlag', 2017, 'Fortgeschrittene Datenbankthemen', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-0-12-374968-5', '7836666666', 1,'IT-Sicherheit Grundlagen', 'Norbert Weiß', 'SecurityPro', 2021, 'Grundlagen der IT-Sicherheit', 'available', 5),
                                                                                                                                                 (DEFAULT, '978-1-47-321678-3', '2322200009', 2,'E-Commerce Technologien', 'Jan König', 'Commerce Verlag', 2019, 'Technologien für E-Commerce Systeme', 'borrowed', 3),
                                                                                                                                                 (DEFAULT, '978-0-13-708107-9', '1110001110', 1, 'Data Engineering Basics', 'Birgit Lutz', 'Data Verlag', 2020, 'Grundlagen des Data Engineerings', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-1-23-456789-1', '2122222222', 3,'Digitalisierung im Unternehmen', 'Otto Groß', 'Digital Press', 2018, 'Digitalisierungskonzepte', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-1', '9012229489', 2,'Data Science 101', 'Maria Weber', 'TechBooks', 2015, 'An introduction to Data Science fundamentals.', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-2', '9988776522', 1,'Python für Anfänger 2', 'Thomas Müller', 'CodeMedia', 2018, 'A comprehensive guide to Python programming for beginners.', 'borrowed', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-3', '2226356472',1,'Java in Depth', 'Sandra Schmid', 'DevPress', 2016, 'Advanced Java programming techniques and best practices.', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-4', '1000000001', 1,'Machine Learning Essentials', 'Laura Richter', 'AI Books', 2019, 'A beginner-friendly guide to machine learning concepts.', 'reserved', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-5', '1000000002', 2,'C++ in der Praxis', 'Felix Lang', 'TechWorld', 2017, 'Practical applications and examples in C++ programming.', 'borrowed', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-6', '1000000003', 3, 'Die Welt der Algorithmen', 'Lisa Braun', 'InformatikVerlag', 2020, 'A deep dive into algorithm design and analysis.', 'available', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-7', '1000000004',4,'Datenstrukturen leicht gemacht', 'Martin Becker', 'ComputerBooks', 2015, 'Fundamentals of data structures with practical examples.', 'borrowed', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-8', '1000000005', 5, 'JavaScript Basics', 'Nina Fischer', 'WebDev Publishers', 2019, 'An introduction to JavaScript for web development.', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148410-9', '1000000006', 6,'Projektmanagement in IT', 'Peter Hoffmann', 'BusinessBooks', 2018, 'Managing projects in the tech industry effectively.', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-0', '1000000007', 7,'Künstliche Intelligenz für Anfänger', 'Alexandra Meyer', 'FutureTech', 2020, 'An introduction to artificial intelligence concepts.', 'reserved', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-1', '1000000008', 8,'Big Data Grundlagen', 'Oliver Müller', 'DataPress', 2017, 'Exploring the basics of Big Data technologies.', 'borrowed', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-2', '1000000009', 9,'SQL und Datenbanken', 'Emma Schmidt', 'CodeMedia', 2016, 'A practical guide to SQL and relational databases.', 'available', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-3', '2000000001', 1,'Linux Administration', 'Tim Berger', 'SysAdmin Books', 2015, 'Essential knowledge for Linux system administrators.', 'borrowed', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-4', '2000000002', 2,'Cloud Computing für Unternehmen', 'Sandra Keller', 'CloudPress', 2019, 'Implementing cloud solutions for businesses.', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-5', '2000000003', 4,'Netzwerksicherheit', 'Sebastian Lorenz', 'CyberBooks', 2018, 'Protecting networks from cyber threats.', 'reserved', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-6', '2000000004', 4,'Agile Entwicklungsmethoden', 'Tobias Schneider', 'IT Management', 2016, 'Introduction to Agile and Scrum methodologies.', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-7', '2000000005', 4, 'Android Programmierung', 'Julia Fischer', 'MobileDev', 2017, 'Developing applications for Android devices.', 'available', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-8', '2274350598', 3, 'Software Testing', 'Fabian Weiß', 'TestWorld', 2020, 'Best practices in software testing.', 'borrowed', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148411-9', '5779684565', 1, 'Blockchain für Einsteiger', 'Melanie Klein', 'FutureTech', 2019, 'A beginner’s guide to blockchain technology.', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-0', '9133487424', 1, 'Cybersecurity Basics', 'Kevin Jung', 'SecBooks', 2015, 'Understanding cybersecurity principles.', 'reserved', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-1', '2233086136', 3, 'R für Datenanalyse', 'Thomas Keller', 'DataPress', 2018, 'Data analysis with the R programming language.', 'borrowed', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-2', '3448828072', 4, 'Digitales Marketing', 'Sarah Wagner', 'MarketingPro', 2017, 'An overview of digital marketing strategies.', 'available', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-3', '4951489342', 3,'Fortgeschrittene Python-Programmierung', 'Lars Wolf', 'TechBooks', 2020, 'Advanced techniques in Python programming.', 'borrowed', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-4', '7504242343', 1,'IT-Sicherheit', 'Max Weber', 'CyberPress', 2019, 'Best practices for IT security management.', 'available', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-5', '5119785119', 3,'Datenvisualisierung', 'Anna Kaiser', 'VizBooks', 2016, 'Data visualization techniques and tools.', 'borrowed', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-6', '2679082805', 6, 'Scrum und Agile Methoden', 'Michael Franz', 'Agile Books', 2018, 'Applying Scrum and Agile methodologies in projects.', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-7', '1059564553', 3,'Digitale Transformation', 'Clara Winkler', 'FutureTech', 2019, 'Navigating digital transformation in organizations.', 'reserved', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-8', '0217346134', 2,'Webentwicklung mit HTML5 und CSS3', 'Frank Müller', 'WebDev Press', 2017, 'Creating modern websites with HTML5 and CSS3.', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148412-9', '3331583882', 8, 'React für Einsteiger', 'Nina Ludwig', 'CodeMedia', 2020, 'Introduction to React for front-end development.', 'available', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-0', '6582062333', 5,'Datenanalyse mit SQL', 'Simon Köhler', 'DataPress', 2015, 'Analyzing data with SQL queries.', 'borrowed', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-1', '4216243299', 3,'Systemarchitektur', 'Uwe Becker', 'InformatikVerlag', 2016, 'Designing scalable system architectures.', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-2', '0145629201', 5,'Einführung in Ruby', 'Leonie Fischer', 'RubyBooks', 2018, 'Learning the Ruby programming language.', 'borrowed', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-3', '0543642213', 3,'Design Thinking', 'Tom Schuster', 'Creative Books', 2017, 'Applying design thinking to innovation.', 'reserved', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-4', '8500725528', 5,'Kubernetes für Entwickler', 'Patrick Brandt', 'CloudPress', 2019, 'Using Kubernetes for container management.', 'available', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-5', '8123300367', 2,'Künstliche neuronale Netze', 'Nina Schwarz', 'AI Books', 2020, 'An introduction to neural networks.', 'borrowed', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-6', '4195205270', 2,'Cyber-Risiken in Unternehmen', 'Max Bauer', 'SecBooks', 2018, 'Understanding and mitigating cyber risks.', 'available', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-7', '8261651843', 4,'Die Programmiersprache Go', 'Oliver König', 'DevPress', 2017, 'An introduction to the Go programming language.', 'borrowed', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-8', '6414613095', 2,'Software-Engineering', 'Miriam Schmid', 'TechBooks', 2015, 'Software development processes and methodologies.', 'available', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148413-9', '1196250167', 1,'JavaScript Frameworks', 'Lars Walter', 'WebDev Publishers', 2019, 'A guide to popular JavaScript frameworks.', 'reserved', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-0', '5468309882', 2,'SQL für Fortgeschrittene', 'Klaus Weber', 'DataPress', 2016, 'Advanced SQL techniques and practices.', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-1', '1774371415', 2,'3D-Animation und Modellierung', 'Stefan Braun', 'GraphicsPro', 2018, 'Creating 3D animations and models.', 'available', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-2','900000384', 1,  'Microservices Architektur', 'Petra Wolf', 'CloudPress', 2020, 'Developing applications with microservices.', 'borrowed', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-3', '4622760045', 5,'IT-Projektmanagement', 'Birgit Lang', 'BusinessBooks', 2017, 'Managing IT projects effectively.', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-4', '0799165772', 4,'Digitalisierung in der Industrie', 'Helmut Richter', 'IndustrialBooks', 2019, 'Digital transformation in the industrial sector.', 'borrowed', 2),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-5','1907977995', 2, 'Einführung in NoSQL', 'Carina Ludwig', 'DataPress', 2015, 'Exploring NoSQL databases and their applications.', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-6', '7772692814', 2,'Kreatives Programmieren', 'Tobias Busch', 'Creative Books', 2016, 'Coding creatively with Processing and p5.js.', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-7', '1193926872', 2,'Risikomanagement in der IT', 'Fabian Neumann', 'RiskBooks', 2018, 'Managing risk in IT projects.', 'available', 5),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-8', '8023939891', 8,'Web Design Trends', 'Vanessa Kurz', 'WebDev Publishers', 2020, 'Latest trends in web design and UX.', 'reserved', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-148414-9','0081926301', 2, 'Agile Transformation', 'Johannes Maier', 'Agile Books', 2019, 'Implementing agile processes in organizations.', 'borrowed', 1),
                                                                                                                                                 (DEFAULT, '978-1-61-729256-5', '0557440352', 4, 'Die letzten Sterne', 'Mia Schulze', 'SciFi Verlag', 2023, 'Ein Weltraumabenteuer in einer fernen Zukunft', 'available', 1),
                                                                                                                                                 (DEFAULT, '978-0-14-132323-3', '6814524807', 2,'Magie der Drachen', 'Elena Wolf', 'Fantasy World', 2022, 'Ein episches Abenteuer im Land der Drachen', 'borrowed', 2),
                                                                                                                                                 (DEFAULT, '978-0-54-537718-7', '8349589906', 5,'Der Fluch der Rosen', 'Jessica Meyer', 'Romance Verlag', 2021, 'Eine verbotene Liebe zwischen zwei Welten', 'available', 3),
                                                                                                                                                 (DEFAULT, '978-0-15-104549-5', '0441299518', 5,'Der mysteriöse Fall', 'Oliver Schwarz', 'MysteryPress', 2022, 'Ein unlösbarer Mordfall in einer kleinen Stadt', 'borrowed', 4),
                                                                                                                                                 (DEFAULT, '978-1-23-456847-9', '3168060260', 3,'Die Jagd', 'Sarah Becker', 'Thriller Verlag', 2023, 'Ein Thriller über einen unerbittlichen Jäger', 'available', 5),
                                                                                                                                                 (DEFAULT, '978-1-25-346938-3', '2463665267', 3,'Blutmond', 'Lukas Jäger', 'Horror Verlag', 2020, 'Dunkle Mächte und ein schreckliches Geheimnis', 'borrowed', 6),
                                                                                                                                                 (DEFAULT, '978-3-16-415271-4', '7227673315',2,'Der Krieg der Könige', 'Katharina Stein', 'Historical Fiction Books', 2021, 'Ein historischer Roman über Macht und Verrat', 'available', 7),
                                                                                                                                                 (DEFAULT, '978-1-84-784206-7', '2400641219',1,'Die Insel der verlorenen Schätze', 'Thomas Schuster', 'Adventure Press', 2022, 'Ein Abenteuer voller Geheimnisse und Schätze', 'borrowed', 8),
                                                                                                                                                 (DEFAULT, '978-0-32-918435-5', '2634530061', 3,'Der geheime Club', 'Anna Fischer', 'Young Adult Verlag', 2021, 'Freundschaft und Geheimnisse in der Jugendzeit', 'available', 9),
                                                                                                                                                 (DEFAULT, '978-1-41-657345-9', '5023597566',2,'Welt aus Asche', 'Felix Braun', 'Dystopian Books', 2020, 'Eine Zukunft zerstört von Naturkatastrophen', 'borrowed', 10),
                                                                                                                                                 (DEFAULT, '978-0-15-846236-9', '4761007598', 3,'Die verborgene Welt', 'Monika Kraus', 'Paranormal Verlag', 2022, 'Geheimnisse und übernatürliche Kräfte', 'available', 11),
                                                                                                                                                 (DEFAULT, '978-1-58-832046-9', '6848065000', 1,'Im Schatten des Zweifels', 'Robert Peters', 'Contemporary Verlag', 2021, 'Ein Roman über Liebe, Verlust und Vertrauen', 'borrowed', 12),
                                                                                                                                                 (DEFAULT, '978-1-45-237741-8', '4621262920',1,'Ein Leben in Worten', 'Jessica Fischer', 'Biography Press', 2023, 'Die Geschichte eines außergewöhnlichen Lebens', 'available', 13),
                                                                                                                                                 (DEFAULT, '978-1-56-672934-6', '9111134213', 2,'In Erinnerung an den Krieg', 'Markus Braun', 'Memoir Verlag', 2022, 'Ein persönliches Memoir über das Leben nach dem Krieg', 'borrowed', 14),
                                                                                                                                                 (DEFAULT, '978-1-68-722409-5', '9698231068', 9,'Der Weg der Veränderung', 'Simon Müller', 'Non-fiction Books', 2021, 'Ein Buch über persönliche Entwicklung und Veränderung', 'available', 15),
                                                                                                                                                 (DEFAULT, '978-0-14-127844-4', '4621760045', 1,'Kraft der Gedanken', 'Eva Schulz', 'Self-help Verlag', 2020, 'Hilfreiche Tipps zur Steigerung des persönlichen Wohlbefindens', 'borrowed', 16),
                                                                                                                                                 (DEFAULT, '978-0-98-765453-4', '6036388423', 1,'Der Erfolgscode', 'Julian Weber', 'Business Verlag', 2022, 'Erfolgsstrategien für Unternehmer und Selbstständige', 'available', 17),
                                                                                                                                                 (DEFAULT, '978-1-73-254892-6', '3270370227', 1,'Die Kunst der Selbstfürsorge', 'Lena Becker', 'Health & Wellness Verlag', 2021, 'Ein Leitfaden für ein gesundes und glückliches Leben', 'borrowed', 18),
                                                                                                                                                 (DEFAULT, '978-1-45-675763-2', '7008614729', 1,'Gesunde Küche', 'Miriam Klein', 'Cookbook Press', 2020, 'Leckere Rezepte für eine ausgewogene Ernährung', 'available', 19),
                                                                                                                                                 (DEFAULT, '978-0-98-734208-3', '5500150166', 8,'Die Farben der Welt', 'Paul Richter', 'ArtBooks', 2021, 'Ein Kunstbuch über die Bedeutung von Farben in der Kunst', 'borrowed', 20),
                                                                                                                                                 (DEFAULT, '978-1-84-323073-7','5010714745', 2, 'Gedichte der Nacht', 'Clara Vogel', 'Poetry Press', 2022, 'Eine Sammlung von düsteren und nachdenklichen Gedichten', 'available', 21),
                                                                                                                                                 (DEFAULT, '978-1-62-118430-0', '7508317679', 3,'Die Unendlichkeit des Augenblicks', 'Jana Weber', 'ClassicBooks', 2021, 'Ein klassischer Roman über die Unvermeidlichkeit des Schicksals', 'borrowed', 22),
                                                                                                                                                 (DEFAULT, '978-0-12-349672-3','9308618245', 4, 'Der Lächelnsplan', 'Eva Heidrich', 'Humor Press', 2022, 'Lachen als Lebensstrategie – ein humorvolles Sachbuch', 'available', 23),
                                                                                                                                                 (DEFAULT, '978-1-56-738129-4', '0818830141', 4,'Die verlorenen Tage', 'Ursula Hoffmann', 'Children''s Fiction Verlag', 2020, 'Ein Kinderbuch über Freundschaft und Abenteuer', 'borrowed', 24),
                                                                                                                                                 (DEFAULT, '978-3-15-948632-7', '2403818633', 1, 'Der große Traum', 'Felix Sturm', 'Literary Fiction Books', 2022, 'Ein literarisches Meisterwerk über das Leben und seine Tragödien', 'available', 25),
                                                                                                                                                 (DEFAULT, '978-1-13-489567-7', '6036820037', 1,'Das düstere Geheimnis', 'Isabelle Reuter', 'CrimeBooks', 2021, 'Ein Kriminalfall, der das Leben aller Beteiligten verändert', 'borrowed', 26),
                                                                                                                                                 (DEFAULT, '978-1-43-248753-0', '2413818633', 1, 'Das düstere Netz', 'Markus Stein', 'True Crime Verlag', 2022, 'Echte Kriminalfälle, die die Welt erschütterten', 'available', 27),
                                                                                                                                                 (DEFAULT, '978-1-50-151848-2', '3420751627', 1,'Das Geheimnis der Sterne', 'Andrea Weber', 'Science Verlag', 2020, 'Wissenschaftliche Entdeckungen und ihre Bedeutung für die Zukunft', 'borrowed', 28),
                                                                                                                                                 (DEFAULT, '978-1-54-654937-5','2476498345', 3,  'Die geheime Natur', 'Johanna Fischer', 'NatureBooks', 2021, 'Eine Reise in die Geheimnisse der Natur', 'available', 29),
                                                                                                                                                 (DEFAULT, '978-3-16-715899-2', '7735760294', 1, 'Die Maschinen', 'Erik Müller', 'Technology Books', 2022, 'Wie Maschinen die Zukunft verändern', 'borrowed', 30),
                                                                                                                                                 (DEFAULT, '978-1-24-798596-4', '5726252668', 3, 'Die Philosophie des Lebens', 'Marcel Fischer', 'Philosophy Books', 2021, 'Ein philosophischer Blick auf das Leben und seine Bedeutung', 'available', 31),
                                                                                                                                                 (DEFAULT, '978-0-19-482982-1', '2224490317', 3,'Psychologie des Glücks', 'Elena Hahn', 'Psychology Press', 2020, 'Wie du dein Leben mit positiven Gedanken verändern kannst', 'borrowed', 32),
                                                                                                                                                 (DEFAULT, '978-1-56-072804-7','3353574855', 1, 'Das Geheimnis des Glaubens', 'Oliver Becker', 'Religion Verlag', 2021, 'Ein philosophischer Blick auf Religion und Spiritualität', 'available', 33),
                                                                                                                                                 (DEFAULT, '978-0-92-184396-4', '8618399525', 1,'Der Weg zum inneren Frieden', 'Jana Huber', 'Spirituality Press', 2022, 'Wie du deine innere Ruhe findest', 'borrowed', 34),
                                                                                                                                                 (DEFAULT, '978-1-13-348172-6', '2111989373', 1,'Die Welt bereisen', 'Max Schuster', 'TravelBooks', 2021, 'Reiseberichte aus den entlegensten Teilen der Erde', 'available', 35),
                                                                                                                                                 (DEFAULT, '978-1-25-374901-8', '7111111112', 3, 'Der Klang der Musik', 'Eva Krüger', 'Music Press', 2020, 'Eine Reise durch die Welt der Musik und ihrer Geschichte', 'borrowed', 36),
(DEFAULT, '978-1-23-456789-1', '1234567890', 3, 'JavaScript für Fortgeschrittene', 'Lena Weber', 'CodeBooks', 2018, 'Vertiefung von JavaScript-Konzepten', 'available', 7),
(DEFAULT, '978-0-14-312547-2', '9876543210', 5, 'Datenbanken für Fortgeschrittene', 'Lukas Bauer', 'DataTech', 2017, 'Erweiterte Konzepte der Datenbanken', 'borrowed', 10),
(DEFAULT, '978-1-61-729443-6', '6549873214', 2, 'Machine Learning mit Python', 'Clara Schmidt', 'AI World', 2021, 'Grundlagen von Machine Learning mit Python', 'reserved', 4),
(DEFAULT, '978-1-61-729469-5', '8529637411', 1, 'Webentwicklung mit Vue.js', 'Emily Weber', 'Frontend Books', 2020, 'Moderne Webentwicklung mit Vue.js', 'available', 9),
(DEFAULT, '978-1-61-729598-2', '1478523690', 4, 'Datenanalyse mit SQL', 'Mark Fischer', 'DataPress', 2019, 'Analyse von Daten mit SQL', 'reserved', 12),
(DEFAULT, '978-1-61-729598-3', '7539514623', 1, 'Datenvisualisierung mit Tableau', 'Anna Meier', 'DataBooks', 2018, 'Visualisierung von Daten mit Tableau', 'borrowed', 13),
(DEFAULT, '978-0-12-374979-2', '3216549879', 3, 'Cybersecurity für Anfänger', 'Paul Keller', 'SecurityPress', 2020, 'Grundlagen der Cybersicherheit', 'available', 15),
(DEFAULT, '978-1-84-800003-7', '4569871230', 2, 'Objektorientierte Programmierung', 'Sarah Krieger', 'DeveloperWorld', 2016, 'Einführung in objektorientierte Programmierung', 'borrowed', 8),
(DEFAULT, '978-3-16-148110-2', '8524567893', 1, 'Python für Datenanalyse', 'Maximilian Lange', 'DataTech', 2020, 'Datenanalyse mit Python', 'available', 20),
(DEFAULT, '978-3-16-148110-4', '7418529632', 3, 'Statistik mit SPSS', 'Lisa Bauer', 'StatBooks', 2019, 'Einführung in Statistik mit SPSS', 'reserved', 21),
(DEFAULT, '978-0-13-708107-9', '9632587413', 2, 'Data Engineering mit Spark', 'Hannah Müller', 'BigDataPress', 2021, 'Grundlagen von Data Engineering', 'available', 19),
(DEFAULT, '978-0-13-708108-0', '7896541230', 4, 'Grundlagen der IT-Sicherheit', 'Patrick Fischer', 'IT Security Verlag', 2022, 'Einführung in die IT-Sicherheit', 'reserved', 17),
(DEFAULT, '978-1-50-117321-9', '6547891230', 2, 'Big Data für Einsteiger', 'Julia Weber', 'BigDataBooks', 2020, 'Grundlagen von Big Data', 'available', 22),
(DEFAULT, '978-1-61-729598-1', '1478963250', 5, 'Programmieren mit Kotlin', 'Anna Krieger', 'CodeBooks', 2021, 'Grundlagen von Kotlin', 'borrowed', 11),
(DEFAULT, '978-0-13-110362-8', '7539514867', 3, 'C++ für Fortgeschrittene', 'Daniel Lange', 'CompSci Verlag', 2018, 'Fortgeschrittene Konzepte der C++-Programmierung', 'borrowed', 14),
(DEFAULT, '978-0-19-964582-8', '1234569871', 1, 'Fortgeschrittene Algorithmen mit Python', 'Lukas Keller', 'CompSci Verlag', 2020, 'Algorithmen in Python', 'available', 18),
(DEFAULT, '978-1-61-729469-6', '7419638523', 4, 'Data Science Grundlagen', 'Nina Weber', 'DataWorld', 2021, 'Einführung in Data Science', 'reserved', 23),
(DEFAULT, '978-1-61-729598-4', '1237894560', 2, 'Cloud Computing mit Google Cloud', 'Sarah Krieger', 'CloudPress', 2019, 'Einführung in Google Cloud Platform', 'available', 5),
(DEFAULT, '978-1-61-729469-7', '3698521470', 3, 'AWS Grundlagen', 'Thomas Meier', 'CloudBooks', 2018, 'Einführung in Amazon Web Services', 'reserved', 16),
(DEFAULT, '978-1-61-729443-7', '7894561239', 1, 'Datenbanken mit MongoDB', 'Emily Fischer', 'NoSQL Verlag', 2020, 'Einführung in MongoDB', 'borrowed', 24),
(DEFAULT, '978-1-61-729443-8', '9517538524', 3, 'Java für Fortgeschrittene', 'Patrick Weber', 'CodePress', 2017, 'Erweiterte Java-Konzepte', 'available', 25),
(DEFAULT, '978-1-61-729469-8', '9517538523', 4, 'Frontend mit Angular', 'Lisa Schmidt', 'Frontend Verlag', 2020, 'Einführung in Angular', 'reserved', 28),
(DEFAULT, '978-1-61-729598-5', '7539514865', 2, 'Cybersecurity Essentials', 'Lukas Bauer', 'SecurityBooks', 2021, 'Grundlagen der Cybersicherheit', 'available', 29),
(DEFAULT, '978-0-12-374979-3', '3214569874', 1, 'Big Data mit Spark', 'Daniel Müller', 'DataTech', 2019, 'Grundlagen von Big Data und Apache Spark', 'borrowed', 26),
(DEFAULT, '978-3-16-148110-5', '7539514872', 3, 'Machine Learning Grundlagen', 'Maximilian Weber', 'AI World', 2020, 'Einführung in maschinelles Lernen', 'available', 30),
(DEFAULT, '978-1-61-729443-9', '7893216540', 4, 'Python für Experten', 'Lukas Lange', 'CodeBooks', 2021, 'Fortgeschrittene Python-Konzepte', 'reserved', 27),
(DEFAULT, '978-1-61-729598-6', '9874561237', 2, 'Statistik Grundlagen', 'Nina Schmidt', 'StatPress', 2018, 'Einführung in Statistik', 'available', 19),
(DEFAULT, '978-1-61-729443-5', '4561237894', 1, 'Internet of Things mit Raspberry Pi', 'Clara Krieger', 'IoT World', 2021, 'IoT-Anwendungen mit Raspberry Pi', 'borrowed', 6),
(DEFAULT, '978-1-61-729598-7', '1234569872', 5, 'Python für Data Science', 'Sarah Keller', 'DataBooks', 2020, 'Python für die Datenanalyse', 'reserved', 3),
(DEFAULT, '978-0-14-310616-2', '1234567890', 2, 'IoT und Sensoren', 'Thomas Bauer', 'TechBooks', 2021, 'Einführung in die Welt der Sensoren und IoT-Technologien', 'available', 5),
(DEFAULT, '978-0-19-514390-3', '9876543210', 3, 'Machine Learning in der Praxis', 'Sophie Meier', 'AI World', 2020, 'Anwendungen und Beispiele für maschinelles Lernen', 'borrowed', 3),
(DEFAULT, '978-0-13-110362-9', '6549873214', 5, 'Software-Architektur Grundlagen', 'Hannah Krieger', 'DevBooks', 2019, 'Best Practices für moderne Software-Architekturen', 'reserved', 7),
(DEFAULT, '978-1-59-327424-5', '8529637411', 2, 'Linux für Einsteiger', 'Daniel Lange', 'TechPress', 2018, 'Grundlagen der Linux-Betriebssysteme', 'available', 12),
(DEFAULT, '978-1-61-729443-0', '1478523690', 1, 'C# für Anfänger', 'Maximilian Schmidt', 'CodeWorld', 2021, 'Ein einfacher Einstieg in die C#-Programmierung', 'available', 11),
(DEFAULT, '978-1-61-564612-5', '1234567891', 4, 'Ernährung im Alltag', 'Lena Weber', 'HealthBooks', 2020, 'Tipps und Tricks für eine gesunde Ernährung', 'reserved', 21),
(DEFAULT, '978-1-50-117370-8', '3216549875', 3, 'Yoga für Einsteiger', 'Julia Fischer', 'FitnessPress', 2019, 'Ein praktischer Leitfaden für Yoga-Anfänger', 'borrowed', 18),
(DEFAULT, '978-0-13-708108-5', '7539514624', 2, 'Mentale Gesundheit im Beruf', 'Thomas Keller', 'MindTech', 2018, 'Strategien für ein besseres Stressmanagement', 'available', 14),
(DEFAULT, '978-1-59-327410-2', '1234569873', 1, 'Superfoods und ihre Wirkung', 'Clara Meier', 'FoodWorld', 2021, 'Ein Überblick über die bekanntesten Superfoods', 'reserved', 19),
(DEFAULT, '978-1-49-191077-0', '7418529634', 3, 'Fitness für Profis', 'Markus Weber', 'SportsPress', 2017, 'Fortgeschrittene Übungen für Kraft und Ausdauer', 'available', 22),
(DEFAULT, '978-1-61-729441-2', '9638527414', 5, 'Der verlorene Schlüssel', 'Lena Fischer', 'Roman Verlag', 2020, 'Ein spannender Krimi über einen mysteriösen Schlüssel', 'borrowed', 6),
(DEFAULT, '978-0-13-708108-6', '9874561238', 3, 'Das Geheimnis der alten Villa', 'Nina Weber', 'KrimiBooks', 2021, 'Ein mysteriöser Thriller in einer alten Villa', 'reserved', 11),
(DEFAULT, '978-1-50-117321-6', '1597534568', 2, 'Im Schatten des Mondes', 'Lukas Schmidt', 'Fiction World', 2019, 'Eine Geschichte über Liebe und Verlust', 'available', 15),
(DEFAULT, '978-1-61-729443-1', '9517534872', 4, 'Das verlorene Paradies', 'Clara Krieger', 'Literatur Verlag', 2018, 'Ein episches Drama über Familie und Geheimnisse', 'borrowed', 10),
(DEFAULT, '978-1-59-327401-3', '7896541231', 2, 'Der letzte Atemzug', 'Maximilian Lange', 'ThrillerPress', 2020, 'Ein packender Thriller voller Wendungen', 'available', 12),
(DEFAULT, '978-0-13-708108-7', '7419638525', 2, 'Investieren für Einsteiger', 'Patrick Weber', 'FinanceBooks', 2021, 'Ein Leitfaden für den Einstieg ins Investieren', 'available', 8),
(DEFAULT, '978-1-59-327412-4', '4569871234', 3, 'Finanzielle Freiheit erreichen', 'Anna Meier', 'MoneyWorld', 2019, 'Tipps für ein unabhängiges Leben', 'borrowed', 7),
(DEFAULT, '978-0-13-708108-8', '9632587415', 4, 'Startup-Gründung leicht gemacht', 'Lukas Fischer', 'Entrepreneur Press', 2020, 'Ein praktischer Leitfaden für Gründer', 'reserved', 9),
(DEFAULT, '978-0-13-708108-9', '8524567894', 3, 'Personal Finance Basics', 'Thomas Lange', 'WealthTech', 2018, 'Grundlagen des persönlichen Finanzmanagements', 'available', 10),
(DEFAULT, '978-1-59-327410-4', '7539514874', 2, 'Erfolgreiches Projektmanagement', 'Clara Krieger', 'PM World', 2017, 'Best Practices für das Management von Projekten', 'reserved', 15),
(DEFAULT, '978-0-12-374979-5', '1597534569', 1, 'Reisen durch Europa', 'Markus Weber', 'TravelBooks', 2021, 'Ein Leitfaden für Abenteurer und Reisende', 'available', 4),
(DEFAULT, '978-1-50-117370-0', '3214569875', 3, 'Geschichte der Wissenschaft', 'Lena Fischer', 'HistoryWorld', 2020, 'Ein Blick auf die Entwicklung der Wissenschaft', 'reserved', 3),
(DEFAULT, '978-0-13-708108-1', '6547891234', 5, 'Die Wunder der Natur', 'Julia Meier', 'Nature Press', 2019, 'Ein Buch über die erstaunliche Welt der Natur', 'borrowed', 7),
(DEFAULT, '978-1-61-729443-2', '4561237895', 2, 'Technologien der Zukunft', 'Patrick Keller', 'TechWorld', 2018, 'Ein Überblick über aufkommende Technologien', 'available', 10),
(DEFAULT, '978-1-59-327410-6', '8527419632', 3, 'Die Kunst der Fotografie', 'Anna Schuster', 'PhotoPress', 2021, 'Ein Leitfaden für angehende Fotografen', 'reserved', 12),
(DEFAULT, '978-1-23-456789-9', '1234567891', 3, 'Docker und Kubernetes Basics', 'Lisa Bauer', 'TechPress', 2020, 'Containerisierung und Orchestrierung leicht gemacht', 'available', 5),
(DEFAULT, '978-1-16-148410-0', '9876543211', 2, 'Datenbanken mit SQL', 'Maximilian Lange', 'DataTech', 2018, 'Ein Leitfaden für Datenbankanfänger', 'borrowed', 7),
(DEFAULT, '978-0-13-110163-2', '4569871235', 5, 'Einführung in künstliche Intelligenz', 'Hannah Krieger', 'AI Verlag', 2019, 'Grundlagen der künstlichen Intelligenz', 'reserved', 4),
(DEFAULT, '978-1-61-729443-3', '6549873215', 3, 'Webentwicklung mit Angular', 'Thomas Keller', 'Frontend Verlag', 2021, 'Angular für moderne Webprojekte', 'available', 8),
(DEFAULT, '978-1-61-729598-0', '1478523691', 4, 'Programmieren mit Go', 'Daniel Weber', 'CodeBooks', 2020, 'Einführung in die Go-Programmierung', 'reserved', 6),
(DEFAULT, '978-0-12-374979-8', '8529637412', 2, 'Cloud Computing Basics', 'Julia Schmidt', 'CloudWorld', 2017, 'Grundlagen des Cloud Computings', 'borrowed', 9),
(DEFAULT, '978-1-84-800003-8', '1597534569', 3, 'IT-Sicherheit leicht gemacht', 'Sarah Lange', 'SecurityPress', 2021, 'Tipps und Tricks für Cybersicherheit', 'available', 11),
(DEFAULT, '978-3-16-148110-6', '7539514625', 1, 'Python für Einsteiger', 'Lucas Meier', 'DevBooks', 2019, 'Grundlagen der Python-Programmierung', 'reserved', 13),
(DEFAULT, '978-0-13-708108-3', '9517534863', 2, 'Big Data und Hadoop', 'Clara Weber', 'DataPress', 2020, 'Einführung in Hadoop-Technologien', 'borrowed', 18),
(DEFAULT, '978-1-61-729469-9', '7418529633', 4, 'JavaScript Best Practices', 'Patrick Krieger', 'CodeWorld', 2022, 'Moderne JavaScript-Techniken', 'available', 10),
(DEFAULT, '978-1-41-654982-7', '8527419633', 3, 'Investieren leicht gemacht', 'Hannah Keller', 'FinancePress', 2021, 'Ein Leitfaden für den Einstieg ins Investieren', 'reserved', 7),
(DEFAULT, '978-1-59-327424-6', '3698521471', 5, 'Erfolgreiches Projektmanagement', 'Lisa Bauer', 'PM Books', 2018, 'Tipps für effizientes Projektmanagement', 'available', 4),
(DEFAULT, '978-0-13-708108-4', '7539514875', 2, 'Startup-Gründung Basics', 'Lena Weber', 'Entrepreneur Books', 2019, 'Einführung in die Welt der Startups', 'borrowed', 11),
(DEFAULT, '978-1-61-729469-2', '9632587416', 4, 'Finanzielle Freiheit erreichen', 'Sarah Krieger', 'MoneyTech', 2020, 'Tipps für finanzielle Unabhängigkeit', 'reserved', 12),
(DEFAULT, '978-1-50-117370-1', '4569871236', 3, 'Wirtschaft im Wandel', 'Maximilian Fischer', 'BusinessWorld', 2021, 'Ein Blick auf aktuelle Wirtschaftstrends', 'available', 9),
(DEFAULT, '978-1-61-729443-4', '1237894561', 2, 'Börse für Einsteiger', 'Lucas Weber', 'FinancePress', 2017, 'Ein Leitfaden für Börsenanfänger', 'borrowed', 8),
(DEFAULT, '978-0-13-708108-2', '1478523692', 4, 'Projektmanagement mit Scrum', 'Thomas Meier', 'PM Verlag', 2019, 'Einführung in Scrum-Techniken', 'available', 10),
(DEFAULT, '978-1-61-729469-1', '9517534864', 3, 'Personal Finance Basics', 'Patrick Weber', 'FinanceBooks', 2018, 'Grundlagen des Finanzmanagements', 'reserved', 14),
(DEFAULT, '978-1-59-327412-5', '7539514866', 2, 'Effiziente Teamarbeit', 'Nina Schmidt', 'BusinessTech', 2020, 'Tipps für effektives Teamwork', 'borrowed', 13),
(DEFAULT, '978-0-13-708108-6', '9632587417', 1, 'Strategien für Startups', 'Daniel Keller', 'EntrepreneurWorld', 2021, 'Tipps für junge Unternehmer', 'available', 15),
(DEFAULT, '978-0-13-708108-9', '1597534863', 3, 'Grundlagen der Robotik', 'Hannah Weber', 'TechWorld', 2020, 'Einführung in die Robotik und Automatisierung', 'available', 7),
(DEFAULT, '978-1-59-327412-6', '9517534874', 4, 'Effiziente Teamführung', 'Patrick Lange', 'BusinessTech', 2019, 'Strategien für erfolgreiche Teamarbeit', 'borrowed', 6),
(DEFAULT, '978-0-13-110362-9', '7539514627', 1, 'Deep Learning für Anfänger', 'Clara Meier', 'AI Verlag', 2021, 'Grundlagen des Deep Learning', 'reserved', 12),
(DEFAULT, '978-1-50-117321-8', '8527419635', 2, 'Der letzte Winter', 'Nina Fischer', 'RomanWorld', 2018, 'Ein spannender Thriller in einer abgelegenen Hütte', 'available', 9),
(DEFAULT, '978-1-61-729598-2', '1597534875', 5, 'Python für Data Science', 'Lukas Weber', 'DataPress', 2020, 'Einführung in die Datenanalyse mit Python', 'borrowed', 15),
(DEFAULT, '978-1-61-729469-8', '9517534876', 3, 'Grundlagen der Mathematik', 'Lisa Bauer', 'MathBooks', 2019, 'Ein Leitfaden für mathematische Grundlagen', 'available', 11),
(DEFAULT, '978-0-13-708108-0', '4569871238', 2, 'Börse verstehen', 'Daniel Keller', 'FinanceBooks', 2017, 'Ein Leitfaden für Einsteiger in die Börsenwelt', 'reserved', 10),
(DEFAULT, '978-1-61-729443-5', '1237894562', 1, 'Machine Learning mit TensorFlow', 'Sarah Krieger', 'AI Verlag', 2021, 'Ein praktischer Einstieg in TensorFlow', 'borrowed', 5),
(DEFAULT, '978-1-50-117370-9', '7539514877', 3, 'Fortgeschrittene Algorithmen', 'Thomas Meier', 'CompSci Verlag', 2018, 'Vertiefung von Algorithmen und Datenstrukturen', 'available', 8),
(DEFAULT, '978-1-59-327424-7', '8529637414', 4, 'Geschichte der Antike', 'Julia Weber', 'HistoryBooks', 2021, 'Ein Einblick in die Welt der Antike', 'borrowed', 14),
(DEFAULT, '978-0-13-110363-0', '4561237898', 2, 'Cybersecurity und Hacking', 'Patrick Keller', 'SecurityPress', 2020, 'Ein Leitfaden für IT-Sicherheit', 'reserved', 13),
(DEFAULT, '978-1-61-729443-6', '9517534877', 1, 'Webentwicklung mit React', 'Lucas Schmidt', 'FrontendBooks', 2019, 'Einführung in React und Redux', 'available', 16),
(DEFAULT, '978-1-50-117370-2', '3216549877', 2, 'Blockchain-Technologie verstehen', 'Clara Weber', 'TechPress', 2021, 'Ein Blick auf Blockchain-Anwendungen', 'reserved', 18),
(DEFAULT, '978-0-13-708108-1', '9632587418', 3, 'Algorithmen für Fortgeschrittene', 'Hannah Lange', 'CompSci Verlag', 2020, 'Erweiterte Algorithmenkonzepte', 'borrowed', 19),
(DEFAULT, '978-1-61-729469-1', '4569871239', 4, 'Projektmanagement Essentials', 'Lisa Fischer', 'PM Verlag', 2018, 'Grundlagen des Projektmanagements', 'available', 20),
(DEFAULT, '978-0-13-708108-2', '1597534878', 1, 'C++ für Einsteiger', 'Sarah Weber', 'CodeBooks', 2022, 'Ein Leitfaden für Anfänger in C++', 'reserved', 15),
(DEFAULT, '978-1-61-729443-7', '8527419636', 5, 'Internet of Things verstehen', 'Nina Krieger', 'IoT World', 2021, 'Ein Überblick über IoT-Technologien', 'borrowed', 12),
(DEFAULT, '978-1-59-327424-8', '9517534878', 2, 'Java für Fortgeschrittene', 'Maximilian Bauer', 'CodeWorld', 2020, 'Fortgeschrittene Konzepte in Java', 'available', 10),
(DEFAULT, '978-1-50-117321-7', '7539514879', 3, 'Der verborgene Schatz', 'Thomas Keller', 'FictionWorld', 2019, 'Ein spannender Abenteuerroman', 'borrowed', 7),
(DEFAULT, '978-0-13-708108-3', '9517534865', 1, 'Yoga und Entspannung', 'Julia Lange', 'HealthBooks', 2021, 'Ein Leitfaden für Yoga-Anfänger', 'available', 11),
(DEFAULT, '978-1-61-729469-2', '4569871240', 4, 'Datenbanken mit MySQL', 'Lucas Weber', 'DataBooks', 2018, 'Ein praktischer Einstieg in MySQL', 'reserved', 14),
(DEFAULT, '978-1-50-117370-3', '1597534880', 3, 'Fitness für Fortgeschrittene', 'Lisa Bauer', 'HealthPress', 2019, 'Fortgeschrittene Trainingsmethoden', 'borrowed', 5),
(DEFAULT, '978-1-59-327401-5', '9632587419', 2, 'Statistik Basics', 'Hannah Fischer', 'StatBooks', 2020, 'Ein Leitfaden für Statistik-Einsteiger', 'available', 10),
(DEFAULT, '978-1-50-117321-6', '7539514881', 4, 'Programmieren mit Kotlin', 'Clara Krieger', 'CodePress', 2022, 'Einführung in die Welt von Kotlin', 'reserved', 18),
(DEFAULT, '978-0-13-708108-4', '8527419637', 5, 'Meditation im Alltag', 'Sarah Weber', 'MindWorld', 2020, 'Praktische Tipps für mehr Gelassenheit', 'available', 13),
(DEFAULT, '978-1-59-327424-9', '9517534882', 3, 'Das Geheimnis der Berge', 'Nina Fischer', 'Fiction Verlag', 2018, 'Ein packender Roman in den Alpen', 'borrowed', 9),
(DEFAULT, '978-1-61-729443-8', '1237894564', 1, 'Deep Learning für Experten', 'Lucas Schmidt', 'AI Verlag', 2021, 'Vertiefte Konzepte des Deep Learning', 'reserved', 16),
(DEFAULT, '978-1-50-117370-4', '3216549878', 3, 'Künstliche Intelligenz in der Praxis', 'Lisa Meier', 'AI World', 2020, 'Anwendungen von KI in der Industrie', 'available', 15),
(DEFAULT, '978-0-13-708108-5', '8529637416', 4, 'Frontend-Entwicklung Basics', 'Patrick Krieger', 'CodeBooks', 2019, 'Grundlagen der Frontend-Programmierung', 'borrowed', 19),
(DEFAULT, '978-1-50-110363-9', '1234567890', 2, 'Cloud Computing mit AWS', 'Daniel Keller', 'CloudBooks', 2021, 'Ein Leitfaden für die Nutzung von AWS in der Cloud', 'available', 3),
(DEFAULT, '978-0-19-878634-0', '9876543210', 4, 'Datenbanken mit PostgreSQL', 'Julia Fischer', 'DataPress', 2020, 'Ein praktischer Einstieg in PostgreSQL', 'borrowed', 6),
(DEFAULT, '978-1-61-729469-0', '6549873210', 5, 'Einführung in die KI-Forschung', 'Maximilian Meier', 'AI World', 2019, 'Ein Überblick über die Grundlagen der KI', 'reserved', 9),
(DEFAULT, '978-0-13-708110-9', '8529637410', 3, 'Python für Wissenschaftler', 'Lisa Bauer', 'ScienceBooks', 2018, 'Ein Leitfaden für wissenschaftliches Programmieren', 'available', 7),
(DEFAULT, '978-1-61-729598-3', '7418529630', 1, 'Blockchain verstehen', 'Clara Schmidt', 'TechBooks', 2021, 'Ein Einstieg in Blockchain-Technologien', 'reserved', 12),
(DEFAULT, '978-1-43-021078-9', '1597534560', 4, 'Statistik für Einsteiger', 'Thomas Krieger', 'DataWorld', 2020, 'Grundlagen der Statistik für Anfänger', 'borrowed', 11),
(DEFAULT, '978-1-61-729469-4', '4569871230', 5, 'Frontend-Entwicklung mit Vue.js', 'Lucas Weber', 'Frontend Verlag', 2021, 'Moderne Webentwicklung mit Vue.js', 'available', 5),
(DEFAULT, '978-1-61-729443-9', '7539514860', 2, 'Projektmanagement Basics', 'Nina Krieger', 'PMBooks', 2019, 'Ein Leitfaden für effektives Projektmanagement', 'reserved', 14),
(DEFAULT, '978-0-12-374979-1', '9517534870', 3, 'Java für Fortgeschrittene', 'Patrick Lange', 'CodeWorld', 2017, 'Fortgeschrittene Java-Konzepte', 'borrowed', 10),
(DEFAULT, '978-1-59-327412-7', '1234569870', 4, 'Effiziente Teamarbeit', 'Hannah Weber', 'BusinessTech', 2018, 'Strategien für effektive Zusammenarbeit im Team', 'available', 8),
(DEFAULT, '978-1-61-729598-4', '8527419630', 2, 'Machine Learning mit R', 'Daniel Keller', 'AI Verlag', 2020, 'Einführung in maschinelles Lernen mit R', 'reserved', 13),
(DEFAULT, '978-1-50-117370-5', '7419638520', 1, 'Cybersecurity Grundlagen', 'Julia Meier', 'SecurityBooks', 2021, 'Ein Leitfaden zur IT-Sicherheit', 'borrowed', 16),
(DEFAULT, '978-1-61-729469-5', '3698521470', 5, 'Datenanalyse mit Python', 'Maximilian Fischer', 'DataTech', 2020, 'Grundlagen der Datenanalyse mit Python', 'available', 18),
(DEFAULT, '978-1-50-117321-9', '9517534871', 3, 'Führung und Motivation', 'Lisa Bauer', 'LeadershipBooks', 2019, 'Tipps für erfolgreiche Führungskräfte', 'reserved', 9),
(DEFAULT, '978-1-59-327424-0', '1597534860', 4, 'Yoga für Fortgeschrittene', 'Clara Weber', 'MindTech', 2020, 'Fortgeschrittene Yoga-Übungen für den Alltag', 'borrowed', 7),
(DEFAULT, '978-1-61-729443-8', '9517534872', 2, 'Künstliche Intelligenz und Ethik', 'Patrick Krieger', 'AI World', 2021, 'Ein Leitfaden zu ethischen Fragen in der KI', 'available', 6),
(DEFAULT, '978-1-50-117370-6', '7539514861', 5, 'Die Geheimnisse der Quantenphysik', 'Thomas Meier', 'SciencePress', 2018, 'Ein Überblick über die Welt der Quantenphysik', 'reserved', 12),
(DEFAULT, '978-1-61-729469-6', '7418529631', 4, 'Finanzielle Freiheit erreichen', 'Daniel Schmidt', 'FinanceBooks', 2019, 'Tipps für finanzielle Unabhängigkeit', 'borrowed', 15),
(DEFAULT, '978-0-13-708108-6', '9517534862', 3, 'Datenvisualisierung mit Tableau', 'Nina Weber', 'DataTech', 2021, 'Einführung in Visualisierungen mit Tableau', 'available', 10),
(DEFAULT, '978-1-59-327410-3', '9632587410', 2, 'Gesundheit und Ernährung', 'Sarah Krieger', 'HealthBooks', 2020, 'Tipps für eine ausgewogene Ernährung', 'reserved', 8),
(DEFAULT, '978-1-50-117321-8', '4569871231', 1, 'Kreatives Schreiben', 'Hannah Meier', 'WriterBooks', 2021, 'Ein Leitfaden für kreative Autoren', 'borrowed', 7),
(DEFAULT, '978-1-61-729469-7', '1597534861', 4, 'Meditation für Anfänger', 'Lucas Lange', 'MindBooks', 2019, 'Ein einfacher Einstieg in die Welt der Meditation', 'available', 14),
(DEFAULT, '978-0-12-374979-2', '9517534863', 5, 'Datenbanken mit MongoDB', 'Maximilian Weber', 'DataWorld', 2020, 'Einführung in NoSQL-Datenbanken', 'reserved', 5),
(DEFAULT, '978-1-61-729598-5', '8527419631', 3, 'Big Data in der Praxis', 'Clara Schmidt', 'BigDataBooks', 2018, 'Praktische Anwendungen von Big Data', 'borrowed', 9),
(DEFAULT, '978-1-50-117370-7', '3698521471', 2, 'Effizientes Arbeiten mit Scrum', 'Lisa Fischer', 'PMBooks', 2020, 'Ein Leitfaden für agiles Arbeiten', 'available', 15),
(DEFAULT, '978-1-59-327412-8', '7539514862', 4, 'Moderne Webentwicklung', 'Patrick Lange', 'Frontend Verlag', 2021, 'Ein Blick auf aktuelle Web-Technologien', 'reserved', 6),
(DEFAULT, '978-0-13-708108-7', '4561237890', 1, 'Fortgeschrittene C++ Konzepte', 'Daniel Keller', 'CodeBooks', 2019, 'Vertiefte Konzepte in der C++-Programmierung', 'borrowed', 10),
(DEFAULT, '978-1-61-729469-8', '9517534873', 3, 'Blockchain für Unternehmen', 'Sarah Weber', 'TechWorld', 2020, 'Ein Überblick über Blockchain-Anwendungen', 'available', 12),
(DEFAULT, '978-1-50-117321-7', '8527419632', 2, 'Die Kunst des Führens', 'Maximilian Krieger', 'LeadershipBooks', 2021, 'Tipps für erfolgreiche Führung', 'reserved', 8),
(DEFAULT, '978-1-59-327424-1', '1597534862', 5, 'Java für Einsteiger', 'Julia Fischer', 'CodePress', 2018, 'Ein Leitfaden für Anfänger in Java', 'borrowed', 11),
(DEFAULT, '978-3-16-148410-1', '9876543212', 2, 'Cloud Computing für Fortgeschrittene', 'Lukas Meier', 'TechBooks', 2021, 'Erweiterte Konzepte der Cloud-Nutzung', 'available', 7),
(DEFAULT, '978-1-61-729469-9', '7539514863', 4, 'KI und maschinelles Lernen', 'Nina Weber', 'AI World', 2020, 'Einführung in künstliche Intelligenz', 'borrowed', 9),
(DEFAULT, '978-1-59-327412-9', '1234569871', 3, 'Big Data mit Hadoop', 'Clara Lange', 'DataBooks', 2018, 'Grundlagen von Hadoop und Big Data', 'reserved', 14),
(DEFAULT, '978-1-61-729598-6', '9517534874', 5, 'Effizientes Arbeiten im Team', 'Patrick Schmidt', 'BusinessTech', 2019, 'Strategien für produktive Teamarbeit', 'available', 10),
(DEFAULT, '978-0-13-708108-8', '6549873217', 2, 'Grundlagen der Python-Programmierung', 'Sarah Weber', 'CodePress', 2021, 'Ein einfacher Einstieg in Python', 'reserved', 6),
(DEFAULT, '978-1-61-729469-0', '3698521472', 1, 'Statistik leicht gemacht', 'Daniel Meier', 'StatBooks', 2017, 'Ein Leitfaden für Statistik-Einsteiger', 'borrowed', 8),
(DEFAULT, '978-1-50-117321-8', '7418529632', 3, 'Algorithmen verstehen', 'Maximilian Krieger', 'CompSci Verlag', 2020, 'Grundlagen der Algorithmusanalyse', 'available', 11),
(DEFAULT, '978-1-61-729598-7', '1597534863', 4, 'Projektmanagement Essentials', 'Lukas Fischer', 'PMBooks', 2019, 'Ein Überblick über die Grundlagen des Projektmanagements', 'reserved', 13),
(DEFAULT, '978-1-59-327410-4', '1234567892', 5, 'C++ für Fortgeschrittene', 'Nina Weber', 'CodeBooks', 2021, 'Vertiefte Konzepte der C++-Programmierung', 'borrowed', 12),
(DEFAULT, '978-1-61-729443-9', '9517534875', 3, 'Yoga und Achtsamkeit', 'Julia Lange', 'MindBooks', 2018, 'Ein Leitfaden für ein achtsames Leben', 'available', 9),
(DEFAULT, '978-1-50-117370-8', '6549873218', 2, 'Meditation im Alltag', 'Lisa Meier', 'HealthBooks', 2020, 'Praktische Übungen für mehr Entspannung', 'reserved', 15),
(DEFAULT, '978-1-59-327424-2', '7539514864', 1, 'Blockchain für Unternehmen', 'Patrick Weber', 'TechWorld', 2019, 'Ein Überblick über Blockchain-Technologien', 'borrowed', 8),
(DEFAULT, '978-1-61-729469-1', '8529637417', 4, 'Kreatives Schreiben für Autoren', 'Clara Krieger', 'WriterPress', 2021, 'Tipps für kreatives Schreiben', 'available', 6),
(DEFAULT, '978-1-61-729443-6', '9517534866', 5, 'Cybersecurity Basics', 'Daniel Schmidt', 'SecurityBooks', 2018, 'Ein Leitfaden zur IT-Sicherheit', 'reserved', 7),
(DEFAULT, '978-1-50-117321-9', '3698521473', 2, 'Data Science mit Python', 'Hannah Weber', 'DataBooks', 2020, 'Ein Einführung in die Datenanalyse mit Python', 'borrowed', 9),
(DEFAULT, '978-1-61-729598-8', '7418529633', 1, 'Finanzielle Freiheit leicht gemacht', 'Lucas Lange', 'FinancePress', 2021, 'Tipps für ein unabhängiges Leben', 'available', 11),
(DEFAULT, '978-0-13-708108-9', '4569871232', 3, 'Java für Einsteiger', 'Sarah Krieger', 'CodeWorld', 2019, 'Ein Leitfaden für die Java-Programmierung', 'reserved', 13),
(DEFAULT, '978-1-59-327410-5', '7539514876', 4, 'Datenbanken mit PostgreSQL', 'Maximilian Fischer', 'DataTech', 2017, 'Ein praktischer Einstieg in PostgreSQL', 'borrowed', 15),
(DEFAULT, '978-1-50-117370-9', '6549873219', 5, 'Machine Learning für Fortgeschrittene', 'Julia Meier', 'AI World', 2020, 'Erweiterte Konzepte im maschinellen Lernen', 'available', 6),
(DEFAULT, '978-1-61-729469-2', '9517534877', 2, 'Effiziente Webentwicklung', 'Daniel Schmidt', 'FrontendBooks', 2021, 'Ein Leitfaden für moderne Webentwicklung', 'reserved', 8),
(DEFAULT, '978-1-59-327424-3', '8529637418', 3, 'Yoga für Anfänger', 'Patrick Lange', 'HealthPress', 2018, 'Ein praktischer Einstieg in Yoga', 'borrowed', 14),
(DEFAULT, '978-1-61-729443-7', '9517534867', 4, 'Internet of Things Basics', 'Clara Weber', 'IoT World', 2020, 'Grundlagen des Internet der Dinge', 'available', 9),
(DEFAULT, '978-1-50-117321-7', '1234567893', 5, 'Künstliche Intelligenz und Ethik', 'Lukas Fischer', 'AI Verlag', 2019, 'Ein Überblick über ethische Fragen der KI', 'reserved', 11),
(DEFAULT, '978-1-61-729469-3', '7418529634', 1, 'Die Zukunft der Arbeit', 'Hannah Krieger', 'FutureBooks', 2021, 'Ein Blick auf die Arbeitswelt von morgen', 'borrowed', 6),
(DEFAULT, '978-0-12-374979-3', '6549873220', 2, 'Fortgeschrittene Statistik', 'Julia Fischer', 'StatPress', 2017, 'Vertiefte Statistik-Konzepte', 'available', 7),
(DEFAULT, '978-1-59-327410-6', '8529637419', 4, 'Webentwicklung mit Angular', 'Lucas Meier', 'Frontend Verlag', 2020, 'Einführung in Angular', 'reserved', 13),
(DEFAULT, '978-1-50-117370-2', '3698521474', 3, 'Effizientes Teammanagement', 'Sarah Weber', 'PM Verlag', 2018, 'Ein Leitfaden für effektives Teammanagement', 'borrowed', 9),
(DEFAULT, '978-1-61-729598-9', '1234567894', 5, 'Algorithmen in der Praxis', 'Clara Lange', 'CompSci Verlag', 2021, 'Anwendungen von Algorithmen', 'available', 11),
(DEFAULT, '978-1-50-117321-6', '9517534878', 1, 'Blockchain verstehen', 'Daniel Schmidt', 'TechPress', 2019, 'Ein Überblick über Blockchain-Anwendungen', 'reserved', 12),
(DEFAULT, '978-1-61-729469-0', '1597534863', 3, 'Big Data mit Spark', 'Lucas Lange', 'DataBooks', 2021, 'Einführung in die Verarbeitung großer Datenmengen', 'available', 11),
(DEFAULT, '978-0-13-708108-6', '7539514878', 4, 'Machine Learning Basics', 'Sarah Weber', 'AI World', 2020, 'Grundlagen des maschinellen Lernens', 'reserved', 7),
(DEFAULT, '978-1-50-117321-6', '6549873221', 2, 'Künstliche Intelligenz verstehen', 'Clara Krieger', 'TechBooks', 2019, 'Ein Überblick über KI-Technologien', 'borrowed', 8),
(DEFAULT, '978-1-59-327412-5', '9517534879', 5, 'Statistik für Data Science', 'Daniel Meier', 'StatPress', 2021, 'Statistische Methoden für die Datenanalyse', 'available', 15),
(DEFAULT, '978-1-50-117370-9', '8529637420', 1, 'Cybersecurity Grundlagen', 'Patrick Lange', 'SecurityBooks', 2018, 'Ein Leitfaden zur IT-Sicherheit', 'borrowed', 12),
(DEFAULT, '978-1-61-729443-6', '3698521475', 4, 'Projektmanagement mit Scrum', 'Julia Fischer', 'PMBooks', 2019, 'Einführung in agile Methoden', 'reserved', 6),
(DEFAULT, '978-1-50-117370-8', '1234567895', 3, 'Datenbanken mit MySQL', 'Maximilian Weber', 'DataTech', 2020, 'Ein praktischer Leitfaden für MySQL', 'available', 10),
(DEFAULT, '978-1-61-729469-2', '4569871234', 2, 'Effizientes Arbeiten mit R', 'Lisa Meier', 'DataBooks', 2021, 'Einführung in die Datenanalyse mit R', 'reserved', 9),
(DEFAULT, '978-0-13-708108-7', '7539514880', 5, 'Webentwicklung mit React', 'Nina Krieger', 'Frontend Verlag', 2018, 'Ein moderner Ansatz für Webentwicklung', 'borrowed', 13),
(DEFAULT, '978-1-61-729443-7', '9517534881', 4, 'Algorithmen für Fortgeschrittene', 'Clara Lange', 'CompSci Verlag', 2019, 'Vertiefte Algorithmenkonzepte', 'available', 14),
(DEFAULT, '978-1-59-327424-2', '6549873222', 1, 'Blockchain für Einsteiger', 'Lucas Schmidt', 'TechBooks', 2020, 'Ein Einstieg in Blockchain-Technologien', 'reserved', 7),
(DEFAULT, '978-1-61-729469-3', '8529637421', 3, 'Machine Learning für Fortgeschrittene', 'Patrick Krieger', 'AI Verlag', 2019, 'Erweiterte Konzepte des maschinellen Lernens', 'borrowed', 8),
(DEFAULT, '978-1-50-117321-7', '3698521476', 2, 'Kreatives Schreiben für Anfänger', 'Sarah Fischer', 'WriterBooks', 2021, 'Ein Leitfaden für kreative Autoren', 'available', 11),
(DEFAULT, '978-0-13-708108-8', '9517534882', 4, 'Effiziente Führung in Unternehmen', 'Daniel Weber', 'LeadershipPress', 2020, 'Tipps für erfolgreiche Führungskräfte', 'reserved', 12),
(DEFAULT, '978-1-59-327410-3', '7539514883', 1, 'Datenanalyse mit Python', 'Maximilian Meier', 'DataWorld', 2021, 'Grundlagen der Python-Datenanalyse', 'borrowed', 6),
(DEFAULT, '978-1-61-729598-4', '6549873223', 5, 'Big Data für Unternehmen', 'Julia Lange', 'BigDataBooks', 2018, 'Anwendungen von Big Data im Geschäftsumfeld', 'available', 9),
(DEFAULT, '978-1-50-117370-2', '8529637422', 3, 'Statistik Basics', 'Clara Krieger', 'StatBooks', 2020, 'Ein Leitfaden für Statistik-Einsteiger', 'reserved', 13),
(DEFAULT, '978-1-61-729469-4', '3698521477', 4, 'Die Zukunft der KI', 'Lucas Fischer', 'AI World', 2019, 'Ein Ausblick auf die Entwicklung künstlicher Intelligenz', 'borrowed', 10),
(DEFAULT, '978-1-59-327412-6', '7539514884', 2, 'Fortgeschrittene C++ Konzepte', 'Patrick Weber', 'CodeBooks', 2021, 'Vertiefte Konzepte der C++-Programmierung', 'available', 7),
(DEFAULT, '978-1-50-117321-8', '9517534883', 1, 'Meditation und Achtsamkeit', 'Sarah Krieger', 'MindBooks', 2020, 'Praktische Übungen für ein achtsames Leben', 'reserved', 15),
(DEFAULT, '978-0-13-708108-9', '6549873224', 3, 'Effizientes Arbeiten im Team', 'Maximilian Schmidt', 'BusinessBooks', 2018, 'Strategien für produktive Zusammenarbeit', 'borrowed', 8),
(DEFAULT, '978-1-61-729443-9', '8529637423', 4, 'Gesundheit und Ernährung', 'Lisa Lange', 'HealthPress', 2021, 'Tipps für einen gesunden Lebensstil', 'available', 14),
(DEFAULT, '978-1-59-327424-3', '7539514885', 5, 'Finanzielle Freiheit erreichen', 'Daniel Meier', 'FinanceBooks', 2020, 'Tipps für finanzielle Unabhängigkeit', 'reserved', 9),
(DEFAULT, '978-1-50-117370-3', '3698521478', 2, 'Yoga und Entspannung', 'Clara Weber', 'MindTech', 2019, 'Ein praktischer Leitfaden für Yoga', 'borrowed', 12),
(DEFAULT, '978-1-61-729469-5', '9517534884', 3, 'Webentwicklung mit Angular', 'Lucas Krieger', 'Frontend Verlag', 2021, 'Einführung in Angular', 'available', 7),
(DEFAULT, '978-1-59-327412-7', '6549873225', 4, 'Effiziente Projektplanung', 'Patrick Lange', 'PM Verlag', 2020, 'Ein Leitfaden für erfolgreiche Projektplanung', 'reserved', 10),
(DEFAULT, '978-1-50-117321-9', '8529637424', 1, 'Algorithmen und Datenstrukturen', 'Sarah Meier', 'CompSci Verlag', 2018, 'Einführung in grundlegende Algorithmen', 'borrowed', 8),
(DEFAULT, '978-1-61-729443-8', '7539514886', 5, 'Cybersecurity für Fortgeschrittene', 'Daniel Weber', 'SecurityBooks', 2021, 'Vertiefte Konzepte zur IT-Sicherheit', 'available', 11),
(DEFAULT, '978-1-61-729598-5', '9517534885', 2, 'Künstliche Intelligenz in der Praxis', 'Julia Fischer', 'AI World', 2019, 'Anwendungen von KI in der Industrie', 'reserved', 13),
(DEFAULT, '978-0-14-312547-2', '1234567891', 3, 'Machine Learning Grundlagen', 'Daniel Schmidt', 'AI Books', 2021, 'Grundlagen des maschinellen Lernens', 'available', 11),
(DEFAULT, '978-1-61-729469-1', '9876543211', 2, 'Blockchain für Einsteiger', 'Nina Weber', 'TechPress', 2020, 'Ein einfacher Einstieg in Blockchain-Technologien', 'borrowed', 6),
(DEFAULT, '978-0-13-110362-8', '6549873211', 4, 'Python für Wissenschaftler', 'Clara Fischer', 'ScienceBooks', 2019, 'Einführung in die Python-Programmierung für wissenschaftliche Zwecke', 'reserved', 7),
(DEFAULT, '978-1-50-117321-7', '1597534864', 5, 'Big Data und Hadoop', 'Patrick Lange', 'BigData Press', 2018, 'Ein Leitfaden für die Arbeit mit Hadoop und Big Data', 'available', 14),
(DEFAULT, '978-1-59-327412-8', '8529637412', 1, 'Cybersecurity für Anfänger', 'Maximilian Krieger', 'Security World', 2020, 'Ein Leitfaden für den Einstieg in die IT-Sicherheit', 'borrowed', 8),
(DEFAULT, '978-1-61-729443-8', '7539514861', 3, 'Statistik Basics', 'Daniel Meier', 'StatPress', 2021, 'Einführung in statistische Konzepte und Methoden', 'reserved', 9),
(DEFAULT, '978-0-13-708108-7', '9517534870', 4, 'Datenanalyse mit R', 'Julia Lange', 'DataWorld', 2020, 'Grundlagen der Datenanalyse mit R', 'available', 12),
(DEFAULT, '978-1-59-327410-6', '3698521470', 2, 'C++ für Fortgeschrittene', 'Lucas Weber', 'CodeBooks', 2019, 'Fortgeschrittene Konzepte der C++-Programmierung', 'borrowed', 10),
(DEFAULT, '978-1-61-729469-2', '6549873212', 5, 'Künstliche Intelligenz in der Praxis', 'Sarah Fischer', 'AI Verlag', 2021, 'Ein Überblick über praktische Anwendungen der KI', 'available', 13),
(DEFAULT, '978-1-50-117370-9', '1234567892', 3, 'Java für Einsteiger', 'Clara Meier', 'CodeWorld', 2018, 'Ein einfacher Einstieg in die Java-Programmierung', 'reserved', 15),
(DEFAULT, '978-1-61-729598-6', '7539514862', 1, 'Meditation im Alltag', 'Lisa Weber', 'MindBooks', 2020, 'Praktische Tipps für mehr Entspannung und Gelassenheit', 'borrowed', 6),
(DEFAULT, '978-0-13-708108-9', '8529637413', 4, 'Effiziente Projektplanung', 'Patrick Schmidt', 'PMBooks', 2019, 'Ein Leitfaden für erfolgreiche Projektplanung', 'available', 10),
(DEFAULT, '978-1-59-327424-1', '6549873213', 2, 'Effiziente Teamarbeit', 'Maximilian Lange', 'BusinessPress', 2020, 'Strategien für produktives Arbeiten im Team', 'reserved', 8),
(DEFAULT, '978-1-61-729443-9', '9517534871', 3, 'Yoga für Anfänger', 'Daniel Meier', 'HealthBooks', 2021, 'Ein praktischer Einstieg in die Welt des Yoga', 'borrowed', 9),
(DEFAULT, '978-1-50-117370-2', '7539514870', 5, 'Kreatives Schreiben', 'Sarah Krieger', 'WriterPress', 2018, 'Ein Leitfaden für kreatives Schreiben', 'available', 14),
(DEFAULT, '978-1-61-729469-4', '8529637414', 4, 'Blockchain für Unternehmen', 'Lucas Lange', 'TechBooks', 2019, 'Ein Überblick über Blockchain-Anwendungen in Unternehmen', 'reserved', 11),
(DEFAULT, '978-1-50-117321-8', '1234567893', 2, 'Internet of Things verstehen', 'Clara Fischer', 'IoT World', 2020, 'Einführung in die Welt des Internet of Things', 'borrowed', 7),
(DEFAULT, '978-0-13-708108-0', '3698521471', 1, 'Fortgeschrittene Algorithmen', 'Lisa Weber', 'CompSci Verlag', 2021, 'Vertiefte Konzepte der Algorithmusanalyse', 'available', 13),
(DEFAULT, '978-1-59-327412-9', '6549873214', 3, 'Statistik für Fortgeschrittene', 'Julia Lange', 'StatBooks', 2019, 'Vertiefte statistische Methoden für Profis', 'reserved', 6),
(DEFAULT, '978-1-61-729598-7', '7539514863', 4, 'Big Data Grundlagen', 'Patrick Weber', 'DataWorld', 2020, 'Ein Überblick über Big Data Konzepte und Technologien', 'borrowed', 9),
(DEFAULT, '978-1-50-117370-3', '8529637415', 5, 'Cybersecurity für Profis', 'Sarah Meier', 'Security World', 2018, 'Vertiefte Konzepte zur IT-Sicherheit', 'available', 10),
(DEFAULT, '978-1-61-729469-5', '9517534872', 3, 'Python für Data Science', 'Daniel Schmidt', 'DataBooks', 2021, 'Einführung in Python für die Datenanalyse', 'reserved', 7),
(DEFAULT, '978-1-59-327410-7', '3698521472', 2, 'Effizientes Arbeiten mit Scrum', 'Maximilian Krieger', 'PMBooks', 2020, 'Ein Leitfaden für agiles Projektmanagement', 'borrowed', 8),
(DEFAULT, '978-1-61-729443-7', '6549873215', 4, 'Künstliche Intelligenz Grundlagen', 'Clara Weber', 'AI Verlag', 2019, 'Ein Überblick über die Grundkonzepte der KI', 'available', 12),
(DEFAULT, '978-1-50-117321-6', '7539514864', 5, 'Machine Learning Basics', 'Lisa Meier', 'AI World', 2020, 'Grundlagen des maschinellen Lernens', 'reserved', 11),
(DEFAULT, '978-1-59-327424-2', '9517534873', 1, 'Effizientes Arbeiten im Team', 'Julia Lange', 'BusinessTech', 2021, 'Strategien für produktive Teamarbeit', 'borrowed', 14),
(DEFAULT, '978-1-61-729469-6', '8529637416', 2, 'Statistik für Data Science', 'Patrick Schmidt', 'StatPress', 2020, 'Statistische Methoden für die Datenanalyse', 'available', 8),
(DEFAULT, '978-1-50-117370-7', '3698521473', 3, 'Yoga für Fortgeschrittene', 'Sarah Fischer', 'HealthPress', 2018, 'Fortgeschrittene Yoga-Übungen für den Alltag', 'reserved', 9),
(DEFAULT, '978-0-13-708108-1', '6549873216', 4, 'Blockchain verstehen', 'Lucas Krieger', 'TechPress', 2019, 'Ein Überblick über Blockchain-Anwendungen', 'borrowed', 15),
(DEFAULT, '978-1-59-327412-3', '7539514865', 1, 'Datenbanken mit PostgreSQL', 'Maximilian Lange', 'DataWorld', 2020, 'Ein praktischer Leitfaden für PostgreSQL', 'available', 11),
(DEFAULT, '978-1-50-117321-5', '9517534874', 2, 'Meditation für Anfänger', 'Clara Fischer', 'MindBooks', 2021, 'Einführung in die Welt der Meditation', 'reserved', 6),
(DEFAULT, '978-1-61-729443-6', '1597534865', 3, 'Webentwicklung mit Angular', 'Lisa Fischer', 'FrontendBooks', 2021, 'Einführung in die moderne Webentwicklung mit Angular', 'available', 8),
(DEFAULT, '978-1-50-117370-6', '6549873217', 5, 'Fortgeschrittene Python-Konzepte', 'Daniel Weber', 'CodeBooks', 2018, 'Ein Blick auf fortgeschrittene Python-Techniken', 'reserved', 12),
(DEFAULT, '978-1-59-327424-4', '7539514866', 2, 'Effiziente Projektplanung', 'Patrick Lange', 'PMBooks', 2020, 'Ein Leitfaden für produktive Projekte', 'borrowed', 14),
(DEFAULT, '978-1-61-729469-7', '8529637417', 4, 'Blockchain für Fortgeschrittene', 'Maximilian Krieger', 'TechWorld', 2019, 'Vertiefte Konzepte der Blockchain-Technologie', 'available', 7),
(DEFAULT, '978-1-50-117321-8', '9517534875', 3, 'Data Science Grundlagen', 'Julia Meier', 'DataTech', 2021, 'Grundlagen der Datenwissenschaft', 'reserved', 10),
(DEFAULT, '978-0-13-708108-2', '3698521474', 1, 'Einführung in die KI-Forschung', 'Clara Fischer', 'AI Verlag', 2020, 'Ein Überblick über die Grundlagen der KI-Forschung', 'borrowed', 9),
(DEFAULT, '978-1-59-327410-8', '6549873218', 5, 'Yoga und Gesundheit', 'Sarah Krieger', 'HealthBooks', 2019, 'Ein Leitfaden für ein gesundes Leben durch Yoga', 'available', 11),
(DEFAULT, '978-1-61-729598-8', '7539514867', 4, 'Effizientes Arbeiten im Team', 'Daniel Schmidt', 'BusinessPress', 2020, 'Strategien für effektive Zusammenarbeit', 'reserved', 8),
(DEFAULT, '978-1-50-117370-5', '9517534876', 3, 'Machine Learning für Einsteiger', 'Patrick Weber', 'AI World', 2021, 'Ein einfacher Einstieg in Machine Learning', 'borrowed', 12),
(DEFAULT, '978-1-61-729469-8', '8529637418', 2, 'Algorithmen und Datenstrukturen', 'Lucas Lange', 'CompSci Verlag', 2018, 'Einführung in grundlegende Algorithmenkonzepte', 'available', 10),
(DEFAULT, '978-1-59-327424-5', '3698521475', 1, 'Statistik Basics', 'Maximilian Meier', 'StatPress', 2019, 'Einführung in statistische Methoden', 'reserved', 9),
(DEFAULT, '978-1-50-117321-9', '6549873219', 4, 'Kreatives Schreiben für Fortgeschrittene', 'Julia Lange', 'WriterBooks', 2020, 'Tipps für erfahrene Autoren', 'borrowed', 14),
(DEFAULT, '978-1-61-729443-7', '7539514868', 5, 'Blockchain-Anwendungen im Unternehmen', 'Sarah Fischer', 'TechPress', 2021, 'Ein Überblick über Blockchain-Technologien', 'available', 7),
(DEFAULT, '978-1-50-117370-7', '9517534877', 3, 'Internet of Things Basics', 'Daniel Schmidt', 'IoT World', 2020, 'Ein praktischer Leitfaden für IoT', 'reserved', 11),
(DEFAULT, '978-1-59-327412-4', '8529637419', 2, 'Cybersecurity Essentials', 'Clara Fischer', 'SecurityBooks', 2018, 'Grundlagen der IT-Sicherheit', 'borrowed', 13),
(DEFAULT, '978-1-61-729469-9', '3698521476', 4, 'Effizientes Projektmanagement mit Scrum', 'Patrick Weber', 'PM Verlag', 2019, 'Ein Leitfaden für agiles Arbeiten', 'available', 9),
(DEFAULT, '978-1-50-117321-7', '6549873220', 5, 'Python für Data Science', 'Lucas Krieger', 'DataBooks', 2021, 'Einführung in Python für die Datenanalyse', 'reserved', 8),
(DEFAULT, '978-1-61-729598-9', '7539514869', 3, 'Big Data Anwendungen', 'Sarah Meier', 'BigData Press', 2020, 'Ein Überblick über die Nutzung von Big Data', 'borrowed', 14),
(DEFAULT, '978-1-50-117370-8', '9517534878', 2, 'Yoga für Profis', 'Daniel Weber', 'HealthTech', 2018, 'Fortgeschrittene Übungen und Techniken im Yoga', 'available', 10),
(DEFAULT, '978-1-61-729469-0', '8529637420', 4, 'Fortgeschrittene Statistik-Konzepte', 'Maximilian Lange', 'StatPress', 2021, 'Vertiefte Methoden für statistische Analysen', 'reserved', 11),
(DEFAULT, '978-1-59-327410-9', '3698521477', 1, 'Blockchain für die Zukunft', 'Julia Lange', 'TechWorld', 2020, 'Ein Überblick über zukünftige Blockchain-Anwendungen', 'borrowed', 8),
(DEFAULT, '978-1-61-729443-8', '6549873221', 3, 'Künstliche Intelligenz und Ethik', 'Clara Fischer', 'AI Verlag', 2019, 'Ein Überblick über ethische Fragen der KI', 'available', 13),
(DEFAULT, '978-1-50-117321-8', '7539514870', 5, 'Projektmanagement mit Kanban', 'Lucas Lange', 'PMBooks', 2021, 'Ein Leitfaden für Kanban-Methoden', 'reserved', 6),
(DEFAULT, '978-1-61-729598-6', '9517534879', 2, 'Machine Learning und KI', 'Patrick Weber', 'AI World', 2020, 'Einführung in KI-Technologien und maschinelles Lernen', 'borrowed', 7),
(DEFAULT, '978-1-59-327424-6', '8529637421', 4, 'Webentwicklung mit React', 'Maximilian Meier', 'Frontend Verlag', 2018, 'Ein moderner Ansatz für Webentwicklung', 'available', 11),
(DEFAULT, '978-1-50-117370-6', '3698521478', 1, 'Statistische Methoden für Einsteiger', 'Sarah Weber', 'StatBooks', 2019, 'Ein praktischer Leitfaden für Statistik', 'reserved', 14),
(DEFAULT, '978-1-61-729469-1', '6549873222', 3, 'Effizientes Arbeiten im Team', 'Daniel Weber', 'BusinessTech', 2021, 'Strategien für produktive Teamarbeit', 'borrowed', 8),
(DEFAULT, '978-1-59-327412-5', '7539514871', 5, 'C++ für Einsteiger', 'Clara Lange', 'CodeBooks', 2020, 'Ein Leitfaden für Anfänger in C++', 'available', 12),
(DEFAULT, '978-1-50-117321-9', '9517534880', 2, 'Data Science Grundlagen', 'Lucas Krieger', 'DataBooks', 2019, 'Einführung in die Datenwissenschaft', 'reserved', 9),
(DEFAULT, '978-1-61-729443-9', '8529637422', 4, 'Blockchain verstehen', 'Patrick Weber', 'TechPress', 2021, 'Ein einfacher Einstieg in Blockchain-Technologien', 'borrowed', 11),
(DEFAULT, '978-1-61-729443-1', '9517534863', 3, 'Cloud Computing Essentials', 'Lucas Lange', 'TechBooks', 2021, 'Einführung in Cloud-Technologien', 'available', 14),
(DEFAULT, '978-1-59-327412-9', '7539514872', 5, 'Blockchain für Einsteiger', 'Nina Fischer', 'TechWorld', 2019, 'Grundlagen der Blockchain-Technologie', 'borrowed', 11),
(DEFAULT, '978-0-13-708108-3', '4569871233', 2, 'Datenbanken mit PostgreSQL', 'Patrick Weber', 'DataBooks', 2020, 'Ein praktischer Einstieg in PostgreSQL', 'reserved', 7),
(DEFAULT, '978-1-50-117370-5', '8529637413', 4, 'Machine Learning Basics', 'Julia Meier', 'AI Books', 2021, 'Grundlagen des maschinellen Lernens', 'available', 9),
(DEFAULT, '978-1-61-729469-2', '3698521479', 1, 'Statistik für Einsteiger', 'Maximilian Schmidt', 'StatPress', 2018, 'Ein praktischer Leitfaden für Statistik', 'borrowed', 8),
(DEFAULT, '978-1-59-327410-5', '6549873213', 2, 'Python für Datenwissenschaftler', 'Daniel Krieger', 'CodePress', 2020, 'Grundlagen der Python-Datenanalyse', 'reserved', 10),
(DEFAULT, '978-1-61-729443-2', '7539514873', 3, 'Webentwicklung mit React', 'Clara Lange', 'FrontendBooks', 2019, 'Ein moderner Ansatz zur Webentwicklung', 'available', 13),
(DEFAULT, '978-1-50-117321-8', '9517534864', 5, 'Yoga und Achtsamkeit', 'Lucas Weber', 'MindBooks', 2021, 'Ein Leitfaden für mehr Achtsamkeit im Alltag', 'borrowed', 6),
(DEFAULT, '978-0-13-708108-5', '8529637423', 4, 'Cybersecurity Grundlagen', 'Patrick Meier', 'SecurityTech', 2018, 'Ein Überblick über IT-Sicherheit', 'reserved', 12),
(DEFAULT, '978-1-61-729598-6', '3698521480', 1, 'Machine Learning für Fortgeschrittene', 'Sarah Schmidt', 'AI Verlag', 2020, 'Erweiterte Konzepte des maschinellen Lernens', 'available', 7),
(DEFAULT, '978-1-59-327424-1', '7539514874', 3, 'Effizientes Projektmanagement', 'Nina Krieger', 'PM Verlag', 2021, 'Ein Leitfaden für agile Methoden', 'reserved', 14),
(DEFAULT, '978-1-50-117370-8', '9517534875', 2, 'C++ für Fortgeschrittene', 'Maximilian Lange', 'CompSci Verlag', 2019, 'Vertiefte Konzepte der C++-Programmierung', 'borrowed', 11),
(DEFAULT, '978-1-61-729469-3', '8529637424', 4, 'Meditation im Alltag', 'Julia Weber', 'HealthBooks', 2020, 'Praktische Übungen für mehr Gelassenheit', 'available', 8),
(DEFAULT, '978-1-59-327412-5', '3698521481', 5, 'Blockchain für Unternehmen', 'Clara Meier', 'TechBooks', 2018, 'Anwendungen der Blockchain-Technologie', 'reserved', 10),
(DEFAULT, '978-1-61-729443-3', '7539514875', 3, 'Datenanalyse mit R', 'Patrick Weber', 'DataPress', 2021, 'Ein Leitfaden für R-Programmierung', 'borrowed', 12),
(DEFAULT, '978-1-50-117321-9', '9517534876', 2, 'Yoga für Fortgeschrittene', 'Maximilian Schmidt', 'MindBooks', 2020, 'Erweiterte Yoga-Techniken für Profis', 'available', 7),
(DEFAULT, '978-0-13-708108-6', '8529637425', 4, 'Effiziente Teamarbeit', 'Lucas Krieger', 'BusinessBooks', 2019, 'Strategien für produktive Zusammenarbeit', 'reserved', 14),
(DEFAULT, '978-1-61-729598-7', '3698521482', 1, 'Statistik Basics', 'Sarah Fischer', 'StatWorld', 2020, 'Ein Überblick über grundlegende statistische Methoden', 'borrowed', 13),
(DEFAULT, '978-1-50-117370-9', '7539514876', 3, 'Einführung in maschinelles Lernen', 'Clara Lange', 'AI Verlag', 2021, 'Grundlagen von Machine Learning', 'available', 9),
(DEFAULT, '978-1-59-327410-6', '9517534877', 2, 'Künstliche Intelligenz verstehen', 'Daniel Weber', 'AI World', 2018, 'Ein Leitfaden für KI-Einsteiger', 'reserved', 6),
(DEFAULT, '978-1-61-729443-4', '8529637426', 5, 'Datenbanken mit NoSQL', 'Maximilian Meier', 'DataTech', 2020, 'Einführung in die Welt der NoSQL-Datenbanken', 'borrowed', 11),
(DEFAULT, '978-1-50-117321-7', '3698521483', 4, 'Machine Learning in der Praxis', 'Nina Weber', 'AI Books', 2021, 'Praktische Anwendungen von maschinellem Lernen', 'available', 8),
(DEFAULT, '978-1-59-327424-2', '7539514877', 3, 'Projektmanagement mit Kanban', 'Patrick Fischer', 'PM Verlag', 2019, 'Ein praktischer Leitfaden für Kanban-Methoden', 'reserved', 10),
(DEFAULT, '978-1-61-729469-4', '9517534878', 2, 'Cybersecurity Essentials', 'Julia Lange', 'SecurityPress', 2020, 'Ein Überblick über IT-Sicherheitskonzepte', 'borrowed', 14),
(DEFAULT, '978-1-50-117370-3', '8529637427', 5, 'Effizientes Arbeiten im Team', 'Maximilian Schmidt', 'BusinessTech', 2018, 'Ein praktischer Leitfaden für Teamarbeit', 'available', 12),
(DEFAULT, '978-0-13-708108-7', '3698521484', 3, 'Statistik für Einsteiger', 'Clara Fischer', 'StatBooks', 2019, 'Grundlagen der Statistik für Anfänger', 'reserved', 7),
(DEFAULT, '978-1-59-327412-6', '7539514878', 4, 'Blockchain für Fortgeschrittene', 'Sarah Weber', 'TechPress', 2021, 'Vertiefte Konzepte der Blockchain-Technologie', 'borrowed', 9),
(DEFAULT, '978-1-61-729598-8', '9517534879', 2, 'Meditation und Achtsamkeit', 'Daniel Krieger', 'MindWorld', 2020, 'Einführung in Achtsamkeitstechniken', 'available', 11),
(DEFAULT, '978-1-50-117321-6', '8529637428', 5, 'Big Data Anwendungen', 'Nina Fischer', 'BigData Press', 2019, 'Anwendungsbeispiele von Big Data', 'reserved', 13),
(DEFAULT, '978-1-59-327424-3', '3698521485', 3, 'Effizientes Projektmanagement mit Scrum', 'Lucas Weber', 'PM Verlag', 2018, 'Einführung in agiles Projektmanagement', 'borrowed', 10),
(DEFAULT, '978-1-61-729443-6', '4569871234', 3, 'Einführung in die Datenanalyse', 'Daniel Weber', 'DataBooks', 2021, 'Ein praktischer Leitfaden für Datenanalysen', 'available', 7),
(DEFAULT, '978-0-13-708108-8', '9517534881', 4, 'Big Data und NoSQL', 'Clara Meier', 'BigDataPress', 2020, 'Grundlagen von Big Data Technologien und NoSQL', 'borrowed', 11),
(DEFAULT, '978-1-50-117321-8', '7539514879', 5, 'Machine Learning für Einsteiger', 'Lucas Fischer', 'AI Verlag', 2019, 'Ein einfacher Einstieg in maschinelles Lernen', 'reserved', 13),
(DEFAULT, '978-1-59-327412-7', '8529637429', 2, 'Yoga und Gesundheit', 'Sarah Weber', 'HealthPress', 2021, 'Praktische Tipps für mehr Gesundheit durch Yoga', 'available', 8),
(DEFAULT, '978-1-61-729469-5', '3698521486', 3, 'Datenbanken mit MySQL', 'Patrick Lange', 'DataTech', 2020, 'Ein Leitfaden für die Arbeit mit MySQL-Datenbanken', 'borrowed', 10),
(DEFAULT, '978-1-59-327424-4', '9517534882', 4, 'Statistische Methoden verstehen', 'Maximilian Weber', 'StatPress', 2018, 'Ein Überblick über grundlegende Statistikmethoden', 'reserved', 6),
(DEFAULT, '978-1-50-117370-8', '7539514880', 2, 'Blockchain-Anwendungen', 'Julia Fischer', 'TechBooks', 2019, 'Anwendungsbeispiele für Blockchain-Technologien', 'available', 9),
(DEFAULT, '978-0-13-708108-0', '8529637430', 5, 'Effiziente Führung', 'Daniel Weber', 'LeadershipPress', 2020, 'Strategien für erfolgreiche Führungskräfte', 'borrowed', 12),
(DEFAULT, '978-1-61-729443-7', '3698521487', 3, 'Python für Datenwissenschaften', 'Clara Fischer', 'DataBooks', 2021, 'Ein praktischer Leitfaden für Python-Programmierung', 'reserved', 10),
(DEFAULT, '978-1-59-327410-7', '9517534883', 4, 'Webentwicklung mit Vue.js', 'Sarah Meier', 'Frontend Verlag', 2020, 'Ein moderner Ansatz zur Webentwicklung', 'available', 7),
(DEFAULT, '978-1-50-117321-9', '7539514881', 5, 'Machine Learning und KI', 'Lucas Fischer', 'AI World', 2019, 'Grundlagen des maschinellen Lernens und KI', 'reserved', 13),
(DEFAULT, '978-0-13-708108-1', '8529637431', 2, 'Datenanalyse mit Python', 'Patrick Weber', 'DataPress', 2021, 'Ein praktischer Einstieg in Python-Datenanalyse', 'borrowed', 14),
(DEFAULT, '978-1-61-729469-6', '9517534884', 3, 'Blockchain für Fortgeschrittene', 'Maximilian Meier', 'TechWorld', 2020, 'Vertiefte Konzepte der Blockchain-Technologie', 'available', 9),
(DEFAULT, '978-1-59-327424-5', '7539514882', 4, 'Effizientes Arbeiten mit Scrum', 'Julia Lange', 'PM Verlag', 2019, 'Ein Leitfaden für agiles Projektmanagement', 'reserved', 6),
(DEFAULT, '978-1-50-117370-9', '8529637432', 2, 'Statistik leicht gemacht', 'Sarah Weber', 'StatBooks', 2020, 'Grundlagen der Statistik für Anfänger', 'borrowed', 8),
(DEFAULT, '978-1-61-729443-8', '9517534885', 5, 'Yoga für Profis', 'Lucas Fischer', 'MindPress', 2018, 'Fortgeschrittene Techniken und Übungen', 'available', 10),
(DEFAULT, '978-1-59-327410-8', '7539514883', 3, 'Cybersecurity Basics', 'Clara Meier', 'SecurityPress', 2021, 'Grundlagen der IT-Sicherheit', 'reserved', 14),
(DEFAULT, '978-0-13-708108-2', '8529637433', 4, 'Big Data Anwendungen', 'Patrick Lange', 'BigDataPress', 2019, 'Anwendungsbeispiele für Big Data in Unternehmen', 'borrowed', 12),
(DEFAULT, '978-1-61-729469-7', '9517534886', 2, 'Machine Learning Essentials', 'Maximilian Weber', 'AI Verlag', 2020, 'Ein Überblick über maschinelles Lernen', 'available', 11),
(DEFAULT, '978-1-50-117321-7', '7539514884', 5, 'Meditation im Alltag', 'Julia Fischer', 'MindBooks', 2021, 'Praktische Tipps für Achtsamkeit im Alltag', 'reserved', 13),
(DEFAULT, '978-1-59-327412-8', '8529637434', 3, 'Blockchain verstehen', 'Sarah Weber', 'TechPress', 2018, 'Ein Leitfaden für Blockchain-Einsteiger', 'borrowed', 6),
(DEFAULT, '978-0-13-708108-3', '9517534887', 4, 'Effizientes Arbeiten im Team', 'Lucas Fischer', 'BusinessTech', 2019, 'Ein Überblick über Teammanagement', 'available', 10),
(DEFAULT, '978-1-61-729443-9', '7539514885', 2, 'Statistische Analysen', 'Clara Lange', 'StatPress', 2020, 'Einführung in statistische Analysemethoden', 'reserved', 12),
(DEFAULT, '978-1-59-327410-9', '8529637435', 5, 'Python für Data Science', 'Daniel Weber', 'DataBooks', 2021, 'Grundlagen der Python-Datenanalyse', 'borrowed', 9),
(DEFAULT, '978-1-50-117370-6', '9517534888', 3, 'Yoga für Anfänger', 'Maximilian Schmidt', 'MindPress', 2019, 'Ein Leitfaden für Yoga-Neulinge', 'available', 8),
(DEFAULT, '978-0-13-708108-4', '7539514886', 4, 'C++ für Fortgeschrittene', 'Patrick Meier', 'CompSci Verlag', 2020, 'Vertiefte Konzepte der C++-Programmierung', 'reserved', 14),
(DEFAULT, '978-1-61-729469-8', '8529637436', 2, 'Machine Learning für Unternehmen', 'Julia Lange', 'AI Verlag', 2018, 'Anwendungen von maschinellem Lernen', 'borrowed', 11),
(DEFAULT, '978-1-50-117321-6', '9517534889', 5, 'Effizientes Projektmanagement', 'Sarah Fischer', 'PM Verlag', 2021, 'Ein Leitfaden für agile Methoden', 'available', 7),
(DEFAULT, '978-1-59-327424-6', '7539514887', 3, 'Statistik für Einsteiger', 'Clara Meier', 'StatBooks', 2020, 'Grundlagen der Statistik', 'reserved', 9),
(DEFAULT, '978-1-61-729443-0', '8529637437', 4, 'Cybersecurity für Einsteiger', 'Lucas Fischer', 'SecurityPress', 2019, 'Grundlagen der IT-Sicherheit', 'borrowed', 6);



-- Person

insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (1, 'Sibley', 'Billing', '16/07/1965', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (2, 'Candra', 'De Vaan', '09/03/1923', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (3, 'Hannis', 'Skipworth', '08/07/1967', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (4, 'Esra', 'Stillmann', '12/09/1971', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (5, 'De', 'Powdrell', '02/03/1966', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (6, 'Storm', 'Boorn', '12/02/1917', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (7, 'Rina', 'Spears', '16/02/1996', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (8, 'Renie', 'Moreby', '22/12/2011', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (9, 'Stefanie', 'Danett', '01/09/1952', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (10, 'Perle', 'Sommerling', '19/03/1952', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (11, 'Massimo', 'Shillitto', '10/06/1962', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (12, 'Vale', 'Fist', '28/02/1964', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (13, 'Bobbee', 'Fidoe', '04/04/1939', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (14, 'Cristal', 'Sartain', '28/08/2020', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (15, 'Lew', 'Mitchelson', '27/01/1919', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (16, 'Ame', 'Mohammed', '12/12/1915', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (17, 'Allix', 'Stebbing', '04/08/1991', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (18, 'Adara', 'Pilmoor', '06/10/1983', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (19, 'Emile', 'Chadbourne', '16/12/2011', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (20, 'Chev', 'Pollicote', '22/03/1983', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (21, 'Tiena', 'McAndrew', '17/05/2022', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (22, 'Antoine', 'Salliss', '03/01/2000', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (23, 'Lockwood', 'Jakeway', '08/03/2018', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (24, 'Rosette', 'Quixley', '16/02/1908', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (25, 'Hubey', 'Coot', '25/11/1984', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (26, 'Dane', 'Wilbore', '14/07/1986', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (27, 'Quintin', 'McHan', '10/04/1907', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (28, 'Lyn', 'MacAree', '14/09/1988', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (29, 'Augie', 'Rains', '01/11/1928', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (30, 'Traci', 'Drysdale', '10/12/1939', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (31, 'Elmo', 'Estabrook', '06/01/1900', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (32, 'Lyn', 'Vescovini', '18/10/1941', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (33, 'Corrinne', 'Barczynski', '21/05/1974', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (34, 'Parker', 'Menghi', '10/07/1939', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (35, 'Eba', 'Wheelband', '01/01/1992', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (36, 'Gasparo', 'Lingley', '06/01/1930', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (37, 'Sara', 'Sanbroke', '21/05/1998', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (38, 'Guido', 'Halversen', '03/08/1983', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (39, 'Sayre', 'Pentin', '26/09/1973', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (40, 'Preston', 'Terbrugge', '10/08/1997', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (41, 'Antoni', 'Astle', '22/01/1947', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (42, 'Lilllie', 'Aldersley', '07/09/1928', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (43, 'Reece', 'Kegg', '29/07/1944', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (44, 'Shaun', 'Harnwell', '26/02/1948', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (45, 'Nedi', 'Kull', '12/07/1905', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (46, 'Filippa', 'Coase', '18/05/1902', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (47, 'Anjela', 'Robjohns', '26/09/1943', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (48, 'Consuela', 'Darthe', '02/12/2013', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (49, 'Flin', 'Crumpe', '20/04/1922', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (50, 'Cristin', 'Folley', '30/03/1949', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (51, 'Derby', 'Woodison', '15/11/1907', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (52, 'Renaldo', 'Proffer', '18/01/2021', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (53, 'Irvine', 'Deathridge', '18/12/2000', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (54, 'Inger', 'Rankine', '27/09/1908', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (55, 'Annie', 'Squeers', '06/07/1949', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (56, 'Ruthi', 'Byford', '04/05/2017', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (57, 'Etheline', 'Hayer', '11/08/1902', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (58, 'Easter', 'Paskell', '29/05/1942', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (59, 'Stacia', 'Sautter', '16/10/2007', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (60, 'Fonsie', 'Baddow', '12/07/1927', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (61, 'Allister', 'Elce', '09/09/1971', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (62, 'Trudie', 'Davidov', '11/11/1908', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (63, 'Staffard', 'Betteson', '12/12/1972', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (64, 'Andrej', 'Dowse', '14/12/1937', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (65, 'Brandise', 'Cobby', '28/04/1967', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (66, 'Orland', 'Barke', '14/10/2002', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (67, 'Ringo', 'Triggol', '07/01/1994', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (68, 'Calvin', 'Danielot', '18/02/1922', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (69, 'Madelle', 'McCurdy', '14/10/1936', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (70, 'Trixi', 'Wrankling', '13/10/1983', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (71, 'Teresita', 'Georges', '11/06/1969', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (72, 'Maxi', 'Collard', '19/05/2003', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (73, 'Analiese', 'Espinas', '12/07/2013', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (74, 'Ignacio', 'Pendrigh', '12/06/1904', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (75, 'Rosabel', 'Ivanitsa', '28/08/1911', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (76, 'Kimmie', 'Treverton', '03/12/1949', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (77, 'Kathe', 'Scheu', '25/03/1968', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (78, 'Corella', 'Fend', '05/05/1921', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (79, 'Rick', 'Moorman', '04/11/1975', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (80, 'Bogey', 'Klimushev', '27/12/2011', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (81, 'Kayne', 'Litherborough', '10/06/1987', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (82, 'Zilvia', 'Bullivent', '26/03/1986', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (83, 'Terrye', 'Wernham', '25/04/1938', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (84, 'Dulce', 'Karlowicz', '12/10/1938', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (85, 'Halsy', 'Beller', '03/03/1982', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (86, 'Allie', 'Whibley', '29/10/1956', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (87, 'Dannie', 'Astridge', '26/06/2010', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (88, 'Susan', 'MacSkeagan', '10/09/1921', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (89, 'Janaya', 'Reinhardt', '04/05/2015', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (90, 'Janenna', 'Boyde', '28/10/1907', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (91, 'Jory', 'Spraging', '08/12/2020', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (92, 'Gregorio', 'Culleton', '26/05/1997', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (93, 'Ruprecht', 'Corpes', '21/03/1922', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (94, 'Merna', 'Greser', '24/07/2019', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (95, 'Conway', 'McQuilliam', '09/08/1950', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (96, 'Thornton', 'Ind', '27/08/2003', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (97, 'Cam', 'Klezmski', '28/07/1960', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (98, 'Eleanore', 'Dainter', '19/02/1924', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (99, 'Carole', 'Vasichev', '14/09/2008', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (100, 'Lauritz', 'Sleford', '22/02/2009', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (101, 'Ophelie', 'Godfray', '28/05/2015', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (102, 'Cobby', 'Gellately', '28/03/1996', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (103, 'Vilma', 'Jenkin', '02/02/1944', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (104, 'Bradan', 'Extal', '25/07/1970', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (105, 'Marie-ann', 'Huffadine', '25/02/1938', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (106, 'Adham', 'Pourvoieur', '24/11/1900', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (107, 'Brendis', 'Mabbott', '17/09/1918', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (108, 'Andria', 'Gaye', '17/05/1923', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (109, 'Norrie', 'Lembke', '14/10/1949', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (110, 'Ricard', 'Paradise', '21/09/1967', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (111, 'Nerti', 'Exley', '09/01/1975', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (112, 'Benjy', 'Sworne', '04/01/1971', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (113, 'Ruperto', 'Call', '13/01/2017', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (114, 'Grazia', 'Moff', '14/12/1922', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (115, 'Marisa', 'Aireton', '26/01/1960', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (116, 'Elbertina', 'Yakovlev', '06/01/1940', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (117, 'Tabby', 'Grishelyov', '09/11/1954', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (118, 'Saw', 'Duxbury', '17/09/1971', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (119, 'Abby', 'Riccio', '18/08/1930', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (120, 'Leelah', 'Playden', '14/01/1957', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (121, 'Velvet', 'Chandlar', '22/07/1999', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (122, 'Sherlock', 'Ullyott', '16/09/2006', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (123, 'Ronni', 'Jurs', '14/08/2012', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (124, 'Chickie', 'Shallo', '11/05/1915', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (125, 'Felicia', 'Halwill', '31/10/2005', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (126, 'Drusy', 'Berthe', '28/03/2008', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (127, 'Giovanna', 'McKeon', '13/02/1922', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (128, 'Darnall', 'Whatman', '28/10/1922', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (129, 'Reina', 'Christoffels', '15/02/1950', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (130, 'Zared', 'Rance', '20/08/1994', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (131, 'Calla', 'Dabell', '05/04/1927', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (132, 'Tiertza', 'Burland', '17/10/1933', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (133, 'Sherlock', 'Matovic', '20/06/1910', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (134, 'Erroll', 'Alcorn', '27/09/2005', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (135, 'Griswold', 'Kivlin', '04/05/2003', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (136, 'Juliet', 'Archell', '24/02/1961', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (137, 'Garek', 'Ciccerale', '06/12/2003', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (138, 'Olenka', 'Huffy', '04/06/2011', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (139, 'David', 'Boeter', '22/11/2002', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (140, 'Jocelin', 'Obray', '23/12/1989', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (141, 'Mamie', 'Crozier', '04/06/1948', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (142, 'Huntley', 'Laughtisse', '14/06/1972', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (143, 'Zebadiah', 'Stegers', '24/09/1916', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (144, 'Klemens', 'Merrin', '24/08/1900', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (145, 'Garrik', 'Devenny', '21/11/1920', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (146, 'Hannah', 'Reiach', '04/11/1965', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (147, 'Francene', 'Albertson', '23/10/1988', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (148, 'Anastasie', 'Ben-Aharon', '27/07/1927', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (149, 'Gabriella', 'Chippindall', '03/02/1969', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (150, 'Donica', 'Getley', '06/08/1940', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (151, 'Skip', 'Ormes', '03/01/1995', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (152, 'Charla', 'Daulton', '03/07/2016', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (153, 'Jereme', 'Eckh', '19/05/2022', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (154, 'Smith', 'Shadfourth', '04/07/2015', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (155, 'Ruben', 'Illsley', '21/12/1902', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (156, 'Raynell', 'Babbidge', '26/05/1946', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (157, 'Adler', 'Kinkaid', '24/02/2001', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (158, 'Jorey', 'Deacon', '08/07/2004', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (159, 'Earlie', 'Greet', '05/03/1920', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (160, 'Tobey', 'Innocenti', '09/10/1934', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (161, 'Winnifred', 'Waters', '06/03/1912', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (162, 'Shelden', 'Satterthwaite', '07/02/1981', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (163, 'Theadora', 'Viggars', '17/05/1954', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (164, 'Tessy', 'Midner', '05/09/1935', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (165, 'Cathleen', 'Kolin', '30/12/2000', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (166, 'Mira', 'MacTavish', '09/05/1917', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (167, 'Minta', 'Thatcham', '19/10/2011', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (168, 'Averil', 'Rayer', '05/12/1901', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (169, 'Vernen', 'Iceton', '04/01/1916', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (170, 'Bennie', 'Lackner', '16/12/1916', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (171, 'Constantin', 'Elie', '01/12/1947', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (172, 'Pegeen', 'Myles', '21/06/1958', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (173, 'Torey', 'Capp', '01/02/1902', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (174, 'Emmalee', 'Hitscher', '27/03/1994', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (175, 'Deva', 'Leggin', '13/11/1918', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (176, 'Cahra', 'Oliphard', '20/07/1948', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (177, 'Carmella', 'Drover', '29/09/2003', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (178, 'Brena', 'Stapylton', '02/10/1985', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (179, 'Rubina', 'Seyler', '11/01/1943', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (180, 'Byran', 'Jencken', '28/10/1915', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (181, 'Jennette', 'Zellner', '25/10/2002', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (182, 'Yevette', 'Rassmann', '11/01/1994', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (183, 'Base', 'Lauret', '09/03/1937', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (184, 'Nonna', 'Goater', '06/10/1986', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (185, 'Job', 'Leythley', '21/12/2002', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (186, 'Werner', 'Brimman', '31/03/1988', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (187, 'Garret', 'Tracy', '14/07/1932', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (188, 'Wendeline', 'Ivkovic', '08/11/1918', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (189, 'Jeniece', 'Gumme', '10/06/1942', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (190, 'Kerwinn', 'Gobbett', '13/06/1914', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (191, 'Clemente', 'Andreou', '29/01/2005', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (192, 'Mickie', 'Dilliway', '03/06/1914', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (193, 'Brian', 'Garling', '23/08/2019', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (194, 'Miguel', 'Este', '06/10/1910', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (195, 'Allister', 'Hrycek', '15/01/1980', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (196, 'Sigvard', 'Hensmans', '29/08/1980', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (197, 'Sonnie', 'D''Adda', '10/06/1915', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (198, 'Cirilo', 'Crudge', '19/05/1991', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (199, 'Brigit', 'Suero', '25/02/1925', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (200, 'Druci', 'Howgego', '23/06/1915', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (201, 'Penn', 'Rate', '28/05/1933', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (202, 'Elenore', 'Quantrell', '06/10/1905', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (203, 'Natal', 'Commings', '03/06/1975', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (204, 'Vivianna', 'Cordero', '06/11/1903', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (205, 'Meghan', 'Slamaker', '04/01/1950', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (206, 'Lonny', 'Hulbert', '31/01/1967', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (207, 'Bernete', 'Midgley', '23/04/1985', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (208, 'Mair', 'Coburn', '05/09/1953', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (209, 'Norri', 'Mico', '14/03/1905', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (210, 'Helene', 'Curnokk', '12/02/1915', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (211, 'Jodi', 'Marchant', '09/12/1942', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (212, 'Juliet', 'Franca', '23/09/1984', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (213, 'Beau', 'Grice', '24/02/1993', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (214, 'Brier', 'Tilston', '25/04/1965', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (215, 'Kerianne', 'Dirkin', '03/07/1991', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (216, 'Terencio', 'Muscott', '22/01/1982', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (217, 'Darice', 'Stallibrass', '20/10/1965', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (218, 'Aurore', 'Stambridge', '14/09/1964', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (219, 'Benjamin', 'Merkle', '24/05/1941', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (220, 'Orella', 'Yokel', '21/11/2004', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (221, 'Haywood', 'Croyser', '25/01/1933', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (222, 'Giorgia', 'Varcoe', '20/06/1928', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (223, 'Kirsteni', 'Diemer', '17/12/1976', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (224, 'Garner', 'Fowell', '26/06/1956', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (225, 'Jeffy', 'Hawkeswood', '19/05/1973', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (226, 'Alyss', 'Huggens', '23/12/1983', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (227, 'Liza', 'Farfoot', '27/06/1944', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (228, 'Tilda', 'Warwick', '06/12/1988', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (229, 'Michelle', 'Treacy', '20/02/1914', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (230, 'Gwenette', 'Coaster', '25/02/1976', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (231, 'Bethanne', 'Brigshaw', '20/10/2012', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (232, 'Chad', 'Carlyle', '13/02/1991', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (233, 'Billy', 'Parradye', '30/04/1999', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (234, 'Ailee', 'Dummer', '31/05/1939', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (235, 'Yule', 'Milesop', '20/05/1994', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (236, 'Sharla', 'Hulland', '30/06/1993', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (237, 'Laurice', 'Filon', '04/10/1927', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (238, 'Ashely', 'Petkovic', '08/06/1920', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (239, 'Noell', 'Stopher', '06/07/1926', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (240, 'Joyann', 'Rymell', '06/08/2003', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (241, 'Lora', 'Chasemore', '13/09/1945', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (242, 'Augustine', 'Fardon', '27/01/1968', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (243, 'Claudian', 'Stammers', '09/07/1904', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (244, 'Ruthi', 'Petti', '30/05/2003', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (245, 'Vidovic', 'Soff', '04/09/1988', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (246, 'Carmelia', 'Elkin', '12/07/1902', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (247, 'Garfield', 'Marflitt', '30/10/1977', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (248, 'Victoir', 'Reoch', '30/07/1985', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (249, 'Inessa', 'Pimlott', '25/10/1977', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (250, 'Godwin', 'Giorgio', '10/02/2002', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (251, 'Malinde', 'Huyge', '05/05/1933', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (252, 'Bat', 'Ceaser', '15/03/1901', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (253, 'Eugen', 'Butland', '05/04/1915', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (254, 'Terrye', 'Croxall', '16/10/2003', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (255, 'Twyla', 'Oaker', '07/05/2005', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (256, 'Rafferty', 'Terram', '04/08/1923', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (257, 'Antone', 'Sieve', '15/10/1932', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (258, 'Tony', 'Linskill', '09/12/1974', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (259, 'Austina', 'D''Adamo', '28/05/1971', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (260, 'Maggie', 'Birkmyr', '13/11/1926', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (261, 'Dody', 'De Matteis', '17/05/1975', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (262, 'Darrin', 'Strick', '11/05/1930', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (263, 'Franny', 'Carlisso', '09/01/1910', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (264, 'Wallis', 'Metcalf', '10/03/2008', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (265, 'Karol', 'Arthurs', '10/03/1958', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (266, 'Alleyn', 'Wiggans', '08/06/1930', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (267, 'Sammy', 'Tabard', '26/02/1920', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (268, 'Maisie', 'Elsley', '16/08/1944', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (269, 'Barris', 'O''Loughane', '04/03/1970', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (270, 'Keely', 'Clemencet', '06/06/1931', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (271, 'Andris', 'MacConnell', '23/07/1983', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (272, 'Hobard', 'Daud', '04/05/1959', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (273, 'Sarge', 'Haselden', '23/11/2004', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (274, 'Jarvis', 'Grimm', '29/08/2007', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (275, 'Shirline', 'Zoanetti', '21/06/2016', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (276, 'Godart', 'Dolder', '07/06/1925', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (277, 'Marcille', 'Judron', '05/10/1926', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (278, 'Analise', 'Newbigging', '11/09/1965', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (279, 'Eula', 'Risso', '07/06/1935', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (280, 'Bee', 'Croston', '10/02/1936', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (281, 'Ainslie', 'Tankus', '02/04/1929', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (282, 'Raynell', 'Hunting', '10/09/1916', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (283, 'Jenica', 'Tankus', '21/01/1949', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (284, 'Quintus', 'Stonnell', '15/06/2019', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (285, 'Madison', 'Cosh', '15/02/1989', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (286, 'Anallise', 'Adlard', '11/10/1925', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (287, 'Jasen', 'Stolte', '17/11/1977', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (288, 'Netty', 'Beaver', '16/03/1990', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (289, 'Rebecka', 'O''Corren', '04/08/1929', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (290, 'Peder', 'McGrayle', '23/12/1978', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (291, 'Brandyn', 'Jeandillou', '25/03/1909', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (292, 'Dean', 'Binnell', '25/03/1974', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (293, 'Sasha', 'McCawley', '08/10/1932', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (294, 'Bond', 'Ceney', '29/11/1929', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (295, 'Fleur', 'Sandever', '19/05/1902', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (296, 'Ollie', 'Beacham', '28/03/1908', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (297, 'Norry', 'Boule', '12/04/1931', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (298, 'Simone', 'Older', '26/03/1900', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (299, 'Mac', 'Laneham', '30/05/1943', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (300, 'Peria', 'Ecclesall', '28/01/2016', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (301, 'Angy', 'Maghull', '02/08/1929', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (302, 'Roscoe', 'Froment', '31/05/1959', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (303, 'Jeffie', 'Moulson', '19/01/1907', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (304, 'Benjy', 'Pryke', '22/12/1963', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (305, 'Dana', 'Fortesquieu', '18/11/1987', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (306, 'Eddie', 'Norewood', '26/08/1942', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (307, 'Auberon', 'Moorhead', '05/12/1975', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (308, 'Stephanie', 'Mewhirter', '07/11/1973', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (309, 'Idaline', 'Diviney', '09/05/2007', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (310, 'Butch', 'Jordin', '29/11/1984', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (311, 'Gwenny', 'Borne', '10/02/1956', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (312, 'Oliy', 'Durtnall', '24/04/1944', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (313, 'Lydia', 'Moores', '03/03/2016', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (314, 'Stanfield', 'Standbrook', '12/07/1972', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (315, 'Eloise', 'Houltham', '04/07/1906', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (316, 'Eada', 'Maybey', '24/07/1968', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (317, 'Rutter', 'Soreau', '05/05/1912', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (318, 'Tucky', 'Dando', '15/11/1971', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (319, 'Jeddy', 'Cracie', '18/12/1943', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (320, 'Mindy', 'Biddulph', '19/04/1954', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (321, 'Simone', 'Mascall', '11/07/1964', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (322, 'Hailey', 'Selwyn', '13/01/1938', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (323, 'Dulcy', 'Ruprich', '25/05/1968', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (324, 'Gabe', 'Dinsell', '08/09/1990', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (325, 'Damon', 'Ravelus', '11/05/1983', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (326, 'Dolph', 'Rembaud', '19/02/1979', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (327, 'Connie', 'Standish', '08/07/1993', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (328, 'Gates', 'Switzer', '17/07/2004', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (329, 'Leonora', 'Pala', '02/06/1940', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (330, 'Ingmar', 'Jery', '26/06/1949', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (331, 'Theressa', 'Marion', '27/08/1998', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (332, 'Amalea', 'Erbain', '07/05/1974', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (333, 'Chaddy', 'Pabelik', '12/09/1922', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (334, 'Shep', 'Burdell', '08/09/1947', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (335, 'Mandi', 'Giannassi', '27/09/1990', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (336, 'Audra', 'Cunrado', '09/09/1984', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (337, 'Christian', 'Sheridan', '23/07/1909', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (338, 'Rosaline', 'Puttan', '21/05/2010', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (339, 'Pollyanna', 'Kordovani', '02/12/1931', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (340, 'Ase', 'Iacovuzzi', '20/07/1997', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (341, 'Jens', 'Mogg', '22/12/1998', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (342, 'Jany', 'Harraway', '30/03/1987', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (343, 'Kristopher', 'Francescotti', '18/07/1911', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (344, 'Gregor', 'Gresswell', '01/01/1984', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (345, 'Hermann', 'Huertas', '05/08/1996', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (346, 'Oswell', 'Birkby', '27/04/1972', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (347, 'Husein', 'Bohlens', '21/06/2004', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (348, 'Ricardo', 'Giovannelli', '13/07/1913', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (349, 'Vivyan', 'Jacks', '21/10/1992', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (350, 'Ranee', 'Baulcombe', '10/05/2008', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (351, 'Herta', 'Altimas', '22/08/1908', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (352, 'Ramsay', 'Gard', '03/11/1912', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (353, 'Cullan', 'Fust', '17/03/2015', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (354, 'Liane', 'Bathersby', '23/09/2022', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (355, 'Dukie', 'Bernardini', '10/04/1945', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (356, 'Nefen', 'Dobey', '18/04/1999', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (357, 'Pieter', 'Kilday', '10/10/1999', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (358, 'Anthony', 'Kenningham', '13/12/1979', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (359, 'Devinne', 'Croal', '25/10/1957', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (360, 'Juditha', 'Jahner', '05/07/1931', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (361, 'Aubert', 'Rosten', '05/04/1940', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (362, 'Massimiliano', 'Bennie', '17/04/2004', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (363, 'Cathe', 'Hanington', '07/02/1900', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (364, 'Gerri', 'Probey', '27/06/2007', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (365, 'Karole', 'Dungay', '25/11/1991', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (366, 'Vinson', 'Nyssens', '23/03/1934', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (367, 'Fonsie', 'Ranaghan', '26/05/2009', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (368, 'Gauthier', 'Gresswell', '28/10/1941', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (369, 'Coriss', 'Devaney', '02/11/1936', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (370, 'Dayle', 'Pawling', '22/07/2002', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (371, 'Beverie', 'Jadczak', '21/09/1925', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (372, 'Shirlene', 'Etoile', '05/12/1963', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (373, 'Illa', 'Kitchingman', '09/12/1937', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (374, 'Catha', 'Pennrington', '21/02/2013', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (375, 'Herby', 'De Gregorio', '28/06/1909', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (376, 'Mala', 'Dietz', '14/06/1961', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (377, 'Larissa', 'Alpe', '27/09/1912', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (378, 'Leone', 'Kisar', '21/08/1937', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (379, 'Cordula', 'Fairfoull', '01/04/1937', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (380, 'Colas', 'Stillmann', '18/03/1904', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (381, 'Jazmin', 'Jury', '21/01/1971', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (382, 'Lorenzo', 'Searby', '06/01/1910', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (383, 'Olly', 'Turpey', '28/03/1948', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (384, 'Kaye', 'Cestard', '20/11/1917', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (385, 'Elnore', 'Redpath', '24/12/1926', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (386, 'Shaun', 'Annandale', '12/01/1936', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (387, 'Elka', 'Rosenboim', '05/12/1973', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (388, 'Ray', 'O'' Flaherty', '03/02/1955', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (389, 'Natalya', 'Parades', '20/08/1904', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (390, 'Claudell', 'Mc Cahey', '26/05/1976', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (391, 'Kristian', 'Lant', '27/01/1971', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (392, 'Lanette', 'Santoro', '19/06/1922', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (393, 'Granny', 'Opfer', '25/11/1976', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (394, 'Frederigo', 'Limerick', '12/03/1947', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (395, 'Jackson', 'Witsey', '19/05/1950', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (396, 'Rutherford', 'Mary', '18/04/2005', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (397, 'Chickie', 'Merrell', '22/12/1938', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (398, 'Welsh', 'Byforth', '04/08/1978', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (399, 'Dukie', 'Bannell', '26/05/1959', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (400, 'Antoinette', 'Lazell', '05/10/2004', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (401, 'Viviana', 'Adair', '12/10/2013', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (402, 'Hill', 'Acutt', '06/08/1970', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (403, 'Shelbi', 'Mariault', '19/10/1925', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (404, 'Bette', 'Garvie', '26/04/1947', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (405, 'Graeme', 'Andres', '06/12/1951', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (406, 'Sue', 'Rizzolo', '09/10/1981', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (407, 'Parry', 'Jeakins', '21/12/2021', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (408, 'Farrell', 'Cecchetelli', '19/07/1923', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (409, 'Pollyanna', 'Ianitti', '14/11/2010', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (410, 'Brig', 'Argabrite', '18/09/1928', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (411, 'Catriona', 'Salt', '18/08/1984', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (412, 'Melisse', 'Castagne', '06/03/1905', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (413, 'Coleen', 'Clementucci', '28/07/1950', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (414, 'Sybille', 'Wheaton', '09/08/1911', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (415, 'Ursa', 'Daynter', '07/05/1940', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (416, 'Sebastiano', 'Beacon', '04/01/1982', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (417, 'Eberhard', 'Mc Meekin', '10/12/1927', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (418, 'Law', 'Matuszynski', '13/07/1998', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (419, 'Jeanne', 'Forcer', '19/09/1961', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (420, 'Tammy', 'Bingell', '25/08/1940', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (421, 'Maurita', 'Shuard', '08/10/1916', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (422, 'Norby', 'Schulke', '24/05/1901', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (423, 'Ky', 'Haithwaite', '20/11/1971', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (424, 'Brendon', 'Mayberry', '20/01/1974', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (425, 'Kip', 'Elfitt', '15/09/1971', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (426, 'Myles', 'Lammert', '29/11/1971', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (427, 'Evyn', 'Pettyfar', '20/05/1988', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (428, 'Mirabel', 'Rief', '03/10/1909', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (429, 'Zilvia', 'Biggs', '13/07/1950', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (430, 'Benedicta', 'Cleaton', '15/02/1939', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (431, 'Jennie', 'Cherm', '13/09/1929', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (432, 'Manny', 'Chaffer', '18/03/1978', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (433, 'Olympe', 'Santer', '15/06/2013', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (434, 'Sadye', 'Rodbourne', '15/02/1933', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (435, 'Claudian', 'Lyver', '02/07/2012', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (436, 'Iosep', 'Mechem', '22/04/1969', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (437, 'Shannan', 'Tarplee', '29/11/1933', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (438, 'Diahann', 'Danbi', '21/05/1927', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (439, 'Casper', 'Meaker', '21/04/2009', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (440, 'Farlay', 'Danis', '10/07/1952', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (441, 'Michelle', 'Armistead', '23/02/1986', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (442, 'Meaghan', 'Prettyman', '13/03/1907', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (443, 'Carrie', 'Baglow', '02/09/2011', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (444, 'Cinnamon', 'Giacomuzzi', '22/05/1919', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (445, 'Laura', 'Rizzardini', '30/06/2011', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (446, 'Zahara', 'McFater', '31/07/1925', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (447, 'Kylen', 'Slatford', '20/01/1912', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (448, 'Barnett', 'Hillett', '02/05/1980', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (449, 'Devinne', 'Pettipher', '22/06/1963', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (450, 'Bianca', 'Kubanek', '01/07/1915', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (451, 'Ruddie', 'Wanless', '11/11/1998', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (452, 'Efrem', 'Quemby', '29/04/2021', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (453, 'Sharline', 'Maass', '28/02/1926', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (454, 'Alfredo', 'Aizic', '31/05/1979', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (455, 'Had', 'Renad', '06/09/1991', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (456, 'Caron', 'Kesteven', '09/08/1903', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (457, 'Daniela', 'Brilon', '31/12/1997', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (458, 'Pincas', 'Probyn', '01/01/1915', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (459, 'Granthem', 'Lusk', '27/05/1915', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (460, 'Ardine', 'Bicksteth', '16/07/1953', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (461, 'Caprice', 'Wasiela', '27/09/1914', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (462, 'Fey', 'Whelpton', '09/10/1937', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (463, 'Clemmie', 'Camillo', '20/07/2012', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (464, 'Karita', 'Hurlston', '16/11/2007', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (465, 'Lacee', 'O'' Timony', '06/08/1947', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (466, 'Leonora', 'Burberye', '06/11/1916', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (467, 'Murdock', 'Isherwood', '29/08/2022', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (468, 'Delaney', 'Sawyers', '20/10/1966', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (469, 'Claudine', 'Conyer', '17/02/1920', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (470, 'Lucia', 'Kinforth', '09/03/2007', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (471, 'Arlan', 'Frie', '20/02/1982', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (472, 'Wilden', 'Morritt', '15/06/2015', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (473, 'Kynthia', 'Blanshard', '21/04/1932', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (474, 'Cobby', 'Varey', '13/09/1925', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (475, 'Randa', 'Dixie', '18/02/1912', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (476, 'Marylou', 'Brewins', '13/07/2021', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (477, 'Viki', 'Blackie', '10/07/1977', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (478, 'Beltran', 'Wallington', '08/02/1979', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (479, 'Erik', 'Downgate', '20/12/1981', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (480, 'Teirtza', 'Sharplin', '14/07/1959', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (481, 'Garald', 'Lipmann', '21/01/1941', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (482, 'Annetta', 'Bridgewater', '17/01/1995', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (483, 'Waylon', 'MacGorrie', '23/06/1941', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (484, 'Rene', 'Hawley', '27/01/1956', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (485, 'Anitra', 'Checchi', '12/02/1931', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (486, 'Amandie', 'Ridout', '22/02/1922', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (487, 'Quinlan', 'McAdam', '05/05/1909', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (488, 'Emily', 'Brastead', '15/01/1941', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (489, 'Filberto', 'Tunsley', '05/11/1996', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (490, 'Drucill', 'Antyshev', '30/07/1985', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (491, 'Leshia', 'Gutridge', '23/05/1913', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (492, 'Dale', 'Eastway', '17/07/1974', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (493, 'Leora', 'Spelman', '22/01/1953', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (494, 'Stefa', 'Bilsborrow', '20/07/1922', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (495, 'Elita', 'Bogays', '04/09/1925', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (496, 'Verne', 'Rait', '04/03/1955', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (497, 'Gordie', 'Trotter', '11/04/1902', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (498, 'Melody', 'Bowditch', '05/06/1902', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (499, 'Lianna', 'O''Sirin', '17/07/2000', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (500, 'Taite', 'Wimms', '18/05/1980', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (501, 'Merralee', 'Grievson', '02/12/1963', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (502, 'Mattie', 'Lines', '01/05/1948', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (503, 'Wes', 'Olrenshaw', '09/02/1934', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (504, 'Alameda', 'MacRanald', '11/05/1976', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (505, 'Erminie', 'Bryde', '20/07/1955', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (506, 'Bryan', 'Randell', '31/03/1905', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (507, 'Markus', 'Tremblett', '29/04/1951', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (508, 'Judah', 'Tremoulet', '13/08/1925', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (509, 'Jacinta', 'Cardillo', '27/07/1968', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (510, 'Cordie', 'Gaiford', '25/11/1917', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (511, 'Dana', 'McGlade', '31/07/1993', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (512, 'Valle', 'Figger', '03/01/1919', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (513, 'Tasia', 'Blogg', '28/01/1908', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (514, 'Alanah', 'Sowthcote', '08/05/2007', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (515, 'Ludovika', 'Mawson', '23/03/1960', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (516, 'Sophronia', 'Gainsborough', '27/10/1943', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (517, 'Zolly', 'Wakeley', '06/02/1929', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (518, 'Roseanne', 'Vannozzii', '02/09/1912', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (519, 'Faber', 'Sesser', '26/08/1914', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (520, 'Case', 'Inglesent', '24/04/1910', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (521, 'Kean', 'Daborn', '15/04/1952', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (522, 'Netty', 'Weber', '12/11/2002', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (523, 'Moss', 'Shackleton', '12/03/1996', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (524, 'Perry', 'Tolman', '20/08/1938', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (525, 'Manuel', 'Rosekilly', '15/03/1920', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (526, 'Allsun', 'McCoughan', '02/10/2017', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (527, 'Romona', 'Jennison', '28/05/1922', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (528, 'Kirbee', 'Iiannone', '12/02/1954', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (529, 'Sandor', 'Message', '27/12/2012', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (530, 'Lou', 'Sang', '19/08/1929', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (531, 'Flo', 'Restall', '14/07/1902', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (532, 'Jesse', 'Volke', '16/08/1913', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (533, 'Roobbie', 'Haitlie', '04/11/2017', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (534, 'Aveline', 'Totterdell', '20/11/1955', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (535, 'Belvia', 'Bartali', '01/03/1936', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (536, 'Jeremie', 'Neward', '28/12/2021', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (537, 'Niki', 'Lavall', '24/09/1936', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (538, 'Hayden', 'Peat', '11/03/1929', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (539, 'Nancey', 'Firks', '06/06/1972', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (540, 'Shaun', 'Coopper', '03/08/2003', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (541, 'Dacy', 'Mulchrone', '25/06/1962', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (542, 'Sallie', 'De Cristofalo', '20/02/2018', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (543, 'Alain', 'Bescoby', '13/10/1973', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (544, 'Alley', 'Murford', '09/01/1955', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (545, 'Sherri', 'Jeffs', '15/11/2017', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (546, 'Candis', 'Mohamed', '15/02/1931', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (547, 'Deva', 'Colthurst', '03/10/2005', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (548, 'Friederike', 'Aireton', '21/01/1942', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (549, 'Haleigh', 'Aidler', '13/12/1972', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (550, 'Neron', 'Sleford', '24/11/2018', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (551, 'Brit', 'Bessom', '08/07/1923', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (552, 'Cathyleen', 'Moncreiff', '01/08/1983', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (553, 'Hector', 'Rogan', '06/12/1946', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (554, 'Lindy', 'Snawdon', '31/03/1958', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (555, 'Kain', 'Addison', '23/12/2016', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (556, 'Rheba', 'Readett', '18/11/2006', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (557, 'Tyrus', 'Osburn', '31/12/2014', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (558, 'Charin', 'Gage', '07/09/1938', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (559, 'Stephen', 'Ludlow', '04/10/1905', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (560, 'Issie', 'Mallam', '26/05/1931', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (561, 'Edin', 'Mulkerrins', '08/08/1902', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (562, 'Kerr', 'Serraillier', '10/11/2001', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (563, 'Lillian', 'Maudlen', '24/11/1902', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (564, 'Vlad', 'Steadman', '08/02/1984', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (565, 'Frederik', 'Linger', '08/05/1912', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (566, 'Abagail', 'Clayborn', '12/06/1960', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (567, 'Dede', 'Edgerly', '26/09/1996', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (568, 'Keith', 'Blaney', '07/11/1968', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (569, 'Jim', 'Royds', '05/10/1944', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (570, 'Sigrid', 'Bourget', '24/02/2009', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (571, 'Krystalle', 'Coppenhall', '28/09/1941', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (572, 'Merrielle', 'Beales', '11/06/2017', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (573, 'Joana', 'Gelsthorpe', '26/06/1998', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (574, 'Mable', 'Monketon', '21/10/1978', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (575, 'Verge', 'Piser', '12/11/2015', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (576, 'Morley', 'Luna', '15/08/1987', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (577, 'Denys', 'Hinckesman', '29/11/2012', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (578, 'Luise', 'Ough', '07/09/1921', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (579, 'Zeb', 'O''Heyne', '18/08/1906', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (580, 'Franz', 'Suggitt', '20/04/2022', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (581, 'Noby', 'Speirs', '12/03/1966', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (582, 'Tersina', 'Blenkiron', '02/02/1919', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (583, 'Candra', 'Haynesford', '22/02/1931', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (584, 'Angel', 'Loving', '28/01/1924', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (585, 'Loretta', 'Rowe', '14/03/2002', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (586, 'Lexine', 'Tailby', '07/01/1979', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (587, 'Melesa', 'Coonihan', '04/04/1937', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (588, 'Ulick', 'Shingles', '12/02/1985', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (589, 'Emlynn', 'Reaman', '02/08/1958', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (590, 'Faber', 'Avrahamov', '10/06/1903', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (591, 'Eulalie', 'Peplaw', '25/11/1970', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (592, 'Marla', 'Lauchlan', '05/01/1980', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (593, 'Rube', 'Twentyman', '05/03/1928', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (594, 'Gavan', 'Pocknell', '31/05/1926', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (595, 'Ezra', 'Evenden', '15/06/1912', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (596, 'Stirling', 'Ormerod', '02/03/2003', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (597, 'Julina', 'Wolford', '08/11/1916', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (598, 'Andres', 'Gutridge', '31/08/1998', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (599, 'Carma', 'Jagiello', '13/07/1940', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (600, 'Willette', 'Stancliffe', '14/09/1914', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (601, 'Carina', 'Theze', '30/11/1999', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (602, 'Paulette', 'MacGow', '26/12/2011', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (603, 'Jordon', 'Finby', '24/09/2000', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (604, 'Shara', 'Gramer', '16/10/1992', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (605, 'Burton', 'Keane', '17/05/1975', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (606, 'Carleen', 'Cheasman', '25/10/1988', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (607, 'Brittaney', 'Fordyce', '12/04/1956', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (608, 'Torey', 'Kidner', '02/01/1956', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (609, 'Meggy', 'Kingsman', '10/04/1959', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (610, 'Miranda', 'Bautiste', '27/10/1917', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (611, 'Clementia', 'Marryatt', '07/06/2005', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (612, 'Aloisia', 'Mandrake', '18/08/1923', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (613, 'Corby', 'Manville', '13/12/2011', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (614, 'Casi', 'Sapshed', '26/12/1962', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (615, 'Findley', 'Benka', '16/09/1922', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (616, 'Val', 'Tellett', '27/07/1953', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (617, 'Ado', 'Scadding', '07/02/1979', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (618, 'Lannie', 'Bayston', '27/07/2017', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (619, 'Karry', 'MacLeod', '22/06/1946', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (620, 'Jodie', 'Union', '03/11/1912', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (621, 'Caren', 'Bruckner', '09/12/1974', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (622, 'Dre', 'Matyukon', '20/01/1997', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (623, 'Penrod', 'Verheyden', '17/12/1961', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (624, 'Juli', 'Scranedge', '20/12/1976', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (625, 'Auberta', 'Bach', '07/10/1968', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (626, 'Minne', 'Brigg', '23/10/1923', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (627, 'Cele', 'Cristofol', '08/11/1909', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (628, 'Cesar', 'Curd', '25/11/1951', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (629, 'Lou', 'Wilkennson', '10/05/1933', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (630, 'Harlin', 'Barthrop', '11/02/1905', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (631, 'Kippy', 'Fonquernie', '28/01/1948', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (632, 'Anderea', 'Itzakson', '29/11/1970', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (633, 'Kylie', 'Bernakiewicz', '27/10/1975', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (634, 'Florida', 'Spellissy', '06/09/1983', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (635, 'Kym', 'Swayton', '10/02/1961', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (636, 'Urban', 'Robertis', '18/08/1956', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (637, 'Charlena', 'Evett', '20/04/2005', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (638, 'Myrtice', 'Gilroy', '06/05/1921', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (639, 'Micah', 'Aberkirdo', '26/07/1955', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (640, 'Hale', 'Lawdham', '19/05/2018', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (641, 'Nicoli', 'Tooting', '06/05/1961', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (642, 'Binky', 'Mathiot', '04/09/1970', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (643, 'Michele', 'Gettins', '09/04/2012', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (644, 'Estrellita', 'Billingsly', '17/05/1932', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (645, 'Amelia', 'Tanner', '05/08/1910', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (646, 'Elena', 'Somner', '26/11/1993', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (647, 'Monika', 'Newcomb', '19/09/2017', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (648, 'Cathyleen', 'McCormack', '16/02/1984', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (649, 'Charlean', 'Wiggam', '17/09/1976', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (650, 'Chester', 'Svanetti', '21/04/1987', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (651, 'Toddie', 'Trubshawe', '30/06/1930', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (652, 'Erika', 'Malyon', '14/09/2016', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (653, 'Mariejeanne', 'Ninnotti', '09/05/1950', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (654, 'Frieda', 'Duesberry', '10/01/2020', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (655, 'Dona', 'Hillatt', '11/06/2013', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (656, 'Keslie', 'Losselyong', '24/09/2017', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (657, 'Edee', 'Legan', '02/04/1995', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (658, 'Aurora', 'Hanscombe', '20/08/1938', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (659, 'Rochester', 'Bliben', '01/05/2005', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (660, 'Constantia', 'Tredwell', '15/10/1953', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (661, 'Charil', 'Kewish', '31/01/1977', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (662, 'Madonna', 'Dusting', '16/08/1942', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (663, 'Zane', 'Cossum', '26/01/1966', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (664, 'Lukas', 'Skypp', '20/02/1956', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (665, 'Daphna', 'Rosenwald', '17/07/2018', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (666, 'Patsy', 'Derill', '04/06/2016', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (667, 'Nesta', 'Pantone', '22/06/1958', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (668, 'Gabbie', 'Riedel', '05/12/1993', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (669, 'Charlton', 'Iwanicki', '23/01/1997', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (670, 'Bennett', 'O''Shavlan', '14/06/1975', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (671, 'Kingsley', 'Skeffington', '16/07/1919', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (672, 'Donny', 'D''Emanuele', '08/06/1951', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (673, 'Reamonn', 'Corsor', '04/10/1976', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (674, 'Madison', 'Pauleau', '11/07/1922', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (675, 'Sallee', 'Kernar', '15/01/1910', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (676, 'Evered', 'Fishley', '28/02/1932', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (677, 'Vance', 'Shawl', '04/07/1918', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (678, 'Gaynor', 'Sagg', '11/12/1983', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (679, 'Jeff', 'Strutt', '15/03/1902', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (680, 'Eugenio', 'Rubke', '25/01/1927', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (681, 'Cornie', 'Peter', '21/01/2010', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (682, 'Rolph', 'Parlor', '15/04/1916', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (683, 'Randee', 'Bussetti', '10/08/1953', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (684, 'Rodney', 'Curtayne', '24/02/1906', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (685, 'Edgar', 'Kryszkiecicz', '19/01/1987', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (686, 'Rosene', 'Carluccio', '09/11/1966', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (687, 'Izak', 'Caslett', '08/03/1925', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (688, 'Lorelle', 'Penni', '13/04/1902', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (689, 'Fernanda', 'Lathaye', '30/07/1928', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (690, 'Athene', 'Lichfield', '19/10/1954', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (691, 'Frannie', 'Chillingsworth', '02/11/1926', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (692, 'Ryann', 'Jelkes', '07/11/1914', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (693, 'Bryanty', 'Hame', '16/02/1966', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (694, 'Noreen', 'Todarini', '30/06/2014', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (695, 'Wang', 'Lewry', '21/05/1965', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (696, 'Minette', 'Angelini', '24/11/1982', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (697, 'Dennie', 'Messier', '03/08/1907', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (698, 'Jemimah', 'Merkel', '19/05/1962', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (699, 'Kimberly', 'Knee', '28/07/1978', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (700, 'Meyer', 'Bullocke', '09/09/1915', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (701, 'Fitzgerald', 'Steutly', '23/12/2022', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (702, 'Zarla', 'Brogan', '15/03/1943', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (703, 'Tybi', 'Darco', '26/10/1946', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (704, 'Sidney', 'Iacovacci', '17/09/1916', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (705, 'Andreas', 'Perelli', '13/11/1981', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (706, 'Morgen', 'Soughton', '13/04/2012', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (707, 'Benedetta', 'Alenichicov', '28/02/1923', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (708, 'Mandy', 'O''Lehane', '03/08/1924', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (709, 'Alys', 'Membry', '21/10/2017', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (710, 'Kimberli', 'Beaument', '16/03/1967', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (711, 'Rupert', 'Creigan', '19/03/2012', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (712, 'Maighdiln', 'Belle', '31/05/1975', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (713, 'Deanne', 'Barthod', '29/05/2020', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (714, 'Andriana', 'Thorold', '20/03/1916', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (715, 'Harald', 'Botley', '24/06/1906', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (716, 'Redford', 'Ladds', '17/10/1999', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (717, 'Pietrek', 'Acutt', '01/07/1975', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (718, 'Gustavus', 'Robarts', '12/10/2018', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (719, 'Edythe', 'Memory', '15/12/1991', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (720, 'Mariam', 'Livings', '24/08/1979', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (721, 'Rosabel', 'Truter', '29/09/1916', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (722, 'Cris', 'Edyson', '02/02/1992', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (723, 'Hannah', 'Janicek', '23/02/1958', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (724, 'Fabio', 'Anthon', '15/08/2020', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (725, 'Finn', 'Fishly', '01/01/1955', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (726, 'Shane', 'Ruperti', '07/02/1901', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (727, 'Albert', 'Antyshev', '30/05/2007', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (728, 'Kira', 'Chalkly', '21/09/2012', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (729, 'Therine', 'Kersting', '06/07/1933', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (730, 'Mathias', 'Trinbey', '16/03/1910', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (731, 'Rasla', 'Gerger', '31/12/1933', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (732, 'Rodie', 'Batey', '06/06/1934', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (733, 'Hurley', 'Grishakin', '18/10/1965', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (734, 'Abby', 'Druett', '01/01/2010', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (735, 'Codie', 'Wolfit', '19/01/1963', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (736, 'Danni', 'Danforth', '20/08/1954', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (737, 'Theadora', 'Glide', '01/04/1977', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (738, 'Emmey', 'Lynskey', '14/06/1930', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (739, 'Merrilee', 'Piesing', '31/10/2019', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (740, 'Garvey', 'Lody', '15/03/1966', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (741, 'Leena', 'Iacomi', '07/02/1909', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (742, 'Shari', 'Caddan', '19/10/1976', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (743, 'Calida', 'Guitonneau', '19/07/1915', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (744, 'Madelle', 'Aspling', '14/04/1970', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (745, 'Elmo', 'Fosserd', '16/01/1949', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (746, 'Vivianna', 'Yven', '27/06/1981', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (747, 'Quillan', 'Ruffles', '19/10/1988', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (748, 'Terrence', 'Keener', '30/12/1963', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (749, 'Hans', 'Munro', '03/04/1944', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (750, 'Earl', 'Bilbrook', '06/05/1950', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (751, 'Sargent', 'Chessel', '22/09/1994', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (752, 'Lissi', 'Seale', '06/04/1900', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (753, 'Cordelia', 'Steane', '24/03/1927', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (754, 'Juline', 'Morgan', '12/08/1944', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (755, 'Gunter', 'Ivachyov', '11/10/1966', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (756, 'Filberto', 'Beazley', '20/09/1924', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (757, 'Lynnette', 'Tomaszkiewicz', '01/02/1952', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (758, 'Sheila', 'MacEveley', '26/04/1963', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (759, 'Abbot', 'Mahaddy', '27/01/1965', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (760, 'Abbey', 'Chinnick', '17/03/1952', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (761, 'Serge', 'Creavan', '02/03/1999', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (762, 'Rurik', 'McKeevers', '30/07/1912', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (763, 'Selestina', 'Huntington', '10/08/2021', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (764, 'Ted', 'Kellaway', '27/09/1932', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (765, 'Josias', 'Edelston', '22/11/1934', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (766, 'Noami', 'Scarborough', '26/06/1972', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (767, 'Reilly', 'Rowden', '11/01/1931', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (768, 'Port', 'Milesap', '15/01/1902', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (769, 'Larisa', 'Durrett', '22/04/1999', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (770, 'Kimberley', 'Anstis', '23/07/1973', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (771, 'Erskine', 'Adanet', '20/02/1920', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (772, 'Rosette', 'Brobyn', '18/04/1960', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (773, 'Halette', 'Gidley', '10/03/1945', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (774, 'Ninette', 'Coryndon', '19/01/1970', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (775, 'Hoebart', 'Glanz', '30/12/1961', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (776, 'Efren', 'Kittley', '06/10/1906', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (777, 'Angie', 'Eberlein', '02/03/1900', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (778, 'Marice', 'Witchalls', '17/11/2020', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (779, 'Aldin', 'Wimsett', '14/11/1952', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (780, 'Jeniece', 'Crean', '17/07/1969', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (781, 'Rosaline', 'Marzello', '14/04/2003', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (782, 'Yoshiko', 'Ledgeway', '05/05/2007', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (783, 'Zita', 'Folkerts', '15/01/1961', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (784, 'Bastien', 'Colicot', '18/01/1957', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (785, 'Tucky', 'Shambrook', '17/02/2008', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (786, 'Kameko', 'Urling', '08/11/1991', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (787, 'Audry', 'Extil', '12/05/1995', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (788, 'Bradney', 'McQuillen', '27/11/1916', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (789, 'Yorgo', 'Vasquez', '30/01/1942', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (790, 'Vite', 'Beazleigh', '28/09/1963', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (791, 'Harlin', 'Faux', '20/11/2006', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (792, 'Hunfredo', 'St. Quintin', '16/01/1956', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (793, 'Deanne', 'Harrowing', '11/05/1913', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (794, 'Barbette', 'Capelow', '23/11/1969', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (795, 'Diana', 'Fysh', '06/08/1980', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (796, 'Idaline', 'Walshaw', '23/11/1909', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (797, 'Tamara', 'Longford', '31/03/2021', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (798, 'Nessa', 'Laughlin', '24/05/1949', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (799, 'Emanuele', 'Hankey', '16/12/2001', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (800, 'Fiann', 'Handasyde', '18/06/1973', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (801, 'Nataline', 'Wahncke', '28/06/1910', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (802, 'Celie', 'Gellert', '23/05/1905', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (803, 'Brennan', 'Madner', '14/04/1956', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (804, 'Nicol', 'Kirsch', '03/02/1976', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (805, 'Dinnie', 'Kolinsky', '15/01/1928', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (806, 'Brandi', 'Poure', '16/07/2019', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (807, 'Beatriz', 'Zanre', '22/08/1974', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (808, 'Eustacia', 'Aldersea', '05/05/1964', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (809, 'Ruby', 'Antonelli', '16/09/1911', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (810, 'Suellen', 'Bodd', '23/09/1969', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (811, 'Hilary', 'Rigmond', '01/09/1943', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (812, 'Hermann', 'Clifford', '07/10/1981', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (813, 'Agnes', 'Martinovsky', '03/11/1956', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (814, 'Lisette', 'Muxworthy', '12/06/1951', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (815, 'Corbet', 'Micklewright', '02/04/1926', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (816, 'Beverly', 'Twidale', '04/08/1930', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (817, 'Griz', 'Manntschke', '03/05/1991', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (818, 'Jennica', 'Humbey', '04/05/1975', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (819, 'Fanchette', 'Van der Spohr', '29/03/1936', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (820, 'Moritz', 'Jenne', '13/03/1913', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (821, 'Koralle', 'Bollins', '13/05/1948', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (822, 'Elbertine', 'FitzGibbon', '19/08/1971', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (823, 'Hadley', 'Sibbson', '22/12/1959', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (824, 'Gamaliel', 'Devonside', '19/04/1962', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (825, 'Ermina', 'Breckwell', '03/11/1933', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (826, 'Hamil', 'Oosthout de Vree', '27/06/1911', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (827, 'Roddie', 'Boustead', '12/11/1974', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (828, 'Huntlee', 'Humberstone', '08/05/1906', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (829, 'Elwyn', 'Cambden', '10/09/1901', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (830, 'Austin', 'Moberley', '06/04/1904', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (831, 'Tallulah', 'Chessman', '27/10/1955', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (832, 'Delainey', 'Harding', '10/12/1913', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (833, 'Karina', 'MacGuigan', '18/07/1950', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (834, 'Isidoro', 'Douce', '11/04/1926', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (835, 'Annamarie', 'Dragoe', '04/05/1903', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (836, 'Juana', 'Gribbell', '13/01/1901', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (837, 'Belinda', 'Pickring', '06/06/2013', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (838, 'Cathee', 'Kenneford', '11/10/1967', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (839, 'Regine', 'Sheehan', '08/10/1939', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (840, 'Gale', 'Tippetts', '16/03/1996', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (841, 'Brnaba', 'Sparshett', '30/10/2007', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (842, 'Wyatt', 'Loadsman', '09/09/1966', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (843, 'Isak', 'Fonte', '03/03/1925', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (844, 'Ketti', 'Raggles', '02/11/1904', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (845, 'Michal', 'Challender', '18/02/1910', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (846, 'Jorry', 'Domnick', '31/01/1978', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (847, 'Valentine', 'Albert', '03/04/1907', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (848, 'Ambrosius', 'O'' Hogan', '06/12/1973', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (849, 'Angelita', 'Stampe', '07/03/1903', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (850, 'Rosalie', 'Joiner', '03/06/2000', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (851, 'Godfrey', 'Bedrosian', '05/03/1979', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (852, 'Bernadene', 'Britnell', '20/09/1929', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (853, 'Olivero', 'Ibbison', '02/02/1986', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (854, 'Marietta', 'Yetman', '10/12/1986', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (855, 'Pauly', 'Priscott', '19/08/1943', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (856, 'De witt', 'Kleint', '22/02/1924', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (857, 'Thalia', 'Ionnisian', '16/06/1995', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (858, 'Eolande', 'Mailes', '07/11/1996', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (859, 'Paula', 'Shenfisch', '27/12/1986', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (860, 'Lyndsey', 'Vanshin', '16/01/1949', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (861, 'Gabbey', 'Bannester', '13/06/2014', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (862, 'Krystle', 'Le Franc', '30/09/1925', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (863, 'Marian', 'McReidy', '28/06/1904', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (864, 'Debi', 'Farreil', '18/01/1928', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (865, 'Yetty', 'Cumberbatch', '13/07/1978', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (866, 'Amalle', 'Tour', '27/11/1971', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (867, 'Chico', 'Kleeman', '05/11/1978', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (868, 'Kerstin', 'Axleby', '29/03/1903', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (869, 'Aloin', 'Casburn', '03/11/1939', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (870, 'Silvia', 'Sire', '19/11/1923', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (871, 'Brynn', 'Uccello', '11/12/1995', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (872, 'Lynde', 'Larret', '16/06/2010', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (873, 'Granville', 'Stirland', '06/02/1986', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (874, 'Linzy', 'Crombie', '11/10/2003', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (875, 'Rhodie', 'Dabling', '07/05/2009', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (876, 'Barret', 'Redhole', '17/09/1922', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (877, 'Filippo', 'Eldon', '27/09/1934', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (878, 'Vere', 'Lamswood', '23/10/1957', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (879, 'Diego', 'Petyt', '27/08/1960', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (880, 'Iris', 'Amberger', '04/07/1968', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (881, 'Honey', 'Passey', '15/03/1975', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (882, 'Arvie', 'Meeking', '16/06/1931', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (883, 'Milli', 'Kleisel', '13/01/1971', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (884, 'Annabell', 'Cofax', '27/01/1974', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (885, 'Elliott', 'Harken', '05/03/1953', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (886, 'Valle', 'Wyatt', '03/02/1931', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (887, 'Franklin', 'Fever', '13/03/1970', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (888, 'Newton', 'Petticrew', '04/07/1977', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (889, 'Jerrilee', 'Sullly', '30/01/1944', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (890, 'Mikol', 'Brotherhood', '18/05/1920', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (891, 'Ansell', 'Cazin', '15/10/1964', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (892, 'Carolan', 'Loges', '23/01/1960', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (893, 'Filberto', 'Cuesta', '12/01/1924', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (894, 'Thibaut', 'Derrington', '31/03/1908', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (895, 'Sherwood', 'Prayer', '29/04/1991', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (896, 'Marcelia', 'Pentecost', '08/11/1963', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (897, 'Helene', 'Syddon', '24/09/2004', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (898, 'Adolphus', 'Block', '26/03/1906', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (899, 'Tristan', 'Drohane', '07/08/1953', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (900, 'Ainslee', 'Ivell', '26/02/1962', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (901, 'Pammi', 'Luc', '06/01/2009', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (902, 'Tadd', 'Stairs', '13/08/1998', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (903, 'Normand', 'Mullen', '18/08/1918', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (904, 'Errol', 'Dampier', '29/07/2022', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (905, 'Worthington', 'Autrie', '19/08/1904', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (906, 'George', 'Mayho', '13/07/1924', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (907, 'Daron', 'Fowlie', '19/09/1932', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (908, 'Coral', 'Ertel', '11/01/1901', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (909, 'Noemi', 'McLaverty', '13/06/1922', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (910, 'Adrien', 'Pedroni', '23/05/1949', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (911, 'Petra', 'Foale', '20/04/2015', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (912, 'Sibylla', 'Muslim', '07/10/1960', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (913, 'Arnuad', 'Cabble', '25/12/1986', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (914, 'Ruby', 'Chewter', '09/10/1954', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (915, 'Deeanne', 'Stubbs', '06/11/2018', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (916, 'Frasier', 'Griswood', '09/12/1977', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (917, 'Babita', 'Dolby', '23/03/1939', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (918, 'Guillermo', 'Colly', '19/07/2003', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (919, 'Doralynne', 'Whitty', '18/05/1961', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (920, 'Benedetto', 'Chalfain', '18/02/1962', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (921, 'Ginni', 'McMeekan', '23/08/1996', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (922, 'Raynell', 'Locke', '12/11/1942', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (923, 'Giraldo', 'Lutman', '09/07/1978', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (924, 'Wally', 'Jerdein', '31/07/1975', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (925, 'Lishe', 'Glenfield', '27/03/1954', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (926, 'Ade', 'Willerton', '06/09/1927', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (927, 'Fania', 'Dinsale', '24/09/2000', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (928, 'Hamlen', 'Livett', '10/10/2020', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (929, 'Corene', 'Youll', '29/04/1967', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (930, 'Dory', 'Guitel', '23/04/1913', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (931, 'Shaun', 'Oldcroft', '16/09/1952', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (932, 'Sadie', 'Isenor', '05/11/1983', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (933, 'Lorrayne', 'Lefeaver', '06/12/1930', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (934, 'Sonya', 'Snellman', '07/04/1948', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (935, 'Gilberte', 'Keoghan', '27/09/1923', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (936, 'Dorolice', 'Beals', '06/11/1951', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (937, 'Jeremy', 'Tiffany', '29/03/1977', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (938, 'Der', 'Allanson', '02/02/2012', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (939, 'Tiphani', 'Lovat', '17/10/2017', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (940, 'Pauline', 'Pettendrich', '19/01/1903', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (941, 'Gertie', 'Ramage', '08/06/1918', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (942, 'Gun', 'Ourtic', '08/01/1993', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (943, 'Hoyt', 'Chipperfield', '27/01/1929', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (944, 'Marley', 'Artindale', '08/10/1967', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (945, 'Reba', 'Flaune', '28/01/2018', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (946, 'Chico', 'Coonihan', '04/12/1949', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (947, 'Aime', 'Weerdenburg', '23/02/2014', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (948, 'Devin', 'Noice', '17/09/1995', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (949, 'Rena', 'Edmondson', '14/02/1986', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (950, 'Rozamond', 'Hannon', '30/01/1914', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (951, 'Judon', 'Spenley', '22/07/1966', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (952, 'Neall', 'Sanham', '04/06/1917', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (953, 'Danit', 'Cratere', '17/07/1990', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (954, 'Reynolds', 'Beyn', '13/11/1975', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (955, 'Robbi', 'Hamblen', '05/06/1924', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (956, 'Chandler', 'Friar', '28/08/1929', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (957, 'Alick', 'Pavitt', '02/08/1957', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (958, 'Talbot', 'Conan', '18/01/1902', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (959, 'Benedikta', 'Firidolfi', '01/05/1953', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (960, 'Elaina', 'Bowick', '14/07/1917', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (961, 'Rudiger', 'Philpots', '18/05/1951', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (962, 'Georgianna', 'Baszkiewicz', '05/11/1976', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (963, 'Susanetta', 'Banes', '09/01/1909', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (964, 'Biddy', 'Blaske', '24/08/1906', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (965, 'Karie', 'Gwinnell', '13/05/1909', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (966, 'Reg', 'Worman', '18/12/1991', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (967, 'Merrill', 'Easter', '09/11/1955', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (968, 'Alma', 'Haslegrave', '01/03/1947', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (969, 'Ophelie', 'Ewebank', '19/10/1956', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (970, 'Pinchas', 'Emons', '27/04/1943', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (971, 'Xavier', 'Darnody', '05/02/1975', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (972, 'Cornelius', 'Lunt', '21/03/1998', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (973, 'Muhammad', 'Grishmanov', '17/03/1923', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (974, 'Friedrick', 'Tebbet', '28/06/1936', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (975, 'Bryna', 'Espie', '06/11/2009', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (976, 'Dolph', 'Gomar', '18/07/1984', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (977, 'Stanford', 'Ferbrache', '02/06/2003', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (978, 'Denise', 'Bourgour', '25/09/1968', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (979, 'Melita', 'Barenski', '09/11/1917', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (980, 'Ado', 'Gilfoyle', '06/09/1953', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (981, 'Antonin', 'Lissenden', '31/12/1943', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (982, 'Jillie', 'Vigar', '05/10/1992', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (983, 'Silva', 'Mylchreest', '09/03/1968', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (984, 'Kacy', 'Crumpton', '02/11/1948', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (985, 'Ezri', 'Vigne', '09/04/2021', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (986, 'Karly', 'Yvens', '13/11/1946', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (987, 'Wenona', 'Brainsby', '21/06/1900', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (988, 'Richie', 'Kezar', '01/08/1949', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (989, 'Laurie', 'Ballham', '23/09/1914', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (990, 'Fransisco', 'Petrov', '08/12/2004', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (991, 'Sansone', 'Casbourne', '14/03/2010', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (992, 'Tuesday', 'Moncaster', '12/02/1984', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (993, 'Hedvig', 'Caneo', '25/09/2006', 'F', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (994, 'Wandis', 'Spragg', '25/08/1978', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (995, 'Dukey', 'Mulvin', '26/03/1949', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (996, 'Dennie', 'Cornell', '21/10/2019', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (997, 'Eloise', 'Foster-Smith', '13/04/1975', 'M', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (998, 'Farrel', 'Jery', '05/06/1944', 'M', 'worker');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (999, 'Ashil', 'Mourbey', '03/01/1927', 'F', 'borrower');
insert into PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) values (1000, 'Georgine', 'Pedwell', '31/01/2010', 'F', 'borrower');



-- Waitlist

INSERT INTO WAITLIST (WAITLIST_ID, USER_ID, BOOK_ID, CHECKOUT_DATE, RETURN_DATE, STATUS) VALUES
                                                                                             (DEFAULT, 1, 3, '2023-01-01', '2023-01-14', 'available'),
                                                                                             (DEFAULT, 2, 5, '2023-01-02', '2023-01-16', 'available'),
                                                                                             (DEFAULT, 2, 8, '2023-01-03', '2023-01-17', 'available'),
                                                                                             (DEFAULT, 3, 10, '2023-01-04', '2023-01-18', 'available'),
                                                                                             (DEFAULT, 4, 12, '2023-01-05', '2023-01-19', 'available'),
                                                                                             (DEFAULT, 5, 6, '2023-01-06', '2023-01-20', 'available'),
                                                                                             (DEFAULT, 6, 15, '2023-01-07', '2023-01-21', 'available'),
                                                                                             (DEFAULT, 7, 7, '2023-01-08', '2023-01-22', 'available'),
                                                                                             (DEFAULT, 8, 20, '2023-01-09', '2023-01-23', 'available'),
                                                                                             (DEFAULT, 9, 1, '2023-01-10', '2023-01-24', 'available'),
                                                                                             (DEFAULT, 9, 3, '2023-01-11', '2023-01-25', 'available'),
                                                                                             (DEFAULT, 10, 17, '2023-01-12', '2023-01-26', 'available'),
                                                                                             (DEFAULT, 11, 14, '2023-01-13', '2023-01-27', 'available'),
                                                                                             (DEFAULT, 22, 4, '2023-01-14', '2023-01-28', 'available'),
                                                                                             (DEFAULT, 13, 9, '2023-01-15', '2023-01-29', 'available'),
                                                                                             (DEFAULT, 14, 13, '2023-01-16', '2023-01-30', 'available'),
                                                                                             (DEFAULT, 15, 18, '2023-01-17', '2023-01-31', 'available'),
                                                                                             (DEFAULT, 16, 16, '2023-01-18', NULL, 'waiting'),
                                                                                             (DEFAULT, 22, 11, '2023-01-19', NULL, 'waiting'),
                                                                                             (DEFAULT, 56, 5, '2023-01-20', NULL, 'waiting'),
                                                                                             (DEFAULT, 56, 2, '2023-01-21', NULL, 'waiting'),
                                                                                             (DEFAULT, 20, 12, '2023-01-22', NULL, 'waiting'),
                                                                                             (DEFAULT, 21, 8, '2023-01-23', NULL, 'waiting'),
                                                                                             (DEFAULT, 22, 6, '2023-01-24', NULL, 'waiting'),
                                                                                             (DEFAULT, 78, 14, '2023-01-25', NULL, 'waiting'),
                                                                                             (DEFAULT, 24, 3, '2023-01-26', NULL, 'waiting'),
                                                                                             (DEFAULT, 83, 16, '2023-01-27', NULL, 'waiting'),
                                                                                             (DEFAULT, 26, 1, '2023-01-28', NULL, 'waiting'),
                                                                                             (DEFAULT, 27, 4, '2023-01-29', NULL, 'waiting'),
                                                                                             (DEFAULT, 28, 18, '2023-01-30', NULL, 'waiting'),
                                                                                             (DEFAULT, 77, 9, '2023-01-31', NULL, 'waiting'),
                                                                                             (DEFAULT, 30, 13, '2023-02-01', NULL, 'waiting'),
                                                                                             (DEFAULT, 31, 15, '2023-02-02', NULL, 'waiting'),
                                                                                             (DEFAULT, 53, 8, '2023-02-03', NULL, 'waiting'),
                                                                                             (DEFAULT, 33, 7, '2023-02-04', NULL, 'waiting'),
                                                                                             (DEFAULT, 34, 5, '2023-02-05', NULL, 'waiting'),
                                                                                             (DEFAULT, 35, 17, '2023-02-06', NULL, 'waiting'),
                                                                                             (DEFAULT, 36, 3, '2023-02-07', NULL, 'waiting'),
                                                                                             (DEFAULT, 37, 2, '2023-02-08', NULL, 'waiting'),
                                                                                             (DEFAULT, 38, 14, '2023-02-09', NULL, 'waiting'),
                                                                                             (DEFAULT, 39, 6, '2023-02-10', NULL, 'waiting'),
                                                                                             (DEFAULT, 40, 4, '2023-02-11', NULL, 'waiting'),
                                                                                             (DEFAULT, 41, 12, '2023-02-12', NULL, 'waiting'),
                                                                                             (DEFAULT, 42, 9, '2023-02-13', NULL, 'waiting'),
                                                                                             (DEFAULT, 43, 8, '2023-02-14', NULL, 'waiting'),
                                                                                             (DEFAULT, 44, 5, '2023-02-15', NULL, 'waiting');



-- Review

insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (1, 50, 228, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', '2017-06-02', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (2, 916, 284, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2015-02-23', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (3, 126, 641, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '2002-08-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (4, 825, 778, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2021-03-21', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (5, 793, 426, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2003-05-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (6, 131, 113, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2004-10-06', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (7, 773, 646, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2000-11-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (8, 668, 945, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2013-07-08', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (9, 97, 598, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2006-11-18', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (10, 513, 403, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2008-07-03', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (11, 937, 63, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2007-09-05', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (12, 897, 961, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2018-09-04', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (13, 519, 392, 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2009-03-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (14, 874, 119, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2021-01-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (15, 689, 676, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2008-11-20', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (16, 184, 146, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2015-07-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (17, 917, 756, 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2015-10-20', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (18, 642, 501, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2021-03-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (19, 226, 45, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2020-02-21', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (20, 484, 51, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2000-10-27', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (21, 84, 859, 'Morbi vel lectus in quam fringilla rhoncus.', '2007-12-01', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (22, 699, 244, 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2018-10-04', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (23, 643, 706, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2005-05-02', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (24, 161, 962, 'Nam dui.', '2000-07-23', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (25, 115, 929, 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2010-12-10', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (26, 501, 718, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2015-12-05', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (27, 190, 40, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2019-04-02', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (28, 149, 937, 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2006-11-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (29, 469, 368, 'In hac habitasse platea dictumst.', '2010-07-24', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (30, 861, 712, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2008-09-26', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (31, 674, 816, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2013-01-18', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (32, 481, 32, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2012-10-17', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (33, 735, 877, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2007-02-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (34, 190, 286, 'Aenean lectus.', '2023-03-22', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (35, 494, 575, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2005-12-15', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (36, 348, 491, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2005-10-20', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (37, 454, 461, 'Nulla ut erat id mauris vulputate elementum.', '2008-03-19', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (38, 867, 390, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2017-01-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (39, 420, 9, 'Duis consequat dui nec nisi volutpat eleifend.', '2021-02-19', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (40, 528, 22, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2018-12-19', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (41, 932, 786, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2015-07-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (42, 895, 708, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2007-10-07', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (43, 847, 838, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2001-05-01', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (44, 480, 492, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2007-08-31', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (45, 22, 342, 'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2007-10-25', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (46, 71, 690, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2003-07-26', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (47, 126, 180, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2010-03-18', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (48, 64, 829, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2003-01-18', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (49, 426, 165, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2019-01-10', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (50, 768, 295, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2022-08-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (51, 258, 695, 'Vivamus vel nulla eget eros elementum pellentesque.', '2011-03-17', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (52, 161, 427, 'Cras pellentesque volutpat dui.', '2001-12-25', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (53, 79, 940, 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2019-03-26', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (54, 487, 22, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '2010-01-30', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (55, 497, 588, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2006-09-22', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (56, 798, 585, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2024-02-13', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (57, 481, 925, 'Nam tristique tortor eu pede.', '2024-05-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (58, 834, 360, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2016-06-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (59, 726, 712, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2005-01-27', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (60, 926, 967, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2019-11-01', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (61, 179, 135, 'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2023-02-02', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (62, 392, 286, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2009-04-27', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (63, 313, 976, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2020-10-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (64, 283, 819, 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2019-02-02', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (65, 309, 459, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2016-05-24', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (66, 58, 6, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2016-04-14', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (67, 54, 280, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2020-04-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (68, 531, 182, 'Aenean auctor gravida sem.', '2005-11-15', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (69, 213, 800, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2020-02-03', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (70, 952, 365, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2001-09-10', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (71, 573, 63, 'Maecenas tincidunt lacus at velit.', '2004-04-23', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (72, 957, 303, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2006-11-05', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (73, 83, 422, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2010-08-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (74, 895, 190, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2000-08-29', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (75, 117, 978, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2024-01-06', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (76, 188, 418, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2022-02-08', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (77, 750, 957, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2001-10-05', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (78, 396, 163, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2007-06-01', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (79, 493, 837, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2012-10-03', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (80, 71, 883, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2011-12-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (81, 692, 431, 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2013-11-25', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (82, 355, 741, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2018-11-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (83, 433, 947, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2012-01-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (84, 393, 933, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2015-07-14', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (85, 643, 315, 'Nulla mollis molestie lorem.', '2000-10-11', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (86, 432, 734, 'Morbi non quam nec dui luctus rutrum.', '2010-11-01', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (87, 723, 438, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', '2020-12-18', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (88, 264, 139, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2001-09-09', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (89, 43, 385, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2001-12-25', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (90, 77, 803, 'Phasellus sit amet erat. Nulla tempus.', '2004-09-20', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (91, 812, 231, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2006-09-21', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (92, 729, 977, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2022-12-04', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (93, 278, 814, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2018-06-15', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (94, 30, 382, 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2005-02-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (95, 367, 207, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2021-12-31', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (96, 675, 189, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2011-10-24', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (97, 726, 485, 'Praesent lectus.', '2020-02-22', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (98, 919, 770, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2013-09-21', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (99, 899, 629, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2015-06-03', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (100, 795, 508, 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2014-07-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (101, 883, 577, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2015-03-16', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (102, 464, 944, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2015-07-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (103, 858, 26, 'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2011-01-31', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (104, 617, 527, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2007-12-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (105, 376, 310, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2016-08-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (106, 666, 278, 'Donec semper sapien a libero. Nam dui.', '2024-03-27', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (107, 868, 335, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2000-08-17', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (108, 138, 779, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', '2002-12-03', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (109, 884, 182, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2006-03-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (110, 188, 391, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2016-03-03', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (111, 12, 164, 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2018-07-04', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (112, 836, 722, 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2007-12-04', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (113, 287, 829, 'Duis bibendum. Morbi non quam nec dui luctus rutrum.', '2016-06-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (114, 843, 240, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2020-03-10', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (115, 193, 872, 'Aliquam erat volutpat.', '2002-03-20', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (116, 81, 253, 'Morbi a ipsum.', '2016-11-12', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (117, 40, 352, 'Curabitur in libero ut massa volutpat convallis.', '2009-04-06', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (118, 900, 66, 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2022-07-10', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (119, 207, 489, 'In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2024-08-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (120, 59, 866, 'Praesent id massa id nisl venenatis lacinia.', '2022-06-11', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (121, 570, 480, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2009-01-22', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (122, 531, 871, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2010-06-25', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (123, 944, 145, 'In sagittis dui vel nisl. Duis ac nibh.', '2012-12-02', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (124, 120, 494, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2024-09-25', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (125, 394, 708, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2004-10-04', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (126, 443, 481, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2016-07-09', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (127, 795, 679, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2001-12-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (128, 68, 812, 'Pellentesque at nulla. Suspendisse potenti.', '2023-08-08', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (129, 282, 672, 'Vestibulum ac est lacinia nisi venenatis tristique.', '2002-09-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (130, 596, 579, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2009-01-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (131, 414, 450, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2009-09-25', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (132, 557, 242, 'Sed accumsan felis.', '2023-09-27', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (133, 836, 167, 'Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2013-03-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (134, 206, 314, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2008-11-10', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (135, 504, 570, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2016-05-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (136, 614, 1000, 'Duis aliquam convallis nunc.', '2003-02-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (137, 2, 866, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2022-04-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (138, 33, 114, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2000-10-30', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (139, 31, 856, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2012-10-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (140, 551, 412, 'Mauris lacinia sapien quis libero.', '2013-09-18', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (141, 13, 10, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh.', '2008-06-03', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (142, 150, 337, 'Quisque id justo sit amet sapien dignissim vestibulum.', '2000-09-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (143, 526, 686, 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2020-12-03', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (144, 292, 432, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2014-11-19', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (145, 411, 687, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2002-09-16', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (146, 686, 114, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2010-08-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (147, 376, 281, 'Aliquam non mauris. Morbi non lectus.', '2005-07-18', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (148, 175, 999, 'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2020-12-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (149, 346, 587, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2005-09-06', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (150, 58, 367, 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2024-09-17', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (151, 186, 850, 'Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2003-08-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (152, 610, 952, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2019-06-30', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (153, 296, 406, 'Nulla justo.', '2005-02-22', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (154, 394, 905, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2020-01-04', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (155, 853, 358, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2011-07-06', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (156, 433, 877, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2008-06-18', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (157, 768, 558, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2011-03-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (158, 575, 358, 'Cras pellentesque volutpat dui.', '2001-08-12', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (159, 280, 697, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2016-03-21', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (160, 994, 67, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2021-12-24', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (161, 231, 343, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2010-07-02', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (162, 407, 395, 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2004-10-15', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (163, 656, 633, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2013-09-12', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (164, 272, 17, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2000-10-23', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (165, 684, 859, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2013-08-02', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (166, 89, 32, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2018-08-30', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (167, 245, 212, 'Curabitur in libero ut massa volutpat convallis.', '2007-03-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (168, 715, 671, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2020-08-12', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (169, 784, 924, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2009-08-09', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (170, 536, 996, 'Suspendisse potenti. Nullam porttitor lacus at turpis.', '2011-03-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (171, 599, 695, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2009-07-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (172, 120, 255, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2009-02-25', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (173, 196, 920, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2001-08-02', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (174, 537, 342, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2007-06-08', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (175, 318, 328, 'Pellentesque ultrices mattis odio. Donec vitae nisi.', '2013-11-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (176, 684, 336, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2020-02-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (177, 804, 377, 'Integer non velit.', '2010-01-23', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (178, 663, 656, 'In congue. Etiam justo.', '2000-05-05', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (179, 486, 103, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2005-09-15', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (180, 424, 975, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2024-08-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (181, 883, 709, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2012-01-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (182, 443, 420, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2016-06-10', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (183, 308, 393, 'Nam dui.', '2020-03-03', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (184, 266, 194, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2002-08-14', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (185, 252, 863, 'Donec semper sapien a libero. Nam dui.', '2013-07-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (186, 728, 237, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '2012-10-21', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (187, 600, 3, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2001-03-31', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (188, 846, 237, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2004-03-12', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (189, 332, 646, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2015-01-27', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (190, 811, 105, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '2022-12-25', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (191, 461, 745, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', '2003-03-03', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (192, 778, 986, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2014-08-14', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (193, 127, 997, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2016-06-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (194, 167, 199, 'Morbi a ipsum.', '2010-01-18', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (195, 183, 777, 'Etiam vel augue. Vestibulum rutrum rutrum neque.', '2011-06-26', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (196, 506, 141, 'Sed sagittis.', '2005-11-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (197, 696, 202, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2021-08-17', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (198, 230, 324, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2020-07-07', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (199, 382, 708, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2012-02-11', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (200, 926, 803, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2023-05-19', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (201, 37, 497, 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2001-10-07', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (202, 554, 623, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2016-09-08', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (203, 690, 999, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo.', '2011-05-06', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (204, 710, 49, 'In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2010-10-04', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (205, 640, 754, 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2002-02-09', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (206, 483, 592, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2016-01-02', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (207, 926, 193, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2008-07-30', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (208, 458, 467, 'Sed ante. Vivamus tortor.', '2024-08-16', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (209, 529, 253, 'Nam tristique tortor eu pede.', '2014-12-19', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (210, 78, 142, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2023-12-11', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (211, 49, 354, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2003-05-30', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (212, 954, 623, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2024-09-05', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (213, 368, 637, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2022-11-24', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (214, 835, 333, 'Donec posuere metus vitae ipsum. Aliquam non mauris.', '2015-12-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (215, 973, 324, 'Nulla nisl.', '2023-03-31', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (216, 997, 301, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2006-12-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (217, 301, 127, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2001-11-19', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (218, 132, 470, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2012-03-31', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (219, 526, 287, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2014-06-28', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (220, 845, 189, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2010-12-30', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (221, 609, 336, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2021-06-19', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (222, 152, 660, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2012-07-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (223, 959, 917, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2008-10-03', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (224, 939, 190, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2017-01-01', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (225, 287, 898, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2013-12-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (226, 862, 898, 'In hac habitasse platea dictumst.', '2002-10-02', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (227, 713, 501, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2008-03-14', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (228, 447, 931, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2016-07-07', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (229, 138, 28, 'Fusce posuere felis sed lacus.', '2020-10-23', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (230, 300, 111, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2018-10-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (231, 385, 262, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2024-07-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (232, 491, 624, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2018-08-21', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (233, 402, 1000, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2009-04-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (234, 829, 176, 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2002-08-07', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (235, 694, 497, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2015-12-06', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (236, 882, 425, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2012-12-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (237, 346, 810, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2008-10-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (238, 465, 432, 'Vivamus vel nulla eget eros elementum pellentesque.', '2002-05-18', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (239, 573, 112, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2005-04-12', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (240, 351, 299, 'Vivamus vel nulla eget eros elementum pellentesque.', '2019-07-29', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (241, 786, 712, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2001-04-19', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (242, 634, 954, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2023-04-03', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (243, 653, 725, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2007-07-13', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (244, 820, 186, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2018-09-10', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (245, 256, 955, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2006-04-02', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (246, 174, 730, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2014-08-09', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (247, 75, 621, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2004-04-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (248, 877, 316, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2008-10-25', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (249, 943, 847, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2016-05-28', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (250, 440, 337, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2016-04-05', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (251, 905, 19, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2024-02-19', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (252, 311, 65, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2003-05-08', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (253, 614, 22, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2009-07-14', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (254, 998, 364, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2000-06-29', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (255, 862, 327, 'Vestibulum rutrum rutrum neque.', '2011-11-12', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (256, 399, 796, 'Mauris sit amet eros.', '2003-05-25', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (257, 357, 421, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2004-10-25', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (258, 204, 209, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2024-06-12', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (259, 55, 700, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2004-12-24', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (260, 783, 457, 'Cras non velit nec nisi vulputate nonummy.', '2021-01-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (261, 396, 128, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2011-12-08', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (262, 340, 592, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2010-12-15', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (263, 652, 10, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2001-06-23', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (264, 76, 147, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2022-04-28', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (265, 162, 285, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2013-02-02', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (266, 743, 674, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2017-02-23', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (267, 942, 648, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', '2009-12-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (268, 493, 391, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2004-11-03', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (269, 112, 479, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2020-09-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (270, 202, 58, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2022-12-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (271, 854, 857, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2002-06-01', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (272, 206, 105, 'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2023-09-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (273, 505, 940, 'Sed sagittis.', '2014-09-24', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (274, 995, 255, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2011-02-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (275, 156, 99, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2001-12-30', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (276, 966, 465, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2005-04-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (277, 608, 4, 'Etiam pretium iaculis justo.', '2002-12-16', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (278, 182, 78, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2018-09-07', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (279, 824, 858, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2010-02-01', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (280, 193, 411, 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2015-11-26', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (281, 747, 676, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2001-03-05', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (282, 612, 375, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2004-04-12', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (283, 392, 410, 'Praesent blandit. Nam nulla.', '2021-11-16', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (284, 260, 380, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2004-05-20', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (285, 344, 660, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2009-11-09', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (286, 305, 808, 'Nunc rhoncus dui vel sem. Sed sagittis.', '2006-07-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (287, 329, 978, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2020-12-07', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (288, 583, 529, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2001-01-12', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (289, 745, 5, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2015-05-04', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (290, 947, 695, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2023-12-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (291, 901, 8, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2024-12-28', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (292, 941, 915, 'Integer non velit.', '2021-11-16', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (293, 825, 836, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2004-06-22', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (294, 863, 538, 'Duis aliquam convallis nunc.', '2023-10-22', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (295, 709, 277, 'Nullam molestie nibh in lectus.', '2004-06-19', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (296, 672, 902, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2010-10-20', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (297, 842, 81, 'Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2013-03-07', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (298, 359, 661, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2015-03-31', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (299, 595, 961, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2002-01-23', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (300, 435, 434, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2014-01-25', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (301, 109, 253, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2012-12-10', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (302, 301, 485, 'Suspendisse potenti.', '2003-10-27', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (303, 552, 223, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2023-05-27', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (304, 796, 988, 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2000-11-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (305, 848, 649, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2010-06-09', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (306, 280, 525, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2004-04-20', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (307, 706, 301, 'Proin risus. Praesent lectus.', '2000-06-29', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (308, 786, 493, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2010-08-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (309, 958, 404, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2021-07-22', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (310, 234, 383, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2012-12-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (311, 259, 898, 'Duis at velit eu est congue elementum.', '2012-09-06', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (312, 994, 184, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2012-12-09', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (313, 219, 580, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2014-06-30', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (314, 556, 473, 'Morbi vel lectus in quam fringilla rhoncus.', '2023-01-03', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (315, 656, 281, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2007-12-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (316, 681, 279, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2023-11-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (317, 836, 658, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2019-11-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (318, 833, 351, 'Pellentesque ultrices mattis odio.', '2007-04-03', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (319, 120, 776, 'Sed sagittis.', '2004-07-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (320, 529, 838, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2012-05-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (321, 766, 87, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2012-08-23', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (322, 249, 218, 'Aenean sit amet justo. Morbi ut odio.', '2010-03-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (323, 190, 953, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2023-11-14', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (324, 540, 681, 'Quisque ut erat.', '2015-06-04', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (325, 608, 989, 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2008-08-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (326, 751, 494, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2018-12-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (327, 847, 16, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', '2015-04-18', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (328, 403, 957, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2012-01-03', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (329, 580, 677, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2011-08-13', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (330, 471, 438, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2006-09-21', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (331, 691, 380, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2015-06-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (332, 806, 848, 'Suspendisse accumsan tortor quis turpis. Sed ante.', '2003-04-02', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (333, 626, 462, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2024-06-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (334, 403, 570, 'Mauris sit amet eros.', '2000-07-05', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (335, 679, 683, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2012-12-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (336, 639, 478, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2005-05-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (337, 216, 932, 'Etiam vel augue.', '2017-05-30', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (338, 297, 237, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2004-02-20', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (339, 4, 710, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2022-12-21', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (340, 355, 609, 'In congue. Etiam justo. Etiam pretium iaculis justo.', '2000-12-12', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (341, 779, 138, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', '2023-07-31', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (342, 512, 602, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2000-05-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (343, 817, 15, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2008-10-19', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (344, 709, 166, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2013-07-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (345, 525, 553, 'In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2021-12-23', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (346, 199, 452, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2008-09-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (347, 964, 824, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2017-12-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (348, 888, 277, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2001-12-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (349, 299, 489, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2005-10-24', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (350, 953, 477, 'Morbi porttitor lorem id ligula.', '2005-12-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (351, 46, 413, 'Nulla tellus. In sagittis dui vel nisl.', '2011-06-18', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (352, 49, 248, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2008-01-14', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (353, 524, 47, 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2007-03-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (354, 447, 420, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2000-07-25', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (355, 202, 135, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2017-12-30', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (356, 557, 371, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2015-11-30', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (357, 555, 979, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2001-03-30', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (358, 766, 669, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2012-12-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (359, 882, 29, 'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2018-05-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (360, 539, 978, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2016-02-28', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (361, 69, 15, 'Quisque id justo sit amet sapien dignissim vestibulum.', '2002-06-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (362, 162, 959, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2000-08-14', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (363, 925, 821, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2006-07-27', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (364, 529, 752, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2018-06-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (365, 667, 564, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2016-03-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (366, 839, 263, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2024-12-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (367, 707, 213, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2021-03-26', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (368, 511, 467, 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2010-09-30', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (369, 203, 707, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2018-01-29', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (370, 434, 174, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2000-01-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (371, 607, 863, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2005-02-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (372, 325, 753, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2020-01-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (373, 822, 994, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2011-05-17', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (374, 199, 107, 'In hac habitasse platea dictumst.', '2017-04-12', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (375, 654, 907, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2011-11-24', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (376, 906, 608, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2000-10-15', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (377, 346, 366, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2014-07-25', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (378, 179, 825, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2014-11-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (379, 971, 177, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2000-05-21', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (380, 269, 939, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', '2014-04-21', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (381, 642, 14, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2016-11-17', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (382, 813, 451, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2001-06-06', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (383, 315, 201, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2023-11-02', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (384, 123, 984, 'Sed vel enim sit amet nunc viverra dapibus.', '2021-02-16', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (385, 884, 747, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2005-08-14', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (386, 397, 802, 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2010-10-27', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (387, 811, 790, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2005-03-07', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (388, 917, 623, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', '2020-07-19', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (389, 775, 697, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2003-04-25', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (390, 640, 979, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2004-11-26', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (391, 786, 552, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2024-04-30', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (392, 310, 588, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2007-03-19', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (393, 495, 564, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2005-08-31', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (394, 356, 223, 'Pellentesque eget nunc.', '2004-02-19', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (395, 869, 486, 'Donec dapibus.', '2012-02-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (396, 21, 194, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2010-11-21', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (397, 108, 107, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2018-04-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (398, 593, 359, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2018-01-18', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (399, 881, 402, 'Nulla nisl. Nunc nisl.', '2019-11-12', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (400, 321, 524, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', '2018-12-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (401, 915, 686, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2013-06-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (402, 716, 315, 'Duis aliquam convallis nunc.', '2016-06-25', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (403, 279, 783, 'Nulla tellus.', '2020-05-31', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (404, 277, 291, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2001-09-16', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (405, 398, 401, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2010-10-13', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (406, 851, 44, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2010-12-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (407, 142, 674, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2010-11-09', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (408, 671, 907, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2004-05-20', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (409, 446, 423, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo.', '2000-11-02', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (410, 909, 365, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2007-11-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (411, 211, 668, 'Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2019-02-18', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (412, 255, 146, 'Proin at turpis a pede posuere nonummy. Integer non velit.', '2003-10-27', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (413, 806, 561, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2020-01-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (414, 674, 876, 'Vestibulum ac est lacinia nisi venenatis tristique.', '2008-07-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (415, 422, 442, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2019-12-13', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (416, 546, 93, 'Duis bibendum.', '2023-03-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (417, 258, 584, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2019-03-15', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (418, 191, 884, 'Cras in purus eu magna vulputate luctus.', '2003-01-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (419, 741, 635, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2005-10-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (420, 486, 80, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2019-11-21', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (421, 843, 182, 'Nullam molestie nibh in lectus.', '2007-12-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (422, 139, 38, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2018-05-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (423, 59, 383, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2007-02-21', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (424, 343, 207, 'Suspendisse potenti. Nullam porttitor lacus at turpis.', '2012-04-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (425, 390, 120, 'Morbi non quam nec dui luctus rutrum.', '2016-10-24', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (426, 694, 649, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2022-05-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (427, 470, 48, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2007-11-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (428, 872, 100, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2015-03-08', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (429, 86, 141, 'Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2007-04-18', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (430, 297, 763, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2022-03-24', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (431, 170, 513, 'Etiam pretium iaculis justo.', '2024-05-17', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (432, 120, 375, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2010-11-18', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (433, 665, 668, 'Duis mattis egestas metus.', '2003-05-09', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (434, 789, 373, 'Nulla facilisi.', '2020-12-23', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (435, 951, 489, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2011-01-20', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (436, 906, 825, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2004-09-10', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (437, 284, 388, 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2002-07-11', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (438, 362, 513, 'Sed ante.', '2018-10-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (439, 930, 547, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2016-12-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (440, 370, 710, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2021-06-29', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (441, 778, 205, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2000-08-07', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (442, 876, 533, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2007-08-26', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (443, 909, 343, 'Aenean lectus.', '2024-03-26', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (444, 574, 113, 'Vivamus vel nulla eget eros elementum pellentesque.', '2003-12-24', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (445, 463, 355, 'Maecenas tincidunt lacus at velit.', '2020-08-26', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (446, 452, 515, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2017-08-26', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (447, 163, 309, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo.', '2008-06-01', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (448, 920, 415, 'Nullam molestie nibh in lectus.', '2003-10-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (449, 358, 556, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2019-02-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (450, 569, 200, 'Pellentesque ultrices mattis odio.', '2012-08-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (451, 399, 627, 'Aenean lectus.', '2020-04-09', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (452, 132, 175, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2000-11-28', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (453, 778, 192, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2008-01-20', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (454, 168, 313, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '2008-07-02', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (455, 173, 729, 'In congue. Etiam justo. Etiam pretium iaculis justo.', '2016-01-20', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (456, 578, 97, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2000-01-28', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (457, 571, 231, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2014-12-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (458, 750, 200, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2016-02-19', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (459, 975, 960, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2002-01-23', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (460, 135, 297, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2015-03-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (461, 757, 611, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2020-02-12', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (462, 993, 899, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2009-05-25', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (463, 753, 799, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2001-06-02', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (464, 335, 217, 'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2018-07-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (465, 828, 340, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2000-01-03', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (466, 143, 176, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2003-01-08', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (467, 437, 603, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2006-09-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (468, 594, 123, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2015-11-14', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (469, 106, 677, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2019-06-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (470, 683, 802, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2003-03-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (471, 186, 10, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2018-06-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (472, 885, 537, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', '2007-06-19', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (473, 64, 497, 'Cras in purus eu magna vulputate luctus.', '2001-09-26', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (474, 991, 727, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2001-06-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (475, 991, 815, 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2020-07-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (476, 83, 669, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2003-05-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (477, 13, 505, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2001-05-02', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (478, 359, 178, 'Proin eu mi. Nulla ac enim.', '2018-11-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (479, 333, 543, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2019-09-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (480, 479, 927, 'Etiam faucibus cursus urna. Ut tellus.', '2008-07-07', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (481, 241, 848, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2011-06-17', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (482, 669, 286, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2024-12-29', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (483, 913, 404, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2005-08-23', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (484, 463, 962, 'Aliquam quis turpis eget elit sodales scelerisque.', '2002-08-03', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (485, 996, 414, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2016-07-02', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (486, 281, 914, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2024-01-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (487, 161, 231, 'In quis justo.', '2016-02-12', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (488, 587, 891, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2010-11-12', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (489, 670, 192, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2014-07-03', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (490, 31, 157, 'Phasellus sit amet erat.', '2016-04-27', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (491, 641, 749, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2018-11-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (492, 921, 218, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2022-07-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (493, 113, 629, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2003-07-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (494, 652, 523, 'Aliquam non mauris. Morbi non lectus.', '2003-11-21', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (495, 84, 537, 'Aenean lectus. Pellentesque eget nunc.', '2001-06-07', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (496, 456, 797, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2007-02-18', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (497, 399, 97, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2011-11-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (498, 826, 254, 'Donec posuere metus vitae ipsum. Aliquam non mauris.', '2002-09-07', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (499, 697, 93, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2011-08-22', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (500, 942, 168, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '2005-02-09', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (501, 88, 982, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2016-06-27', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (502, 132, 146, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2000-11-22', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (503, 292, 530, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2003-11-19', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (504, 749, 322, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2000-06-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (505, 32, 640, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2016-09-01', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (506, 563, 520, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2011-11-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (507, 875, 209, 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2013-02-09', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (508, 315, 936, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2024-02-23', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (509, 256, 505, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2019-01-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (510, 247, 421, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2015-09-05', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (511, 406, 199, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2005-11-24', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (512, 748, 209, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2005-07-02', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (513, 876, 354, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2020-02-17', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (514, 534, 435, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2005-07-16', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (515, 755, 941, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2006-05-05', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (516, 478, 545, 'In hac habitasse platea dictumst.', '2004-07-26', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (517, 158, 93, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2023-02-14', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (518, 727, 355, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2007-05-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (519, 707, 107, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2009-10-10', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (520, 58, 61, 'Morbi vel lectus in quam fringilla rhoncus.', '2016-07-17', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (521, 215, 835, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2012-08-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (522, 370, 353, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', '2014-12-09', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (523, 94, 72, 'Aenean sit amet justo.', '2013-12-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (524, 941, 831, 'Maecenas tincidunt lacus at velit.', '2009-07-07', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (525, 286, 734, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '2005-09-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (526, 100, 500, 'Nulla nisl.', '2015-12-20', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (527, 585, 827, 'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2008-12-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (528, 576, 112, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '2002-08-09', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (529, 651, 113, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2013-02-04', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (530, 157, 364, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2004-06-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (531, 552, 729, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2008-08-05', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (532, 124, 346, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2000-07-09', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (533, 372, 309, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', '2010-11-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (534, 627, 758, 'Nam nulla.', '2010-11-04', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (535, 737, 431, 'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2015-02-05', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (536, 535, 565, 'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2023-04-16', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (537, 966, 3, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2017-01-08', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (538, 923, 28, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2018-08-08', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (539, 661, 780, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2007-08-21', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (540, 621, 461, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2012-04-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (541, 223, 980, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2010-12-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (542, 110, 478, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2022-06-12', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (543, 515, 94, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2004-08-07', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (544, 58, 807, 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2022-09-12', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (545, 289, 429, 'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2003-03-05', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (546, 509, 555, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2019-12-11', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (547, 103, 619, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '2016-10-07', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (548, 69, 563, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2020-02-14', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (549, 941, 369, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2007-11-20', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (550, 102, 964, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2010-08-13', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (551, 744, 941, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2014-06-09', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (552, 169, 954, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2017-06-25', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (553, 896, 256, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2017-05-18', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (554, 1, 304, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2022-03-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (555, 936, 468, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2011-08-21', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (556, 553, 755, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2004-10-28', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (557, 458, 209, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2004-03-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (558, 837, 99, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2001-07-25', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (559, 947, 711, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2000-06-15', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (560, 847, 987, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2000-03-17', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (561, 594, 962, 'Vivamus tortor.', '2017-01-04', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (562, 123, 444, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2013-12-07', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (563, 228, 159, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2011-11-05', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (564, 3, 764, 'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2012-08-05', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (565, 95, 871, 'Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2015-03-31', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (566, 289, 915, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2019-10-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (567, 553, 105, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2018-03-25', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (568, 925, 342, 'Curabitur gravida nisi at nibh.', '2003-12-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (569, 539, 413, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2015-06-02', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (570, 646, 168, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2017-10-29', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (571, 603, 807, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2009-02-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (572, 35, 793, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2024-10-31', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (573, 580, 45, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2006-03-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (574, 474, 515, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '2006-07-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (575, 912, 988, 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2003-04-10', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (576, 61, 423, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2016-08-10', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (577, 594, 49, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2017-08-05', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (578, 128, 156, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2017-01-12', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (579, 880, 249, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2008-04-12', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (580, 783, 221, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2022-01-24', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (581, 23, 934, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2020-09-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (582, 873, 919, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2019-01-06', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (583, 244, 379, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2003-05-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (584, 2, 62, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2000-07-06', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (585, 424, 385, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2018-06-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (586, 293, 304, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2004-08-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (587, 899, 408, 'Nunc nisl.', '2016-05-05', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (588, 467, 336, 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2006-07-01', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (589, 929, 362, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2000-11-19', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (590, 408, 625, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2022-08-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (591, 147, 471, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2005-01-13', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (592, 883, 583, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2001-01-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (593, 54, 306, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2016-11-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (594, 581, 912, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2014-05-17', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (595, 176, 610, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2014-09-01', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (596, 136, 243, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2007-05-06', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (597, 278, 665, 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2012-11-15', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (598, 37, 758, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', '2004-12-14', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (599, 222, 40, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2019-10-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (600, 281, 857, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', '2000-12-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (601, 886, 670, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2013-10-27', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (602, 547, 92, 'Proin eu mi. Nulla ac enim.', '2020-06-04', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (603, 901, 471, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2022-11-24', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (604, 759, 683, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', '2023-05-25', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (605, 870, 769, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2009-01-15', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (606, 372, 321, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', '2022-10-23', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (607, 303, 418, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2003-01-27', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (608, 292, 805, 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2013-10-05', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (609, 491, 218, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2000-12-04', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (610, 372, 667, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2007-05-31', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (611, 810, 386, 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2003-02-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (612, 817, 75, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2014-07-26', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (613, 353, 152, 'Nulla tellus. In sagittis dui vel nisl.', '2015-11-27', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (614, 833, 883, 'Integer ac leo. Pellentesque ultrices mattis odio.', '2007-05-05', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (615, 553, 792, 'Cras non velit nec nisi vulputate nonummy.', '2013-06-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (616, 625, 741, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2021-01-28', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (617, 199, 677, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2022-01-13', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (618, 801, 671, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2013-12-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (619, 401, 428, 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2004-06-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (620, 672, 613, 'Maecenas tincidunt lacus at velit.', '2023-07-07', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (621, 330, 229, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2004-04-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (622, 465, 79, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2019-04-10', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (623, 822, 610, 'Maecenas ut massa quis augue luctus tincidunt.', '2003-06-02', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (624, 35, 826, 'Cras pellentesque volutpat dui.', '2005-08-29', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (625, 178, 490, 'Ut at dolor quis odio consequat varius.', '2008-05-31', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (626, 203, 210, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2010-04-26', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (627, 829, 134, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2007-07-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (628, 939, 292, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2013-10-12', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (629, 815, 752, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2022-02-16', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (630, 519, 468, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2021-10-07', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (631, 400, 510, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2000-08-23', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (632, 896, 325, 'Aenean sit amet justo.', '2000-12-12', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (633, 275, 929, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2023-11-24', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (634, 38, 371, 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2022-11-14', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (635, 355, 577, 'Praesent lectus.', '2011-04-26', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (636, 769, 433, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', '2009-06-20', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (637, 290, 536, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2017-09-04', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (638, 756, 531, 'Sed vel enim sit amet nunc viverra dapibus.', '2018-05-30', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (639, 765, 924, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2018-10-10', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (640, 740, 553, 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2024-04-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (641, 102, 976, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2009-03-11', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (642, 531, 182, 'Curabitur gravida nisi at nibh.', '2006-11-27', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (643, 248, 851, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2001-09-22', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (644, 860, 509, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2005-11-10', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (645, 782, 719, 'Integer non velit.', '2008-03-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (646, 391, 644, 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2008-11-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (647, 677, 847, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2023-06-16', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (648, 157, 355, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2001-09-30', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (649, 12, 610, 'Curabitur in libero ut massa volutpat convallis.', '2005-08-06', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (650, 127, 16, 'Praesent lectus.', '2004-10-12', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (651, 177, 694, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2017-12-03', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (652, 463, 192, 'Curabitur at ipsum ac tellus semper interdum.', '2024-12-27', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (653, 193, 380, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2000-03-14', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (654, 695, 847, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus.', '2008-12-21', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (655, 619, 961, 'Nulla ac enim.', '2021-08-07', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (656, 664, 533, 'Nullam varius.', '2014-02-04', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (657, 549, 861, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2010-04-17', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (658, 244, 767, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2008-07-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (659, 482, 945, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2002-02-16', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (660, 434, 586, 'Nunc nisl.', '2005-01-11', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (661, 199, 295, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2012-04-01', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (662, 664, 834, 'Nullam molestie nibh in lectus.', '2007-02-28', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (663, 912, 203, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2021-06-07', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (664, 416, 348, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2002-09-23', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (665, 408, 229, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2002-09-17', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (666, 782, 641, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2018-05-31', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (667, 73, 307, 'Integer ac leo.', '2007-01-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (668, 577, 704, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2013-06-09', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (669, 185, 940, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2009-04-28', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (670, 437, 730, 'Etiam justo. Etiam pretium iaculis justo.', '2024-01-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (671, 21, 197, 'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2014-02-15', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (672, 560, 243, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2018-03-07', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (673, 955, 250, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2011-10-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (674, 768, 798, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2016-04-29', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (675, 237, 960, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2008-07-10', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (676, 913, 828, 'Phasellus in felis.', '2010-02-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (677, 124, 629, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2012-08-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (678, 845, 212, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2012-02-17', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (679, 442, 46, 'Duis mattis egestas metus. Aenean fermentum.', '2023-02-09', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (680, 366, 984, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2005-07-03', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (681, 187, 878, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', '2020-09-13', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (682, 250, 506, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2020-11-15', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (683, 165, 866, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '2002-07-27', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (684, 383, 601, 'Nulla nisl. Nunc nisl.', '2023-09-06', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (685, 671, 100, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2020-06-11', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (686, 566, 806, 'Suspendisse potenti. In eleifend quam a odio.', '2008-02-13', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (687, 186, 413, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '2018-12-04', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (688, 605, 612, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2022-07-23', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (689, 117, 216, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2009-12-11', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (690, 603, 412, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2019-08-03', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (691, 90, 331, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2009-04-05', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (692, 62, 849, 'Duis aliquam convallis nunc.', '2005-08-20', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (693, 183, 870, 'Proin risus.', '2008-06-06', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (694, 45, 115, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2023-05-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (695, 753, 667, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2010-02-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (696, 863, 396, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2008-01-12', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (697, 54, 322, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2014-11-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (698, 611, 535, 'Morbi porttitor lorem id ligula.', '2017-06-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (699, 487, 873, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2006-11-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (700, 504, 780, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2011-02-27', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (701, 479, 582, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh.', '2025-01-22', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (702, 263, 335, 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2019-06-19', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (703, 87, 286, 'Morbi non lectus.', '2002-05-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (704, 683, 687, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2023-06-17', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (705, 204, 492, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2021-02-01', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (706, 603, 81, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2014-05-30', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (707, 127, 129, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2017-03-03', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (708, 89, 188, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2002-10-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (709, 177, 16, 'Nulla justo.', '2019-09-23', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (710, 835, 571, 'Morbi ut odio.', '2004-10-11', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (711, 510, 483, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2001-10-01', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (712, 299, 158, 'Aliquam sit amet diam in magna bibendum imperdiet.', '2003-10-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (713, 226, 353, 'Morbi ut odio.', '2019-06-01', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (714, 306, 112, 'Phasellus id sapien in sapien iaculis congue.', '2018-02-26', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (715, 674, 309, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2012-05-20', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (716, 113, 433, 'Aliquam non mauris. Morbi non lectus.', '2005-09-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (717, 269, 656, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2003-02-26', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (718, 747, 306, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2016-04-17', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (719, 378, 423, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2005-10-07', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (720, 853, 579, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2006-01-02', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (721, 798, 321, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2024-07-23', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (722, 255, 69, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2017-02-13', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (723, 63, 952, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2000-01-16', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (724, 201, 918, 'Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2021-06-06', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (725, 742, 575, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2001-08-14', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (726, 993, 984, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '2003-06-29', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (727, 800, 960, 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2004-07-15', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (728, 96, 193, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2019-04-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (729, 404, 52, 'Suspendisse potenti. Nullam porttitor lacus at turpis.', '2004-07-05', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (730, 346, 686, 'In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2005-02-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (731, 62, 407, 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.', '2014-02-03', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (732, 123, 884, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', '2017-12-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (733, 32, 992, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2007-10-14', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (734, 563, 567, 'Fusce posuere felis sed lacus.', '2024-06-08', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (735, 144, 770, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2010-08-18', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (736, 34, 529, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2018-01-31', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (737, 773, 176, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2020-04-15', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (738, 590, 549, 'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2014-09-26', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (739, 688, 603, 'Nullam molestie nibh in lectus.', '2020-04-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (740, 588, 389, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2006-03-07', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (741, 990, 451, 'Quisque porta volutpat erat.', '2017-08-16', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (742, 409, 706, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2003-10-09', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (743, 741, 653, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2009-08-07', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (744, 741, 639, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2019-06-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (745, 712, 635, 'Suspendisse accumsan tortor quis turpis. Sed ante.', '2012-08-24', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (746, 184, 986, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2013-11-09', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (747, 457, 417, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2001-10-29', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (748, 768, 561, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2006-10-01', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (749, 935, 251, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2023-08-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (750, 632, 663, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2020-06-20', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (751, 366, 644, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2021-01-16', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (752, 75, 40, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2014-05-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (753, 128, 987, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '2022-02-26', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (754, 614, 461, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2017-11-07', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (755, 364, 350, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2005-08-06', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (756, 129, 778, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2008-10-06', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (757, 488, 817, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2003-01-24', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (758, 680, 273, 'Curabitur at ipsum ac tellus semper interdum.', '2016-06-08', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (759, 302, 448, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2017-01-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (760, 628, 116, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2011-03-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (761, 345, 334, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2000-11-05', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (762, 486, 59, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2014-02-13', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (763, 59, 814, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2006-06-18', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (764, 933, 35, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2019-04-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (765, 544, 262, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2016-12-17', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (766, 258, 999, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2002-08-09', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (767, 997, 624, 'Maecenas ut massa quis augue luctus tincidunt.', '2023-01-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (768, 363, 366, 'Sed vel enim sit amet nunc viverra dapibus.', '2011-09-25', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (769, 927, 18, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2014-09-01', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (770, 460, 168, 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2019-02-18', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (771, 893, 313, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2013-04-17', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (772, 753, 324, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', '2003-12-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (773, 177, 547, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2021-12-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (774, 81, 932, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2009-01-10', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (775, 761, 632, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2010-09-21', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (776, 219, 646, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2021-10-25', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (777, 690, 134, 'Morbi ut odio.', '2014-03-26', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (778, 623, 187, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2020-12-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (779, 928, 872, 'Morbi vel lectus in quam fringilla rhoncus.', '2014-10-06', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (780, 772, 884, 'Proin at turpis a pede posuere nonummy. Integer non velit.', '2013-10-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (781, 155, 997, 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2014-09-30', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (782, 272, 180, 'Nullam molestie nibh in lectus.', '2012-06-26', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (783, 914, 192, 'Duis consequat dui nec nisi volutpat eleifend.', '2003-07-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (784, 913, 636, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2024-06-13', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (785, 733, 838, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2003-05-07', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (786, 602, 78, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2018-02-15', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (787, 494, 755, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2017-02-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (788, 680, 818, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2014-11-01', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (789, 819, 46, 'Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2008-12-22', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (790, 875, 380, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2001-04-15', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (791, 547, 954, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2021-02-14', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (792, 68, 454, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2022-10-03', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (793, 326, 68, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2023-09-29', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (794, 678, 783, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', '2012-08-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (795, 50, 357, 'Nunc purus.', '2003-02-03', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (796, 797, 238, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2008-08-02', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (797, 255, 254, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2009-07-23', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (798, 114, 718, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2018-12-08', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (799, 480, 150, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2017-10-30', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (800, 30, 639, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', '2002-08-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (801, 850, 491, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2014-02-25', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (802, 193, 438, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2014-07-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (803, 435, 247, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2001-03-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (804, 579, 820, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2004-12-23', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (805, 179, 105, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2022-02-12', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (806, 99, 782, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2009-12-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (807, 162, 39, 'Nam nulla.', '2022-06-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (808, 395, 756, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2014-03-07', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (809, 103, 88, 'In hac habitasse platea dictumst.', '2024-10-23', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (810, 567, 936, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2021-04-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (811, 577, 38, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2001-04-09', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (812, 367, 687, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2002-04-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (813, 906, 12, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2023-08-11', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (814, 542, 823, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2001-11-22', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (815, 619, 419, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2021-06-24', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (816, 130, 994, 'Ut at dolor quis odio consequat varius. Integer ac leo.', '2000-01-16', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (817, 781, 253, 'Ut tellus.', '2024-11-07', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (818, 233, 325, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2003-05-14', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (819, 883, 164, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2006-04-29', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (820, 513, 875, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2012-04-18', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (821, 608, 34, 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', '2014-12-19', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (822, 180, 67, 'Integer ac leo.', '2016-02-16', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (823, 864, 967, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2016-04-13', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (824, 641, 769, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2019-08-07', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (825, 755, 701, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2016-07-27', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (826, 684, 79, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2011-08-24', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (827, 664, 127, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2013-11-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (828, 911, 142, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2019-01-20', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (829, 589, 360, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2016-08-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (830, 898, 888, 'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2000-01-13', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (831, 130, 244, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-12-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (832, 887, 858, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2024-09-19', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (833, 62, 880, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2009-03-14', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (834, 141, 58, 'Ut at dolor quis odio consequat varius. Integer ac leo.', '2015-03-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (835, 587, 36, 'Quisque ut erat. Curabitur gravida nisi at nibh.', '2023-07-30', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (836, 253, 618, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2012-07-31', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (837, 332, 273, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2016-12-07', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (838, 427, 996, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2003-05-26', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (839, 216, 930, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2009-10-05', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (840, 501, 323, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '2004-11-29', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (841, 359, 202, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '2015-11-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (842, 122, 1000, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2012-02-03', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (843, 72, 566, 'In congue. Etiam justo.', '2022-06-14', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (844, 978, 564, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2018-11-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (845, 941, 662, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2011-07-28', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (846, 978, 863, 'Duis consequat dui nec nisi volutpat eleifend.', '2021-04-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (847, 48, 733, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2007-03-19', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (848, 35, 469, 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2005-09-04', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (849, 215, 326, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2000-12-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (850, 803, 38, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2004-12-24', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (851, 537, 841, 'Curabitur gravida nisi at nibh.', '2014-12-06', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (852, 472, 493, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2016-12-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (853, 908, 640, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2001-12-13', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (854, 385, 714, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-06-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (855, 837, 757, 'In blandit ultrices enim.', '2015-01-06', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (856, 610, 539, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2007-03-26', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (857, 104, 598, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2019-04-26', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (858, 379, 756, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2009-10-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (859, 904, 927, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2013-11-12', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (860, 672, 402, 'Duis aliquam convallis nunc.', '2011-08-28', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (861, 802, 735, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2012-11-13', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (862, 13, 938, 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2016-04-09', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (863, 88, 906, 'Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2021-05-27', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (864, 517, 459, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2005-11-14', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (865, 615, 932, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2011-08-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (866, 392, 57, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2020-04-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (867, 458, 851, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2006-08-23', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (868, 404, 708, 'Integer non velit.', '2022-10-22', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (869, 970, 60, 'Aliquam erat volutpat.', '2015-11-02', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (870, 403, 226, 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2007-06-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (871, 556, 353, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2005-02-27', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (872, 16, 686, 'Ut tellus.', '2003-11-03', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (873, 6, 467, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2022-06-28', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (874, 539, 161, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2011-03-21', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (875, 457, 414, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2003-07-01', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (876, 611, 376, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2024-11-29', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (877, 938, 188, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2002-01-20', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (878, 910, 979, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2009-09-16', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (879, 266, 918, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2018-08-27', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (880, 926, 619, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2013-01-16', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (881, 618, 442, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2014-12-02', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (882, 611, 218, 'Donec semper sapien a libero. Nam dui.', '2021-10-19', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (883, 433, 356, 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2012-10-17', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (884, 442, 615, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2013-03-03', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (885, 144, 246, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2024-08-22', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (886, 267, 286, 'Vivamus tortor.', '2021-12-20', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (887, 437, 530, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '2020-05-11', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (888, 418, 549, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2002-12-09', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (889, 640, 256, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2024-09-29', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (890, 515, 86, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2009-02-25', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (891, 308, 429, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2008-03-02', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (892, 165, 643, 'In sagittis dui vel nisl.', '2015-11-10', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (893, 544, 719, 'Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2006-04-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (894, 826, 121, 'Vestibulum rutrum rutrum neque.', '2017-02-03', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (895, 833, 483, 'In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2006-06-04', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (896, 893, 699, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2019-05-19', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (897, 322, 322, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2018-06-08', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (898, 657, 960, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2018-04-03', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (899, 55, 620, 'Curabitur in libero ut massa volutpat convallis.', '2002-07-24', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (900, 220, 547, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2003-03-17', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (901, 875, 710, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2013-05-13', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (902, 854, 556, 'Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2022-06-16', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (903, 419, 746, 'Morbi a ipsum. Integer a nibh.', '2003-01-11', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (904, 397, 336, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2015-12-12', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (905, 473, 657, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2007-03-18', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (906, 970, 417, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2006-09-02', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (907, 406, 584, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', '2018-03-30', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (908, 834, 731, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '2021-03-29', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (909, 344, 355, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2005-11-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (910, 496, 669, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2023-09-11', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (911, 448, 134, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2014-12-01', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (912, 423, 306, 'Morbi a ipsum. Integer a nibh. In quis justo.', '2000-04-23', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (913, 782, 162, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2020-01-29', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (914, 378, 412, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2018-01-10', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (915, 606, 520, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2015-01-05', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (916, 688, 728, 'In quis justo.', '2023-07-29', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (917, 909, 155, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2021-05-30', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (918, 593, 557, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2012-10-31', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (919, 139, 121, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2001-05-14', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (920, 286, 227, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2020-10-13', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (921, 668, 916, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2019-06-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (922, 852, 100, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2015-06-11', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (923, 414, 573, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2001-07-08', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (924, 931, 149, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2020-07-11', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (925, 651, 446, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2000-08-22', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (926, 123, 66, 'Curabitur in libero ut massa volutpat convallis.', '2011-04-19', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (927, 439, 275, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '2006-05-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (928, 505, 900, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2002-05-25', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (929, 779, 383, 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2023-09-07', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (930, 205, 576, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2023-05-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (931, 127, 511, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2023-04-06', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (932, 756, 783, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2004-05-24', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (933, 19, 268, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2015-07-22', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (934, 243, 664, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2021-05-14', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (935, 311, 30, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2007-09-19', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (936, 109, 362, 'Integer non velit.', '2000-10-04', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (937, 841, 134, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2023-01-28', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (938, 802, 411, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2020-02-16', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (939, 97, 794, 'Aliquam quis turpis eget elit sodales scelerisque.', '2024-08-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (940, 196, 461, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2000-02-11', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (941, 220, 119, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2006-03-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (942, 807, 781, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2018-09-30', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (943, 568, 657, 'Praesent blandit lacinia erat.', '2000-12-15', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (944, 551, 133, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2015-11-21', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (945, 452, 753, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2013-11-09', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (946, 319, 815, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2003-03-02', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (947, 454, 486, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2001-03-05', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (948, 757, 288, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2024-12-22', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (949, 471, 919, 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', '2002-04-01', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (950, 123, 396, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2002-01-08', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (951, 170, 469, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2022-04-30', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (952, 467, 193, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2024-07-06', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (953, 840, 161, 'Ut at dolor quis odio consequat varius.', '2007-04-29', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (954, 217, 400, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2016-06-23', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (955, 864, 795, 'Aliquam sit amet diam in magna bibendum imperdiet.', '2023-05-16', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (956, 463, 498, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh.', '2001-05-31', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (957, 930, 539, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2009-10-19', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (958, 896, 465, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2018-05-22', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (959, 551, 981, 'Aenean auctor gravida sem.', '2008-12-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (960, 183, 956, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2018-01-24', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (961, 181, 599, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2023-08-09', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (962, 892, 908, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2006-03-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (963, 920, 379, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2012-08-30', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (964, 937, 439, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2007-04-23', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (965, 458, 850, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2024-05-08', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (966, 18, 834, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2021-06-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (967, 310, 78, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2023-09-10', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (968, 577, 115, 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2009-02-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (969, 948, 60, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2022-01-29', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (970, 516, 712, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2006-08-21', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (971, 729, 533, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2022-05-27', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (972, 840, 459, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2007-08-22', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (973, 277, 152, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2024-05-31', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (974, 331, 208, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2005-05-28', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (975, 201, 607, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2001-05-15', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (976, 555, 365, 'Donec quis orci eget orci vehicula condimentum.', '2014-03-30', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (977, 759, 5, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2013-07-02', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (978, 218, 525, 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2001-07-16', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (979, 283, 225, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2001-09-13', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (980, 711, 784, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2013-06-02', 4);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (981, 678, 872, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2009-02-11', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (982, 431, 332, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2018-10-25', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (983, 152, 5, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', '2018-09-13', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (984, 368, 363, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2020-04-21', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (985, 929, 27, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2020-12-01', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (986, 633, 53, 'Morbi porttitor lorem id ligula.', '2018-08-18', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (987, 793, 115, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2000-05-23', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (988, 813, 703, 'Suspendisse accumsan tortor quis turpis. Sed ante.', '2022-10-06', 5);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (989, 286, 583, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2017-11-20', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (990, 503, 65, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2024-10-18', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (991, 544, 701, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2000-12-11', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (992, 485, 682, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2011-05-02', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (993, 74, 495, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2020-01-04', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (994, 340, 579, 'Nulla tellus. In sagittis dui vel nisl.', '2007-08-27', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (995, 149, 924, 'Proin interdum mauris non ligula pellentesque ultrices.', '2003-09-28', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (996, 372, 168, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2023-03-06', 2);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (997, 438, 286, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', '2017-02-21', 0);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (998, 477, 691, 'Morbi a ipsum.', '2001-02-01', 1);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (999, 543, 294, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2012-09-05', 3);
insert into REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) values (1000, 129, 559, 'Praesent id massa id nisl venenatis lacinia.', '2003-03-30', 3);


-- Lending

INSERT INTO LENDING (LENDING_ID, BOOK_ID, USER_ID_BORROWER, USER_ID_WORKER, STATUS, CHECKOUT_DATE, RETURN_DATE, DUE_DATE) VALUES
                                                                                                                              (DEFAULT, 1, 1, 2, 'borrowed', '2023-03-01', NULL, '2023-03-29'),
                                                                                                                              (DEFAULT, 2, 3, 2, 'returned', '2023-04-01', '2023-04-10', '2023-04-08'),
                                                                                                                              (DEFAULT, 3, 7, 2, 'borrowed', '2023-05-10', NULL, '2023-06-07'),
                                                                                                                              (DEFAULT, 4, 10, 2, 'returned', '2023-02-15', '2023-02-28', '2023-02-22'),
                                                                                                                              (DEFAULT, 5, 12, 2, 'borrowed', '2023-06-05', NULL, '2023-07-03'),
                                                                                                                              (DEFAULT, 6, 15, 2, 'returned', '2023-01-20', '2023-01-30', '2023-01-27'),
                                                                                                                              (DEFAULT, 7, 18, 2, 'borrowed', '2023-07-01', NULL, '2023-07-29'),
                                                                                                                              (DEFAULT, 8, 21, 2, 'returned', '2023-04-15', '2023-04-22', '2023-04-22'),
                                                                                                                              (DEFAULT, 9, 25, 2, 'borrowed', '2023-05-15', NULL, '2023-06-12'),
                                                                                                                              (DEFAULT, 10, 30, 2, 'returned', '2023-03-01', '2023-03-10', '2023-03-08'),
                                                                                                                              (DEFAULT, 11, 35, 2, 'borrowed', '2023-02-20', NULL, '2023-03-20'),
                                                                                                                              (DEFAULT, 12, 40, 2, 'returned', '2023-05-25', '2023-06-01', '2023-05-30'),
                                                                                                                              (DEFAULT, 13, 45, 2, 'borrowed', '2023-06-05', NULL, '2023-07-03'),
                                                                                                                              (DEFAULT, 14, 50, 2, 'returned', '2023-03-15', '2023-03-25', '2023-03-22'),
                                                                                                                              (DEFAULT, 15, 55, 2, 'borrowed', '2023-07-10', NULL, '2023-08-07'),
                                                                                                                              (DEFAULT, 16, 60, 2, 'returned', '2023-02-10', '2023-02-20', '2023-02-17'),
                                                                                                                              (DEFAULT, 17, 63, 2, 'borrowed', '2023-06-15', NULL, '2023-07-13'),
                                                                                                                              (DEFAULT, 18, 68, 2, 'returned', '2023-01-05', '2023-01-15', '2023-01-12'),
                                                                                                                              (DEFAULT, 19, 71, 2, 'borrowed', '2023-07-15', NULL, '2023-08-12'),
                                                                                                                              (DEFAULT, 20, 75, 2, 'returned', '2023-03-20', '2023-03-25', '2023-03-22'),
                                                                                                                              (DEFAULT, 21, 78, 2, 'borrowed', '2023-04-05', NULL, '2023-05-03'),
                                                                                                                              (DEFAULT, 22, 82, 2, 'returned', '2023-01-10', '2023-01-15', '2023-01-12'),
                                                                                                                              (DEFAULT, 23, 88, 2, 'borrowed', '2023-06-25', NULL, '2023-07-23'),
                                                                                                                              (DEFAULT, 24, 91, 2, 'returned', '2023-02-01', '2023-02-10', '2023-02-07'),
                                                                                                                              (DEFAULT, 25, 95, 2, 'borrowed', '2023-05-30', NULL, '2023-06-27'),
                                                                                                                              (DEFAULT, 26, 99, 2, 'returned', '2023-04-20', '2023-04-28', '2023-04-25'),
                                                                                                                              (DEFAULT, 27, 2, 2, 'borrowed', '2023-07-05', NULL, '2023-08-02'),
                                                                                                                              (DEFAULT, 28, 6, 2, 'returned', '2023-02-25', '2023-03-03', '2023-02-28'),
                                                                                                                              (DEFAULT, 29, 11, 2, 'borrowed', '2023-06-10', NULL, '2023-07-08'),
                                                                                                                              (DEFAULT, 30, 14, 2, 'returned', '2023-03-01', '2023-03-12', '2023-03-09'),
                                                                                                                              (DEFAULT, 31, 19, 2, 'borrowed', '2023-05-01', NULL, '2023-05-29'),
                                                                                                                              (DEFAULT, 32, 23, 2, 'returned', '2023-04-01', '2023-04-08', '2023-04-05'),
                                                                                                                              (DEFAULT, 33, 27, 2, 'borrowed', '2023-07-10', NULL, '2023-08-07'),
                                                                                                                              (DEFAULT, 34, 31, 2, 'returned', '2023-03-15', '2023-03-25', '2023-03-22'),
                                                                                                                              (DEFAULT, 35, 34, 2, 'borrowed', '2023-06-20', NULL, '2023-07-18'),
                                                                                                                              (DEFAULT, 36, 38, 2, 'returned', '2023-02-05', '2023-02-15', '2023-02-12'),
                                                                                                                              (DEFAULT, 37, 41, 2, 'borrowed', '2023-07-12', NULL, '2023-08-09'),
                                                                                                                              (DEFAULT, 38, 45, 2, 'returned', '2023-01-15', '2023-01-22', '2023-01-19'),
                                                                                                                              (DEFAULT, 39, 49, 2, 'borrowed', '2023-06-30', NULL, '2023-07-28'),
                                                                                                                              (DEFAULT, 40, 52, 2, 'returned', '2023-04-15', '2023-04-22', '2023-04-19');



-- Contact

insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (1, 1, 'sewence0@sphinn.com', '216-603-4694', '826-672-1276');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (2, 2, 'jtoten1@uol.com.br', '332-296-8462', '523-116-5519');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (3, 3, 'salcock2@pen.io', '313-793-4804', '313-339-9990');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (4, 4, 'cstrathman3@stumbleupon.com', '842-781-3557', '471-810-6100');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (5, 5, 'nhardwich4@bluehost.com', '823-693-6623', '964-823-5840');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (6, 6, 'gemberton5@archive.org', '711-826-6149', '955-342-8610');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (7, 7, 'ksadler6@slashdot.org', '350-217-5238', '599-216-6562');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (8, 8, 'astroder7@ucsd.edu', '891-976-5394', '962-259-5238');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (9, 9, 'alamswood8@nbcnews.com', '538-145-3457', '599-504-9899');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (10, 10, 'mblakemore9@washingtonpost.com', '382-263-2882', '141-646-3115');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (11, 11, 'mdupreea@cyberchimps.com', '994-475-2899', '924-656-2053');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (12, 12, 'swrankmoreb@weather.com', '777-475-9003', '261-274-4782');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (13, 13, 'dciricc@lulu.com', '265-123-3064', '170-547-4043');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (14, 14, 'lbeddoed@dropbox.com', '195-354-7387', '321-424-2686');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (15, 15, 'csnodinge@google.co.jp', '955-184-9538', '272-917-5676');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (16, 16, 'cmacellarf@webeden.co.uk', '972-859-8523', '151-555-3830');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (17, 17, 'lgraeserg@state.tx.us', '607-137-8258', '990-517-6987');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (18, 18, 'tdillowayh@foxnews.com', '200-633-4441', '524-942-7603');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (19, 19, 'fbicklei@stumbleupon.com', '959-738-9806', '699-121-7783');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (20, 20, 'esturgej@nature.com', '117-375-5772', '822-258-4503');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (21, 21, 'bivashevk@blogs.com', '127-695-0811', '995-569-6092');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (22, 22, 'bbernolletl@multiply.com', '699-116-0407', '431-780-8459');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (23, 23, 'mbumfordm@disqus.com', '780-456-2891', '493-300-5064');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (24, 24, 'vfaiersn@wix.com', '641-549-1344', '946-376-5359');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (25, 25, 'lwitteyo@wikispaces.com', '333-478-0822', '225-927-7888');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (26, 26, 'bberthelp@amazon.co.jp', '922-913-8622', '287-339-7479');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (27, 27, 'gcadamyq@netlog.com', '529-326-5009', '707-963-4578');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (28, 28, 'tstephensr@edublogs.org', '833-954-9672', '518-779-2504');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (29, 29, 'mgorringes@amazon.de', '528-988-1669', '265-894-0516');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (30, 30, 'sbeddallt@moonfruit.com', '650-109-2117', '969-929-4681');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (31, 31, 'ttyroneu@nsw.gov.au', '820-516-7138', '922-768-0444');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (32, 32, 'eblagbroughv@bravesites.com', '469-723-8880', '819-569-0907');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (33, 33, 'aglennyw@blogspot.com', '617-494-1945', '133-315-7770');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (34, 34, 'hlivezeyx@smh.com.au', '699-886-6441', '203-874-1994');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (35, 35, 'nmatousy@miibeian.gov.cn', '479-744-0889', '824-882-8788');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (36, 36, 'gfeitosaz@freewebs.com', '110-180-8655', '586-265-7236');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (37, 37, 'cclute10@wsj.com', '970-863-4441', '945-627-1003');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (38, 38, 'scrilley11@hostgator.com', '290-158-7722', '902-849-3741');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (39, 39, 'mdillistone12@columbia.edu', '747-626-1512', '251-480-0355');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (40, 40, 'bostick13@networkadvertising.org', '952-659-0402', '306-823-4452');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (41, 41, 'lhaggett14@e-recht24.de', '318-958-2289', '353-881-5387');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (42, 42, 'ypauletti15@techcrunch.com', '363-680-0427', '332-442-1100');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (43, 43, 'etran16@nbcnews.com', '153-578-2538', '270-472-2026');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (44, 44, 'tlegrove17@arstechnica.com', '498-496-4197', '427-699-1244');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (45, 45, 'llongbothom18@shareasale.com', '658-406-9402', '611-533-1090');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (46, 46, 'rsimeon19@army.mil', '162-842-3567', '238-869-5776');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (47, 47, 'cewen1a@hostgator.com', '340-269-6583', '801-362-6551');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (48, 48, 'daland1b@storify.com', '320-218-2366', '859-269-3735');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (49, 49, 'rmasi1c@netscape.com', '499-944-2159', '211-497-1587');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (50, 50, 'nobbard1d@google.de', '217-148-6142', '958-550-9725');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (51, 51, 'mgieves1e@clickbank.net', '942-730-0836', '536-613-4841');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (52, 52, 'nlegrave1f@webeden.co.uk', '717-625-3363', '373-560-7029');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (53, 53, 'kvarvell1g@ning.com', '798-977-9115', '596-443-3692');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (54, 54, 'libert1h@icq.com', '353-769-4516', '150-754-4620');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (55, 55, 'bgreenly1i@fda.gov', '652-138-1567', '189-206-2291');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (56, 56, 'sgate1j@paypal.com', '726-486-1281', '842-355-3419');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (57, 57, 'msivills1k@elegantthemes.com', '137-839-0555', '744-491-1656');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (58, 58, 'lscrange1l@slideshare.net', '364-246-9411', '850-644-3812');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (59, 59, 'mbodemeaid1m@opensource.org', '930-868-7976', '588-811-4581');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (60, 60, 'amapletoft1n@hud.gov', '999-376-3254', '558-308-4261');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (61, 61, 'pboobier1o@godaddy.com', '880-249-6280', '762-191-2031');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (62, 62, 'msarver1p@wordpress.com', '959-127-1247', '207-724-1664');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (63, 63, 'rlogg1q@cmu.edu', '904-143-4714', '708-244-6412');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (64, 64, 'bsibylla1r@tamu.edu', '230-924-8680', '163-427-7242');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (65, 65, 'bcanland1s@devhub.com', '477-300-4169', '871-427-6452');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (66, 66, 'cjostan1t@adobe.com', '568-832-4156', '174-110-5393');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (67, 67, 'dcostello1u@telegraph.co.uk', '139-702-9153', '976-431-3860');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (68, 68, 'rcush1v@hexun.com', '370-325-6484', '804-940-5204');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (69, 69, 'hreasun1w@myspace.com', '503-311-9731', '843-603-6533');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (70, 70, 'mfolbigg1x@gravatar.com', '185-467-2221', '557-622-0198');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (71, 71, 'chinchcliffe1y@dailymail.co.uk', '171-578-2577', '388-373-6514');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (72, 72, 'dforster1z@reference.com', '554-772-4211', '346-352-9679');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (73, 73, 'adufour20@drupal.org', '182-893-6839', '105-332-2868');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (74, 74, 'fcrumbleholme21@freewebs.com', '795-758-7881', '592-479-4178');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (75, 75, 'cedge22@dailymotion.com', '751-441-8521', '108-378-5780');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (76, 76, 'ssmead23@archive.org', '408-232-2192', '378-908-1118');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (77, 77, 'mcossons24@ycombinator.com', '100-410-6610', '707-487-7779');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (78, 78, 'sgatman25@privacy.gov.au', '246-597-7239', '675-109-4728');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (79, 79, 'fporcher26@loc.gov', '380-766-7734', '251-451-1836');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (80, 80, 'tbowton27@ocn.ne.jp', '474-622-4200', '844-713-7711');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (81, 81, 'dkingman28@ocn.ne.jp', '104-485-6743', '996-180-8548');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (82, 82, 'amoss29@amazon.de', '224-396-2468', '843-477-8086');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (83, 83, 'apointin2a@parallels.com', '702-556-2905', '859-977-4385');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (84, 84, 'aghidini2b@cam.ac.uk', '545-281-9510', '370-742-9097');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (85, 85, 'hdeighton2c@cdbaby.com', '431-278-4049', '392-199-9227');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (86, 86, 'cwinder2d@nbcnews.com', '843-780-6967', '979-985-2149');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (87, 87, 'tkopp2e@simplemachines.org', '748-493-0400', '426-923-2280');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (88, 88, 'lkleanthous2f@canalblog.com', '856-819-9585', '801-938-6679');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (89, 89, 'cmiddlewick2g@intel.com', '823-558-9079', '995-511-0198');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (90, 90, 'bgravy2h@redcross.org', '948-129-4389', '729-528-2112');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (91, 91, 'ifroschauer2i@pen.io', '107-883-5901', '371-266-0158');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (92, 92, 'rcolborn2j@t.co', '768-231-6532', '426-384-9566');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (93, 93, 'zbourthoumieux2k@wordpress.org', '543-111-2078', '850-817-1783');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (94, 94, 'mtwine2l@wisc.edu', '245-125-3545', '615-309-8172');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (95, 95, 'jwellfare2m@ifeng.com', '201-527-1067', '482-134-2757');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (96, 96, 'gpettis2n@usnews.com', '724-804-7099', '230-192-3018');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (97, 97, 'tgloves2o@1688.com', '828-440-4201', '827-258-1189');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (98, 98, 'scosslett2p@nymag.com', '119-767-0851', '485-224-7325');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (99, 99, 'gjaze2q@nsw.gov.au', '953-518-7419', '525-375-3902');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (100, 100, 'ghendin2r@yelp.com', '190-945-7342', '109-944-5387');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (101, 101, 'fwikey2s@stanford.edu', '385-850-7807', '215-322-0621');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (102, 102, 'dceschini2t@yellowbook.com', '438-973-8122', '333-617-0087');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (103, 103, 'tjosilowski2u@soup.io', '256-997-2391', '702-831-9466');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (104, 104, 'rrickasse2v@skyrock.com', '823-858-0469', '551-274-9243');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (105, 105, 'bholhouse2w@washington.edu', '631-598-5390', '904-468-7604');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (106, 106, 'kizakov2x@webs.com', '222-298-6730', '154-657-8882');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (107, 107, 'mcursons2y@domainmarket.com', '842-216-1062', '250-239-8710');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (108, 108, 'nbramsen2z@va.gov', '865-952-8467', '977-470-2235');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (109, 109, 'ldummett30@dagondesign.com', '165-336-7401', '296-212-2035');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (110, 110, 'ceustanch31@quantcast.com', '227-177-5253', '887-979-5541');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (111, 111, 'tbacop32@issuu.com', '813-445-9531', '806-478-1781');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (112, 112, 'hjacklin33@wunderground.com', '124-136-4723', '188-161-9343');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (113, 113, 'tdewi34@auda.org.au', '128-146-6386', '644-777-3447');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (114, 114, 'omatovic35@cocolog-nifty.com', '742-947-7045', '478-370-1598');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (115, 115, 'benos36@blinklist.com', '735-871-0213', '147-667-1959');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (116, 116, 'msinton37@shop-pro.jp', '986-152-0526', '981-814-1648');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (117, 117, 'wfranken38@ucoz.com', '957-848-8117', '566-377-0724');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (118, 118, 'naleksankin39@engadget.com', '998-734-8833', '205-867-4415');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (119, 119, 'gmcgrorty3a@answers.com', '551-346-4790', '818-398-6506');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (120, 120, 'wbelchamp3b@adobe.com', '830-375-3329', '156-176-2710');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (121, 121, 'atout3c@wsj.com', '808-736-5754', '954-122-3307');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (122, 122, 'cvillar3d@wisc.edu', '761-881-7856', '154-688-7122');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (123, 123, 'zgrellis3e@ihg.com', '796-446-9966', '562-139-6898');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (124, 124, 'rklausen3f@parallels.com', '522-446-9437', '596-275-4537');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (125, 125, 'ckirlin3g@taobao.com', '453-296-6038', '221-189-4657');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (126, 126, 'gsitwell3h@kickstarter.com', '360-838-7619', '797-226-5281');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (127, 127, 'apitson3i@topsy.com', '672-151-4703', '880-767-4769');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (128, 128, 'vbrunotti3j@symantec.com', '962-952-6900', '490-871-4101');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (129, 129, 'vmacaskill3k@blogs.com', '698-724-7277', '436-186-0621');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (130, 130, 'rschroter3l@photobucket.com', '806-540-1741', '929-802-7818');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (131, 131, 'rbalcers3m@woothemes.com', '929-729-0880', '467-312-5958');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (132, 132, 'lexall3n@google.co.jp', '363-344-4225', '642-485-8923');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (133, 133, 'atomisch3o@instagram.com', '961-194-9685', '451-652-2083');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (134, 134, 'ajulyan3p@stumbleupon.com', '520-330-0767', '351-580-2498');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (135, 135, 'rmckeevers3q@google.de', '734-681-4655', '303-354-8169');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (136, 136, 'atrood3r@howstuffworks.com', '323-314-4946', '700-345-2595');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (137, 137, 'agrayling3s@microsoft.com', '873-226-6624', '679-394-9361');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (138, 138, 'dbodesson3t@icio.us', '316-838-6496', '764-548-7208');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (139, 139, 'hwoolrich3u@nps.gov', '901-329-6121', '709-449-9635');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (140, 140, 'kbridal3v@wordpress.com', '493-255-3432', '691-783-9568');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (141, 141, 'dfrichley3w@mapy.cz', '430-651-6220', '585-558-0764');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (142, 142, 'imatteau3x@pinterest.com', '125-489-6463', '799-432-7372');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (143, 143, 'rmackriell3y@yelp.com', '657-572-4372', '331-754-7078');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (144, 144, 'srosenfield3z@archive.org', '102-816-1691', '273-278-3927');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (145, 145, 'dashborne40@google.cn', '717-162-0931', '418-163-5894');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (146, 146, 'cmosdell41@engadget.com', '968-289-1545', '420-151-2255');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (147, 147, 'fgrichukhanov42@cafepress.com', '622-536-5091', '504-795-2619');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (148, 148, 'jmawman43@columbia.edu', '650-404-1481', '802-523-5022');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (149, 149, 'jdelayglesias44@microsoft.com', '647-250-5841', '569-861-5306');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (150, 150, 'cglacken45@upenn.edu', '305-482-3004', '803-887-4599');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (151, 151, 'rmarr46@gizmodo.com', '436-926-8583', '816-597-1058');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (152, 152, 'afrancke47@columbia.edu', '439-238-3860', '828-426-5364');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (153, 153, 'pference48@ow.ly', '547-360-3020', '595-503-1288');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (154, 154, 'bterney49@ox.ac.uk', '890-582-7585', '732-472-0691');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (155, 155, 'lmatis4a@fc2.com', '252-792-5824', '591-447-1116');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (156, 156, 'vquarrell4b@studiopress.com', '361-126-6762', '157-467-9303');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (157, 157, 'bbeauchop4c@google.pl', '625-715-8234', '786-699-0293');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (158, 158, 'imillichap4d@slashdot.org', '440-430-2038', '964-370-9361');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (159, 159, 'jbeeke4e@shinystat.com', '994-922-9671', '191-144-6004');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (160, 160, 'mtorresi4f@bigcartel.com', '908-273-8123', '323-768-2418');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (161, 161, 'awalkowski4g@diigo.com', '908-281-8540', '333-529-6281');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (162, 162, 'wmillard4h@jimdo.com', '417-359-0774', '534-260-4915');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (163, 163, 'cgreed4i@bloglovin.com', '594-531-2576', '297-547-0874');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (164, 164, 'rgurton4j@google.it', '335-114-4782', '516-832-8826');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (165, 165, 'ekauble4k@wordpress.org', '762-789-5875', '692-540-2067');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (166, 166, 'wbrophy4l@wix.com', '328-261-0998', '810-131-8673');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (167, 167, 'bhansell4m@columbia.edu', '214-952-3975', '897-492-9000');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (168, 168, 'fskirlin4n@archive.org', '156-695-6235', '869-872-3092');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (169, 169, 'ltitcom4o@sfgate.com', '408-969-7225', '119-219-6564');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (170, 170, 'gmedmore4p@google.pl', '947-100-2031', '389-886-7668');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (171, 171, 'crenwick4q@about.com', '444-211-9572', '345-518-7044');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (172, 172, 'shackney4r@blog.com', '154-893-1342', '620-154-3700');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (173, 173, 'cmckeggie4s@ucoz.ru', '547-652-8774', '143-812-4492');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (174, 174, 'rclinnick4t@nsw.gov.au', '704-995-2357', '431-913-9518');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (175, 175, 'ktwidale4u@altervista.org', '609-311-1983', '389-351-5437');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (176, 176, 'kszachniewicz4v@opensource.org', '451-773-1582', '951-368-3369');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (177, 177, 'lscragg4w@time.com', '912-338-4014', '733-943-4473');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (178, 178, 'lharcase4x@jigsy.com', '524-851-0477', '294-782-0791');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (179, 179, 'blayborn4y@uol.com.br', '478-434-1233', '958-290-5904');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (180, 180, 'cricciardelli4z@liveinternet.ru', '516-364-5823', '867-998-9103');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (181, 181, 'etrustie50@craigslist.org', '679-138-5587', '144-563-1198');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (182, 182, 'bdowdam51@tripadvisor.com', '974-103-9456', '443-741-2778');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (183, 183, 'hroles52@opera.com', '671-241-5532', '296-967-2669');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (184, 184, 'jridsdale53@washington.edu', '491-459-2960', '936-704-7431');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (185, 185, 'molwen54@newyorker.com', '933-751-4191', '876-505-0824');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (186, 186, 'nbeagan55@nbcnews.com', '768-387-1245', '263-857-9546');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (187, 187, 'fgruczka56@census.gov', '749-179-0930', '706-933-9899');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (188, 188, 'tscartifield57@cnn.com', '522-703-3491', '424-221-0875');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (189, 189, 'bboyne58@4shared.com', '887-503-6043', '214-742-1541');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (190, 190, 'dclowney59@google.ca', '485-550-5200', '589-726-7592');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (191, 191, 'lbrydon5a@studiopress.com', '626-885-2323', '490-834-0064');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (192, 192, 'gswaisland5b@vistaprint.com', '136-527-2778', '712-442-2429');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (193, 193, 'gpumfrey5c@mediafire.com', '495-396-6909', '577-208-5679');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (194, 194, 'shaveline5d@techcrunch.com', '341-873-2495', '631-249-7229');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (195, 195, 'bhauch5e@odnoklassniki.ru', '590-473-2845', '842-482-0358');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (196, 196, 'tyeatman5f@washingtonpost.com', '854-303-8523', '899-416-6022');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (197, 197, 'wollarenshaw5g@patch.com', '472-458-4685', '286-277-7394');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (198, 198, 'rmillsap5h@t.co', '485-182-3500', '697-354-1152');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (199, 199, 'dbreen5i@buzzfeed.com', '327-375-6323', '774-876-8918');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (200, 200, 'shellard5j@jiathis.com', '233-892-8915', '202-883-3974');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (201, 201, 'kdenmead5k@gnu.org', '467-289-6632', '976-502-6477');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (202, 202, 'fbown5l@pbs.org', '651-829-7779', '136-133-1884');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (203, 203, 'alisamore5m@t-online.de', '605-802-1336', '943-438-6108');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (204, 204, 'jfantini5n@indiatimes.com', '742-854-7959', '435-567-4044');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (205, 205, 'ascholler5o@hhs.gov', '877-836-5708', '887-290-5771');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (206, 206, 'omacleod5p@businessinsider.com', '826-308-0461', '539-557-6171');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (207, 207, 'jhupka5q@blinklist.com', '530-310-9300', '432-976-2362');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (208, 208, 'kboulger5r@xrea.com', '237-595-8418', '988-844-0351');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (209, 209, 'pantoni5s@artisteer.com', '718-906-0863', '470-349-6038');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (210, 210, 'gmuttitt5t@aboutads.info', '934-849-3766', '313-661-0194');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (211, 211, 'dmatysik5u@xrea.com', '694-472-6828', '363-480-1897');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (212, 212, 'emackereth5v@squarespace.com', '675-320-9539', '235-585-8742');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (213, 213, 'ggoublier5w@topsy.com', '410-162-2896', '729-221-5322');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (214, 214, 'ldahlen5x@va.gov', '334-727-6610', '892-186-6792');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (215, 215, 'jluberti5y@unesco.org', '138-499-3532', '379-365-1863');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (216, 216, 'ecapelow5z@telegraph.co.uk', '912-122-0040', '256-652-9321');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (217, 217, 'backwood60@discovery.com', '305-219-7816', '460-355-7806');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (218, 218, 'mpeake61@sina.com.cn', '540-176-2670', '994-662-6051');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (219, 219, 'adressell62@stumbleupon.com', '412-334-0693', '445-433-1144');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (220, 220, 'ndomek63@parallels.com', '297-633-7472', '104-611-2155');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (221, 221, 'msollitt64@slideshare.net', '959-156-8709', '361-277-7854');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (222, 222, 'zsanthouse65@clickbank.net', '220-626-0930', '197-994-8626');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (223, 223, 'gfigurski66@csmonitor.com', '249-843-2716', '788-456-9596');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (224, 224, 'fbean67@livejournal.com', '978-310-9509', '443-846-1733');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (225, 225, 'daleksandrov68@webnode.com', '332-208-3834', '496-630-4157');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (226, 226, 'hholde69@parallels.com', '852-885-2106', '754-352-9814');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (227, 227, 'sbowsher6a@tinypic.com', '140-228-0534', '967-214-3413');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (228, 228, 'kantonetti6b@un.org', '697-858-8919', '717-532-1394');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (229, 229, 'mstonefewings6c@oracle.com', '906-933-3737', '609-837-6884');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (230, 230, 'mfutcher6d@vk.com', '793-482-9497', '803-927-4227');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (231, 231, 'tspenceley6e@ifeng.com', '914-323-4348', '785-878-1322');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (232, 232, 'phanmer6f@fda.gov', '962-770-3664', '635-814-0729');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (233, 233, 'cedlyn6g@php.net', '486-756-0015', '602-358-0717');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (234, 234, 'dbarnardo6h@chronoengine.com', '213-707-7737', '218-287-3826');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (235, 235, 'ascurr6i@opensource.org', '802-515-8132', '964-767-7622');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (236, 236, 'kuccelli6j@nydailynews.com', '271-971-7386', '761-983-1148');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (237, 237, 'egatrell6k@icq.com', '174-685-1492', '840-594-7217');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (238, 238, 'scarnegie6l@ask.com', '732-390-5380', '142-818-4366');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (239, 239, 'mdowyer6m@cam.ac.uk', '490-514-5681', '329-289-9440');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (240, 240, 'dcollomosse6n@tumblr.com', '541-796-6178', '549-786-1344');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (241, 241, 'mloraine6o@engadget.com', '158-861-9129', '291-482-8720');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (242, 242, 'fdeighton6p@nbcnews.com', '524-538-8507', '815-472-6667');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (243, 243, 'mmccloid6q@slideshare.net', '343-507-2964', '226-221-9204');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (244, 244, 'bfricker6r@businessweek.com', '173-824-1121', '638-332-1104');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (245, 245, 'saspel6s@opera.com', '493-992-0919', '889-151-1952');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (246, 246, 'cwhitham6t@answers.com', '931-413-6505', '896-980-8401');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (247, 247, 'aphizackerly6u@hubpages.com', '954-787-1142', '238-228-6745');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (248, 248, 'mlindmark6v@imageshack.us', '263-256-4814', '298-399-7539');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (249, 249, 'rgrason6w@slashdot.org', '791-229-6379', '470-982-9411');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (250, 250, 'pcorwin6x@odnoklassniki.ru', '162-233-2445', '250-178-3392');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (251, 251, 'erapps6y@prlog.org', '715-796-7387', '635-386-8303');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (252, 252, 'gheenan6z@amazon.co.jp', '795-907-0641', '618-952-7265');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (253, 253, 'rstonebridge70@google.co.jp', '666-227-4085', '120-707-6751');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (254, 254, 'ejindra71@live.com', '200-970-2557', '433-114-3471');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (255, 255, 'ematushenko72@ezinearticles.com', '685-929-9434', '883-770-0626');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (256, 256, 'spitherick73@angelfire.com', '347-462-3892', '564-994-7918');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (257, 257, 'kblakely74@cnet.com', '217-606-0846', '313-432-5840');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (258, 258, 'dbenkhe75@typepad.com', '393-416-9538', '943-966-7048');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (259, 259, 'adominetti76@nydailynews.com', '905-541-3220', '653-816-6688');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (260, 260, 'ctearny77@adobe.com', '381-927-2964', '222-475-7720');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (261, 261, 'lbetts78@moonfruit.com', '590-346-1183', '309-743-8987');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (262, 262, 'ccocci79@cbslocal.com', '918-119-8891', '295-367-9789');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (263, 263, 'bwasbrough7a@networkadvertising.org', '792-916-9874', '548-272-6028');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (264, 264, 'ocarthew7b@unesco.org', '175-904-8850', '827-241-4566');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (265, 265, 'gdunsire7c@tumblr.com', '700-288-1710', '515-393-6807');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (266, 266, 'mprettyjohns7d@bigcartel.com', '832-734-2056', '319-587-6985');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (267, 267, 'wfinch7e@arizona.edu', '370-515-9942', '393-266-7866');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (268, 268, 'ebehling7f@diigo.com', '591-604-2424', '573-179-1648');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (269, 269, 'jpallesen7g@example.com', '659-559-2844', '773-430-5713');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (270, 270, 'bhasard7h@about.me', '354-363-7089', '931-851-9134');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (271, 271, 'aboner7i@chronoengine.com', '120-258-0483', '608-669-2972');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (272, 272, 'cedelston7j@admin.ch', '703-888-2753', '921-905-8689');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (273, 273, 'ahusbands7k@storify.com', '430-445-2573', '813-139-6692');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (274, 274, 'apiletic7l@4shared.com', '548-967-7826', '887-748-7906');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (275, 275, 'ljemmett7m@booking.com', '364-716-6106', '790-233-5140');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (276, 276, 'nlunny7n@facebook.com', '931-634-4572', '961-891-1265');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (277, 277, 'wtremmil7o@reference.com', '519-346-1509', '546-910-4570');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (278, 278, 'hgentle7p@bluehost.com', '892-126-2813', '676-246-0394');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (279, 279, 'bseagood7q@webeden.co.uk', '541-224-3316', '110-738-1402');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (280, 280, 'cdrees7r@accuweather.com', '762-788-5145', '297-169-6155');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (281, 281, 'mdominy7s@altervista.org', '706-184-7761', '604-132-4024');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (282, 282, 'dceely7t@facebook.com', '520-755-4353', '503-296-6113');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (283, 283, 'seccles7u@ezinearticles.com', '282-338-5091', '617-628-0802');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (284, 284, 'kfarrants7v@samsung.com', '884-777-1885', '544-886-5214');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (285, 285, 'stwaits7w@wordpress.com', '760-148-3280', '878-898-1848');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (286, 286, 'kstrike7x@plala.or.jp', '560-556-4985', '107-875-8163');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (287, 287, 'rgatlin7y@tiny.cc', '325-605-4333', '391-847-2794');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (288, 288, 'alandall7z@ezinearticles.com', '737-443-3357', '983-634-5605');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (289, 289, 'dspringtorp80@washington.edu', '575-133-2420', '791-185-1532');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (290, 290, 'mcornelius81@whitehouse.gov', '299-617-0443', '513-889-1466');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (291, 291, 'cdyka82@is.gd', '263-279-5137', '418-714-4152');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (292, 292, 'tbirtwisle83@youku.com', '783-653-2916', '576-415-7218');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (293, 293, 'adriuzzi84@earthlink.net', '227-460-6727', '731-507-5816');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (294, 294, 'cchaffey85@samsung.com', '792-747-2452', '554-685-5746');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (295, 295, 'jragbourne86@reverbnation.com', '321-736-4701', '547-232-6811');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (296, 296, 'crignall87@nps.gov', '989-242-6376', '326-116-9664');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (297, 297, 'tlaba88@blogs.com', '130-994-0727', '227-292-7112');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (298, 298, 'nandresser89@hubpages.com', '873-370-4077', '196-462-7034');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (299, 299, 'ogowans8a@sbwire.com', '439-394-8447', '684-684-6679');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (300, 300, 'lskillicorn8b@jiathis.com', '920-336-4217', '388-186-8958');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (301, 301, 'pscorey8c@nifty.com', '450-544-9943', '702-257-5991');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (302, 302, 'tdumper8d@pagesperso-orange.fr', '589-922-0120', '785-741-8858');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (303, 303, 'frameau8e@twitter.com', '498-685-2649', '711-520-0515');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (304, 304, 'nmaven8f@google.fr', '975-465-3058', '318-665-1530');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (305, 305, 'aharmour8g@amazon.com', '274-122-3500', '777-465-2870');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (306, 306, 'rruncie8h@weebly.com', '502-161-4819', '175-214-0647');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (307, 307, 'khadaway8i@seesaa.net', '824-296-8559', '459-452-9658');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (308, 308, 'egooderham8j@clickbank.net', '684-899-5057', '138-148-8697');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (309, 309, 'vmcvrone8k@howstuffworks.com', '308-202-9450', '120-177-1675');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (310, 310, 'jhaine8l@senate.gov', '697-116-4460', '329-399-6269');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (311, 311, 'bmathie8m@cocolog-nifty.com', '413-123-3047', '488-722-2474');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (312, 312, 'ckildea8n@va.gov', '764-927-1624', '581-995-6304');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (313, 313, 'mwickling8o@xing.com', '406-299-8575', '139-853-1763');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (314, 314, 'mjeffels8p@cornell.edu', '369-216-3873', '698-880-9742');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (315, 315, 'bkimblin8q@rediff.com', '607-194-1231', '425-871-3214');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (316, 316, 'lmaccrae8r@meetup.com', '459-780-4685', '231-479-4677');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (317, 317, 'mhawtry8s@hud.gov', '337-339-4189', '503-600-6832');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (318, 318, 'kflintoff8t@ow.ly', '854-801-7145', '939-726-2625');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (319, 319, 'sgrocock8u@123-reg.co.uk', '995-803-1549', '582-325-1007');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (320, 320, 'kkeyme8v@themeforest.net', '608-291-4919', '621-305-0710');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (321, 321, 'ltonge8w@google.com.hk', '715-119-6117', '270-917-9397');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (322, 322, 'aellaman8x@rediff.com', '704-757-7595', '648-628-4877');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (323, 323, 'fsinkings8y@dion.ne.jp', '340-627-5972', '431-352-7056');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (324, 324, 'btooze8z@twitpic.com', '173-118-1130', '484-941-9449');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (325, 325, 'tturnell90@marriott.com', '262-419-0130', '182-254-1145');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (326, 326, 'tjoliffe91@printfriendly.com', '383-476-1656', '781-667-3388');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (327, 327, 'fgilbane92@bravesites.com', '254-748-7500', '412-449-3893');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (328, 328, 'cbreakwell93@1688.com', '941-873-1782', '175-430-9361');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (329, 329, 'dbowdery94@yale.edu', '504-555-9791', '499-555-7049');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (330, 330, 'sturle95@blinklist.com', '109-493-7276', '762-716-3197');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (331, 331, 'gmccreery96@thetimes.co.uk', '737-813-9113', '902-207-2603');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (332, 332, 'khuie97@apache.org', '336-604-3461', '118-442-6666');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (333, 333, 'rcannam98@wikia.com', '867-491-3365', '903-839-8020');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (334, 334, 'crosel99@archive.org', '507-207-0936', '883-588-7297');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (335, 335, 'rnoweak9a@instagram.com', '482-716-4838', '488-580-6329');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (336, 336, 'dluckin9b@blogger.com', '345-640-2891', '920-970-3558');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (337, 337, 'troebuck9c@netvibes.com', '141-342-3908', '623-228-4492');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (338, 338, 'kdrage9d@samsung.com', '519-592-3038', '771-282-8956');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (339, 339, 'nmountjoy9e@hibu.com', '855-431-4968', '591-149-1218');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (340, 340, 'imailey9f@house.gov', '940-573-3518', '658-277-9649');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (341, 341, 'mekell9g@tinyurl.com', '304-523-9839', '615-586-4920');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (342, 342, 'pabels9h@weather.com', '965-640-2751', '485-307-9177');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (343, 343, 'wcorpes9i@yahoo.co.jp', '346-846-3752', '223-263-1419');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (344, 344, 'twestberg9j@umich.edu', '292-604-4590', '206-737-3901');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (345, 345, 'acrathorne9k@live.com', '990-174-7176', '487-421-7304');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (346, 346, 'jhulles9l@booking.com', '683-836-9536', '237-484-4212');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (347, 347, 'lmoger9m@google.com.hk', '721-357-6725', '794-988-9856');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (348, 348, 'klambourn9n@msu.edu', '477-403-4334', '101-487-6675');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (349, 349, 'crelfe9o@domainmarket.com', '484-254-6280', '193-837-9078');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (350, 350, 'kkennan9p@topsy.com', '291-652-1324', '651-413-3541');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (351, 351, 'sfrail9q@smh.com.au', '227-609-1068', '228-439-5881');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (352, 352, 'agonnel9r@tuttocitta.it', '878-471-3874', '916-478-7934');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (353, 353, 'wainslee9s@baidu.com', '514-141-2374', '656-846-0666');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (354, 354, 'morbine9t@istockphoto.com', '804-551-0631', '729-456-2940');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (355, 355, 'aroarty9u@miitbeian.gov.cn', '852-425-1602', '247-993-1386');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (356, 356, 'charrill9v@washingtonpost.com', '513-468-6230', '506-217-0694');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (357, 357, 'ecrew9w@nationalgeographic.com', '444-984-1939', '619-213-0287');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (358, 358, 'jickovitz9x@cpanel.net', '251-282-5436', '169-600-7039');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (359, 359, 'ualcide9y@bigcartel.com', '703-413-7558', '744-292-6845');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (360, 360, 'metherington9z@newsvine.com', '563-440-9281', '766-560-9807');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (361, 361, 'rwarriera0@spotify.com', '454-643-9157', '942-258-7541');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (362, 362, 'zhacksbya1@miitbeian.gov.cn', '334-246-8740', '957-716-9914');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (363, 363, 'vbansteada2@un.org', '884-990-4956', '155-486-2028');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (364, 364, 'femtagea3@cbslocal.com', '379-711-4801', '700-543-8371');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (365, 365, 'gbritnella4@patch.com', '288-307-0294', '989-700-5708');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (366, 366, 'ifallaa5@npr.org', '118-379-9983', '478-780-5517');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (367, 367, 'schallicombea6@who.int', '207-524-8546', '226-122-0714');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (368, 368, 'fwhetsona7@cbslocal.com', '644-740-7678', '218-365-8360');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (369, 369, 'ltolomioa8@typepad.com', '414-184-0339', '230-143-6034');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (370, 370, 'srentcomea9@soundcloud.com', '683-161-5077', '109-484-4021');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (371, 371, 'hrignoldaa@plala.or.jp', '538-149-3903', '213-745-3269');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (372, 372, 'pbasileab@i2i.jp', '141-491-8982', '688-536-9958');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (373, 373, 'jaubrayac@msu.edu', '849-933-2683', '975-998-7033');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (374, 374, 'murianad@about.me', '110-618-6373', '857-809-2041');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (375, 375, 'bbrodwayae@cocolog-nifty.com', '257-162-4483', '837-719-8896');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (376, 376, 'cminilloaf@archive.org', '179-219-0643', '914-418-6615');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (377, 377, 'fshortoag@harvard.edu', '800-382-9752', '970-867-5262');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (378, 378, 'agodwynah@amazon.com', '618-113-3603', '630-501-0015');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (379, 379, 'kackensonai@cpanel.net', '964-494-1958', '401-346-1102');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (380, 380, 'fgiannottiaj@usda.gov', '441-536-7345', '117-129-0827');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (381, 381, 'swicksteadak@cisco.com', '902-806-8045', '733-255-1328');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (382, 382, 'jbraamsal@weibo.com', '523-889-6650', '734-955-5974');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (383, 383, 'amcsperronam@cargocollective.com', '561-920-3946', '941-833-0323');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (384, 384, 'kmillieran@addthis.com', '688-270-6591', '158-467-4813');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (385, 385, 'dburkillao@bbc.co.uk', '845-565-7044', '180-332-2555');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (386, 386, 'imyrickap@instagram.com', '337-513-9860', '714-305-6790');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (387, 387, 'jmacgauhyaq@alibaba.com', '902-350-9394', '383-464-3598');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (388, 388, 'sbyllamar@tinyurl.com', '946-545-3014', '658-216-6598');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (389, 389, 'awilcinskisas@desdev.cn', '238-564-4648', '711-308-2762');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (390, 390, 'dnockallsat@sina.com.cn', '139-783-2067', '395-196-1536');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (391, 391, 'bsimonuttiau@quantcast.com', '928-808-2376', '706-341-5654');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (392, 392, 'wglavinav@istockphoto.com', '147-450-3241', '763-966-3980');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (393, 393, 'ktofftsaw@xrea.com', '836-411-0997', '474-896-3890');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (394, 394, 'jhagyardax@ucoz.com', '581-342-7103', '579-630-1700');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (395, 395, 'ncoppockay@vk.com', '335-902-0035', '751-508-4514');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (396, 396, 'ndenzilowaz@walmart.com', '434-859-7818', '746-279-3824');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (397, 397, 'blefebreb0@tmall.com', '637-316-6785', '413-626-6594');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (398, 398, 'cnormandb1@archive.org', '937-865-4482', '143-612-1229');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (399, 399, 'kswabeyb2@liveinternet.ru', '315-955-3652', '281-702-3290');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (400, 400, 'wkilgallonb3@youtu.be', '924-824-8642', '592-379-4655');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (401, 401, 'cnanib4@cmu.edu', '975-158-4524', '342-244-4824');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (402, 402, 'ghollebonb5@yelp.com', '607-920-9272', '137-888-0814');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (403, 403, 'shannabussb6@fastcompany.com', '185-586-3415', '315-448-1131');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (404, 404, 'rriversb7@bandcamp.com', '807-391-7161', '489-270-6280');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (405, 405, 'scanningsb8@psu.edu', '387-650-9037', '711-208-9503');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (406, 406, 'bschwandnerb9@weebly.com', '168-999-8317', '988-391-9088');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (407, 407, 'vfranchioniba@dedecms.com', '727-456-6377', '294-297-9077');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (408, 408, 'jbohlingolsenbb@salon.com', '935-645-9416', '787-754-1468');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (409, 409, 'tgerritzenbc@nyu.edu', '984-636-7438', '157-443-4861');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (410, 410, 'lredrupbd@amazon.com', '614-746-0794', '210-484-5583');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (411, 411, 'csibbebe@squarespace.com', '385-146-0994', '592-663-5894');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (412, 412, 'dbolsteridgebf@time.com', '151-153-5726', '893-340-4006');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (413, 413, 'vcamillobg@newsvine.com', '832-130-5944', '217-631-9874');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (414, 414, 'mjoslandbh@smh.com.au', '467-959-2576', '774-978-3900');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (415, 415, 'sspurgeonbi@canalblog.com', '928-709-7859', '429-998-8603');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (416, 416, 'ccolliarbj@nba.com', '283-559-0600', '233-361-0178');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (417, 417, 'sselcraigbk@sun.com', '247-219-8143', '937-537-1904');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (418, 418, 'rrubbensbl@bandcamp.com', '236-654-7774', '547-961-8496');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (419, 419, 'cjanawaybm@reverbnation.com', '934-196-0269', '691-925-7254');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (420, 420, 'tdewickebn@dailymotion.com', '416-970-8015', '237-102-4947');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (421, 421, 'ccellibo@drupal.org', '554-768-2781', '511-913-5224');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (422, 422, 'bpetrulisbp@msu.edu', '952-807-1166', '411-684-6449');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (423, 423, 'dfrancesconebq@drupal.org', '948-480-6763', '597-501-5672');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (424, 424, 'tbushellbr@indiatimes.com', '613-274-8191', '658-308-3258');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (425, 425, 'cwolseybs@topsy.com', '123-915-9752', '723-637-7531');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (426, 426, 'nwillmorebt@shinystat.com', '439-272-8953', '620-728-5660');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (427, 427, 'negertonbu@list-manage.com', '396-571-4044', '129-985-3155');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (428, 428, 'jhuddlestonebv@devhub.com', '366-971-7614', '831-973-7073');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (429, 429, 'thowsdenbw@devhub.com', '398-359-5152', '612-967-4879');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (430, 430, 'jkenninghanbx@shinystat.com', '821-495-4021', '893-278-6814');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (431, 431, 'pangearby@state.tx.us', '408-919-4583', '409-533-9369');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (432, 432, 'jholehousebz@springer.com', '180-147-0634', '389-714-3209');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (433, 433, 'lfortnumc0@typepad.com', '129-849-9908', '768-241-6841');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (434, 434, 'jpalserc1@chicagotribune.com', '437-309-6555', '361-591-7378');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (435, 435, 'cduforec2@stanford.edu', '597-930-2764', '681-760-5751');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (436, 436, 'kandrockc3@ihg.com', '248-858-0597', '306-793-6747');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (437, 437, 'eburdgec4@ucsd.edu', '602-470-1273', '321-378-2613');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (438, 438, 'rrandlesc5@scientificamerican.com', '501-266-1556', '255-534-8943');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (439, 439, 'mdebnamc6@facebook.com', '703-654-4873', '913-264-1125');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (440, 440, 'epagninc7@craigslist.org', '582-919-3420', '851-317-6836');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (441, 441, 'cjimmisonc8@yale.edu', '335-840-5223', '872-541-5296');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (442, 442, 'mkortingc9@phpbb.com', '929-842-4941', '492-105-1571');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (443, 443, 'apaineca@jugem.jp', '719-883-1987', '773-762-1105');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (444, 444, 'estickinscb@census.gov', '389-665-3695', '931-577-5235');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (445, 445, 'vmcawcc@discuz.net', '748-686-2860', '407-443-0699');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (446, 446, 'apilkintoncd@yellowbook.com', '961-422-5677', '817-153-3204');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (447, 447, 'oweatherleyce@wikia.com', '309-803-9757', '503-905-1701');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (448, 448, 'banthoincf@facebook.com', '969-279-2106', '926-580-9413');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (449, 449, 'lebycg@goo.ne.jp', '944-225-4161', '450-673-9279');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (450, 450, 'braddench@webs.com', '311-556-9345', '408-432-7846');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (451, 451, 'fgodartci@fema.gov', '579-425-4198', '754-896-3740');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (452, 452, 'acollumcj@mapy.cz', '281-181-0293', '362-596-9505');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (453, 453, 'dcohaneck@pcworld.com', '909-672-8323', '819-630-2729');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (454, 454, 'llorkingscl@goo.gl', '494-294-3161', '730-532-5472');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (455, 455, 'clilescm@tiny.cc', '914-259-8640', '365-846-2954');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (456, 456, 'jnettlecn@deliciousdays.com', '999-464-7247', '466-646-3872');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (457, 457, 'odownieco@youku.com', '437-498-5433', '617-175-7361');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (458, 458, 'mpitmancp@jugem.jp', '171-329-4784', '813-713-5961');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (459, 459, 'abazellcq@csmonitor.com', '122-260-8247', '132-571-5809');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (460, 460, 'fhebditchcr@1688.com', '822-128-3832', '238-910-4236');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (461, 461, 'bhachardcs@ox.ac.uk', '977-697-7447', '226-151-0832');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (462, 462, 'gdikelsct@t-online.de', '169-589-8357', '214-947-7772');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (463, 463, 'crobjantcu@webs.com', '773-149-0443', '461-233-7305');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (464, 464, 'rsealycv@goodreads.com', '579-981-2487', '921-328-4842');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (465, 465, 'ctartcw@hatena.ne.jp', '510-902-7581', '720-794-6943');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (466, 466, 'tanglesscx@storify.com', '436-871-9409', '262-964-0895');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (467, 467, 'acastiglionicy@xrea.com', '633-970-0337', '345-618-0168');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (468, 468, 'aholhousecz@cmu.edu', '648-483-8708', '407-182-9247');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (469, 469, 'dmartinetsd0@nymag.com', '939-733-3940', '420-299-9896');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (470, 470, 'hbonehamd1@blogtalkradio.com', '939-526-3235', '268-800-0727');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (471, 471, 'jsimenond2@sogou.com', '699-701-7020', '781-832-6426');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (472, 472, 'mespinasd3@usnews.com', '500-324-9719', '298-670-3802');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (473, 473, 'crazouxd4@list-manage.com', '600-185-3848', '821-395-3937');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (474, 474, 'uweedond5@springer.com', '146-857-9216', '993-661-2266');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (475, 475, 'lfuged6@mediafire.com', '508-564-3479', '804-730-8776');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (476, 476, 'jdeaved7@columbia.edu', '213-532-4796', '220-523-2358');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (477, 477, 'omacnabd8@vkontakte.ru', '748-776-3269', '217-180-1505');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (478, 478, 'ahinchshawd9@boston.com', '964-558-0741', '507-463-8273');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (479, 479, 'cpurringtonda@mtv.com', '243-565-4793', '205-985-3741');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (480, 480, 'lgavahandb@narod.ru', '579-793-8706', '640-815-1274');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (481, 481, 'kgotherdc@youku.com', '289-238-0751', '794-967-6085');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (482, 482, 'msiemanteldd@flavors.me', '467-516-6665', '847-820-1244');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (483, 483, 'driccardde@theguardian.com', '233-610-5577', '569-669-5506');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (484, 484, 'ctarplydf@gnu.org', '470-182-9040', '443-201-7701');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (485, 485, 'jbouskilldg@bloomberg.com', '213-147-6616', '977-775-1110');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (486, 486, 'sridesdh@wikimedia.org', '753-371-2582', '634-811-9377');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (487, 487, 'cdumsdaydi@simplemachines.org', '910-879-9344', '561-571-7885');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (488, 488, 'mcastelluzzidj@weather.com', '198-537-0150', '193-730-8794');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (489, 489, 'jlghandk@boston.com', '919-487-2749', '261-751-8060');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (490, 490, 'cbeechdl@digg.com', '582-698-2565', '616-440-8509');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (491, 491, 'mashnessdm@artisteer.com', '464-943-9747', '298-520-2468');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (492, 492, 'bcheccidn@fc2.com', '510-633-0653', '468-969-5927');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (493, 493, 'amichelldo@nsw.gov.au', '149-556-9692', '339-458-1096');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (494, 494, 'fhandasydedp@weather.com', '397-876-4850', '997-754-2011');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (495, 495, 'apfliegerdq@columbia.edu', '147-857-5087', '909-153-9114');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (496, 496, 'dbiddydr@oakley.com', '329-361-8921', '805-554-6301');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (497, 497, 'mstanyardds@dot.gov', '448-259-7444', '614-820-3019');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (498, 498, 'grotterydt@hibu.com', '187-260-6033', '941-485-4929');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (499, 499, 'scescotidu@globo.com', '271-780-6260', '944-196-2314');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (500, 500, 'mmytondv@cbsnews.com', '282-587-8762', '887-314-0303');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (501, 501, 'kstronoughdw@salon.com', '664-394-9878', '102-903-5322');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (502, 502, 'knagledx@webmd.com', '595-746-3782', '207-645-2251');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (503, 503, 'cparkmandy@pcworld.com', '931-983-9069', '721-683-4835');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (504, 504, 'fcartledgedz@icio.us', '517-591-2676', '197-339-9713');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (505, 505, 'hpimlette0@prweb.com', '350-316-3856', '557-277-9253');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (506, 506, 'dpreshouse1@taobao.com', '887-179-5883', '409-670-3190');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (507, 507, 'dfennee2@infoseek.co.jp', '179-548-4980', '336-570-5295');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (508, 508, 'mdeeke3@shareasale.com', '391-709-8142', '546-885-6821');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (509, 509, 'lsaverye4@technorati.com', '919-426-1601', '147-200-8363');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (510, 510, 'dquittondene5@cafepress.com', '719-438-8527', '184-769-3668');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (511, 511, 'kbicknelle6@wikia.com', '445-358-8942', '843-551-3733');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (512, 512, 'whartrighte7@baidu.com', '244-881-2811', '367-542-9760');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (513, 513, 'lsibbite8@blinklist.com', '479-874-7572', '357-982-2212');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (514, 514, 'ablundane9@nationalgeographic.com', '549-274-6943', '873-468-8307');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (515, 515, 'tbartosinskiea@google.nl', '159-613-5192', '844-107-8156');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (516, 516, 'lbelloweb@friendfeed.com', '746-620-9468', '487-115-7398');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (517, 517, 'dsavinec@twitter.com', '673-473-4987', '382-570-2656');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (518, 518, 'lfrostdykeed@ed.gov', '713-196-8857', '730-478-5222');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (519, 519, 'iklimukee@google.co.uk', '413-566-5875', '604-542-1642');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (520, 520, 'crushsorthef@mit.edu', '831-362-6640', '390-777-6062');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (521, 521, 'abookereg@vinaora.com', '252-282-1836', '791-160-8367');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (522, 522, 'cfaivreeh@acquirethisname.com', '894-697-8470', '784-667-8270');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (523, 523, 'rpoynorei@walmart.com', '947-600-6626', '187-313-7358');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (524, 524, 'nmattackej@jimdo.com', '916-285-2675', '800-122-7563');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (525, 525, 'ecornwallek@fda.gov', '461-488-2755', '261-100-9653');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (526, 526, 'ostummeyerel@com.com', '442-665-8669', '965-284-2417');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (527, 527, 'fderyebarrettem@hugedomains.com', '539-574-2001', '569-962-7240');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (528, 528, 'cwhitehursten@virginia.edu', '426-124-0767', '374-525-6129');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (529, 529, 'rmatteuccieo@globo.com', '118-925-3827', '174-606-8698');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (530, 530, 'joreganep@weibo.com', '403-931-8088', '585-955-1297');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (531, 531, 'ehulkeeq@smugmug.com', '187-956-1947', '475-812-2335');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (532, 532, 'ebutcharder@boston.com', '177-340-2770', '254-358-9268');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (533, 533, 'azolinies@ask.com', '517-946-6250', '202-569-7678');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (534, 534, 'gsancheset@webmd.com', '401-701-0472', '343-288-9666');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (535, 535, 'sceliereu@fc2.com', '701-884-7436', '265-699-1256');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (536, 536, 'mismayev@uiuc.edu', '841-603-6234', '668-391-5767');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (537, 537, 'spepperew@360.cn', '632-844-3012', '941-691-8867');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (538, 538, 'emonteex@etsy.com', '440-510-3683', '632-615-0851');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (539, 539, 'rcaustickey@wordpress.com', '488-253-2815', '212-891-2156');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (540, 540, 'dcabenaez@yahoo.com', '856-466-4628', '460-244-5233');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (541, 541, 'hduforef0@mysql.com', '613-824-7709', '333-745-9864');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (542, 542, 'pgurradof1@goo.gl', '618-664-4801', '365-699-4999');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (543, 543, 'bscotfordf2@list-manage.com', '164-739-9867', '875-527-1973');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (544, 544, 'vzupaf3@cam.ac.uk', '766-659-7015', '625-870-9963');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (545, 545, 'cdavisf4@imgur.com', '111-797-1210', '709-601-9346');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (546, 546, 'psylvainef5@washingtonpost.com', '950-752-9509', '221-690-0869');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (547, 547, 'lolunnyf6@xrea.com', '876-315-6485', '166-253-3764');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (548, 548, 'knernf7@jugem.jp', '771-566-2725', '474-278-9860');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (549, 549, 'dschorahf8@com.com', '724-668-4720', '786-900-4089');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (550, 550, 'goscanlonf9@ustream.tv', '528-813-2891', '561-463-7456');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (551, 551, 'abrettelfa@buzzfeed.com', '772-833-2182', '757-688-1489');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (552, 552, 'ochristophlefb@yelp.com', '593-982-3503', '613-928-1110');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (553, 553, 'sthunderfc@wired.com', '710-981-9490', '789-526-4375');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (554, 554, 'boreillyfd@friendfeed.com', '933-248-4297', '271-569-6230');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (555, 555, 'pbarsonfe@imageshack.us', '801-403-7042', '805-685-5561');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (556, 556, 'tpinchenff@qq.com', '130-229-8245', '773-470-6285');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (557, 557, 'tyosselevitchfg@pagesperso-orange.fr', '760-109-9958', '707-695-1667');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (558, 558, 'tblaxelandfh@ameblo.jp', '818-786-9742', '314-790-0724');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (559, 559, 'mmurdyfi@etsy.com', '491-407-1181', '863-545-3683');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (560, 560, 'malanbrookefj@google.com', '374-271-3587', '774-663-7407');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (561, 561, 'eturbittfk@dedecms.com', '222-775-2847', '127-291-3598');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (562, 562, 'nflecknoefl@amazon.de', '217-500-0469', '497-130-0037');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (563, 563, 'fpesicfm@typepad.com', '130-152-3531', '467-999-8301');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (564, 564, 'bvasyutkinfn@sfgate.com', '275-723-6140', '749-205-2091');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (565, 565, 'ncornelsfo@cafepress.com', '891-872-8404', '200-381-6711');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (566, 566, 'pmeekefp@4shared.com', '137-155-3267', '982-771-6571');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (567, 567, 'ktanseyfq@icq.com', '368-929-3673', '165-410-4547');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (568, 568, 'xgiraultfr@reuters.com', '792-829-5633', '305-398-7167');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (569, 569, 'amandelfs@mediafire.com', '426-692-9851', '856-434-2824');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (570, 570, 'gseintft@archive.org', '475-707-5873', '266-930-6168');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (571, 571, 'dgaddesfu@addtoany.com', '966-224-2791', '412-602-5376');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (572, 572, 'mmchirriefv@go.com', '354-472-2398', '949-791-0317');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (573, 573, 'sjarmainfw@freewebs.com', '557-468-5399', '477-555-9154');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (574, 574, 'rcorderofx@bbb.org', '470-592-8799', '985-612-0949');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (575, 575, 'pschneiderfy@seesaa.net', '797-911-1470', '327-457-5919');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (576, 576, 'gwehdenfz@phpbb.com', '397-188-4953', '194-549-9134');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (577, 577, 'mgristong0@china.com.cn', '328-280-6195', '133-132-8061');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (578, 578, 'hglentzg1@aol.com', '711-280-4586', '967-402-2083');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (579, 579, 'fvanarsdallg2@com.com', '465-621-2472', '396-239-1769');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (580, 580, 'jpeckettg3@privacy.gov.au', '188-448-0871', '864-498-4302');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (581, 581, 'bpauwelg4@msu.edu', '640-381-7424', '818-675-5685');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (582, 582, 'mklampg5@disqus.com', '599-392-3240', '346-826-0048');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (583, 583, 'gperfilig6@i2i.jp', '686-889-6967', '261-308-9469');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (584, 584, 'bfawdryg7@businessinsider.com', '162-936-5438', '728-753-7004');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (585, 585, 'ktrembleg8@elegantthemes.com', '195-865-4658', '300-167-8997');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (586, 586, 'lepinoyg9@imgur.com', '320-318-8808', '157-996-9111');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (587, 587, 'bpohlkega@nbcnews.com', '652-259-1590', '143-408-6271');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (588, 588, 'cwinksgb@globo.com', '293-358-8953', '508-900-4297');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (589, 589, 'ckemmergc@yelp.com', '351-284-8576', '987-633-8512');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (590, 590, 'sgehrtsgd@reuters.com', '927-165-4795', '862-828-0891');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (591, 591, 'mhughsge@census.gov', '194-143-2709', '501-901-8770');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (592, 592, 'dcockegf@mtv.com', '597-476-1968', '677-745-8324');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (593, 593, 'bfeldhammergg@jugem.jp', '323-238-1248', '261-341-9394');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (594, 594, 'ncallcottgh@altervista.org', '687-820-0857', '798-909-7540');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (595, 595, 'mvernazzagi@nyu.edu', '513-614-4053', '198-633-6262');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (596, 596, 'vmccrackangj@list-manage.com', '773-254-0881', '263-383-4600');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (597, 597, 'plyongk@dot.gov', '564-589-1816', '203-129-3429');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (598, 598, 'nfredianigl@dropbox.com', '985-995-1808', '795-165-1365');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (599, 599, 'htabartgm@squarespace.com', '276-977-0600', '845-924-7639');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (600, 600, 'mlacegn@linkedin.com', '182-129-4719', '646-404-0284');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (601, 601, 'etysongo@earthlink.net', '137-986-2313', '107-860-3994');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (602, 602, 'zminmaghgp@scientificamerican.com', '913-438-3703', '175-323-2800');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (603, 603, 'gallbrookgq@barnesandnoble.com', '768-721-4759', '571-757-2615');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (604, 604, 'vbenwellgr@live.com', '425-856-4731', '402-646-6338');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (605, 605, 'cduerdengs@telegraph.co.uk', '183-705-2157', '920-818-4202');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (606, 606, 'carthangt@weebly.com', '557-706-1947', '371-973-9593');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (607, 607, 'slunagu@shinystat.com', '132-725-4510', '861-944-4810');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (608, 608, 'fcornelleaugv@biblegateway.com', '550-899-1285', '117-624-2404');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (609, 609, 'lishakgw@a8.net', '450-365-3420', '154-416-7430');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (610, 610, 'bhayfieldgx@so-net.ne.jp', '366-708-0242', '996-335-8550');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (611, 611, 'vcreedgy@discovery.com', '631-177-4270', '622-585-8141');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (612, 612, 'icawgz@amazon.de', '752-943-9388', '394-336-8886');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (613, 613, 'tcastellettih0@bandcamp.com', '699-151-4697', '869-979-8943');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (614, 614, 'jblancoweh1@joomla.org', '893-183-0382', '817-703-3433');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (615, 615, 'csidworthh2@weibo.com', '101-785-8795', '808-706-0776');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (616, 616, 'tbarhemsh3@npr.org', '737-641-8990', '338-634-0866');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (617, 617, 'flawnh4@com.com', '744-620-5927', '301-720-2146');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (618, 618, 'emcgeachieh5@hibu.com', '759-515-2826', '715-682-2640');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (619, 619, 'aduncanh6@ftc.gov', '412-791-4250', '768-621-8151');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (620, 620, 'fcatfordh7@joomla.org', '445-970-0436', '365-875-8116');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (621, 621, 'egirkh8@omniture.com', '358-979-0574', '658-445-1977');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (622, 622, 'etrevorrowh9@usda.gov', '800-900-1760', '325-659-8538');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (623, 623, 'lblainha@jalbum.net', '979-767-9544', '389-898-9762');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (624, 624, 'krogeonhb@newsvine.com', '628-388-0133', '840-550-7273');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (625, 625, 'mdorberhc@ted.com', '212-563-6359', '272-832-3185');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (626, 626, 'areviehd@wsj.com', '859-634-7441', '957-748-2926');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (627, 627, 'sdunhillhe@who.int', '141-952-2277', '551-744-0465');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (628, 628, 'fbushrodhf@prnewswire.com', '904-603-2268', '667-947-0455');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (629, 629, 'jlomanseyhg@discuz.net', '986-236-8591', '769-149-0970');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (630, 630, 'oscroytonhh@epa.gov', '890-192-1539', '558-588-3537');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (631, 631, 'wnelanehi@archive.org', '240-487-6523', '339-130-0767');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (632, 632, 'wmurrockhj@netvibes.com', '431-835-3555', '153-781-2108');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (633, 633, 'vhabershonhk@bigcartel.com', '957-565-9856', '522-216-2693');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (634, 634, 'knettinghl@bloglines.com', '743-277-1830', '747-431-7253');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (635, 635, 'ehawtinhm@trellian.com', '405-451-0787', '468-675-5656');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (636, 636, 'pswidenbankhn@live.com', '521-214-8175', '681-942-9062');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (637, 637, 'aharsantho@drupal.org', '521-830-0613', '498-917-4273');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (638, 638, 'vshuardhp@blogger.com', '885-351-5295', '288-659-3112');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (639, 639, 'wyarehq@howstuffworks.com', '845-347-5667', '285-825-2908');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (640, 640, 'mzannelihr@vistaprint.com', '252-380-3305', '858-836-5899');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (641, 641, 'cybarrahs@freewebs.com', '873-713-6476', '302-879-6452');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (642, 642, 'rmckeighanht@homestead.com', '190-641-3493', '446-151-5904');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (643, 643, 'hdrepphu@vimeo.com', '918-392-2372', '946-862-6749');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (644, 644, 'jreedhv@fastcompany.com', '739-160-4010', '731-157-1758');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (645, 645, 'vbluschkehw@weibo.com', '835-539-8688', '984-252-5242');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (646, 646, 'gburrasshx@ask.com', '979-338-5334', '416-173-0365');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (647, 647, 'bkinglakehy@ibm.com', '812-982-2365', '598-702-1908');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (648, 648, 'chorickhz@t.co', '629-180-3535', '620-690-9782');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (649, 649, 'avanderbruggei0@desdev.cn', '242-121-5312', '367-268-4926');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (650, 650, 'adimitrescui1@businesswire.com', '244-220-8805', '944-279-8385');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (651, 651, 'csansoni2@shop-pro.jp', '855-630-1765', '651-885-0282');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (652, 652, 'rsculpheri3@mit.edu', '253-330-1413', '289-752-6132');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (653, 653, 'mhamletti4@vimeo.com', '624-596-5728', '347-789-9073');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (654, 654, 'tkingsnoadi5@state.gov', '333-128-5577', '181-695-7358');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (655, 655, 'nshaveli6@loc.gov', '271-969-2422', '477-459-7017');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (656, 656, 'znuttalli7@opera.com', '725-979-3159', '588-202-9359');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (657, 657, 'ischolari8@google.co.uk', '905-349-6399', '699-218-3102');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (658, 658, 'nlacyi9@blogs.com', '106-242-3115', '923-516-9578');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (659, 659, 'swinterfloodia@fastcompany.com', '584-949-4951', '196-967-9289');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (660, 660, 'sisakssonib@zdnet.com', '682-522-1336', '539-228-2571');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (661, 661, 'eakenheadic@exblog.jp', '909-234-4150', '532-852-5841');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (662, 662, 'nsherebrookeid@virginia.edu', '793-377-9246', '145-236-1505');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (663, 663, 'sstibbsie@cloudflare.com', '128-566-9517', '867-314-4347');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (664, 664, 'sgoodburnif@sogou.com', '682-224-8706', '435-650-5589');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (665, 665, 'lpemberyig@nhs.uk', '474-380-3897', '543-664-4900');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (666, 666, 'qblighih@nbcnews.com', '153-107-5351', '609-380-4524');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (667, 667, 'wabramoviciii@theatlantic.com', '581-606-9176', '621-365-6025');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (668, 668, 'iwindebankij@nature.com', '936-186-3803', '138-364-3036');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (669, 669, 'kroomsik@uol.com.br', '989-425-4351', '404-834-0041');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (670, 670, 'gdinjesil@lulu.com', '357-592-0211', '747-166-0512');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (671, 671, 'iguslonim@cocolog-nifty.com', '311-537-4211', '227-859-5903');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (672, 672, 'touterbridgein@gravatar.com', '865-716-7534', '828-249-7364');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (673, 673, 'abeltonio@trellian.com', '891-308-7515', '331-280-7706');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (674, 674, 'umcgahernip@tripadvisor.com', '814-515-9019', '933-631-6423');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (675, 675, 'marmingeriq@tinyurl.com', '354-436-4374', '510-800-6251');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (676, 676, 'coakinfoldir@scribd.com', '746-132-0110', '387-993-6342');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (677, 677, 'evanezisis@linkedin.com', '651-347-1021', '635-760-5412');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (678, 678, 'ccathelit@irs.gov', '696-866-5918', '213-229-6339');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (679, 679, 'nszymonwicziu@phoca.cz', '649-144-0554', '286-391-1988');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (680, 680, 'rdeaconiv@eepurl.com', '643-295-2458', '987-512-9991');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (681, 681, 'rbattabeeiw@ucsd.edu', '713-156-6527', '796-543-9531');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (682, 682, 'njelksix@pbs.org', '196-539-9208', '516-428-5689');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (683, 683, 'echisholmiy@diigo.com', '714-387-3772', '132-349-2376');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (684, 684, 'vhailiz@yahoo.com', '443-685-2855', '394-100-0572');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (685, 685, 'allewellinj0@ftc.gov', '516-133-8093', '739-490-8333');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (686, 686, 'ccorradoj1@feedburner.com', '274-207-6880', '779-529-0855');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (687, 687, 'bdixj2@bravesites.com', '324-420-1115', '833-639-8402');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (688, 688, 'lroathj3@4shared.com', '929-666-1000', '350-488-2390');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (689, 689, 'cmalthusj4@gravatar.com', '274-762-7985', '294-410-4676');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (690, 690, 'aivanj5@fastcompany.com', '976-527-5088', '602-236-0950');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (691, 691, 'lkertessj6@smh.com.au', '732-289-8442', '719-150-6250');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (692, 692, 'mdeblasej7@webmd.com', '726-358-3125', '631-711-3243');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (693, 693, 'krohlfingj8@umich.edu', '707-474-3067', '859-547-7541');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (694, 694, 'smacroryj9@de.vu', '918-800-5374', '256-761-1961');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (695, 695, 'mallbonesja@nifty.com', '180-632-5030', '382-992-4431');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (696, 696, 'lchomiczjb@vimeo.com', '802-430-9906', '917-324-6333');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (697, 697, 'mbremmelljc@archive.org', '171-925-4364', '507-242-9231');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (698, 698, 'tkitchingmanjd@foxnews.com', '448-529-4388', '439-485-5608');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (699, 699, 'cpaulichje@com.com', '679-661-2310', '407-442-8947');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (700, 700, 'tgeistjf@geocities.com', '908-617-3527', '736-662-3918');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (701, 701, 'avillajg@istockphoto.com', '501-387-1141', '181-290-0755');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (702, 702, 'bmounfieldjh@privacy.gov.au', '173-963-0245', '387-166-5917');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (703, 703, 'lstuddeji@cnbc.com', '990-914-0293', '809-427-4314');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (704, 704, 'mimlochjj@msu.edu', '901-339-6449', '586-762-2742');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (705, 705, 'wstrivensjk@sogou.com', '292-911-1177', '204-127-5428');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (706, 706, 'jpattersonjl@cpanel.net', '215-291-2083', '130-571-6256');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (707, 707, 'fhorseyjm@technorati.com', '172-555-3545', '794-928-6251');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (708, 708, 'dgilchrestjn@shop-pro.jp', '559-280-6091', '848-772-8444');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (709, 709, 'hgentnerjo@slashdot.org', '823-798-8589', '802-685-1118');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (710, 710, 'evasyunkinjp@upenn.edu', '185-248-7201', '874-690-0285');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (711, 711, 'gbeinkejq@mac.com', '909-830-0670', '651-122-0753');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (712, 712, 'smencijr@goo.gl', '990-225-6180', '499-738-2077');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (713, 713, 'oboyenjs@pen.io', '113-896-6673', '734-493-4586');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (714, 714, 'psilsonjt@cisco.com', '522-343-5702', '710-655-9250');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (715, 715, 'kchristonju@prlog.org', '870-377-0127', '309-127-9345');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (716, 716, 'tkybertjv@theguardian.com', '796-978-8305', '569-958-9245');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (717, 717, 'awiggettjw@ft.com', '863-163-2345', '394-191-0462');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (718, 718, 'vspeechleyjx@cnbc.com', '606-290-1538', '241-633-7209');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (719, 719, 'oadamecjy@privacy.gov.au', '324-651-2207', '981-449-4632');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (720, 720, 'afirpojz@mysql.com', '509-645-5366', '224-762-5122');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (721, 721, 'lpopleyk0@hhs.gov', '718-575-0869', '497-707-8831');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (722, 722, 'tmatterfacek1@bravesites.com', '870-408-4687', '311-111-1451');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (723, 723, 'pkleisk2@i2i.jp', '541-586-6757', '282-308-6172');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (724, 724, 'jolivetik3@hhs.gov', '762-179-3083', '160-263-8663');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (725, 725, 'lgartshorek4@naver.com', '385-156-5549', '608-384-3179');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (726, 726, 'ksammsk5@china.com.cn', '692-961-5078', '878-509-4132');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (727, 727, 'swansburyk6@unesco.org', '231-800-2135', '683-662-9340');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (728, 728, 'ehelversenk7@npr.org', '709-214-5110', '636-887-0985');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (729, 729, 'ttrotterk8@netlog.com', '866-421-9818', '328-158-2097');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (730, 730, 'drewcastlek9@fda.gov', '835-707-7737', '819-276-0343');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (731, 731, 'cwedgwoodka@friendfeed.com', '268-577-6773', '550-307-2321');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (732, 732, 'slehouxkb@japanpost.jp', '716-794-4322', '624-973-6033');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (733, 733, 'agrundellkc@ted.com', '901-729-7782', '349-865-1059');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (734, 734, 'bgramerkd@topsy.com', '947-780-3715', '953-313-9178');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (735, 735, 'phartrightke@google.com.au', '146-589-7046', '323-863-3837');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (736, 736, 'kspurrierkf@addthis.com', '827-323-1839', '661-930-1044');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (737, 737, 'bluskkg@yolasite.com', '441-861-5499', '922-787-3952');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (738, 738, 'jdenisotkh@home.pl', '553-662-1996', '418-795-8808');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (739, 739, 'fpestrickeki@squarespace.com', '474-511-1839', '920-956-1274');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (740, 740, 'meddollskj@google.ru', '948-210-5726', '876-422-7096');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (741, 741, 'bmerlekk@blog.com', '427-115-9999', '634-958-5989');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (742, 742, 'qshirdkl@cornell.edu', '560-532-2583', '138-125-6619');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (743, 743, 'nbrockwellkm@squidoo.com', '838-259-3046', '325-807-5076');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (744, 744, 'kjaquinkn@gizmodo.com', '626-588-4351', '884-385-9001');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (745, 745, 'haberchirderko@skyrock.com', '889-287-4065', '291-529-4540');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (746, 746, 'igippkp@topsy.com', '899-155-2975', '650-277-1130');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (747, 747, 'nharpkq@webmd.com', '577-624-6389', '611-805-6267');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (748, 748, 'wmcindoekr@hexun.com', '498-174-4280', '413-759-9922');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (749, 749, 'gbiggks@nyu.edu', '558-395-9310', '615-727-1135');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (750, 750, 'fdearellkt@pagesperso-orange.fr', '147-429-0979', '501-856-6927');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (751, 751, 'lhopkinsku@wsj.com', '441-101-9805', '655-793-3362');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (752, 752, 'acristoforkv@hexun.com', '714-750-5312', '597-971-9660');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (753, 753, 'rkropkw@merriam-webster.com', '988-774-2126', '776-862-6638');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (754, 754, 'gwassonkx@nyu.edu', '980-329-3077', '222-968-4665');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (755, 755, 'hhebborneky@dedecms.com', '470-821-1406', '178-368-0883');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (756, 756, 'ksemenskz@microsoft.com', '434-352-4924', '870-499-9644');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (757, 757, 'bhandforthl0@unesco.org', '518-277-9686', '550-373-1268');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (758, 758, 'mgundreyl1@ocn.ne.jp', '775-394-1231', '814-486-1981');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (759, 759, 'obiesterfeldl2@dyndns.org', '670-295-8782', '505-677-5251');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (760, 760, 'cbrouwerl3@aboutads.info', '714-554-1634', '688-358-1746');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (761, 761, 'mmaccolganl4@nytimes.com', '257-548-6150', '876-422-0655');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (762, 762, 'lstiversl5@blinklist.com', '155-218-7716', '763-317-3246');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (763, 763, 'ledgingtonl6@umich.edu', '525-801-1573', '240-460-8908');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (764, 764, 'nemmertl7@phpbb.com', '616-713-4000', '366-368-2341');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (765, 765, 'nleydonl8@marriott.com', '799-844-9216', '546-706-2871');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (766, 766, 'edederichl9@w3.org', '886-465-3807', '821-942-7147');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (767, 767, 'hmourbeyla@cargocollective.com', '413-617-7233', '165-805-8452');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (768, 768, 'mgionettittilb@cnet.com', '229-406-8118', '585-389-2158');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (769, 769, 'lbunnelllc@msu.edu', '882-403-5284', '917-265-5922');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (770, 770, 'jsnazelld@webeden.co.uk', '623-864-3200', '403-229-1442');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (771, 771, 'clambournele@answers.com', '160-349-9419', '204-144-1771');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (772, 772, 'afendlf@wix.com', '244-249-5476', '401-919-7961');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (773, 773, 'dnelthropplg@phoca.cz', '545-215-8404', '629-225-2462');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (774, 774, 'ebellinolh@dell.com', '279-937-4908', '572-730-2421');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (775, 775, 'ecahenli@uol.com.br', '660-954-1692', '182-143-5363');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (776, 776, 'nmcpakelj@examiner.com', '383-992-2491', '185-999-3942');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (777, 777, 'bgalletleylk@rakuten.co.jp', '862-604-4340', '625-226-2259');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (778, 778, 'mbaudoull@dropbox.com', '323-554-7210', '962-806-3045');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (779, 779, 'tglasbeylm@un.org', '345-624-5621', '121-493-4083');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (780, 780, 'gmacpeiceln@ustream.tv', '929-547-6118', '487-364-8569');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (781, 781, 'kbomfieldlo@berkeley.edu', '337-402-0901', '176-455-3404');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (782, 782, 'jbeaganlp@wikia.com', '502-199-5387', '346-344-2153');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (783, 783, 'jposselowlq@friendfeed.com', '729-238-9342', '385-361-1401');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (784, 784, 'dfaustianlr@examiner.com', '692-304-4373', '311-953-6984');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (785, 785, 'mmetzkels@bigcartel.com', '375-337-5881', '761-830-0296');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (786, 786, 'sguntonlt@samsung.com', '290-403-1850', '743-680-8028');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (787, 787, 'mcudlu@webnode.com', '727-692-7351', '768-702-6044');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (788, 788, 'bhaylorlv@sakura.ne.jp', '754-964-8678', '400-386-6603');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (789, 789, 'kattewelllw@whitehouse.gov', '652-773-3234', '136-614-2676');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (790, 790, 'egandeylx@icq.com', '851-777-7789', '530-726-8605');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (791, 791, 'wbanely@ehow.com', '401-535-8847', '749-190-2795');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (792, 792, 'djewsburylz@huffingtonpost.com', '425-829-3184', '256-920-7461');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (793, 793, 'hjertzm0@csmonitor.com', '493-228-0263', '151-268-8299');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (794, 794, 'nmcgawnm1@spiegel.de', '799-502-4010', '205-329-5304');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (795, 795, 'ssweeneym2@biblegateway.com', '182-379-8863', '540-643-6963');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (796, 796, 'wilbertm3@si.edu', '667-740-7083', '970-283-5893');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (797, 797, 'ajelfm4@ask.com', '782-149-9811', '779-337-2653');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (798, 798, 'gizodm5@blogger.com', '791-108-5435', '373-545-9111');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (799, 799, 'gcraighillm6@cmu.edu', '233-334-6492', '245-870-8098');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (800, 800, 'mlarkm7@networkadvertising.org', '380-893-1733', '732-886-8928');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (801, 801, 'belecumm8@fotki.com', '719-388-7764', '416-327-6018');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (802, 802, 'mgerardeauxm9@sina.com.cn', '496-878-1691', '981-488-2184');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (803, 803, 'bodoughertyma@jugem.jp', '452-529-9737', '870-904-1426');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (804, 804, 'jmariellemb@independent.co.uk', '448-776-4355', '190-447-4614');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (805, 805, 'aenokssonmc@yelp.com', '714-771-4075', '597-494-5636');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (806, 806, 'screbermd@archive.org', '935-685-0154', '459-683-4115');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (807, 807, 'abriattme@va.gov', '154-147-4219', '435-137-0507');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (808, 808, 'kheinlmf@sogou.com', '563-913-2539', '258-128-4701');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (809, 809, 'kgrishinovmg@nifty.com', '184-700-5346', '567-421-7284');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (810, 810, 'crakemh@wired.com', '705-262-4026', '568-156-7747');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (811, 811, 'cstrowgermi@loc.gov', '265-115-8400', '884-633-9848');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (812, 812, 'crodriguezmj@guardian.co.uk', '200-483-3602', '867-365-2830');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (813, 813, 'frobakmk@archive.org', '169-385-3941', '460-705-3918');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (814, 814, 'lmcgonagleml@weebly.com', '339-157-4768', '470-538-2791');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (815, 815, 'dchristmasmm@hc360.com', '957-698-9781', '160-154-7745');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (816, 816, 'lchesonmn@wunderground.com', '570-968-5472', '739-826-2959');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (817, 817, 'jkippiemo@digg.com', '658-575-0971', '954-371-2592');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (818, 818, 'ahodginsmp@whitehouse.gov', '165-804-4292', '750-888-7772');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (819, 819, 'maggasmq@nature.com', '647-691-9663', '371-235-4700');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (820, 820, 'ibeatonmr@ihg.com', '142-549-0850', '986-112-6488');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (821, 821, 'amarienms@com.com', '878-405-8209', '187-448-6490');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (822, 822, 'tluckcuckmt@wikipedia.org', '730-838-0424', '711-747-5891');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (823, 823, 'hplacidomu@businesswire.com', '880-303-3831', '129-360-1649');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (824, 824, 'ebalasmv@businessinsider.com', '351-317-5170', '490-957-5845');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (825, 825, 'thuychemw@msn.com', '202-808-3772', '106-463-3526');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (826, 826, 'abeeresmx@globo.com', '750-697-4061', '856-792-9706');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (827, 827, 'rreiachmy@wp.com', '155-301-2636', '828-594-5026');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (828, 828, 'hdavidgemz@epa.gov', '121-956-0512', '602-367-1589');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (829, 829, 'jcrixn0@phoca.cz', '778-175-0654', '114-306-0485');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (830, 830, 'mpetworthn1@hostgator.com', '792-743-7670', '248-223-7521');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (831, 831, 'sstorrockn2@networkadvertising.org', '734-447-2631', '105-658-9562');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (832, 832, 'cvanarsdalln3@epa.gov', '218-635-2832', '214-998-9207');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (833, 833, 'amccastern4@mashable.com', '217-719-1802', '639-821-1140');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (834, 834, 'aphrippn5@craigslist.org', '554-553-7203', '440-106-2172');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (835, 835, 'fcawsyn6@360.cn', '407-137-6354', '319-209-6389');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (836, 836, 'wbaxtern7@unc.edu', '455-230-5622', '664-813-4502');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (837, 837, 'dgruszeckin8@friendfeed.com', '343-324-2578', '144-908-4523');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (838, 838, 'jrimmern9@tumblr.com', '660-829-4340', '745-495-8610');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (839, 839, 'bcowoppena@forbes.com', '250-921-1043', '789-541-2651');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (840, 840, 'ssturmannb@telegraph.co.uk', '871-127-5585', '355-239-1364');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (841, 841, 'cbluenc@merriam-webster.com', '492-397-4097', '578-602-6129');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (842, 842, 'jberringtonnd@typepad.com', '664-708-6509', '582-163-8446');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (843, 843, 'amilsapne@phpbb.com', '215-617-2682', '801-257-7777');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (844, 844, 'cgrutchfieldnf@berkeley.edu', '315-980-7790', '946-937-9586');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (845, 845, 'nsandelandng@scientificamerican.com', '165-940-2276', '199-822-0239');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (846, 846, 'scalifornianh@stumbleupon.com', '685-301-2888', '202-470-4468');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (847, 847, 'mfishpooleni@deviantart.com', '798-607-1485', '955-509-0869');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (848, 848, 'dtownenj@arstechnica.com', '282-863-7620', '557-206-4847');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (849, 849, 'gbuglassnk@seattletimes.com', '113-324-9355', '933-632-2513');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (850, 850, 'mpaunl@walmart.com', '609-163-4109', '614-608-3568');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (851, 851, 'sgianolonm@omniture.com', '886-682-3064', '569-682-3302');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (852, 852, 'vlorkingnn@businesswire.com', '148-756-5005', '378-262-6981');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (853, 853, 'maxellno@macromedia.com', '915-407-0269', '546-628-7658');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (854, 854, 'bdownnp@instagram.com', '385-639-1656', '350-808-1818');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (855, 855, 'cvoasnq@boston.com', '118-460-0846', '579-980-5595');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (856, 856, 'mitscowicznr@bravesites.com', '909-942-6030', '234-591-3527');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (857, 857, 'wguillotonns@facebook.com', '161-430-6936', '270-775-4555');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (858, 858, 'clockhurstnt@ox.ac.uk', '275-724-4698', '991-597-8579');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (859, 859, 'llowinnu@umn.edu', '666-355-5000', '673-268-2110');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (860, 860, 'ymelladewnv@admin.ch', '209-254-5617', '623-525-1996');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (861, 861, 'cmagovernnw@nasa.gov', '262-909-4047', '715-772-2286');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (862, 862, 'aricenx@liveinternet.ru', '674-870-4973', '111-253-3267');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (863, 863, 'ewillmerny@studiopress.com', '696-707-0217', '216-235-7888');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (864, 864, 'csowerbynz@webs.com', '574-166-8203', '858-933-3358');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (865, 865, 'acanningo0@reference.com', '547-854-8463', '444-707-9426');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (866, 866, 'pbartello1@mashable.com', '425-923-7649', '329-495-8988');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (867, 867, 'lhamberstono2@apple.com', '127-345-5672', '265-179-1164');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (868, 868, 'flocho3@networkadvertising.org', '439-846-1632', '772-486-4979');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (869, 869, 'mmorebyo4@google.de', '145-905-4709', '885-559-6734');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (870, 870, 'hpimmo5@about.me', '183-541-0746', '169-730-5579');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (871, 871, 'tcockadayo6@apple.com', '937-288-3215', '918-364-7846');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (872, 872, 'egreadyo7@phpbb.com', '425-454-8671', '658-653-8351');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (873, 873, 'dvanneo8@scientificamerican.com', '752-751-3931', '149-806-7987');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (874, 874, 'fjonkeo9@networkadvertising.org', '540-486-3758', '761-529-7715');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (875, 875, 'bsoldioa@pen.io', '837-582-3309', '899-565-6332');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (876, 876, 'hchappelleob@webs.com', '533-864-9558', '653-645-2610');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (877, 877, 'lbarberyoc@amazon.de', '664-358-8397', '254-369-4652');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (878, 878, 'vburryod@smh.com.au', '680-368-0577', '699-667-9197');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (879, 879, 'emarshoe@samsung.com', '430-510-5908', '828-976-5272');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (880, 880, 'ghuggillof@biglobe.ne.jp', '892-176-0732', '525-789-3263');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (881, 881, 'mmatthewog@pagesperso-orange.fr', '916-666-7580', '955-388-3218');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (882, 882, 'wpaulinoh@4shared.com', '833-469-8760', '425-667-5690');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (883, 883, 'crosieroi@dell.com', '404-416-0197', '703-497-9318');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (884, 884, 'ygrattonoj@mozilla.org', '871-864-3084', '120-595-2992');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (885, 885, 'rlomathok@paginegialle.it', '929-403-3527', '222-411-7950');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (886, 886, 'bjanuszkiewiczol@abc.net.au', '314-101-8919', '143-431-6285');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (887, 887, 'sbolleom@linkedin.com', '888-396-4351', '615-369-1182');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (888, 888, 'gdevereon@woothemes.com', '952-121-8235', '140-592-5979');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (889, 889, 'iwestmacottoo@go.com', '380-456-3169', '607-297-0398');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (890, 890, 'fchampeop@google.pl', '186-693-3662', '304-856-7259');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (891, 891, 'dmailesoq@friendfeed.com', '452-109-6784', '571-610-4247');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (892, 892, 'dcordeyor@slashdot.org', '741-923-2693', '889-904-7193');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (893, 893, 'slinwoodos@themeforest.net', '864-207-5387', '592-364-0419');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (894, 894, 'ctrudgianot@mashable.com', '728-866-8519', '440-797-8978');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (895, 895, 'plowyou@accuweather.com', '145-597-8689', '697-190-9018');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (896, 896, 'opittelov@boston.com', '436-767-7055', '699-879-7383');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (897, 897, 'gblankingow@jimdo.com', '148-928-1528', '932-664-1685');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (898, 898, 'rbeatsonox@mail.ru', '659-194-0968', '468-479-1695');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (899, 899, 'strebbettoy@chronoengine.com', '131-175-9956', '935-305-4594');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (900, 900, 'epiddleoz@redcross.org', '138-769-6327', '127-750-6133');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (901, 901, 'bmaccathayp0@gizmodo.com', '560-587-0380', '951-850-0972');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (902, 902, 'rklinerp1@bloomberg.com', '691-156-9527', '342-410-2271');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (903, 903, 'wespinozap2@typepad.com', '317-125-3092', '564-937-1705');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (904, 904, 'ffludgatep3@angelfire.com', '144-245-7989', '647-201-1497');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (905, 905, 'gshoutep4@technorati.com', '511-832-9015', '534-984-9181');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (906, 906, 'floudianep5@army.mil', '454-862-7350', '642-306-6911');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (907, 907, 'svianp6@gizmodo.com', '885-843-0904', '238-398-8279');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (908, 908, 'chollymanp7@yahoo.com', '381-280-9267', '160-528-8917');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (909, 909, 'vnilgesp8@smugmug.com', '852-706-2512', '456-229-4456');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (910, 910, 'cscamadenp9@zimbio.com', '742-224-5604', '354-444-1480');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (911, 911, 'mhysompa@is.gd', '686-272-8882', '317-407-9802');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (912, 912, 'abenyonpb@weather.com', '265-424-9502', '162-640-1098');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (913, 913, 'bcreerpc@ifeng.com', '215-130-5809', '918-302-1482');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (914, 914, 'fseakespd@bloglovin.com', '157-293-7383', '954-151-8658');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (915, 915, 'pabbepe@jugem.jp', '799-334-5154', '418-453-2333');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (916, 916, 'ktippettpf@google.pl', '938-798-4153', '392-133-9719');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (917, 917, 'rdeerypg@odnoklassniki.ru', '129-853-6448', '449-778-0388');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (918, 918, 'sdomencph@zimbio.com', '677-896-8647', '470-941-9785');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (919, 919, 'cwooddissepi@earthlink.net', '676-688-9330', '555-129-7116');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (920, 920, 'mgisbornepj@printfriendly.com', '923-411-6637', '485-351-3374');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (921, 921, 'wcourtinpk@github.io', '930-446-2469', '407-707-2127');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (922, 922, 'tkingsmanpl@ezinearticles.com', '898-369-5904', '900-134-9426');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (923, 923, 'tmcgreilpm@state.tx.us', '905-944-9577', '214-286-4398');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (924, 924, 'hschroederpn@rambler.ru', '954-227-4968', '509-346-0052');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (925, 925, 'hentreispo@newyorker.com', '831-127-5729', '377-803-6133');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (926, 926, 'ibummfreypp@hc360.com', '874-639-3332', '657-925-3892');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (927, 927, 'fludlpq@theguardian.com', '661-141-8692', '377-328-6803');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (928, 928, 'rleethampr@miitbeian.gov.cn', '819-448-7977', '589-491-7965');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (929, 929, 'kalpps@mit.edu', '296-707-0630', '125-390-5166');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (930, 930, 'mdacostapt@spiegel.de', '680-213-7681', '329-676-7445');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (931, 931, 'rpraundlpu@youtube.com', '458-799-9481', '408-254-0563');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (932, 932, 'fhealespv@unblog.fr', '701-874-0461', '336-367-1250');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (933, 933, 'mmccourtpw@archive.org', '501-137-7287', '923-120-4974');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (934, 934, 'mdjurdjevicpx@comsenz.com', '897-641-9651', '898-662-8406');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (935, 935, 'swarbeypy@istockphoto.com', '814-109-7653', '745-100-7659');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (936, 936, 'fbompasspz@quantcast.com', '229-230-0946', '842-618-0684');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (937, 937, 'lblowenq0@a8.net', '525-230-1783', '618-837-1772');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (938, 938, 'hfewkesq1@blogs.com', '683-917-7140', '407-754-2928');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (939, 939, 'greynoldsonq2@oakley.com', '139-776-3444', '273-369-6738');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (940, 940, 'nmckeurtonq3@github.com', '183-101-5751', '492-963-0560');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (941, 941, 'hknoxq4@reuters.com', '393-725-6403', '309-583-4138');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (942, 942, 'ahastlerq5@furl.net', '987-891-2828', '834-298-6570');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (943, 943, 'kmckimmieq6@jimdo.com', '361-216-9902', '334-696-1023');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (944, 944, 'ajerzykiewiczq7@hexun.com', '330-682-2976', '498-676-3389');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (945, 945, 'tstaiteq8@furl.net', '542-797-7971', '428-338-8545');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (946, 946, 'adunkersleyq9@bloglovin.com', '956-983-0874', '278-958-9070');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (947, 947, 'jspriggingqa@independent.co.uk', '389-254-0646', '172-373-9048');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (948, 948, 'satchlyqb@angelfire.com', '352-407-5125', '677-685-0617');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (949, 949, 'lhuntarqc@prlog.org', '344-608-4826', '312-787-2384');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (950, 950, 'aspillmanqd@slideshare.net', '815-227-5655', '352-920-3964');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (951, 951, 'vmorecombeqe@blogger.com', '580-458-5549', '236-457-5308');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (952, 952, 'pjanodetqf@yandex.ru', '308-335-6534', '755-186-2820');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (953, 953, 'ebarlesqg@amazon.com', '817-816-3474', '842-414-5490');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (954, 954, 'gclarkewilliamsqh@jugem.jp', '507-970-0316', '412-844-7325');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (955, 955, 'lesteqi@weather.com', '158-904-5228', '997-451-7049');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (956, 956, 'bhorleyqj@npr.org', '661-834-1549', '818-337-6710');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (957, 957, 'aableyqk@amazonaws.com', '978-908-2600', '746-838-5036');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (958, 958, 'tcorbynql@fastcompany.com', '822-957-9872', '772-480-5647');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (959, 959, 'amanchesterqm@bing.com', '810-483-6231', '934-786-6027');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (960, 960, 'mbedomeqn@angelfire.com', '933-631-9230', '640-960-6923');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (961, 961, 'gmiqueletqo@ft.com', '899-767-7080', '746-591-0573');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (962, 962, 'kgraserqp@w3.org', '778-991-0721', '216-502-7590');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (963, 963, 'drochfordqq@sun.com', '282-345-4698', '290-957-8299');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (964, 964, 'ctinhamqr@wikipedia.org', '214-141-3120', '224-544-2962');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (965, 965, 'tspellessyqs@dagondesign.com', '425-469-3685', '492-502-8450');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (966, 966, 'zantatqt@slashdot.org', '431-761-0386', '547-882-5580');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (967, 967, 'dswancottqu@yahoo.co.jp', '883-642-1302', '154-205-0113');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (968, 968, 'cfrymanqv@newyorker.com', '315-487-0386', '649-665-3402');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (969, 969, 'zpauelqw@slashdot.org', '603-561-3859', '156-486-2554');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (970, 970, 'mcockranqx@epa.gov', '271-782-3471', '911-857-3646');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (971, 971, 'sgierathsqy@theatlantic.com', '688-881-3416', '395-974-8369');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (972, 972, 'rfaircleyqz@weebly.com', '527-876-1773', '705-201-8737');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (973, 973, 'mtennantr0@hud.gov', '927-234-1931', '385-123-6930');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (974, 974, 'jbirkmyrr1@nps.gov', '443-502-1978', '429-335-8905');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (975, 975, 'cbengler2@bigcartel.com', '376-530-5217', '168-330-1505');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (976, 976, 'ohadcroftr3@examiner.com', '784-175-3118', '900-345-2051');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (977, 977, 'hleaheyr4@umn.edu', '937-853-0525', '941-654-8834');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (978, 978, 'btriggr5@hubpages.com', '141-623-6151', '715-681-9174');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (979, 979, 'mhoobanr6@webeden.co.uk', '846-157-3201', '388-270-7256');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (980, 980, 'braer7@dot.gov', '927-153-0188', '869-827-7602');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (981, 981, 'oantukr8@marriott.com', '229-708-1846', '713-616-6408');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (982, 982, 'dmacdonellr9@wikispaces.com', '149-488-8031', '494-836-7660');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (983, 983, 'icostera@kickstarter.com', '419-922-5592', '493-156-4359');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (984, 984, 'cyurovrb@army.mil', '347-877-2099', '820-242-6622');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (985, 985, 'jwilkisonrc@mapquest.com', '125-729-9541', '158-726-2098');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (986, 986, 'wduguidrd@youku.com', '784-835-8322', '619-307-4799');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (987, 987, 'vmarringtonre@netlog.com', '315-199-1550', '273-743-1910');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (988, 988, 'atourmellrf@senate.gov', '608-149-4540', '258-655-2588');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (989, 989, 'fneildrg@alexa.com', '776-836-1269', '334-154-6103');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (990, 990, 'bbroomerrh@github.io', '438-336-1878', '189-317-6536');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (991, 991, 'hwroathri@infoseek.co.jp', '967-149-3395', '486-237-3931');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (992, 992, 'zbaudinetrj@washingtonpost.com', '797-557-6504', '266-909-4087');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (993, 993, 'tondrousekrk@alexa.com', '583-620-2106', '180-456-6459');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (994, 994, 'mshortclifferl@g.co', '901-629-2294', '446-772-4045');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (995, 995, 'mhaythornrm@sfgate.com', '226-582-6029', '434-759-5874');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (996, 996, 'ghufferrn@sun.com', '608-413-2901', '777-403-1207');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (997, 997, 'rlowtherro@meetup.com', '211-820-5967', '364-561-6431');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (998, 998, 'jmcgormanrp@i2i.jp', '136-348-6131', '858-437-7323');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (999, 999, 'rcredlandrq@plala.or.jp', '862-356-5193', '272-740-0903');
insert into CONTACT (CONTACT_ID, USER_ID, EMAIL, PHONE, MOBILE) values (1000, 1000, 'rkilduffrr@nba.com', '934-692-8887', '410-286-1723');

-- Address

Iinsert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (1, 1, 'Meadow Vale', '385', 'Emmaboda', '361 31');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (2, 2, 'Canary', '758', 'Kuala Terengganu', '20710');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (3, 3, 'Pearson', '05', 'Rotterdam', '3094');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (4, 4, 'Walton', '51659', 'Tajur', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (5, 5, 'Sunnyside', '5', 'Niort', '79021 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (6, 6, 'Northwestern', '4', 'Zhangjiawo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (7, 7, 'Pennsylvania', '92050', 'Marka', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (8, 8, 'Nova', '1885', 'Obita', '859-0416');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (9, 9, 'Dapin', '43455', 'Hujirt', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (10, 10, 'Kipling', '52300', 'Longfeng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (11, 11, 'Gulseth', '6', 'Uruobo-Okija', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (12, 12, 'Hudson', '83', 'Lancar', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (13, 13, 'Calypso', '9419', 'Harbour Breton', 'M4N');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (14, 14, 'Golf View', '41252', '''s-Hertogenbosch', '5204');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (15, 15, 'Chive', '9178', 'Pantenan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (16, 16, 'Fulton', '57', 'Emiliano Zapata', '86690');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (17, 17, 'Russell', '5', 'Meizhou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (18, 18, 'John Wall', '548', 'Karangarjo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (19, 19, 'Kedzie', '9', 'Ciudad Nueva', '10208');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (20, 20, 'Merchant', '58027', 'Wenchun', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (21, 21, 'Manufacturers', '3828', 'Tongmuluo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (22, 22, 'Lukken', '9134', 'Jatiraya', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (23, 23, 'Sycamore', '045', 'Boston', '02298');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (24, 24, 'Elka', '8', 'Daphu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (25, 25, 'Havey', '414', 'Midland', 'L4R');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (26, 26, 'Hagan', '5', 'Siteía', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (27, 27, 'Bowman', '73', 'Kolsko', '67-415');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (28, 28, 'Susan', '67101', 'Cachan', '94234 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (29, 29, 'Stang', '5176', 'Tamorot', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (30, 30, 'Marquette', '440', 'Fengqiao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (31, 31, 'Quincy', '88467', 'Honolulu', '96825');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (32, 32, 'Declaration', '17', 'Laúndos', '4570-308');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (33, 33, 'Commercial', '963', 'Vidovci', '34000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (34, 34, 'Talisman', '2', 'Tehetu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (35, 35, 'Lindbergh', '8692', 'Safi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (36, 36, 'Valley Edge', '29', 'Ljubovija', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (37, 37, 'Schmedeman', '4', 'Cepões', '3505-157');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (38, 38, 'Norway Maple', '43959', 'Bobota', '32225');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (39, 39, 'Mcguire', '3', 'Za‘tarah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (40, 40, 'Washington', '6929', 'Khudāydād Khēl', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (41, 41, 'East', '7505', 'Valladolid', '47010');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (42, 42, 'Merrick', '256', 'Dongdai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (43, 43, 'Northland', '2', 'Kaédi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (44, 44, 'Maryland', '103', 'Macas', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (45, 45, 'Schurz', '302', 'Jeblog Satu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (46, 46, 'Division', '84117', 'Bengtsfors', '666 32');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (47, 47, 'Doe Crossing', '4558', 'Labinot-Mal', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (48, 48, 'Gina', '9', 'Paris 13', '75623 CEDEX 13');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (49, 49, '3rd', '6894', 'Nikhom Kham Soi', '49130');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (50, 50, 'Hansons', '3756', 'Letovice', '679 61');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (51, 51, 'Pine View', '51', 'Giyon', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (52, 52, 'Superior', '6705', 'Gongjiahe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (53, 53, 'Boyd', '4333', 'Fucheng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (54, 54, 'Mayfield', '9', 'Fujieda', '426-0025');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (55, 55, 'La Follette', '67567', 'Lunéville', '54304 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (56, 56, 'Vidon', '6', 'Václavovice', '742 83');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (57, 57, 'Goodland', '7667', 'Khān Neshīn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (58, 58, 'Toban', '603', 'Croix', '59961 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (59, 59, 'Dixon', '48', 'Ponta Grossa', '84000-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (60, 60, 'Forest Run', '2', 'Nytva', '617000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (61, 61, 'Fulton', '7', 'Shanghang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (62, 62, 'Sommers', '27', 'Unisław', '86-260');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (63, 63, 'Ramsey', '097', 'Maciejowice', '08-480');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (64, 64, 'Green Ridge', '9', 'Houston', '77293');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (65, 65, 'Shelley', '95', 'Sélestat', '67604 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (66, 66, 'Melvin', '976', 'Guadalupe', '10801');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (67, 67, 'Graceland', '7376', 'Jiaoba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (68, 68, 'Melby', '1586', 'Jinhaihu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (69, 69, 'Trailsway', '673', 'Huichang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (70, 70, 'Lakewood', '9970', 'Ziliang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (71, 71, 'Hanover', '289', 'Chuntai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (72, 72, 'Grover', '05', 'Areia Branca', '49580-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (73, 73, 'Walton', '6431', 'Phatthalung', '86000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (74, 74, 'Myrtle', '29', 'Nowa Ruda', '57-403');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (75, 75, 'Kinsman', '66', 'Ziniaré', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (76, 76, 'Fairview', '6655', 'Tsaritsyno', '142717');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (77, 77, 'Susan', '1214', 'Nifuboko', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (78, 78, 'Quincy', '64', 'Bun Barat', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (79, 79, 'Ohio', '48', 'Firenze', '50124');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (80, 80, 'Bonner', '9', 'Haishan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (81, 81, 'Marquette', '5', 'Pahing Jalatrang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (82, 82, 'Scofield', '5', 'Madrid', '28045');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (83, 83, 'Independence', '3217', 'Bom Jesus do Itabapoana', '28360-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (84, 84, 'Rigney', '954', 'Kýthnos', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (85, 85, 'Fremont', '637', 'Changning', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (86, 86, 'Daystar', '67246', 'Cartagena', '2432');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (87, 87, 'Lakewood', '06808', 'Sincé', '056450');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (88, 88, 'Dottie', '34', 'Dobra', '72-210');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (89, 89, 'Aberg', '8', 'Sunagawa', '997-0415');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (90, 90, 'Onsgard', '25', 'Iowa City', '52245');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (91, 91, 'Talmadge', '598', 'Tul’chyn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (92, 92, 'Hayes', '8234', 'Drybin', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (93, 93, 'Scofield', '0273', 'Zabłocie', '43-523');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (94, 94, 'Hauk', '3245', 'Kamal', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (95, 95, 'Spohn', '69', 'Anka', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (96, 96, 'Union', '1029', 'Darungan Lor', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (97, 97, 'Bultman', '60', 'Silab', '1375');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (98, 98, 'Briar Crest', '104', 'Quiaios', '3080-520');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (99, 99, 'Heath', '39654', 'Trenggulunan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (100, 100, 'Lotheville', '69', 'Mora', '792 92');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (101, 101, 'La Follette', '2784', 'Tanarara', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (102, 102, 'Garrison', '1', 'Chrastava', '463 31');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (103, 103, 'Mitchell', '408', 'Satuek', '31150');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (104, 104, 'Barnett', '07858', 'Wichita', '67210');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (105, 105, 'Nova', '53941', 'Verblyany', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (106, 106, 'Magdeline', '44', 'Jatisari', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (107, 107, 'Muir', '8910', 'Banjar Dukuh', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (108, 108, 'Bultman', '119', 'Baiba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (109, 109, 'Waywood', '45887', 'Jakubowice Murowane', '21-003');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (110, 110, 'Dovetail', '5492', 'Campor', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (111, 111, 'Service', '7029', 'Kondangrege', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (112, 112, 'Bluejay', '15506', 'Yaogou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (113, 113, 'Nelson', '01', 'Cavadas', '3070-063');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (114, 114, 'Maywood', '68428', 'Brangsi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (115, 115, 'Acker', '57872', 'Yara', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (116, 116, 'Haas', '8532', 'Montauban', '82037 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (117, 117, 'Rutledge', '9041', 'Cabanaconde', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (118, 118, 'Claremont', '4893', 'Viga', '4805');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (119, 119, 'Mallory', '49', 'Kafr az Zayyāt', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (120, 120, 'Maywood', '553', 'Wanareja', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (121, 121, 'Eagle Crest', '184', 'Duwaktenggi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (122, 122, '1st', '218', 'Zougang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (123, 123, 'Hoffman', '7820', 'Wanglu Kulon', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (124, 124, 'Comanche', '161', 'Klobuky', '273 74');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (125, 125, 'Schmedeman', '59', 'Al Qaryatayn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (126, 126, 'Red Cloud', '89436', 'Pasirhuni', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (127, 127, 'Northridge', '0', 'Czerwionka-Leszczyny', '44-238');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (128, 128, 'Scoville', '000', 'Bandar-e Ganāveh', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (129, 129, 'Dunning', '8734', 'Shakhta', '618383');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (130, 130, 'Goodland', '245', 'Dallas', '75310');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (131, 131, 'Cody', '3945', 'Walce', '47-344');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (132, 132, 'Oak', '07', 'Balut', '8420');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (133, 133, 'Brown', '9', 'Puerto Rico', '503068');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (134, 134, 'Mcbride', '33443', 'Bāgh-e Maīdān', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (135, 135, 'Ramsey', '41', 'Taraco', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (136, 136, 'Westend', '73', 'Santa Cruz de Yojoa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (137, 137, 'Manufacturers', '4474', 'Huangma', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (138, 138, 'Holy Cross', '2709', 'Zhigong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (139, 139, 'Barnett', '5010', 'Maganha', '4785-650');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (140, 140, 'Rutledge', '57', 'São Mamede de Infesta', '4465-005');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (141, 141, 'Starling', '92923', 'Taoyuan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (142, 142, 'Larry', '19', 'Lishu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (143, 143, 'Carey', '119', 'Ghanzi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (144, 144, 'Mockingbird', '131', 'Nugas', '3102');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (145, 145, 'Laurel', '8062', 'Jombang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (146, 146, 'Karstens', '7648', 'Getengan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (147, 147, 'Pleasure', '5', 'Le Blanc-Mesnil', '93591 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (148, 148, 'Porter', '054', 'Dalonghua', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (149, 149, 'Buena Vista', '5541', 'Ostrov', '594 51');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (150, 150, 'Manley', '431', 'Xiangyang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (151, 151, 'Meadow Valley', '27', 'Xinyang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (152, 152, 'La Follette', '6922', 'Brodnica', '87-302');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (153, 153, 'Jana', '2', 'Xinglong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (154, 154, 'Veith', '19', 'Catu', '48110-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (155, 155, 'Garrison', '2', 'Semenivka', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (156, 156, 'Towne', '528', 'Ratnapura', '70000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (157, 157, 'Merchant', '40', 'Thị Trấn Hùng Quốc', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (158, 158, 'Twin Pines', '0665', 'Almere Haven', '1354');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (159, 159, 'Jay', '0', 'Shibli', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (160, 160, 'Springs', '72', 'Kashiwazaki', '976-0034');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (161, 161, 'Redwing', '457', 'Krajan Satu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (162, 162, 'Helena', '13399', 'Benešov nad Ploučnicí', '407 22');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (163, 163, 'Milwaukee', '81437', 'Biloxi', '39534');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (164, 164, 'Holy Cross', '755', 'Lazaro Cardenas', '49274');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (165, 165, 'Loftsgordon', '2589', 'Honglai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (166, 166, 'Mayfield', '84', 'Carriedo', '2446');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (167, 167, 'North', '0201', 'Jaraguá do Sul', '89250-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (168, 168, 'Pankratz', '68', 'Bintawan', '3605');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (169, 169, 'Arkansas', '1721', 'Sunduk', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (170, 170, 'Mesta', '739', 'Quma', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (171, 171, 'Grover', '266', 'Mufulira', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (172, 172, 'Kenwood', '581', 'Pomar', '4950-332');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (173, 173, 'Westridge', '925', 'Chorkówka', '38-458');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (174, 174, 'Redwing', '554', 'Pag-asa', '8113');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (175, 175, 'Division', '25108', 'Nekla', '62-330');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (176, 176, 'Mitchell', '40', 'Guaymango', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (177, 177, 'Annamark', '204', 'Thomassique', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (178, 178, 'Express', '603', 'Suban Jeriji', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (179, 179, 'Sutteridge', '2951', 'Cicuco', '132557');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (180, 180, 'Troy', '5', 'Timbó', '89120-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (181, 181, 'Warrior', '09', 'Condong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (182, 182, 'Gulseth', '037', 'Tarikolot', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (183, 183, 'Sachtjen', '5633', 'Pont-à-Mousson', '54704 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (184, 184, 'Northview', '649', 'Vayk’', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (185, 185, 'Eliot', '438', 'Uritsk', '663594');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (186, 186, 'Chive', '5', 'Suslonger', '425050');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (187, 187, '6th', '8', 'Ostrów Lubelski', '21-110');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (188, 188, 'Longview', '3', 'El Retiro', '055438');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (189, 189, 'Sage', '0424', 'Fernando Gutierrez Barrios', '93420');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (190, 190, 'Kennedy', '0899', 'Khalīlābād', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (191, 191, 'Dottie', '84299', 'Karangboyo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (192, 192, 'Anthes', '5', 'Jangkat', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (193, 193, 'Fisk', '1340', 'Bierawa', '47-240');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (194, 194, 'Bobwhite', '29', 'Maishi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (195, 195, 'North', '9', 'Kalde Panga', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (196, 196, 'Brown', '0859', 'Nantes', '44004 CEDEX 1');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (197, 197, 'Weeping Birch', '6308', 'Donegal', 'A85');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (198, 198, 'Sunfield', '1446', 'Corroios', '2855-005');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (199, 199, 'Arrowood', '821', 'Osby', '283 31');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (200, 200, 'Grover', '9', 'Tianzhou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (201, 201, 'Sage', '847', 'Akonolinga', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (202, 202, 'Bluestem', '76990', 'Road Town', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (203, 203, 'Jenifer', '72', 'Raymond', 'G6K');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (204, 204, 'Raven', '4', 'Quelimane', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (205, 205, 'Artisan', '3496', 'Baku', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (206, 206, 'Logan', '3', 'Sukomulyo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (207, 207, 'Carberry', '1', 'Duanjia', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (208, 208, 'Northland', '2166', 'Boucherville', 'J4B');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (209, 209, 'Division', '15', 'Brudzew', '62-720');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (210, 210, 'Mcbride', '34', 'Dungon', '5611');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (211, 211, 'Pepper Wood', '964', 'New Orleans', '70183');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (212, 212, 'Portage', '41152', 'Rasshevatskaya', '356012');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (213, 213, 'Meadow Vale', '0', 'Planken', '9498');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (214, 214, 'Monument', '2249', 'Rio Piracicaba', '35940-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (215, 215, 'Randy', '55768', 'Jönköping', '550 11');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (216, 216, 'Farragut', '59', 'Roseau', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (217, 217, 'Forest Dale', '81068', 'Pregonero', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (218, 218, 'Lakeland', '894', 'Zaporizhzhya', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (219, 219, 'Monica', '886', 'Conel', '6053');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (220, 220, '6th', '11', 'Seynod', '74604 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (221, 221, 'Dovetail', '820', 'Opoczno', '26-301');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (222, 222, 'Dawn', '440', 'Bergen op Zoom', '4619');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (223, 223, 'Hermina', '80978', 'Bujaków', '43-356');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (224, 224, 'Westport', '6862', 'Dallas', '75216');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (225, 225, 'Oak', '53693', 'Xiashu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (226, 226, 'Mcbride', '57', 'Nuquí', '276058');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (227, 227, 'Ridgeview', '26213', 'Naha-shi', '903-0826');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (228, 228, 'Eastwood', '757', 'Jingzhou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (229, 229, 'Shelley', '05821', 'Shimen', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (230, 230, 'Petterle', '06', 'San Buenaventura', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (231, 231, 'Ronald Regan', '45423', 'Ruše', '2342');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (232, 232, 'Pennsylvania', '707', 'Samoš', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (233, 233, 'Derek', '2328', 'Guancheng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (234, 234, 'Kinsman', '4', 'Layo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (235, 235, 'Eastwood', '8', 'Tangjian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (236, 236, 'Pepper Wood', '16', 'Skärholmen', '127 86');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (237, 237, 'Blue Bill Park', '102', 'Patnongon', '5702');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (238, 238, 'Mcbride', '944', 'Bonebone', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (239, 239, 'Elgar', '8', 'Oruro', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (240, 240, 'Stuart', '6109', 'Juwana', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (241, 241, 'Graedel', '586', 'Fukumitsu', '830-0114');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (242, 242, 'Roth', '23279', 'Dagupan', '5603');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (243, 243, 'Hermina', '53', 'Sinchao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (244, 244, 'Village Green', '4', 'Taichung', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (245, 245, 'Prentice', '6', 'Bergamo', '24129');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (246, 246, 'Clyde Gallagher', '7', 'Matwaḩ', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (247, 247, 'Hudson', '7', 'Mainit', '8407');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (248, 248, 'Old Gate', '712', 'Yanguan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (249, 249, 'Graceland', '79', 'Tha Ruea', '13130');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (250, 250, 'David', '0', 'Santa Vitória do Palmar', '96230-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (251, 251, 'Nobel', '34316', 'Gambut', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (252, 252, 'Banding', '29016', 'Netolice', '507 43');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (253, 253, 'Hovde', '47937', 'Chai Badan', '15130');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (254, 254, 'Dottie', '754', 'Kota Kinabalu', '88998');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (255, 255, 'East', '96', 'Donglu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (256, 256, 'Di Loreto', '80044', 'Jiaokou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (257, 257, 'Knutson', '2658', 'Cornillon', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (258, 258, 'Jenna', '03744', 'Domsjö', '892 34');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (259, 259, 'Larry', '742', 'Ban Tak', '63120');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (260, 260, 'Harbort', '6', 'Buan', '6333');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (261, 261, 'Eagan', '1031', 'Irbit', '623850');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (262, 262, 'Talmadge', '39301', 'Huifeng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (263, 263, 'Dahle', '8', 'Baoxia', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (264, 264, 'Harper', '008', 'Anshan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (265, 265, 'Arkansas', '1', 'Heihe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (266, 266, 'Oriole', '252', 'Zaozhuang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (267, 267, 'Banding', '1', 'Dul’durga', '687200');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (268, 268, 'Bobwhite', '640', 'Fengren', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (269, 269, 'Ludington', '321', 'Sardasht', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (270, 270, 'Judy', '1110', 'Tungelsta', '137 57');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (271, 271, 'Buhler', '1', 'Vrané nad Vltavou', '252 46');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (272, 272, 'Arizona', '237', 'Pittsburgh', '15279');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (273, 273, 'Lawn', '4', 'Cijeungjing Kaler', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (274, 274, 'Hauk', '253', 'Katrineholm', '641 96');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (275, 275, 'Golf View', '65', 'Vapnyarka', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (276, 276, 'Di Loreto', '72', 'Ganjiangtou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (277, 277, 'Stang', '41', 'Luzino', '84-242');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (278, 278, 'Dunning', '10461', 'Longcun', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (279, 279, 'Gulseth', '25', 'Đắk Mâm', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (280, 280, 'Reinke', '5', 'Isfana', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (281, 281, 'Kipling', '94', 'New Leyte', '8102');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (282, 282, 'Golf View', '671', 'Mzimba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (283, 283, 'Claremont', '920', 'Riolândia', '15495-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (284, 284, 'Southridge', '28281', 'Rzyki', '34-125');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (285, 285, 'Ramsey', '3', 'Vyksa', '607069');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (286, 286, 'Prentice', '15', 'Aemura', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (287, 287, 'Jenifer', '3912', 'Singojuruh', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (288, 288, 'Lyons', '68452', 'Besisahar', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (289, 289, 'Bayside', '66', 'Charlemagne', 'J6V');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (290, 290, 'International', '030', 'Charlotte Amalie', '00822');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (291, 291, 'Kinsman', '5', 'Marantao', '9711');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (292, 292, 'Welch', '99', 'Tashtagol', '652993');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (293, 293, 'Rockefeller', '6', 'Itacoatiara', '69100-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (294, 294, 'Johnson', '7', 'Huanghuai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (295, 295, 'Huxley', '8', 'Primorsko-Akhtarsk', '353866');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (296, 296, 'Ruskin', '76424', 'Guangsheng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (297, 297, 'Coolidge', '7490', 'Tarica', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (298, 298, 'Westridge', '7463', 'El Corpus', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (299, 299, 'Daystar', '74', 'Linoan', '8106');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (300, 300, 'Mesta', '00133', 'Inuvik', 'E8L');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (301, 301, 'Holmberg', '1618', 'Lakeland', '33805');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (302, 302, 'Logan', '859', 'Pai do Vento', '2755-279');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (303, 303, 'Heath', '7497', 'Kosmach', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (304, 304, 'Kensington', '8', 'Tangzang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (305, 305, 'Hudson', '21697', 'Sirdaryo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (306, 306, 'Shopko', '8358', 'Boca Chica', '11102');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (307, 307, 'Lyons', '9732', 'Kunjāh', '55151');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (308, 308, 'High Crossing', '458', 'Hämeenkoski', '16801');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (309, 309, 'Kinsman', '65166', 'Murygino', '613641');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (310, 310, 'Kedzie', '9591', 'Dawu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (311, 311, 'Northwestern', '32633', 'Stoney Ground', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (312, 312, 'Forest Run', '14215', 'Kashima-shi', '314-0048');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (313, 313, 'Weeping Birch', '1', 'Sherbrooke', 'J1K');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (314, 314, 'Dayton', '9212', 'Khudāydād Khēl', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (315, 315, 'Pierstorff', '90', 'Huzhen', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (316, 316, 'Calypso', '05', 'Lees Summit', '64082');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (317, 317, 'Fairfield', '73', 'Zheleznogorsk', '307156');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (318, 318, 'Anniversary', '912', 'Wonokerso', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (319, 319, 'Westerfield', '83389', 'Tabogon', '6009');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (320, 320, 'Mccormick', '9', 'Vlorë', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (321, 321, 'Springview', '9', 'Wanjiazhuang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (322, 322, 'Loeprich', '725', 'Qiting', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (323, 323, 'Amoth', '6', 'Tugusirna', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (324, 324, 'Hooker', '69', 'Setro', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (325, 325, 'Westport', '268', 'Havirga', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (326, 326, 'Messerschmidt', '6', 'Tarkwa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (327, 327, 'Derek', '42', 'Jiufeng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (328, 328, 'Homewood', '6', 'El Viejo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (329, 329, 'Shelley', '611', 'Gaoyan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (330, 330, 'Coleman', '84142', 'Gōdo', '503-2429');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (331, 331, 'Dovetail', '1089', 'Guataquí', '252827');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (332, 332, 'Atwood', '8', 'San Miguel Dueñas', '03017');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (333, 333, 'Magdeline', '5027', 'Viale', '3109');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (334, 334, 'Blaine', '9', 'Kanal', '5213');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (335, 335, 'Arapahoe', '67061', 'Zhabagly', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (336, 336, 'Rockefeller', '4378', 'Haapajärvi', '85801');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (337, 337, 'Hazelcrest', '79', 'Geoktschai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (338, 338, 'Dovetail', '7', 'Katiola', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (339, 339, 'Weeping Birch', '01', 'Cataguases', '36770-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (340, 340, 'Sycamore', '789', 'Tenkodogo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (341, 341, 'Red Cloud', '6', 'Mariestad', '542 87');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (342, 342, 'Transport', '81862', 'Hinvi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (343, 343, 'Bellgrove', '7', 'Besançon', '25014 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (344, 344, 'Duke', '52513', 'Boro', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (345, 345, 'Grover', '7329', 'Kedungtaman', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (346, 346, 'Randy', '586', 'Longquan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (347, 347, 'Gale', '8', 'Xiakouyi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (348, 348, 'Carey', '4', 'Xuguang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (349, 349, 'North', '659', 'Boucinha', '4950-122');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (350, 350, 'Mayfield', '246', 'Hoàn Kiếm', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (351, 351, 'Kipling', '680', 'Golek', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (352, 352, 'Dawn', '22855', 'Shizong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (353, 353, 'Eagan', '156', 'Shāhpur Chākar', '72121');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (354, 354, 'Nevada', '2220', 'Burujul', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (355, 355, 'Lakeland', '48020', 'Blagodatnoye', '356503');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (356, 356, 'Dahle', '07309', 'Ivanovo-Alekseyevka', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (357, 357, 'Farwell', '8', 'Krynychky', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (358, 358, 'Larry', '7747', 'Carrascal', '6120-215');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (359, 359, 'Scoville', '7644', 'Ocampo', '4419');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (360, 360, 'Hazelcrest', '1', 'Kalamangog', '7006');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (361, 361, 'Briar Crest', '84214', 'Azua', '10607');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (362, 362, 'Stuart', '8779', 'Pantukan', '8117');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (363, 363, 'Sundown', '484', 'Latowicz', '05-334');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (364, 364, 'Ryan', '61763', 'Tessaoua', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (365, 365, 'Northwestern', '49', 'Pukou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (366, 366, 'Straubel', '0547', 'Baume-les-Dames', '25117 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (367, 367, 'Center', '585', 'Peremyshl’', '249144');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (368, 368, 'Texas', '1420', 'Polo', '1444');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (369, 369, 'Prairieview', '36288', 'Bauta', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (370, 370, 'Ronald Regan', '8', 'Guadalupe Victoria', '93856');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (371, 371, 'Sutteridge', '881', 'Llipa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (372, 372, 'Swallow', '48161', 'Granja', '62430-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (373, 373, 'Heffernan', '302', 'Praia da Vagueira', '3840-272');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (374, 374, 'Village', '6418', 'Nanganumba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (375, 375, 'Sugar', '375', 'Shuishaping', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (376, 376, 'Schlimgen', '19', 'Krzyżanowice', '47-450');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (377, 377, 'Macpherson', '0294', 'Berlin', '12307');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (378, 378, 'Village Green', '9827', 'Dobrovo', '5212');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (379, 379, 'Summit', '776', 'Wurno', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (380, 380, 'Grim', '4894', 'Mabuhay', '7010');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (381, 381, 'John Wall', '3381', 'Yangtan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (382, 382, 'Barnett', '80', 'Petaling Jaya', '47307');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (383, 383, 'Clarendon', '7471', 'Tongzha', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (384, 384, 'Corscot', '87293', 'San Antonio', '4503');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (385, 385, 'Bayside', '0676', 'Madan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (386, 386, 'Elmside', '61', 'Kumlinge', '22820');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (387, 387, 'Dennis', '3279', 'Rungkang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (388, 388, 'Hudson', '0', 'Bečej', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (389, 389, 'Cambridge', '2099', 'Montalegre', '5470-206');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (390, 390, 'Elgar', '92', 'Maastricht', '6224');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (391, 391, 'Larry', '2026', 'Fëdorovskoye', '196625');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (392, 392, 'Moulton', '79253', 'Saint-Germain-en-Laye', '78105 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (393, 393, 'Bluejay', '2361', 'Guadalupe', '52107');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (394, 394, 'Onsgard', '4', 'Kafachan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (395, 395, 'Pepper Wood', '03092', 'Columbus', '43268');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (396, 396, 'Sloan', '367', 'Georgetown', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (397, 397, 'Crownhardt', '3', 'Yajiang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (398, 398, 'Miller', '2588', 'Hronov', '549 31');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (399, 399, 'Upham', '4', 'Mabalacat', '2010');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (400, 400, 'Weeping Birch', '7530', 'Stockholm', '115 22');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (401, 401, 'Monterey', '94', 'Iroquois Falls', 'L6K');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (402, 402, 'Dawn', '3596', 'Lobuk', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (403, 403, 'Chinook', '06', 'Iza', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (404, 404, 'Blue Bill Park', '465', 'Karangboyo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (405, 405, 'Karstens', '3373', 'Vales', '3550-053');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (406, 406, 'Moulton', '8108', 'Boto', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (407, 407, 'Columbus', '41685', 'Urzuf', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (408, 408, 'Dorton', '275', 'Shuangxiqiao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (409, 409, 'Glacier Hill', '7709', 'Kanoni', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (410, 410, 'Cody', '427', 'Matingain', '4211');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (411, 411, 'Holy Cross', '68', 'Sarrazola', '3800-596');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (412, 412, 'North', '5', 'Valle de Guanape', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (413, 413, 'Arkansas', '02', 'Maubara', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (414, 414, 'Larry', '1', 'Kijang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (415, 415, 'Dottie', '3', 'Rokytnice', '755 01');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (416, 416, 'Dunning', '82', 'Kezileboyi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (417, 417, 'Pierstorff', '0', 'Farroupilha', '95180-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (418, 418, 'Gateway', '786', 'Kapsan-ŭp', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (419, 419, 'Harper', '7', 'Quanxi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (420, 420, 'Crowley', '14325', 'Guyang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (421, 421, 'Fair Oaks', '544', 'Tammela', '31300');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (422, 422, 'Merry', '364', 'Ḥurfeish', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (423, 423, 'Hayes', '4', 'Wangdian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (424, 424, 'Valley Edge', '6', 'Taguing', '1960');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (425, 425, 'Summer Ridge', '05452', 'Ciekek', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (426, 426, 'Upham', '7', 'Krutaya Gorka', '646404');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (427, 427, 'Namekagon', '539', 'Etten-Leur', '4874');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (428, 428, 'John Wall', '011', 'Akhtarīn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (429, 429, 'Dennis', '7218', 'Fresno', '93704');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (430, 430, 'Portage', '68', 'Gränna', '563 32');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (431, 431, 'Kingsford', '5', 'Khvastovichi', '249360');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (432, 432, 'Continental', '06859', 'Qingyang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (433, 433, 'Hintze', '5353', 'Antsirabe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (434, 434, 'Dunning', '07516', 'Cileuya', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (435, 435, 'Algoma', '0171', 'Catalina', 'B2V');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (436, 436, 'La Follette', '3', 'Hošťka', '348 06');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (437, 437, 'Tomscot', '496', 'Dayr Sharaf', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (438, 438, 'Dovetail', '638', 'Chicago', '60686');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (439, 439, 'Barby', '275', 'Oleksandriya', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (440, 440, 'Mifflin', '7', 'Ol’ginskaya', '663914');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (441, 441, 'Amoth', '31', 'Şalākhid', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (442, 442, 'Russell', '17228', 'Pszczyna', '43-200');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (443, 443, 'Aberg', '4539', 'Sumber', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (444, 444, 'Grasskamp', '0', 'Tyringe', '282 91');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (445, 445, 'Manufacturers', '58', 'Uummannaq', '3961');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (446, 446, 'Katie', '808', 'Helmas', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (447, 447, 'Cascade', '8464', 'Brandfort', '9400');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (448, 448, 'Coolidge', '1', 'São Luiz Gonzaga', '97800-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (449, 449, 'Oak Valley', '31622', 'Dagda', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (450, 450, 'Golf Course', '87350', 'Teófilo Otoni', '39800-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (451, 451, 'Menomonie', '95123', 'Sult', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (452, 452, 'Ridgeview', '67553', 'Bitkine', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (453, 453, 'Esker', '049', 'Detroit', '48258');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (454, 454, 'Warrior', '7', 'La Unión', '761548');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (455, 455, 'Rowland', '5420', 'Souflí', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (456, 456, 'Grim', '29325', 'Palauig', '6615');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (457, 457, 'Manitowish', '04', 'Créteil', '94039 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (458, 458, 'Bunker Hill', '58419', 'Mulhouse', '68064 CEDEX 3');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (459, 459, 'Weeping Birch', '38', 'Karanganyar', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (460, 460, 'Brentwood', '44718', 'Koronganayam', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (461, 461, 'Lighthouse Bay', '88', 'Bulo', '2510');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (462, 462, 'Trailsway', '97330', 'Watublapi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (463, 463, 'Mitchell', '67', 'Tammela', '31300');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (464, 464, 'Westerfield', '72285', 'Artur Nogueira', '13160-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (465, 465, 'Dovetail', '894', 'Alae', '2705');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (466, 466, 'Harper', '82', 'Puconci', '9201');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (467, 467, 'Morning', '8', 'Pangapisan', '4001');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (468, 468, 'Sycamore', '94', 'Springfield', '62711');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (469, 469, 'Delladonna', '83314', 'Labuhan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (470, 470, 'Mariners Cove', '49', 'Orléans', '45032 CEDEX 1');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (471, 471, 'Pond', '5128', 'Mabua', '3706');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (472, 472, 'Amoth', '1414', 'Rochefort', '17314 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (473, 473, 'Norway Maple', '121', 'Carrasqueira', '2420-267');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (474, 474, 'Morning', '63885', 'Farnham', 'J2N');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (475, 475, 'Green', '422', 'Damai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (476, 476, 'Texas', '363', 'Fedorovka', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (477, 477, 'New Castle', '183', 'London', 'EC1V');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (478, 478, 'Comanche', '91803', 'Guyancourt', '78280');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (479, 479, 'Portage', '183', 'Dębno', '74-400');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (480, 480, 'Charing Cross', '533', 'Costa Rica', '79550-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (481, 481, 'Mallard', '155', 'Yulin', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (482, 482, 'Debra', '15482', 'Beiwenquan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (483, 483, 'Chive', '474', 'Sukadana', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (484, 484, 'Fuller', '54213', 'München', '81679');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (485, 485, 'Lindbergh', '850', 'Bakhmach', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (486, 486, 'Pennsylvania', '690', 'Huangze', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (487, 487, 'New Castle', '29', 'Kembangkerang Lauk Timur', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (488, 488, 'Kinsman', '60', 'Charleroi', '6042');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (489, 489, 'Hallows', '4948', 'Seda', '89051');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (490, 490, 'Almo', '9', 'Zhulan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (491, 491, 'Sunfield', '008', 'Mhango', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (492, 492, 'Kropf', '6384', 'Mwene-Ditu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (493, 493, 'Sycamore', '57', 'Venta', '85019');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (494, 494, 'Sunnyside', '471', 'Chợ Mới', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (495, 495, 'Emmet', '4', 'Suna', '612450');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (496, 496, 'Delladonna', '736', 'Yuxi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (497, 497, 'Laurel', '2430', 'Jingzhou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (498, 498, 'Spaight', '39369', 'Ritchie', '8701');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (499, 499, 'Di Loreto', '5995', 'Temirtau', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (500, 500, 'Vidon', '666', 'Rizal', '7104');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (501, 501, 'Clemons', '23', 'Albert Town', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (502, 502, 'Hansons', '764', 'Robatal', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (503, 503, 'Monterey', '8709', 'Yaotian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (504, 504, 'Logan', '3', 'Mizhhir’ya', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (505, 505, 'Dakota', '0', 'Kamnica', '2351');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (506, 506, 'Pine View', '37', 'Kan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (507, 507, 'Mesta', '26', 'Viitasaari', '44501');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (508, 508, 'Dixon', '7', 'Gar', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (509, 509, 'Golden Leaf', '187', 'Gainesville', '32627');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (510, 510, 'Texas', '372', 'Zhangyang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (511, 511, 'Cordelia', '95802', 'Zvenigorod', '143035');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (512, 512, 'Schlimgen', '1850', 'London', 'WC2H');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (513, 513, 'Utah', '412', 'Shakhta', '618383');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (514, 514, 'Dakota', '37383', 'Kotabaru', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (515, 515, 'Oriole', '15', 'Moyamba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (516, 516, 'Morning', '44', 'Nuwaybi‘a', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (517, 517, 'Monterey', '4', 'Asahikawa', '905-0003');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (518, 518, 'Kennedy', '7', 'Tongbang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (519, 519, 'Summer Ridge', '9', 'Laba Goumen', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (520, 520, 'Holmberg', '30923', 'Al Qanāţir al Khayrīyah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (521, 521, 'Barby', '2', 'Necochea', '7630');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (522, 522, 'Sommers', '36', 'Haolibao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (523, 523, 'Tennyson', '23', 'Bernardo Larroudé', '6220');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (524, 524, 'Bluejay', '53554', 'Bangassou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (525, 525, 'Morning', '5658', 'San Nicolas', '4207');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (526, 526, 'Haas', '3378', 'Youchou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (527, 527, 'Ridgeview', '4', 'Jindřichov', '788 23');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (528, 528, 'Hoepker', '2839', 'Hwawŏn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (529, 529, 'Aberg', '088', 'Chengbei', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (530, 530, 'Garrison', '0218', 'Mencon', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (531, 531, 'Huxley', '622', 'Frisange', 'L-5754');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (532, 532, 'Hanson', '12280', 'Xianan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (533, 533, 'Melvin', '9667', 'Thākurgaon', '1341');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (534, 534, 'Continental', '1', 'San Felipe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (535, 535, 'Londonderry', '84', 'Gotse Delchev', '2971');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (536, 536, 'Prentice', '2', 'København', '1656');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (537, 537, 'Corben', '93235', 'Pajo', '1665');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (538, 538, 'High Crossing', '2', 'Skórzec', '08-114');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (539, 539, 'Truax', '74514', 'Rafaï', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (540, 540, 'Blackbird', '7', 'Värnamo', '331 85');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (541, 541, 'Scott', '601', 'Nam Đàn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (542, 542, 'Truax', '56', 'Shimen', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (543, 543, 'Sherman', '5811', 'El Cairo', '761508');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (544, 544, 'Upham', '40268', 'Fuyo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (545, 545, 'Kennedy', '58957', 'Canoas', '92000-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (546, 546, 'Schiller', '96', 'Göteborg', '400 15');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (547, 547, 'Mallard', '2', 'Knurów', '44-196');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (548, 548, 'Oak', '3180', '‘Arīshah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (549, 549, 'Northland', '46247', 'Sete Cidades', '9555-197');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (550, 550, 'Lotheville', '04', 'Kertabumi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (551, 551, 'Clemons', '86', 'Xinhua', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (552, 552, 'Crownhardt', '21', 'Tanjungbatu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (553, 553, 'West', '9465', 'São Manuel', '18650-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (554, 554, 'Donald', '58', 'Labansari', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (555, 555, 'Eastwood', '957', 'Kutacane', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (556, 556, 'Dwight', '58', 'Koloniya Zastav’ye', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (557, 557, 'Crest Line', '69', 'Thiès Nones', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (558, 558, 'Schurz', '95055', 'Phủ Thông', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (559, 559, 'John Wall', '024', 'Nicoya', '50201');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (560, 560, 'Johnson', '104', 'Al Mazār', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (561, 561, 'Jay', '53', 'Libouchec', '403 35');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (562, 562, 'Mifflin', '92347', 'Comandante Fontana', '3620');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (563, 563, 'Sherman', '10', 'Białołeka', '05-094');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (564, 564, 'Sunbrook', '56533', 'Suwaduk', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (565, 565, 'Cody', '199', 'Balangkayan', '6801');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (566, 566, 'Bluejay', '8377', 'Ciudad Cortés', '60306');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (567, 567, 'Jay', '28611', 'Hangji', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (568, 568, 'Northland', '35257', 'Aanislag', '4500');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (569, 569, 'Del Mar', '0', 'Reszel', '11-440');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (570, 570, 'Haas', '50', 'Nowa Dęba', '39-460');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (571, 571, 'Cardinal', '79', 'Strathmore', 'T1P');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (572, 572, 'Roth', '76', 'Chak Two Hundred Forty-Nine TDA', '19030');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (573, 573, 'Bunker Hill', '342', 'Newlands', '7700');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (574, 574, 'Becker', '2', 'Pamyat’ Parizhskoy Kommuny', '606488');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (575, 575, 'Ramsey', '414', 'Pampas', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (576, 576, 'Farmco', '41633', 'Chengdong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (577, 577, 'Fieldstone', '0775', 'Dos Hermanas', '41703');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (578, 578, 'Sachtjen', '2', 'Shaxi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (579, 579, 'Chinook', '706', 'Villa María', '5900');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (580, 580, 'Graedel', '2843', 'Ica', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (581, 581, 'Shelley', '67', 'Neringa', '93017');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (582, 582, 'Hudson', '7289', 'Gozdowo', '09-213');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (583, 583, 'Rieder', '29358', 'Tuchola', '89-501');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (584, 584, 'Thompson', '89204', 'Carolina', '00987');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (585, 585, 'Waywood', '651', 'Vicente Guerrero', '86350');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (586, 586, 'Haas', '994', 'Zhongshan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (587, 587, 'Cherokee', '2589', 'Wuluquele', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (588, 588, 'Jackson', '5251', 'Phatthaya', '72160');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (589, 589, 'Maywood', '90', 'Mansa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (590, 590, 'Bonner', '485', 'Patsi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (591, 591, 'Prairieview', '9', 'Zhishan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (592, 592, 'Becker', '2', 'Kurihashi', '349-1104');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (593, 593, 'Fairview', '614', 'Dhī as Sufāl', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (594, 594, 'Merrick', '4494', 'Kishi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (595, 595, 'Fisk', '715', 'Pont Cassé', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (596, 596, 'Randy', '12', 'São João dos Montes', '2600-771');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (597, 597, 'Mandrake', '6791', 'Zbąszynek', '66-210');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (598, 598, 'Main', '603', 'Sydney', '1028');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (599, 599, 'Warner', '4', 'Minusinsk', '662622');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (600, 600, 'Manufacturers', '46', 'Birmingham', 'B12');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (601, 601, 'Pawling', '8667', 'Wenquan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (602, 602, 'Maywood', '378', 'Kalangbret', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (603, 603, 'Stang', '19719', 'Guanabacoa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (604, 604, 'Bartillon', '8191', 'Iúna', '29390-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (605, 605, 'Hazelcrest', '63498', 'Non Suwan', '31110');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (606, 606, 'Artisan', '1', 'Bungereng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (607, 607, 'Loftsgordon', '55326', 'Předměřice nad Labem', '503 02');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (608, 608, 'Hoard', '85972', 'Savé', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (609, 609, 'Petterle', '6', 'Puyung', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (610, 610, 'Moose', '032', 'Qumudi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (611, 611, 'Colorado', '5', 'San Agustin', '8305');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (612, 612, 'Ludington', '476', 'Novoaltaysk', '658089');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (613, 613, 'Monica', '2', 'Sundre', 'L9H');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (614, 614, 'Elmside', '17', 'Amor', '2400-772');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (615, 615, 'Bluejay', '4', 'Croix', '59961 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (616, 616, 'Monica', '235', 'Videm pri Ptuju', '2284');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (617, 617, 'Nova', '1', 'Taraš', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (618, 618, 'North', '333', 'Muikamachi', '990-0054');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (619, 619, 'Tony', '7', 'Jiangfang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (620, 620, 'Sachs', '6975', 'Pahonjean', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (621, 621, 'Eliot', '2524', 'Hernando', '5929');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (622, 622, 'Redwing', '5322', 'Launceston', '7904');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (623, 623, 'Chive', '8024', 'Falāvarjān', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (624, 624, 'Arrowood', '723', 'Rego de Água', '2860-278');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (625, 625, 'Thackeray', '22', 'München', '80686');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (626, 626, 'Jenifer', '92', 'João Pessoa', '58000-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (627, 627, 'Vera', '95', 'Shatrovo', '641960');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (628, 628, 'Summit', '7', 'Doloplazy', '783 56');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (629, 629, 'Valley Edge', '16408', 'Alebtong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (630, 630, 'Pepper Wood', '386', 'Belfast', 'BT2');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (631, 631, 'Bashford', '271', 'Oganlima', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (632, 632, 'Bashford', '7', 'Fonte Boa dos Nabos', '2655-469');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (633, 633, 'Little Fleur', '67073', 'Al Manshāh', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (634, 634, 'Jana', '4', 'Łyse', '07-437');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (635, 635, 'Hoard', '7016', 'Chugur', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (636, 636, 'Mifflin', '32492', 'Sunampe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (637, 637, 'Old Gate', '8314', 'Minle', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (638, 638, 'Cody', '6', 'Harstad', '9406');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (639, 639, 'Boyd', '420', 'Jincheng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (640, 640, 'Ridgeway', '2959', 'San Jacinto', '5417');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (641, 641, 'Dapin', '70', 'Nezamyslice', '798 26');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (642, 642, 'La Follette', '98', 'Kamsack', 'R2J');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (643, 643, 'Continental', '78', 'Tonggu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (644, 644, 'Tennyson', '72', 'Weetombo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (645, 645, 'Kensington', '7119', 'Pulo', '1706');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (646, 646, 'Northport', '1', 'Bulgan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (647, 647, 'Rockefeller', '7', 'Gaza', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (648, 648, 'Kipling', '8964', 'Chelopech', '2087');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (649, 649, 'Ludington', '28', 'Kovernino', '606570');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (650, 650, 'Florence', '145', 'Ea T’ling', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (651, 651, 'Butternut', '9', 'Baima', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (652, 652, 'Forster', '29612', 'San Francisco', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (653, 653, 'Brickson Park', '4', 'Minas de Marcona', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (654, 654, 'Beilfuss', '81786', 'Trelleborg', '231 23');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (655, 655, 'Carioca', '046', 'Heshan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (656, 656, 'Welch', '684', 'Pueblo Nuevo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (657, 657, 'Hintze', '2306', 'Wonorejo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (658, 658, 'Onsgard', '371', 'Remscheid', '42897');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (659, 659, 'Sunfield', '275', 'Hezuoqiao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (660, 660, 'Loftsgordon', '163', 'Łobez', '73-150');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (661, 661, 'Westerfield', '67131', 'Mene de Mauroa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (662, 662, 'Corry', '2', 'Kolomak', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (663, 663, 'Cardinal', '528', 'Huiyuan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (664, 664, 'Jackson', '6927', 'Kampala', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (665, 665, '8th', '35310', 'Berģi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (666, 666, 'Arapahoe', '752', 'Esperanza', '8513');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (667, 667, 'Moulton', '69', 'Kuroiso', '325-0017');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (668, 668, 'West', '44801', 'Makīnsk', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (669, 669, 'Corry', '442', 'Jinzhuang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (670, 670, 'Dennis', '11', 'Shilipu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (671, 671, 'Boyd', '75', 'Gīvī', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (672, 672, 'Jenifer', '8', 'Kostakioí', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (673, 673, '5th', '5872', 'Verkhniy Dashkesan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (674, 674, 'Melrose', '4', 'Whitchurch', 'BS14');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (675, 675, 'Schmedeman', '628', 'Lao Suea Kok', '41220');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (676, 676, 'Laurel', '00', 'Youkounkoun', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (677, 677, 'Crest Line', '7', 'Xinchang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (678, 678, 'Forest Dale', '4', 'Kopang Satu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (679, 679, 'Maple', '5897', 'Strančice', '251 63');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (680, 680, 'Buhler', '481', 'Morcolla', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (681, 681, 'Northfield', '23', 'Nouvelle France', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (682, 682, 'Corscot', '2', 'Songwon', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (683, 683, 'Coolidge', '76088', 'Ore', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (684, 684, 'Surrey', '68583', 'Bukabu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (685, 685, 'Bobwhite', '382', 'Candelaria', '111711');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (686, 686, 'Shasta', '69051', 'Mỹ Thọ', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (687, 687, 'Anhalt', '4697', 'Lakha Nëvre', '442638');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (688, 688, 'Hayes', '877', 'Blois', '41965 CEDEX 9');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (689, 689, 'Hintze', '9211', 'Raejeru', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (690, 690, 'Karstens', '2817', 'Fangshan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (691, 691, 'Mcbride', '9', 'Emnambithi-Ladysmith', '3384');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (692, 692, 'Dakota', '285', 'Labège', '31678 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (693, 693, 'Susan', '73', 'Masape', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (694, 694, 'Blue Bill Park', '50', 'Calvário', '4820-449');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (695, 695, 'Pierstorff', '101', 'Santo Isidro', '2985-105');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (696, 696, 'Forest Run', '0178', 'Tyachiv', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (697, 697, 'Meadow Vale', '90467', 'Qianyou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (698, 698, 'Jenifer', '2260', 'Yongning', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (699, 699, 'Briar Crest', '905', 'Sidi Bousber', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (700, 700, 'Manley', '1', 'Železniki', '4228');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (701, 701, 'Johnson', '99', 'Patambuco', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (702, 702, 'Orin', '6695', 'Heping', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (703, 703, 'Bay', '3', 'Yashikera', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (704, 704, 'School', '670', 'Hongyi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (705, 705, 'Vidon', '79', 'Cachachi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (706, 706, 'Pearson', '65654', 'Shangshaleng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (707, 707, 'Mcguire', '06', 'Balaoang', '2509');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (708, 708, 'Welch', '2653', 'Tirtopuro', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (709, 709, 'Ridge Oak', '5', 'Tallahassee', '32314');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (710, 710, 'Mcguire', '6', 'Singajaya', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (711, 711, 'Moose', '578', 'Granada', '18010');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (712, 712, 'Kenwood', '1806', 'Jiuhua', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (713, 713, 'Sutherland', '8831', 'Opařany', '391 61');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (714, 714, 'Pankratz', '66', 'Muara Sabak', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (715, 715, 'Macpherson', '1', 'Fresno', '93726');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (716, 716, 'Acker', '961', 'Xipi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (717, 717, 'Columbus', '02950', 'Santol', '2516');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (718, 718, 'Dottie', '39815', 'Al Majāridah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (719, 719, 'Arapahoe', '93192', 'Sincé', '056450');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (720, 720, 'Pleasure', '3', 'Sāqayn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (721, 721, 'Orin', '8', 'Baimajing', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (722, 722, 'Northwestern', '20159', 'Shinan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (723, 723, 'School', '0', 'Cahors', '46091 CEDEX 9');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (724, 724, 'Talmadge', '14450', 'Covas da Raposa', '2970-124');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (725, 725, 'Farragut', '74294', 'Barreiro', '4950-642');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (726, 726, 'Ridge Oak', '96', 'Bayan Huxu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (727, 727, 'Carpenter', '5', 'Barrancas', '443049');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (728, 728, 'Schurz', '708', 'Dulangan', '5203');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (729, 729, 'Eliot', '38347', 'Shantoudian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (730, 730, 'Johnson', '0013', 'Žeravice', '696 47');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (731, 731, 'Cherokee', '9', 'Lanyang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (732, 732, 'Reindahl', '779', 'Tianzhou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (733, 733, 'Kenwood', '07', 'Зуунмод', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (734, 734, 'Amoth', '703', 'Ghāt', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (735, 735, 'Continental', '571', 'Figueira dos Cavaleiros', '7900-234');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (736, 736, 'Clyde Gallagher', '4', 'Citeguh', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (737, 737, 'Del Mar', '074', 'Andou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (738, 738, 'Eastlawn', '1561', 'Paatan', '9406');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (739, 739, 'Manitowish', '0', 'Sukorambi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (740, 740, 'Fremont', '94111', 'Crespo', '3116');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (741, 741, 'Gina', '2', 'Laojie', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (742, 742, 'Orin', '0', 'Kapchorwa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (743, 743, 'Vidon', '1589', 'Sanankerto', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (744, 744, 'Chinook', '0', 'Amiens', '80042 CEDEX 1');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (745, 745, 'Longview', '24095', 'Baykonyr', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (746, 746, 'Cherokee', '0', 'Nelas', '3520-031');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (747, 747, 'Thierer', '586', 'Maltahöhe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (748, 748, 'Eagle Crest', '6301', 'Luau', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (749, 749, 'Loomis', '4', 'Tapel', '3513');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (750, 750, 'Cordelia', '20462', 'Bertioga', '11250-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (751, 751, 'Mcbride', '18256', 'Bluff', '9814');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (752, 752, 'Dawn', '4', 'São Vicente de Ferreira', '9545-524');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (753, 753, 'Becker', '889', 'Krrabë', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (754, 754, 'Cottonwood', '1', 'Shuidong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (755, 755, 'Barby', '27', 'Dve Mogili', '7159');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (756, 756, 'Kinsman', '62', 'Pewel Wielka', '34-332');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (757, 757, 'Truax', '727', 'Āl Ma‘ūdah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (758, 758, 'Anhalt', '83', 'Las Vegas', '89166');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (759, 759, 'International', '01418', 'Gapyeong', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (760, 760, 'Manley', '0', 'Alakak', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (761, 761, 'Banding', '5', 'Qiangtou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (762, 762, 'Sage', '98089', 'Xiongzhou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (763, 763, 'Fremont', '71849', 'Duotian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (764, 764, 'Southridge', '44', 'Jinggongqiao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (765, 765, 'Sunfield', '916', 'Sovetsk', '238758');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (766, 766, 'Schiller', '52381', 'Pęczniew', '99-235');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (767, 767, 'Paget', '117', 'San Rafael Abajo', '10311');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (768, 768, 'Valley Edge', '61', 'Esperanza', '8513');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (769, 769, 'Northport', '887', 'Baohe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (770, 770, 'International', '48570', 'Peuara', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (771, 771, 'Riverside', '91592', 'Santa Fe', '6513');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (772, 772, 'Northport', '43013', 'Changfa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (773, 773, 'Rusk', '47487', 'Águia Branca', '29795-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (774, 774, 'Cambridge', '07574', 'Gareba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (775, 775, 'Steensland', '1349', 'Coaticook', 'J1A');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (776, 776, 'Kennedy', '55799', 'Latung', '1119');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (777, 777, 'Service', '1', 'Alajuelita', '11001');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (778, 778, 'Pepper Wood', '3011', 'Ust’-Abakan', '163028');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (779, 779, 'Jana', '382', 'Polje', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (780, 780, 'Hermina', '75', 'Leganes', '28914');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (781, 781, 'Warbler', '1', 'Nghĩa Hành', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (782, 782, 'Ronald Regan', '2', 'Qinling Jieban', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (783, 783, 'Laurel', '281', 'Xingou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (784, 784, 'Schlimgen', '24446', 'Carriedo', '2446');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (785, 785, 'Coolidge', '79781', 'Wołomin', '05-203');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (786, 786, 'Rockefeller', '43544', 'Saitama', '343-0801');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (787, 787, '3rd', '80966', 'Samagaltay', '663716');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (788, 788, 'Delaware', '4934', 'Siquirres', '70301');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (789, 789, 'Sutteridge', '64918', 'Mutoko', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (790, 790, 'Sunbrook', '96', 'Bua Yai', '30120');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (791, 791, 'Sommers', '82638', 'Munturkaju', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (792, 792, 'Algoma', '578', 'Xinheng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (793, 793, 'Thompson', '054', 'Watrous', 'L9T');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (794, 794, 'Main', '2', 'Varaždin', '42000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (795, 795, '7th', '1272', 'Yinglan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (796, 796, 'Hanover', '4735', 'Santa Ana', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (797, 797, 'Judy', '19972', 'Sevilla', '41020');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (798, 798, 'Hazelcrest', '778', 'Willemstad', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (799, 799, 'Westport', '025', 'Fajões', '3700-660');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (800, 800, 'Sullivan', '96647', 'Ostashkov', '175276');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (801, 801, 'Moland', '90751', 'Mosul', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (802, 802, 'Oneill', '5984', 'Krasnoye', '309924');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (803, 803, 'Surrey', '78796', 'Abuochiche', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (804, 804, '1st', '1784', 'Krajan Kerjo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (805, 805, 'Anzinger', '14758', 'Tabuaço', '5120-384');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (806, 806, 'Acker', '21', 'Yandev', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (807, 807, 'Armistice', '950', 'Calape', '6328');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (808, 808, 'Hansons', '29', 'Slobodnica', '35252');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (809, 809, 'International', '4', 'Sibulan', '6201');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (810, 810, 'Kipling', '53336', 'Moscow', '901993');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (811, 811, 'Russell', '5242', 'Beigou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (812, 812, 'Grover', '106', 'Binalonan', '2436');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (813, 813, 'Clove', '6', 'Tebingtinggi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (814, 814, 'Ronald Regan', '9', 'Deskáti', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (815, 815, 'Mallory', '4', 'Tuti', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (816, 816, 'Sutherland', '337', 'Taesal-li', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (817, 817, 'Sullivan', '8700', 'Yelenendorf', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (818, 818, 'Norway Maple', '25', 'Chincha Baja', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (819, 819, 'Scofield', '54', 'Karangampel', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (820, 820, 'Kennedy', '2228', 'Ad Dīs ash Sharqīyah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (821, 821, 'Spenser', '44', 'Puyang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (822, 822, 'Nancy', '494', 'Cabanaconde', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (823, 823, 'Loomis', '0199', 'Mastung', '88200');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (824, 824, 'Longview', '869', 'Encontrados', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (825, 825, '8th', '2', 'Cacocum', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (826, 826, 'Katie', '3815', 'Itamaraju', '45836-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (827, 827, 'Manley', '6167', 'Nahrīn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (828, 828, 'Manley', '76', 'Aş Şafaqayn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (829, 829, 'Portage', '97', 'Pandansari', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (830, 830, 'Corben', '2033', 'Thị Trấn Ngan Dừa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (831, 831, 'Derek', '5', 'Rimba Sekampung', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (832, 832, 'Buena Vista', '56', 'Sigaozhuang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (833, 833, 'Truax', '83', 'Yaopi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (834, 834, 'Melvin', '2', 'Bali', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (835, 835, 'Merry', '76', 'Beijie', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (836, 836, 'Northport', '850', 'Baxiangshan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (837, 837, 'Muir', '9103', 'Guyangan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (838, 838, 'Chinook', '58', 'Detroit', '48217');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (839, 839, 'Glendale', '86', 'Xiushan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (840, 840, 'Miller', '3362', 'Montgomery', '36177');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (841, 841, 'Spohn', '01434', 'Cipesing', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (842, 842, 'Fremont', '6', 'Ropcha', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (843, 843, 'Knutson', '8', 'Guam Government House', '96928');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (844, 844, 'Becker', '499', 'Lancaster', '17622');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (845, 845, 'Lighthouse Bay', '5', 'Soubré', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (846, 846, 'Lunder', '5709', 'Anjozorobe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (847, 847, 'Arrowood', '50', 'Nanmu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (848, 848, 'Rieder', '37', 'Kirkton', 'KW10');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (849, 849, 'Grim', '01', 'Micoud', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (850, 850, 'Graedel', '1', 'Guinsadan', '2621');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (851, 851, 'Dottie', '288', 'Marinhais', '2125-106');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (852, 852, 'Merry', '1863', 'Tylicz', '33-383');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (853, 853, 'Tomscot', '5557', 'Västerås', '721 37');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (854, 854, 'Crest Line', '603', 'Janūb as Surrah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (855, 855, 'Dovetail', '84699', 'Södertälje', '151 81');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (856, 856, 'Macpherson', '7976', 'Zhongba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (857, 857, 'Buena Vista', '4', 'Jiangshan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (858, 858, 'Clemons', '87', 'Murovanoye', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (859, 859, 'Rockefeller', '83785', 'Rumoi', '518-0875');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (860, 860, 'Waxwing', '9742', 'Mabyan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (861, 861, 'Hermina', '76', 'Yaojiaji', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (862, 862, 'Green Ridge', '96', 'Pomar', '4950-332');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (863, 863, 'Pennsylvania', '33630', 'Koímisi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (864, 864, 'Vermont', '7062', 'Xêgar', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (865, 865, 'Badeau', '997', 'Zhalinghu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (866, 866, 'Moose', '44', 'Jiangbei', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (867, 867, 'Ronald Regan', '665', 'Kup', '46-082');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (868, 868, 'Mockingbird', '2377', 'Al Qaţīf', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (869, 869, 'Helena', '103', 'Clondalkin', 'D24');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (870, 870, 'Butterfield', '35', 'Cankova', '9261');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (871, 871, 'Moulton', '676', 'Panxi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (872, 872, 'Mccormick', '782', 'Baishi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (873, 873, 'Center', '7724', 'Suchen', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (874, 874, 'Westerfield', '24833', 'Jincheng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (875, 875, 'Fordem', '74125', 'Parnamirim', '56163-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (876, 876, 'Laurel', '343', 'Los Angeles', '90045');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (877, 877, 'Arrowood', '01', 'Luokeng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (878, 878, 'Pearson', '1217', 'Fagersta', '737 47');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (879, 879, 'Transport', '1696', 'Bantul', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (880, 880, 'Havey', '1', 'Enschede', '7534');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (881, 881, 'Lerdahl', '61028', 'Selebi-Phikwe', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (882, 882, 'Katie', '6413', 'Santa Catarina Ixtahuacán', '07006');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (883, 883, 'Rockefeller', '2441', 'Burträsk', '937 91');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (884, 884, 'Dahle', '0', 'Okayama-shi', '709-0844');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (885, 885, '7th', '8', 'Bugene', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (886, 886, 'Gerald', '086', 'Jiuli', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (887, 887, 'Upham', '61', 'Linëvo', '633216');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (888, 888, 'Upham', '297', 'Kināna', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (889, 889, 'Prairie Rose', '0306', 'Zhongbu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (890, 890, 'Marcy', '9289', 'Anhai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (891, 891, 'Algoma', '9792', 'Tsotsin-Yurt', '368033');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (892, 892, 'Tennyson', '90', 'Gocoton', '6337');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (893, 893, 'Moulton', '064', 'Jiangpu', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (894, 894, 'Lindbergh', '4', 'Yelan’', '396647');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (895, 895, 'Sutteridge', '53', 'Guxi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (896, 896, 'Fremont', '63796', 'Puntarenas', '60101');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (897, 897, 'Susan', '59', 'Jingchuan Chengguanzhen', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (898, 898, 'Vermont', '13176', 'Manggis', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (899, 899, 'Bartelt', '80', 'Galapa', '082007');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (900, 900, 'Forest Run', '67979', 'Duas Igrejas', '5210-046');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (901, 901, 'Logan', '2', 'Zhaogezhuang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (902, 902, 'Main', '86', 'Qianqiao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (903, 903, 'Basil', '7778', 'Mauá', '09300-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (904, 904, 'Gerald', '75934', 'Sobhādero', '66191');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (905, 905, 'Arkansas', '1', 'Obo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (906, 906, 'Eagle Crest', '96', 'Keleleng', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (907, 907, 'Acker', '43', 'Dajasongai', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (908, 908, 'Moulton', '35', 'Rameshki', '171439');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (909, 909, 'Melvin', '0214', 'Mayantoc', '2304');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (910, 910, 'Sunnyside', '5577', 'Mainit', '8407');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (911, 911, 'Elmside', '19634', 'Fond du Sac', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (912, 912, 'Green', '450', 'Mamuša', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (913, 913, 'Mandrake', '1455', 'Ełk', '19-305');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (914, 914, 'Knutson', '68480', 'Fujikawaguchiko', '401-0335');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (915, 915, 'Shopko', '8', 'Klagen', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (916, 916, 'Clarendon', '3843', 'Naawan', '9023');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (917, 917, 'Mendota', '5', 'Tyoply Stan', '391237');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (918, 918, 'Brown', '8', 'Port Area', '1018');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (919, 919, 'Manley', '0', 'Shenavan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (920, 920, 'Delaware', '4', 'Koumra', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (921, 921, 'Westend', '0233', 'Mounlapamôk', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (922, 922, 'Swallow', '7352', 'Tríkala', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (923, 923, 'Kipling', '50881', 'Cilongkrang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (924, 924, 'Mesta', '40650', 'Vila Nova de Gaia', '4400-005');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (925, 925, 'Shopko', '4', 'Utsjoki', '99981');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (926, 926, 'David', '875', 'Puconci', '9201');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (927, 927, 'Del Mar', '583', 'Stockholm', '118 20');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (928, 928, 'Nova', '49533', 'Baku', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (929, 929, 'Fair Oaks', '5', 'Canoinhas', '89460-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (930, 930, 'Mccormick', '89', 'Noda', '999-3775');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (931, 931, 'Larry', '575', 'Kerrobert', 'T1P');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (932, 932, 'Montana', '99', 'Liushikou', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (933, 933, 'Reindahl', '86', 'Kowalewo Pomorskie', '87-410');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (934, 934, 'Farwell', '65', 'Tibakisa', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (935, 935, 'Atwood', '743', 'Jatirejo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (936, 936, 'Bobwhite', '6', 'Yerevan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (937, 937, 'Swallow', '00', 'Mabiton', '1801');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (938, 938, 'Mayfield', '510', 'Kyankwanzi', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (939, 939, 'Vermont', '83', 'Svetlyy', '238548');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (940, 940, 'John Wall', '97824', 'Calceta', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (941, 941, 'Tony', '88', 'Ostrów Lubelski', '21-110');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (942, 942, 'Comanche', '6301', 'Freetown', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (943, 943, 'Victoria', '86769', 'Itaquyry', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (944, 944, 'Florence', '8096', 'Pandian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (945, 945, 'Stone Corner', '085', 'San Juan', '6227');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (946, 946, 'Park Meadow', '3267', 'Pryvol’ny', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (947, 947, 'Memorial', '587', 'Wydminy', '11-510');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (948, 948, 'Merrick', '3368', 'Maodao', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (949, 949, 'Schurz', '6306', 'Dijon', '21072 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (950, 950, 'Stephen', '6031', 'Liwonde', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (951, 951, 'Continental', '925', 'Legionowo', '05-122');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (952, 952, 'Darwin', '957', 'Kabba', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (953, 953, 'Anzinger', '282', 'Puck', '84-100');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (954, 954, 'Forest Run', '725', 'Gornje Moštre', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (955, 955, 'Fremont', '2', 'Sukamulya', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (956, 956, 'Sunbrook', '823', 'Barishāl', '81300');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (957, 957, 'Buell', '71', 'Amassoma', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (958, 958, 'Ohio', '801', 'Topory', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (959, 959, 'Dahle', '07583', 'Bobrov', '397706');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (960, 960, 'Katie', '38', 'Dniprodzerzhyns’k', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (961, 961, 'Hauk', '09192', 'Strabychovo', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (962, 962, 'Huxley', '49', 'Không', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (963, 963, 'Clemons', '0726', 'Lumbangan', '1682');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (964, 964, 'Farwell', '4691', 'Lemland', '22610');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (965, 965, 'Fuller', '92', 'Matungao', '9203');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (966, 966, 'Westerfield', '07', 'South River', 'P3Y');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (967, 967, 'Bobwhite', '68', 'Pasirgaru', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (968, 968, 'Lakeland', '67', 'Passagem', '2430-632');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (969, 969, 'Jana', '4', 'Yanac', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (970, 970, 'Warner', '515', 'Mineralnye Vody', '357217');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (971, 971, 'Ridge Oak', '37', 'Nyköping', '611 93');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (972, 972, 'Arizona', '433', 'Gaotian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (973, 973, 'Fordem', '1292', 'Bīleh Savār', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (974, 974, 'Ilene', '8472', 'Almere Stad', '1304');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (975, 975, 'Dorton', '66719', 'Cambé', '86180-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (976, 976, 'Sycamore', '48488', 'Totora', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (977, 977, 'Lerdahl', '927', 'Ford', 'GL54');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (978, 978, 'Doe Crossing', '526', 'Lyon', '69206 CEDEX 01');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (979, 979, 'Grim', '3070', 'Gongli', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (980, 980, 'Washington', '75609', 'Lamovita', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (981, 981, 'Meadow Valley', '38214', 'Shengci', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (982, 982, 'Paget', '61', 'Banjar Danginsema', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (983, 983, 'Maryland', '5', 'Colón', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (984, 984, 'Thompson', '302', 'Ribeira Quente', '9675-165');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (985, 985, 'Banding', '81', 'Mlangali', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (986, 986, 'Fisk', '0', 'Nansan', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (987, 987, 'Petterle', '437', 'Tetandara', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (988, 988, 'Weeping Birch', '3222', 'Tengah', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (989, 989, 'Fairfield', '67380', 'Kampong Thom', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (990, 990, 'Spohn', '7643', 'Jiudian', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (991, 991, 'Crest Line', '1', 'Song', '54120');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (992, 992, 'Rockefeller', '2109', 'Hōfu', '747-1111');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (993, 993, 'Sunnyside', '783', 'Qiantang', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (994, 994, 'Kedzie', '768', 'Obertyn', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (995, 995, 'Main', '65', 'Esperança', '58135-000');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (996, 996, 'Fisk', '4784', 'Neuilly-sur-Seine', '92521 CEDEX');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (997, 997, 'Claremont', '47229', 'Ljungskile', '459 30');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (998, 998, 'Hallows', '08166', 'La Paloma', null);
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (999, 999, 'Clemons', '32', 'Lwówek Śląski', '59-601');
insert into ADDRESS (ADDRESS_ID, USER_ID, STREET, HOUSENUMBER, CITY, ZIP_CODE) values (1000, 1000, 'Mccormick', '8', 'Knežica', null);

