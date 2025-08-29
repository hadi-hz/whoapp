class VisitedByAdminRequest {
  final String alertId;
  final String userId;

  VisitedByAdminRequest({
    required this.alertId,
    required this.userId,
  });
}

class VisitedByAdminResponse {
  final String message;
  final String id;

  VisitedByAdminResponse({
    required this.message,
    required this.id,
  });
}