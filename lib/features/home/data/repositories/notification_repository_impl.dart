import 'package:test3/features/home/data/datasource/notification_datasource.dart';
import 'package:test3/features/home/domain/entities/notification_entity.dart';
import 'package:test3/features/home/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl(this.dataSource);

  @override
  Future<List<NotificationEntity>> getAllNotifications({
    required String userId,
    bool? isRead,
  }) async {
    try {
      final models = await dataSource.getAllNotifications(
        userId: userId,
        isRead: isRead,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

    @override
  Future<bool> deleteNotification(String notificationId) async {
    try {
      return await dataSource.deleteNotification(notificationId);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }
}
