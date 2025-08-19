class GetAlertEntity {
  final String id;
  final String alertDescriptionByDoctor;
  final int alertStatus;
  final int alertType;
  final DateTime serverCreateTime;
  final bool isDoctor;
  final bool isTeamMember;

  GetAlertEntity({
    required this.id,
    required this.alertDescriptionByDoctor,
    required this.alertStatus,
    required this.alertType,
    required this.serverCreateTime,
    required this.isDoctor,
    required this.isTeamMember,
  });
}
