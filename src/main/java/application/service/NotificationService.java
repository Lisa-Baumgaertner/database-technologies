package application.service;

import application.repository.NotificationRepository;


import java.util.List;

/**
 * Service-Klasse zur Verwaltung von Benachrichtigungen für Benutzer.
 * Diese Klasse ermöglicht das Abrufen von Benachrichtigungen bezüglich Fälligkeiten und Verfügbarkeiten von Büchern.
 */
public class NotificationService {

    private final NotificationRepository notificationRepository;

    /**
     * Konstruktor zur Initialisierung des NotificationService mit einem NotificationRepository.
     */
    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    /**
     * Ruft Benachrichtigungen über die Fälligkeitstermine der ausgeliehenen Bücher für einen spezifischen Benutzer ab.
     */
    public List<String> getDueDateNotificationsForUser(Long userId) {
        return notificationRepository.getDueDateNotificationsForUser(userId);
    }

    /**
     * Ruft Benachrichtigungen über die Verfügbarkeit von Büchern ab, die von einem Benutzer gewünscht wurden.
     */
    public List<String> getAvailableBookNotificationsForUser(Long userId) {
        return notificationRepository.getAvailableBookNotificationsForUser(userId);
    }

}
