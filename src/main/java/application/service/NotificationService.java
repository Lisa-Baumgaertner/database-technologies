package application.service;

import application.repository.NotificationRepository;


import java.util.List;

public class NotificationService {

    private final NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }


    public List<String> getDueDateNotificationsForUser(Long userId) {
        return notificationRepository.getDueDateNotificationsForUser(userId);
    }

    public List<String> getAvailableBookNotificationsForUser(Long userId) {
        return notificationRepository.getAvailableBookNotificationsForUser(userId);
    }

}
