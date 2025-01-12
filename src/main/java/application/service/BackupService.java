package application.service;

import application.util.PropertyReader;

import java.io.IOException;

public class BackupService {

    private final PropertyReader propertyReader;
    private final String POSTGRES_BACKUP_SCRIPT = "src/main/resources/backups/backup_postgres.sh";
    private final String MONGO_BACKUP_SCRIPT = "src/main/resources/backups/backup_mongodb.sh";

    public BackupService() {
        this.propertyReader = new PropertyReader("application.properties");
    }

    /**
     * PostgreSQL Backup ausführen.
     */
    public void backupPostgres() {
        String dbUrl = propertyReader.getProperty("database.url");
        String dbUser = propertyReader.getProperty("database.username");
        String dbPassword = propertyReader.getProperty("database.password");

        String command = String.format("bash %s %s %s %s", POSTGRES_BACKUP_SCRIPT, dbUrl, dbUser, dbPassword);
        runBackupScript(command, "PostgreSQL");
    }

    /**
     * MongoDB Backup ausführen.
     */
    public void backupMongoDB() {
        String mongoUri = propertyReader.getProperty("mongodb.uri");
        String mongoDb = propertyReader.getProperty("mongodb.database");

        String command = String.format("bash %s %s %s", MONGO_BACKUP_SCRIPT, mongoUri, mongoDb);
        runBackupScript(command, "MongoDB");
    }

    /**
     * Führt das Backup-Skript aus.
     */
    private void runBackupScript(String command, String dbName) {
        try {
            Process process = Runtime.getRuntime().exec(command);
            int exitCode = process.waitFor();

            if (exitCode == 0) {
                System.out.println(dbName + " Backup erfolgreich.");
            } else {
                System.err.println("Fehler beim " + dbName + " Backup.");
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
