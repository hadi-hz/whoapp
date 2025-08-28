class AssignRoleRequest {
  final String userId;
  final String roleName;

  AssignRoleRequest({
    required this.userId,
    required this.roleName,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roleName': roleName,
    };
  }
}