class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final bool isApproved;
  final bool isEmailConfirmed;
  final List<String> roles;
  final String profileImageUrl;

  UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.isApproved,
    required this.isEmailConfirmed,
    required this.roles,
    required this.profileImageUrl,
  });
}


class UsersFilterEntity {
  final String? name;
  final String? email;
  final String? role;
  final bool? isApproved;
  final String? sortBy;
  final bool? sortDesc;
  final DateTime? registerDateFrom;
  final DateTime? registerDateTo;
  final int page;
  final int pageSize;

  UsersFilterEntity({
    this.name,
    this.email,
    this.role,
    this.isApproved,
    this.sortBy,
    this.sortDesc,
    this.registerDateFrom,
    this.registerDateTo,
    required this.page,
    required this.pageSize,
  });
}