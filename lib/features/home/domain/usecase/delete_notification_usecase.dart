// lib/features/notification/domain/usecases/delete_notification_usecase.dart

import 'package:test3/features/home/domain/repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;
  DeleteNotificationUseCase(this.repository);
  
  Future<bool> call(String notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}