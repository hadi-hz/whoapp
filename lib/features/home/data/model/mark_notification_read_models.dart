class MarkNotificationReadByAlertRequest {
  final String alertId;
  final String currentUserId;

  MarkNotificationReadByAlertRequest({
    required this.alertId,
    required this.currentUserId,
  });

  Map<String, dynamic> toJson() {
    return {'alertId': alertId, 'currentUserId': currentUserId};
  }
}

class MarkNotificationReadByUserRequest {
  final String currentUserId;
  final String relatedToUserId;

  MarkNotificationReadByUserRequest({
    required this.currentUserId,
    required this.relatedToUserId,
  });

  Map<String, dynamic> toJson() {
    return {'currentUserId': currentUserId, 'relatedToUserId': relatedToUserId};
  }
}

class MarkNotificationReadByIdRequest {
  final String notificationId;

  MarkNotificationReadByIdRequest({required this.notificationId});

  Map<String, dynamic> toJson() {
    return {'notificationId': notificationId};
  }
}

class MarkNotificationReadResponse {
  final String message;

  MarkNotificationReadResponse({required this.message});

  factory MarkNotificationReadResponse.fromJson(dynamic json) {
    return MarkNotificationReadResponse(message: json.toString());
  }
}
