import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/mark_notification_read_models.dart';

abstract class NotificationReadDatasource {
  Future<MarkNotificationReadResponse> markAsReadByAlert(
    MarkNotificationReadByAlertRequest request,
  );
  Future<MarkNotificationReadResponse> markAsReadByUser(
    MarkNotificationReadByUserRequest request,
  );
  Future<MarkNotificationReadResponse> markAsReadById(
    MarkNotificationReadByIdRequest request,
  );
}

class NotificationReadDatasourceImpl implements NotificationReadDatasource {
  final Dio _dio = DioBase().dio;

  NotificationReadDatasourceImpl();

  @override
  Future<MarkNotificationReadResponse> markAsReadByAlert(
    MarkNotificationReadByAlertRequest request,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.notifReadAlert,
      data: request.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
      ),
    );

    if (response.statusCode == 200) {
      return MarkNotificationReadResponse.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to mark notifications as read by alert: ${response.statusCode}',
      );
    }
  }

  @override
  Future<MarkNotificationReadResponse> markAsReadByUser(
    MarkNotificationReadByUserRequest request,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.notifReadUser,
      data: request.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
      ),
    );

    if (response.statusCode == 200) {
      return MarkNotificationReadResponse.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to mark notifications as read by user: ${response.statusCode}',
      );
    }
  }

  @override
  Future<MarkNotificationReadResponse> markAsReadById(
    MarkNotificationReadByIdRequest request,
  ) async {
    final response = await _dio.post(
     ApiEndpoints.notifReadNotif,
      data: request.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
      ),
    );

    if (response.statusCode == 200) {
      return MarkNotificationReadResponse.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to mark notification as read: ${response.statusCode}',
      );
    }
  }
}