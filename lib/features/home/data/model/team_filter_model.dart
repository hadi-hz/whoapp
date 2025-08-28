
import 'package:test3/features/home/domain/entities/team_filter_entity.dart';

class TeamsFilterModel extends TeamsFilterEntity {
  TeamsFilterModel({
    String? name,
    bool? isHealthcareCleaningAndDisinfection,
    bool? isHouseholdCleaningAndDisinfection,
    bool? isPatientsReferral,
    bool? isSafeAndDignifiedBurial,
  }) : super(
          name: name,
          isHealthcareCleaningAndDisinfection: isHealthcareCleaningAndDisinfection,
          isHouseholdCleaningAndDisinfection: isHouseholdCleaningAndDisinfection,
          isPatientsReferral: isPatientsReferral,
          isSafeAndDignifiedBurial: isSafeAndDignifiedBurial,
        );

  Map<String, dynamic> toQueryParams() {
    Map<String, dynamic> params = {};

    if (name != null && name!.isNotEmpty) {
      params['Name'] = name;
    }
    if (isHealthcareCleaningAndDisinfection != null) {
      params['IsHealthcareCleaningAndDisinfection'] = isHealthcareCleaningAndDisinfection;
    }
    if (isHouseholdCleaningAndDisinfection != null) {
      params['IsHouseholdCleaningAndDisinfection'] = isHouseholdCleaningAndDisinfection;
    }
    if (isPatientsReferral != null) {
      params['IsPatientsReferral'] = isPatientsReferral;
    }
    if (isSafeAndDignifiedBurial != null) {
      params['IsSafeAndDignifiedBurial'] = isSafeAndDignifiedBurial;
    }

    return params;
  }
}
