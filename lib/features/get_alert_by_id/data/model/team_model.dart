import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';

import 'team_member_model.dart';

class TeamModel extends TeamsEntity {
  TeamModel({
    required String name,
    required String description,
    required List<TeamMemberModel> members,
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
          members: members,
          isHealthcareCleaningAndDisinfection: isHealthcareCleaningAndDisinfection,
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
      members: (json['members'] as List<dynamic>?)
          ?.map((member) => TeamMemberModel.fromJson(member))
          .toList() ?? [],
      isHealthcareCleaningAndDisinfection: json['isHealthcareCleaningAndDisinfection'] ?? false,
      isHouseholdCleaningAndDisinfection: json['isHouseholdCleaningAndDisinfection'] ?? false,
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
      'members': members.map((member) => (member as TeamMemberModel).toJson()).toList(),
      'isHealthcareCleaningAndDisinfection': isHealthcareCleaningAndDisinfection,
      'isHouseholdCleaningAndDisinfection': isHouseholdCleaningAndDisinfection,
      'isPatientsReferral': isPatientsReferral,
      'isSafeAndDignifiedBurial': isSafeAndDignifiedBurial,
      'id': id,
      'isDelete': isDelete,
      'createTime': createTime,
    };
  }
}