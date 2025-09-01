import 'package:test3/features/home/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getAllNotifications({
    required String userId,
    bool? isRead,
  });

  Future<bool> deleteNotification(String notificationId); 
}