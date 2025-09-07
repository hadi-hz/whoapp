
import 'package:test3/features/home/domain/entities/notification_read_entity.dart';
import 'package:test3/features/home/domain/repositories/notification_read_repository.dart';

import '../repositories/notification_repository.dart';

class MarkNotificationReadByAlertUseCase {
  final NotificationReadRepository repository;

  MarkNotificationReadByAlertUseCase({required this.repository});

  Future<NotificationResult> call({
    required String alertId,
    required String currentUserId,
  }) async {
    return await repository.markAsReadByAlert(
      alertId: alertId,
      currentUserId: currentUserId,
    );
  }
}


class MarkNotificationReadByUserUseCase {
  final NotificationReadRepository repository;

  MarkNotificationReadByUserUseCase({required this.repository});

  Future<NotificationResult> call({
    required String currentUserId,
    required String relatedToUserId,
  }) async {
    return await repository.markAsReadByUser(
      currentUserId: currentUserId,
      relatedToUserId: relatedToUserId,
    );
  }
}


class MarkNotificationReadByIdUseCase {
  final NotificationReadRepository repository;

  MarkNotificationReadByIdUseCase({required this.repository});

  Future<NotificationResult> call({
    required String notificationId,
  }) async {
    return await repository.markAsReadById(
      notificationId: notificationId,
    );
  }
}