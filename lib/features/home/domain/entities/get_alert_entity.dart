class Alert {
  final String id;
  final String alertDescriptionByDoctor;
  final int alertStatus;
  final int alertType;
  final DateTime serverCreateTime;
  final String doctorName;
  final String doctorId;
  final String? teamName;
  final String? teamId;
  final bool isDoctor;
  final bool isTeamMember;

  const Alert({
    required this.id,
    required this.alertDescriptionByDoctor,
    required this.alertStatus,
    required this.alertType,
    required this.serverCreateTime,
    required this.doctorName,
    required this.doctorId,
    this.teamName,
    this.teamId,
    required this.isDoctor,
    required this.isTeamMember,
  });
}
