class CreateTeamRequest {
  final String name;
  final String description;
  final bool isHealthcareCleaningAndDisinfection;
  final bool isHouseholdCleaningAndDisinfection;
  final bool isPatientsReferral;
  final bool isSafeAndDignifiedBurial;

  CreateTeamRequest({
    required this.name,
    required this.description,
    required this.isHealthcareCleaningAndDisinfection,
    required this.isHouseholdCleaningAndDisinfection,
    required this.isPatientsReferral,
    required this.isSafeAndDignifiedBurial,
  });
}