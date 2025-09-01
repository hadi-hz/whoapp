

import 'package:test3/features/home/domain/entities/notification_entity.dart';
import 'package:test3/features/home/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call({
    required String userId,
    bool? isRead,
  }) async {
    return await repository.getAllNotifications(
      userId: userId,
      isRead: isRead,
    );
  }
}