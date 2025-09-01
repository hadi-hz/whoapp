import 'package:test3/features/home/domain/entities/notification_entity.dart';

class NotificationModel {
  final String forUserId;
  final String? alertId;
  final String? relateToUserId;
  final String title;
  final String message;
  final int notificationTemplatesType;
  final bool isRead;
  final String? readAt;
  final String id;
  final bool isDelete;
  final String createTime;

  NotificationModel({
    required this.forUserId,
    this.alertId,
    this.relateToUserId,
    required this.title,
    required this.message,
    required this.notificationTemplatesType,
    required this.isRead,
    this.readAt,
    required this.id,
    required this.isDelete,
    required this.createTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      forUserId: json['forUserId'] ?? '',
      alertId: json['alertId'],
      relateToUserId: json['relateToUserId'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      notificationTemplatesType: json['notificationTemplatesType'] ?? 0,
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
      id: json['id'] ?? '',
      isDelete: json['isDelete'] ?? false,
      createTime: json['createTime'] ?? '',
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      forUserId: forUserId,
      alertId: alertId,
      relateToUserId: relateToUserId,
      title: title,
      message: message,
      notificationTemplatesType: notificationTemplatesType,
      isRead: isRead,
      readAt: readAt,
      id: id,
      isDelete: isDelete,
      createTime: createTime,
    );
  }
}