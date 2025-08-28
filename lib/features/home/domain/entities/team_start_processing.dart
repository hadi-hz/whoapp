class TeamStartProcessingRequest {
  final String alertId;
  final String userId;

  TeamStartProcessingRequest({
    required this.alertId,
    required this.userId,
  });
}

class TeamStartProcessingResponse {
  final String message;

  TeamStartProcessingResponse({
    required this.message,
  });
}
