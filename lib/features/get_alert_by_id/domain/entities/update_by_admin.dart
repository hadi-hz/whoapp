class UpdateAlertByAdminRequest {
  final String alertId;
  final String description;
  final String userId;

  UpdateAlertByAdminRequest({
    required this.alertId,
    required this.description,
    required this.userId,
  });
}

class UpdateAlertByAdminResponse {
  final String message;
  final String id;
  final String updatedDescription;

  UpdateAlertByAdminResponse({
    required this.message,
    required this.id,
    required this.updatedDescription,
  });
}