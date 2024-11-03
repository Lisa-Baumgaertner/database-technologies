# Datenbanktechnologien
Repository for our course 

# Google Doc: 
https://docs.google.com/document/d/1C2AAM66euVr3dRe5oEmN0LRMrXNHqncrzLRu335XbQE/edit?tab=t.0

# Miro Link:
https://miro.com/welcomeonboard/eE1QaUp4ZWFqTzd2OWcwdUw5QWlBZWVJc0RveUFYcjd3a3gxVUZyVjJTRWV3ZGhhTVR3eFhXMzVWdU9zaFFrU3wzNDU4NzY0NTkxMDcyNzAyNDk4fDI=?share_link_id=235071368268

# Next steps:
1. Build database in PostgreSQL
2. Generate Test Data
3. Build small UI?
4. Select Technology for NoSQL
5. Build DB in NoSQL
6. Attach NoSQL to UI?
7. Do some analyses & comparisons & queries etc...
8. Document all steps

***
***

# 📊 Database-Technologies Project

 ### Design and Comparison of a Library Application in NoSQL and SQL

##  🔧 Technologies

- JDK: **23.0.1**
- JavaFx SDK: **21.0.5**
- Maven
- PostgreSQL
- MongoDB

## 🚀 Installation
### 1. Clone the repository

```bash
git clone https://github.com/Lisa-Baumgaertner/database-technologies.git
cd database-technologies
```
### 2. Install dependencies
```bash
mvn clean install
```

## 📂 Project Structure
- ```src/main/java```: Contains the Java source files.
- ```src/main/resources```: Contains configuration files .
- ```src/test/java```: Contains the test classes.

## ⚙️ Configuration
The configuration for the database connections is provided in the ```application.properties``` file, located in the src/main/resources directory.

**Note:** You must change yourUsername and yourPassword to your actual database credentials in the application.properties file.

```bash
# PostgreSQL Configuration
database.driver=org.postgresql.Driver
database.url=jdbc:postgresql://localhost:5432/library
database.username=yourUsername
database.password=yourPassword
```
## ➕ Add to ``` .gitignore ```
Create or update the ```.gitignore``` file in your project root and add the following line:
```bash
src/main/resources/application.properties
```
This will ensure that your sensitive credentials are not exposed in the repository.

## 🗄️ Database Connections
The connections to the databases are implemented in the ```SQLDatabaseConnection``` class for PostgreSQL and the ```NoSQLDatabaseConnection``` class for the document-based database.

## ✅ Running Tests

### Running Tests with Maven

 ```bash
 mvn test
 ```

## 👥 Authors
- Aaliyah Roderer
- Basma Rahal
- Lisa Stephanie Baumgärtner