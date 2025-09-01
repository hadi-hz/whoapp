import '../../domain/entities/team_entity.dart';

class TeamModel extends TeamEntity {
  TeamModel({
    required String name,
    required String description,
    required int memberCount,
    required bool isHealthcareCleaningAndDisinfection,
    required bool isHouseholdCleaningAndDisinfection,
    required bool isPatientsReferral,
    required bool isSafeAndDignifiedBurial,
    required String id,
    required bool isDelete,
    required String createTime,
  }) : super(
         name: name,
         description: description,
         memberCount: memberCount,
         isHealthcareCleaningAndDisinfection:
             isHealthcareCleaningAndDisinfection,
         isHouseholdCleaningAndDisinfection: isHouseholdCleaningAndDisinfection,
         isPatientsReferral: isPatientsReferral,
         isSafeAndDignifiedBurial: isSafeAndDignifiedBurial,
         id: id,
         isDelete: isDelete,
         createTime: createTime,
       );

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      memberCount: json['memberCount'],
      isHealthcareCleaningAndDisinfection:
          json['isHealthcareCleaningAndDisinfection'] ?? false,
      isHouseholdCleaningAndDisinfection:
          json['isHouseholdCleaningAndDisinfection'] ?? false,
      isPatientsReferral: json['isPatientsReferral'] ?? false,
      isSafeAndDignifiedBurial: json['isSafeAndDignifiedBurial'] ?? false,
      id: json['id'] ?? '',
      isDelete: json['isDelete'] ?? false,
      createTime: json['createTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'members': memberCount,
      'isHealthcareCleaningAndDisinfection':
          isHealthcareCleaningAndDisinfection,
      'isHouseholdCleaningAndDisinfection': isHouseholdCleaningAndDisinfection,
      'isPatientsReferral': isPatientsReferral,
      'isSafeAndDignifiedBurial': isSafeAndDignifiedBurial,
      'id': id,
      'isDelete': isDelete,
      'createTime': createTime,
    };
  }

  TeamEntity toEntity() {
    return TeamEntity(
      id: id,
      name: name,
      description: description,
      memberCount: memberCount,
      isHealthcareCleaningAndDisinfection: isHealthcareCleaningAndDisinfection,
      isHouseholdCleaningAndDisinfection: isHouseholdCleaningAndDisinfection,
      isPatientsReferral: isPatientsReferral,
      isSafeAndDignifiedBurial: isSafeAndDignifiedBurial,
      isDelete: isDelete,
      createTime: createTime,
    );
  }
}
