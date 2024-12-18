package application.repository;

import java.util.List;

public interface NotificationRepository {

    List<String> getDueDateNotificationsForUser(Long userId);

    List<String> getAvailableBookNotificationsForUser(Long userId);
}