class VisitedByTeamMemberRequest {
  final String alertId;
  final String userId;

  VisitedByTeamMemberRequest({
    required this.alertId,
    required this.userId,
  });
}

class VisitedByTeamMemberResponse {
  final String message;
  final String id;

  VisitedByTeamMemberResponse({
    required this.message,
    required this.id,
  });
}