class TeamMemberEntity {
  final String teamId;
  final String userId;
  final dynamic user;
  final String id;
  final bool isDelete;
  final String createTime;

  TeamMemberEntity({
    required this.teamId,
    required this.userId,
    this.user,
    required this.id,
    required this.isDelete,
    required this.createTime,
  });
}


class TeamsEntity {
  final String name;
  final String description;
  final List<TeamMemberEntity> members;
  final bool isHealthcareCleaningAndDisinfection;
  final bool isHouseholdCleaningAndDisinfection;
  final bool isPatientsReferral;
  final bool isSafeAndDignifiedBurial;
  final String id;
  final bool isDelete;
  final String createTime;

  TeamsEntity({
    required this.name,
    required this.description,
    required this.members,
    required this.isHealthcareCleaningAndDisinfection,
    required this.isHouseholdCleaningAndDisinfection,
    required this.isPatientsReferral,
    required this.isSafeAndDignifiedBurial,
    required this.id,
    required this.isDelete,
    required this.createTime,
  });
}