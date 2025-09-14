class TeamsFilterEntity {
  final String? name;
  final bool? isHealthcareCleaningAndDisinfection;
  final bool? isHouseholdCleaningAndDisinfection;
  final bool? isPatientsReferral;
  final bool? isSafeAndDignifiedBurial;
  final int? page;
  final int? pageSize;

  TeamsFilterEntity({
    this.name,
    this.isHealthcareCleaningAndDisinfection,
    this.isHouseholdCleaningAndDisinfection,
    this.isPatientsReferral,
    this.isSafeAndDignifiedBurial,
    this.page,
    this.pageSize,
  });
}
