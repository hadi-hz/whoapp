import 'package:test3/features/home/domain/entities/team_filter_entity.dart';

class TeamsFilterModel extends TeamsFilterEntity {
  TeamsFilterModel({
    String? name,
    bool? isHealthcareCleaningAndDisinfection,
    bool? isHouseholdCleaningAndDisinfection,
    bool? isPatientsReferral,
    bool? isSafeAndDignifiedBurial,
    int? page,
    int? pageSize,
  }) : super(
         name: name,
         isHealthcareCleaningAndDisinfection: isHealthcareCleaningAndDisinfection,
         isHouseholdCleaningAndDisinfection: isHouseholdCleaningAndDisinfection,
         isPatientsReferral: isPatientsReferral,
         isSafeAndDignifiedBurial: isSafeAndDignifiedBurial,
         page: page,
         pageSize: pageSize,
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

    // تغییر نام پارامترها
    if (page != null) {
      params['PageNumber'] = page;
    }
    if (pageSize != null) {
      params['PageSize'] = pageSize;
    }
    
    return params;
  }
}