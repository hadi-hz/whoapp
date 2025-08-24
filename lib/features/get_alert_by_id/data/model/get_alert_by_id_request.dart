
class AlertDetailRequest {
  final String alertId;

  AlertDetailRequest({required this.alertId});

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
    };
  }
}