class TeamEntity {
  final String name;
  final String description;
  final List<dynamic> members;
  final bool isHealthcareCleaningAndDisinfection;
  final bool isHouseholdCleaningAndDisinfection;
  final bool isPatientsReferral;
  final bool isSafeAndDignifiedBurial;
  final String id;
  final bool isDelete;
  final String createTime;

  TeamEntity({
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

  int get membersCount => members.length;
  
  List<String> get capabilities {
    List<String> caps = [];
    if (isHealthcareCleaningAndDisinfection) caps.add('Healthcare Cleaning');
    if (isHouseholdCleaningAndDisinfection) caps.add('Household Cleaning');
    if (isPatientsReferral) caps.add('Patient Referral');
    if (isSafeAndDignifiedBurial) caps.add('Burial Services');
    return caps;
  }

  String get formattedCreateTime {
    try {
      final dateTime = DateTime.parse(createTime);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return createTime;
    }
  }
}