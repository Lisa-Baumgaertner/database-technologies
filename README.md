# 📊 Database-Technologies Project
Evaluierung und Vergleich von SQL- und dokumentenbasierter NoSQL-Datenbanken im
Kontext einer Büchereianwendung

## 📂 Documentation

### Google Doc: 
https://docs.google.com/document/d/1C2AAM66euVr3dRe5oEmN0LRMrXNHqncrzLRu335XbQE/edit?tab=t.0

### Miro Link:
https://miro.com/welcomeonboard/eE1QaUp4ZWFqTzd2OWcwdUw5QWlBZWVJc0RveUFYcjd3a3gxVUZyVjJTRWV3ZGhhTVR3eFhXMzVWdU9zaFFrU3wzNDU4NzY0NTkxMDcyNzAyNDk4fDI=?share_link_id=235071368268

##  🔧 Technologies Used

- **JDK:** 23.0.1
- **JavaFX SDK:** 21.0.5
- **Maven:** Build-Management
- **PostgreSQL:** Relational Database
- **MongoDB:** Document-based NoSQL Database

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

* ```src/main/java```: Contains the Java source files.
  * ```config:```  Database configuration files.
  * ```controller:```  JavaFX controllers for UI interactions.
  * ``` model:```   Data models.
  * ```repository:```  Database interaction (PostgreSQL, MongoDB).
  * ```service:```  Business logic services.
  * ```util:``` Utility classes (DB connection, helpers).
  * ```Main.java:``` Application entry point
* ```src/main/resources```: Contains configuration files, SQL/NoSQL scripts,  and assets.
* ```src/test/java```: Contains the test classes.

## ⚙️ Configuration
The configuration for the database connections is provided in the ```application.properties``` file, located in the src/main/resources directory.

**Note:** You must change Username and Password to your actual database credentials in the application.properties file.

```bash
# Wähle die Datenbank aus (true für MongoDB, false für PostgreSQL)
database.useMongoDB=false

# PostgreSQL Datenbankverbindung
database.driver=org.postgresql.Driver
database.url=jdbc:postgresql://localhost:5432/library
database.username=username
database.password=password

# MongoDB Datenbankverbindung
mongodb.uri=mongodb+srv://<username>:<password>@librarymanagement.nogaz.mongodb.net/?retryWrites=true&w=majority&appName=librarymanagement
mongodb.database=Library

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