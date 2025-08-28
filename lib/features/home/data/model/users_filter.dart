import 'package:test3/features/home/domain/entities/users_entity.dart' show UsersFilterEntity;



class UsersFilterModel extends UsersFilterEntity {
  UsersFilterModel({
    String? name,
    String? email,
    String? role,
    bool? isApproved,
    String? sortBy,
    bool? sortDesc,
    DateTime? registerDateFrom,
    DateTime? registerDateTo,
    required int page,
    required int pageSize,
  }) : super(
          name: name,
          email: email,
          role: role,
          isApproved: isApproved,
          sortBy: sortBy,
          sortDesc: sortDesc,
          registerDateFrom: registerDateFrom,
          registerDateTo: registerDateTo,
          page: page,
          pageSize: pageSize,
        );

  Map<String, dynamic> toQueryParams() {
    Map<String, dynamic> params = {
      'Page': page,
      'PageSize': pageSize,
    };

    if (name != null && name!.isNotEmpty) {
      params['Name'] = name;
    }
    if (email != null && email!.isNotEmpty) {
      params['Email'] = email;
    }
    if (role != null && role!.isNotEmpty) {
      params['Role'] = role;
    }
    if (isApproved != null) {
      params['IsApproved'] = isApproved;
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      params['SortBy'] = sortBy;
    }
    if (sortDesc != null) {
      params['SortDesc'] = sortDesc;
    }
    if (registerDateFrom != null) {
      params['RegisterDateFrom'] = registerDateFrom!.toIso8601String();
    }
    if (registerDateTo != null) {
      params['RegisterDateTo'] = registerDateTo!.toIso8601String();
    }

    return params;
  }
}