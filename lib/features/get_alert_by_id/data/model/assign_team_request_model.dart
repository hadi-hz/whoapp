class AssignTeamRequest {
  final String alertId;
  final String teamId;
  final String userId;

  AssignTeamRequest({
    required this.alertId,
    required this.teamId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
      'teamId': teamId,
      'userId': userId,
    };
  }
}