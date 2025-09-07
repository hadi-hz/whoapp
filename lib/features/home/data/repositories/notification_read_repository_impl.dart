import 'package:test3/features/home/data/datasource/notification_read_datasource.dart';
import 'package:test3/features/home/data/model/mark_notification_read_models.dart';
import 'package:test3/features/home/domain/entities/notification_read_entity.dart';
import 'package:test3/features/home/domain/repositories/notification_read_repository.dart';


class NotificationReadRepositoryImpl implements NotificationReadRepository {
  final NotificationReadDatasource datasource;

  NotificationReadRepositoryImpl({required this.datasource});

  @override
  Future<NotificationResult> markAsReadByAlert({
    required String alertId,
    required String currentUserId,
  }) async {
    try {
      final request = MarkNotificationReadByAlertRequest(
        alertId: alertId,
        currentUserId: currentUserId,
      );

      final response = await datasource.markAsReadByAlert(request);

      return NotificationResult(success: true, message: response.message);
    } catch (e) {
      return NotificationResult(success: false, message: e.toString());
    }
  }

  @override
  Future<NotificationResult> markAsReadByUser({
    required String currentUserId,
    required String relatedToUserId,
  }) async {
    try {
      final request = MarkNotificationReadByUserRequest(
        currentUserId: currentUserId,
        relatedToUserId: relatedToUserId,
      );

      final response = await datasource.markAsReadByUser(request);

      return NotificationResult(success: true, message: response.message);
    } catch (e) {
      return NotificationResult(success: false, message: e.toString());
    }
  }

  @override
  Future<NotificationResult> markAsReadById({
    required String notificationId,
  }) async {
    try {
      final request = MarkNotificationReadByIdRequest(
        notificationId: notificationId,
      );

      final response = await datasource.markAsReadById(request);

      return NotificationResult(success: true, message: response.message);
    } catch (e) {
      return NotificationResult(success: false, message: e.toString());
    }
  }
}
