class TeamDetailEntity {
  final String id;
  final String name;
  final String description;
  final bool isHealthcareCleaningAndDisinfection;
  final bool isHouseholdCleaningAndDisinfection;
  final bool isPatientsReferral;
  final bool isSafeAndDignifiedBurial;
  final bool isDelete;
  final String createTime;

  TeamDetailEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isHealthcareCleaningAndDisinfection,
    required this.isHouseholdCleaningAndDisinfection,
    required this.isPatientsReferral,
    required this.isSafeAndDignifiedBurial,
    required this.isDelete,
    required this.createTime,
  });
}