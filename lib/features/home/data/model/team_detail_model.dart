import '../../domain/entities/team_detail_entity.dart';

class TeamDetailModel extends TeamDetailEntity {
  TeamDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.isHealthcareCleaningAndDisinfection,
    required super.isHouseholdCleaningAndDisinfection,
    required super.isPatientsReferral,
    required super.isSafeAndDignifiedBurial,
    required super.isDelete,
    required super.createTime,
  });

  factory TeamDetailModel.fromJson(Map<String, dynamic> json) {
    return TeamDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isHealthcareCleaningAndDisinfection: json['isHealthcareCleaningAndDisinfection'] ?? false,
      isHouseholdCleaningAndDisinfection: json['isHouseholdCleaningAndDisinfection'] ?? false,
      isPatientsReferral: json['isPatientsReferral'] ?? false,
      isSafeAndDignifiedBurial: json['isSafeAndDignifiedBurial'] ?? false,
      isDelete: json['isDelete'] ?? false,
      createTime: json['createTime'] ?? '',
    );
  }
}