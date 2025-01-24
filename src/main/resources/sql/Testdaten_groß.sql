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
                                                                                                                                                 (DEFAULT, '978-1-25-374901-8', '7111111112', 3, 'Der Klang der Musik', 'Eva Krüger', 'Music Press', 2020, 'Eine Reise durch die Welt der Musik und ihrer Geschichte', 'borrowed', 36);


-- Person

INSERT INTO PERSON (USER_ID, FIRSTNAME, LASTNAME, BIRTHDATE, GENDER, ROLE) VALUES
                                                                               (DEFAULT, 'Anna', 'Müller', '1990-04-15', 'F', 'borrower'),
                                                                               (DEFAULT, 'Max', 'Schneider', '1985-06-22', 'M', 'worker'),
                                                                               (DEFAULT, 'Julia', 'Fischer', '1978-11-10', 'F', 'borrower'),
                                                                               (DEFAULT, 'Leon', 'Weber', '1992-03-05', 'M', 'borrower'),
                                                                               (DEFAULT, 'Sophia', 'Schmidt', '1989-07-18', 'F', 'worker'),
                                                                               (DEFAULT, 'Paul', 'Meyer', '1983-12-25', 'M', 'borrower'),
                                                                               (DEFAULT, 'Lena', 'Schulz', '1995-09-12', 'F', 'borrower'),
                                                                               (DEFAULT, 'Felix', 'Becker', '1988-01-30', 'M', 'worker'),
                                                                               (DEFAULT, 'Lisa', 'Hofmann', '1991-05-20', 'F', 'borrower'),
                                                                               (DEFAULT, 'Tim', 'Koch', '1986-08-08', 'M', 'borrower'),
                                                                               (DEFAULT, 'Emma', 'Bauer', '1994-03-22', 'F', 'worker'),
                                                                               (DEFAULT, 'Jonas', 'Richter', '1987-07-17', 'M', 'borrower'),
                                                                               (DEFAULT, 'Marie', 'Wagner', '1990-11-14', 'F', 'borrower'),
                                                                               (DEFAULT, 'Ben', 'Neumann', '1984-02-09', 'M', 'worker'),
                                                                               (DEFAULT, 'Lara', 'Schwarz', '1993-06-25', 'F', 'borrower'),
                                                                               (DEFAULT, 'Noah', 'Zimmermann', '1979-10-05', 'M', 'borrower'),
                                                                               (DEFAULT, 'Sarah', 'Schmitt', '1982-04-02', 'F', 'worker'),
                                                                               (DEFAULT, 'David', 'Hartmann', '1986-12-18', 'M', 'borrower'),
                                                                               (DEFAULT, 'Mia', 'Krüger', '1996-08-29', 'F', 'borrower'),
                                                                               (DEFAULT, 'Tom', 'Schmid', '1991-01-11', 'M', 'worker'),
                                                                               (DEFAULT, 'Lea', 'Pohl', '1990-09-16', 'F', 'borrower'),
                                                                               (DEFAULT, 'Finn', 'Lange', '1985-06-30', 'M', 'borrower'),
                                                                               (DEFAULT, 'Hannah', 'Simon', '1988-02-13', 'F', 'worker'),
                                                                               (DEFAULT, 'Jan', 'Maier', '1983-05-23', 'M', 'borrower'),
                                                                               (DEFAULT, 'Amelie', 'Walter', '1994-11-08', 'F', 'borrower'),
                                                                               (DEFAULT, 'Niklas', 'König', '1977-12-02', 'M', 'worker'),
                                                                               (DEFAULT, 'Sophie', 'Keller', '1993-04-20', 'F', 'borrower'),
                                                                               (DEFAULT, 'Lucas', 'Fuchs', '1987-07-14', 'M', 'borrower'),
                                                                               (DEFAULT, 'Nina', 'Schuster', '1990-10-18', 'F', 'worker'),
                                                                               (DEFAULT, 'Elias', 'Brandt', '1985-01-25', 'M', 'borrower'),
                                                                               (DEFAULT, 'Elena', 'Haas', '1992-03-30', 'F', 'borrower'),
                                                                               (DEFAULT, 'Moritz', 'Hahn', '1984-08-03', 'M', 'worker'),
                                                                               (DEFAULT, 'Clara', 'Scholz', '1991-06-12', 'F', 'borrower'),
                                                                               (DEFAULT, 'Matthias', 'Ulrich', '1979-02-22', 'M', 'borrower'),
                                                                               (DEFAULT, 'Isabel', 'Schubert', '1993-11-05', 'F', 'worker'),
                                                                               (DEFAULT, 'Tobias', 'Horn', '1982-12-17', 'M', 'borrower'),
                                                                               (DEFAULT, 'Eva', 'Werner', '1987-09-27', 'F', 'borrower'),
                                                                               (DEFAULT, 'Fabian', 'Winkler', '1986-07-10', 'M', 'worker'),
                                                                               (DEFAULT, 'Nele', 'Berg', '1995-04-07', 'F', 'borrower'),
                                                                               (DEFAULT, 'Jannik', 'Möller', '1990-05-15', 'M', 'borrower'),
                                                                               (DEFAULT, 'Katharina', 'Pfeiffer', '1989-11-19', 'F', 'worker'),
                                                                               (DEFAULT, 'Sebastian', 'Ludwig', '1984-03-13', 'M', 'borrower'),
                                                                               (DEFAULT, 'Antonia', 'Böhm', '1996-02-28', 'F', 'borrower'),
                                                                               (DEFAULT, 'Alexander', 'Schröder', '1985-12-21', 'M', 'worker'),
                                                                               (DEFAULT, 'Paula', 'Franke', '1991-08-26', 'F', 'borrower'),
                                                                               (DEFAULT, 'Christian', 'Krause', '1983-09-11', 'M', 'borrower'),
                                                                               (DEFAULT, 'Marlene', 'Voigt', '1988-06-18', 'F', 'worker'),
                                                                               (DEFAULT, 'Simon', 'Heinrich', '1994-10-22', 'M', 'borrower'),
                                                                               (DEFAULT, 'Franziska', 'Engel', '1990-07-09', 'F', 'borrower'),
                                                                               (DEFAULT, 'Erik', 'Schneider', '1982-05-01', 'M', 'worker'),
                                                                               (DEFAULT, 'Laura', 'Klein', '1989-04-11', 'F', 'borrower'),
                                                                               (DEFAULT, 'Martin', 'Wolf', '1991-10-14', 'M', 'worker'),
                                                                               (DEFAULT, 'Claudia', 'Kühn', '1986-12-19', 'F', 'borrower'),
                                                                               (DEFAULT, 'Lukas', 'Schlegel', '1987-08-22', 'M', 'borrower'),
                                                                               (DEFAULT, 'Helena', 'Busch', '1980-03-15', 'F', 'worker'),
                                                                               (DEFAULT, 'Oliver', 'Franz', '1978-09-20', 'M', 'borrower'),
                                                                               (DEFAULT, 'Theresa', 'Bergmann', '1995-11-30', 'F', 'borrower'),
                                                                               (DEFAULT, 'Patrick', 'Otto', '1990-06-07', 'M', 'worker'),
                                                                               (DEFAULT, 'Melanie', 'Koch', '1985-02-18', 'F', 'borrower'),
                                                                               (DEFAULT, 'Bastian', 'Heller', '1983-05-19', 'M', 'borrower'),
                                                                               (DEFAULT, 'Nadine', 'Frey', '1994-09-26', 'F', 'worker'),
                                                                               (DEFAULT, 'Daniel', 'Jakob', '1988-11-10', 'M', 'borrower'),
                                                                               (DEFAULT, 'Karina', 'Kaiser', '1993-12-25', 'F', 'borrower'),
                                                                               (DEFAULT, 'Florian', 'Peters', '1982-08-02', 'M', 'worker'),
                                                                               (DEFAULT, 'Johanna', 'Böttcher', '1996-03-29', 'F', 'borrower'),
                                                                               (DEFAULT, 'Kilian', 'Lorenz', '1991-01-18', 'M', 'borrower'),
                                                                               (DEFAULT, 'Miriam', 'Hauser', '1984-07-04', 'F', 'worker'),
                                                                               (DEFAULT, 'Konstantin', 'Hennig', '1979-10-09', 'M', 'borrower'),
                                                                               (DEFAULT, 'Veronika', 'Wendt', '1986-06-15', 'F', 'borrower'),
                                                                               (DEFAULT, 'Sascha', 'Ebert', '1990-09-22', 'M', 'worker'),
                                                                               (DEFAULT, 'Silvia', 'Bayer', '1987-01-05', 'F', 'borrower'),
                                                                               (DEFAULT, 'Leonhard', 'Heinze', '1985-04-11', 'M', 'borrower'),
                                                                               (DEFAULT, 'Jasmin', 'Brock', '1992-07-23', 'F', 'worker'),
                                                                               (DEFAULT, 'Armin', 'Schuhmann', '1977-12-08', 'M', 'borrower'),
                                                                               (DEFAULT, 'Carina', 'Voss', '1995-02-26', 'F', 'borrower'),
                                                                               (DEFAULT, 'Marcel', 'Lang', '1983-10-30', 'M', 'worker'),
                                                                               (DEFAULT, 'Denise', 'Brand', '1994-05-27', 'F', 'borrower'),
                                                                               (DEFAULT, 'Michael', 'Wirth', '1989-11-02', 'M', 'borrower'),
                                                                               (DEFAULT, 'Susanne', 'Geiger', '1991-08-10', 'F', 'worker'),
                                                                               (DEFAULT, 'Ralf', 'Kraft', '1984-03-12', 'M', 'borrower'),
                                                                               (DEFAULT, 'Jana', 'Schäfer', '1988-01-17', 'F', 'borrower'),
                                                                               (DEFAULT, 'Thorsten', 'Schick', '1992-04-20', 'M', 'worker'),
                                                                               (DEFAULT, 'Ulrike', 'Lindner', '1985-06-09', 'F', 'borrower'),
                                                                               (DEFAULT, 'Tim', 'Braun', '1987-08-14', 'M', 'borrower'),
                                                                               (DEFAULT, 'Alexandra', 'Roth', '1990-10-18', 'F', 'worker'),
                                                                               (DEFAULT, 'Philipp', 'Korn', '1978-09-27', 'M', 'borrower'),
                                                                               (DEFAULT, 'Angelika', 'Schuster', '1981-05-06', 'F', 'borrower'),
                                                                               (DEFAULT, 'Robert', 'Haag', '1993-12-15', 'M', 'worker'),
                                                                               (DEFAULT, 'Diana', 'Riedel', '1984-02-11', 'F', 'borrower'),
                                                                               (DEFAULT, 'Holger', 'Nowak', '1989-07-21', 'M', 'borrower'),
                                                                               (DEFAULT, 'Simone', 'Kraft', '1986-10-30', 'F', 'worker'),
                                                                               (DEFAULT, 'Christian', 'Dorn', '1991-01-23', 'M', 'borrower'),
                                                                               (DEFAULT, 'Sandra', 'Krebs', '1995-03-09', 'F', 'borrower'),
                                                                               (DEFAULT, 'Sebastian', 'Götz', '1987-11-05', 'M', 'worker'),
                                                                               (DEFAULT, 'Nora', 'Bühler', '1982-04-26', 'F', 'borrower'),
                                                                               (DEFAULT, 'Dirk', 'Klünder', '1988-12-30', 'M', 'borrower'),
                                                                               (DEFAULT, 'Manuela', 'Beck', '1985-09-12', 'F', 'worker'),
                                                                               (DEFAULT, 'Jürgen', 'Schön', '1994-06-28', 'M', 'borrower'),
                                                                               (DEFAULT, 'Petra', 'Mann', '1980-07-18', 'F', 'borrower'),
                                                                               (DEFAULT, 'Gerhard', 'Seidel', '1979-03-31', 'M', 'worker');


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

INSERT INTO REVIEW (REVIEW_ID, BOOK_ID, USER_ID, REVIEW_TEXT, REVIEW_DATE, REVIEW_RATING) VALUES
                                                                                              (DEFAULT, 1, 1, 'Sehr informatives Buch!', '2023-03-01', '5'),
                                                                                              (DEFAULT, 2, 2, 'Gut für Einsteiger.', '2023-03-02', '4'),
                                                                                              (DEFAULT, 3, 5, 'Interessante Perspektiven, aber zu langatmig.', '2023-03-03', '3'),
                                                                                              (DEFAULT, 4, 3, 'Faszinierende Charaktere und Plot!', '2023-03-04', '5'),
                                                                                              (DEFAULT, 5, 10, 'Kann ich nicht empfehlen, zu langweilig.', '2023-03-05', '2'),
                                                                                              (DEFAULT, 6, 7, 'Tolles Buch, aber das Ende war enttäuschend.', '2023-03-06', '4'),
                                                                                              (DEFAULT, 7, 1, 'Habe viel Neues gelernt, sehr aufschlussreich.', '2023-03-07', '5'),
                                                                                              (DEFAULT, 8, 15, 'Gut geschrieben, aber stellenweise zu kompliziert.', '2023-03-08', '3'),
                                                                                              (DEFAULT, 9, 2, 'Eine wahre Leseempfehlung!', '2023-03-09', '5'),
                                                                                              (DEFAULT, 10, 9, 'Gutes Buch, aber zu lang.', '2023-03-10', '4'),
                                                                                              (DEFAULT, 11, 8, 'Nicht mein Fall, zu viele Längen.', '2023-03-11', '2'),
                                                                                              (DEFAULT, 12, 6, 'Sehr gut recherchiert und spannend.', '2023-03-12', '5'),
                                                                                              (DEFAULT, 13, 11, 'Schwache Charakterentwicklung, aber gute Handlung.', '2023-03-13', '3'),
                                                                                              (DEFAULT, 14, 14, 'Ein Klassiker, der nie alt wird.', '2023-03-14', '5'),
                                                                                              (DEFAULT, 15, 12, 'Zu viele unaufgelöste Fragen.', '2023-03-15', '3'),
                                                                                              (DEFAULT, 16, 3, 'Würdig für die Sammlung, fesselnd und tiefgründig.', '2023-03-16', '5'),
                                                                                              (DEFAULT, 17, 20, 'Sehr schwache Story, nicht überzeugend.', '2023-03-17', '1'),
                                                                                              (DEFAULT, 18, 4, 'Ein wenig zu vorhersehbar.', '2023-03-18', '4'),
                                                                                              (DEFAULT, 19, 6, 'Ein Meisterwerk, muss man gelesen haben!', '2023-03-19', '5'),
                                                                                              (DEFAULT, 20, 10, 'Gut geschrieben, aber die Geschichte konnte mich nicht packen.', '2023-03-20', '3'),
                                                                                              (DEFAULT, 21, 17, 'Erfrischend anders und innovativ!', '2023-03-21', '5'),
                                                                                              (DEFAULT, 22, 1, 'Nicht so gut wie erwartet, aber immer noch lesenswert.', '2023-03-22', '4'),
                                                                                              (DEFAULT, 23, 16, 'Spannend bis zur letzten Seite.', '2023-03-23', '5'),
                                                                                              (DEFAULT, 24, 5, 'Habe den Hype nicht verstanden, war ganz okay.', '2023-03-24', '3'),
                                                                                              (DEFAULT, 25, 14, 'Zu viel Kitsch, zu wenig Substanz.', '2023-03-25', '2'),
                                                                                              (DEFAULT, 26, 19, 'Sehr guter Thriller, hat mich total gepackt.', '2023-03-26', '5'),
                                                                                              (DEFAULT, 27, 18, 'Wirklich langweilig, keine Höhepunkte.', '2023-03-27', '1'),
                                                                                              (DEFAULT, 28, 21, 'Langeweile pur, aber das Ende war gut.', '2023-03-28', '3'),
                                                                                              (DEFAULT, 29, 22, 'Besser als erwartet, eine angenehme Lektüre.', '2023-03-29', '4'),
                                                                                              (DEFAULT, 30, 4, 'Fesselnde Story, großartige Charaktere!', '2023-03-30', '5'),
                                                                                              (DEFAULT, 31, 8, 'Wenig überzeugend, ich hatte mehr erwartet.', '2023-03-31', '2'),
                                                                                              (DEFAULT, 32, 11, 'Sehr tiefgründig, aber etwas langatmig.', '2023-04-01', '4'),
                                                                                              (DEFAULT, 60, 13, 'Ein Muss für alle Fantasy-Fans!', '2023-04-02', '5'),
                                                                                              (DEFAULT, 34, 6, 'Tolle Erzählweise, jedoch zu wenig Action.', '2023-04-03', '3'),
                                                                                              (DEFAULT, 35, 9, 'Ergreifend und emotional, hat mich sehr berührt.', '2023-04-04', '5'),
                                                                                              (DEFAULT, 66, 12, 'Ganz nett, aber nicht wirklich originell.', '2023-04-05', '3'),
                                                                                              (DEFAULT, 66, 15, 'Das Buch hat mich tief bewegt, sehr zu empfehlen!', '2023-04-06', '5'),
                                                                                              (DEFAULT, 38, 23, 'Habe mehr erwartet, leider enttäuscht.', '2023-04-07', '2'),
                                                                                              (DEFAULT, 39, 7, 'Sehr spannend und temporeich.', '2023-04-08', '4'),
                                                                                              (DEFAULT, 40, 10, 'Gute Idee, aber schlecht umgesetzt.', '2023-04-09', '2'),
                                                                                              (DEFAULT, 41, 16, 'Fantastisches Buch, man muss es einfach lesen!', '2023-04-10', '5'),
                                                                                              (DEFAULT, 42, 24, 'War etwas zu lang, aber insgesamt gut.', '2023-04-11', '4'),
                                                                                              (DEFAULT, 43, 19, 'Nicht schlecht, aber der Funke ist nicht übergesprungen.', '2023-04-12', '3'),
                                                                                              (DEFAULT, 44, 6, 'Richtig packend bis zur letzten Seite.', '2023-04-13', '5'),
                                                                                              (DEFAULT, 45, 25, 'Zu viele Klischees, hat mir nicht gefallen.', '2023-04-14', '2'),
                                                                                              (DEFAULT, 46, 3, 'Witzig und charmant, hat mir gut gefallen.', '2023-04-15', '4'),
                                                                                              (DEFAULT, 47, 27, 'Eines der besten Bücher, die ich je gelesen habe!', '2023-04-16', '5'),
                                                                                              (DEFAULT, 48, 8, 'Durchschnittlich, keine Überraschungen.', '2023-04-17', '3'),
                                                                                              (DEFAULT, 49, 30, 'Unglaublich spannend und voller Wendungen!', '2023-04-18', '5'),
                                                                                              (DEFAULT, 50, 28, 'Der Plot war schwach, das Ende enttäuschend.', '2023-04-19', '2'),
                                                                                              (DEFAULT, 51, 9, 'Sehr unterhaltsam und leicht zu lesen.', '2023-04-20', '4'),
                                                                                              (DEFAULT, 52, 17, 'Hat mich leider nicht überzeugt, zu wenig Tiefgang.', '2023-04-21', '2'),
                                                                                              (DEFAULT, 53, 29, 'Absolut fesselnd, kann es kaum erwarten, mehr zu lesen!', '2023-04-22', '5'),
                                                                                              (DEFAULT, 54, 13, 'Das Buch hat viel Potenzial, aber nicht voll ausgeschöpft.', '2023-04-23', '3'),
                                                                                              (DEFAULT, 55, 25, 'Die besten 300 Seiten, die ich je gelesen habe.', '2023-04-24', '5'),
                                                                                              (DEFAULT, 56, 12, 'Gut geschrieben, aber irgendwie vorhersehbar.', '2023-04-25', '3'),
                                                                                              (DEFAULT, 57, 2, 'Fantastisch, ich konnte nicht aufhören zu lesen!', '2023-04-26', '5'),
                                                                                              (DEFAULT, 58, 6, 'Enttäuschend, hatte mir mehr erwartet.', '2023-04-27', '2'),
                                                                                              (DEFAULT, 59, 30, 'Ungewöhnlich und spannend, gut recherchiert.', '2023-04-28', '4'),
                                                                                              (DEFAULT, 60, 15, 'Überraschend gut, hat mir gefallen.', '2023-04-29', '4'),
                                                                                              (DEFAULT, 61, 8, 'Ein Klassiker, den man unbedingt gelesen haben muss.', '2023-04-30', '5'),
                                                                                              (DEFAULT, 62, 24, 'War zu vorhersehbar, keine großen Überraschungen.', '2023-05-01', '3'),
                                                                                              (DEFAULT, 63, 9, 'Der perfekte Thriller, ich habe es geliebt!', '2023-05-02', '5'),
                                                                                              (DEFAULT, 64, 17, 'Viel zu lang, aber die Charaktere waren interessant.', '2023-05-03', '3'),
                                                                                              (DEFAULT, 65, 14, 'Sehr gut geschrieben, hat mich berührt.', '2023-05-04', '5'),
                                                                                              (DEFAULT, 66, 11, 'Nicht mein Genre, aber immer noch gut gemacht.', '2023-05-05', '4'),
                                                                                              (DEFAULT, 67, 20, 'Einfach zu lang, aber trotzdem spannend.', '2023-05-06', '4'),
                                                                                              (DEFAULT, 68, 4, 'Gute Story, aber viele Schwächen.', '2023-05-07', '3'),
                                                                                              (DEFAULT, 69, 5, 'Sehr beeindruckend und gut recherchiert.', '2023-05-08', '5'),
                                                                                              (DEFAULT, 70, 2, 'Leider enttäuschend, das Buch zog sich.', '2023-05-09', '2'),
                                                                                              (DEFAULT, 71, 3, 'Tolle Wendungen, aber etwas langatmig.', '2023-05-10', '4'),
                                                                                              (DEFAULT, 72, 22, 'Spannend und gut geschrieben, aber das Ende war zu schnell.', '2023-05-11', '4'),
                                                                                              (DEFAULT, 73, 6, 'Ich konnte nicht aufhören zu lesen, fantastisch!', '2023-05-12', '5'),
                                                                                              (DEFAULT, 74, 7, 'Nicht besonders herausragend, aber solide.', '2023-05-13', '3'),
                                                                                              (DEFAULT, 75, 25, 'Ein echter Page-Turner, sehr empfehlenswert.', '2023-05-14', '5'),
                                                                                              (DEFAULT, 76, 9, 'Gut, aber das Ende war zu vorhersehbar.', '2023-05-15', '3'),
                                                                                              (DEFAULT, 77, 14, 'Ein absoluter Klassiker, den man nicht missen sollte.', '2023-05-16', '5'),
                                                                                              (DEFAULT, 78, 21, 'Hat mich begeistert, aber einige Längen.', '2023-05-17', '4'),
                                                                                              (DEFAULT, 79, 3, 'Zu viele Klischees, nicht sehr originell.', '2023-05-18', '2'),
                                                                                              (DEFAULT, 80, 17, 'Perfekt für Fans dieses Genres!', '2023-05-19', '5');


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

