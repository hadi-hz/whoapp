import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/notification_model.dart';

abstract class NotificationDataSource {
  Future<List<NotificationModel>> getAllNotifications({
    required String userId,
    bool? isRead,
  });
  Future<bool> deleteNotification(String notificationId); 
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final Dio _dio = DioBase().dio;

  NotificationDataSourceImpl() ;

  @override
  Future<List<NotificationModel>> getAllNotifications({
    required String userId,
    bool? isRead,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.getAllNotif,
      data: {
        'userId': userId,
        if (isRead != null) 'isRead': isRead,
      },
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    }
    return [];
  }


   @override
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final response = await _dio.post(ApiEndpoints.notificationDelete, 
        data: {'notificationId': notificationId});
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }
}