package application.repository;
import com.mongodb.client.MongoDatabase;
import java.util.List;

public class MongoNotificationRepositoryImpl implements NotificationRepository {

    private final MongoDatabase database;

    public MongoNotificationRepositoryImpl(MongoDatabase database) {
        this.database = database;
    }
    @Override
    public List<String> getDueDateNotificationsForUser(Long userId) {
        return null;
    }

    @Override
    public List<String> getAvailableBookNotificationsForUser(Long userId) {
       return null;
    }
}
