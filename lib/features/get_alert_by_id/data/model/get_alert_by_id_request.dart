
class AlertDetailRequest {
  final String alertId;
  final String currentUserId;

  AlertDetailRequest({required this.alertId , required this.currentUserId});

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
      'currentUserId' : currentUserId
    };
  }
}