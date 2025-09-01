class NotificationEntity {
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

  NotificationEntity({
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
}