import 'package:test3/features/home/domain/entities/create_team.dart';

class CreateTeamModel {
  final String name;
  final String description;
  final bool isHealthcareCleaningAndDisinfection;
  final bool isHouseholdCleaningAndDisinfection;
  final bool isPatientsReferral;
  final bool isSafeAndDignifiedBurial;

  CreateTeamModel({
    required this.name,
    required this.description,
    required this.isHealthcareCleaningAndDisinfection,
    required this.isHouseholdCleaningAndDisinfection,
    required this.isPatientsReferral,
    required this.isSafeAndDignifiedBurial,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'isHealthcareCleaningAndDisinfection': isHealthcareCleaningAndDisinfection,
      'isHouseholdCleaningAndDisinfection': isHouseholdCleaningAndDisinfection,
      'isPatientsReferral': isPatientsReferral,
      'isSafeAndDignifiedBurial': isSafeAndDignifiedBurial,
    };
  }

  factory CreateTeamModel.fromRequest(CreateTeamRequest request) {
    return CreateTeamModel(
      name: request.name,
      description: request.description,
      isHealthcareCleaningAndDisinfection: request.isHealthcareCleaningAndDisinfection,
      isHouseholdCleaningAndDisinfection: request.isHouseholdCleaningAndDisinfection,
      isPatientsReferral: request.isPatientsReferral,
      isSafeAndDignifiedBurial: request.isSafeAndDignifiedBurial,
    );
  }
}