

import 'package:test3/features/home/domain/entities/notification_read_entity.dart';

abstract class NotificationReadRepository {
  Future<NotificationResult> markAsReadByAlert({
    required String alertId,
    required String currentUserId,
  });

  Future<NotificationResult> markAsReadByUser({
    required String currentUserId,
    required String relatedToUserId,
  });

  Future<NotificationResult> markAsReadById({
    required String notificationId,
  });
}