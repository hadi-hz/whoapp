class ApprovedEntity {
  final String id;
  final String email;
  final String name;
  final String lastname;
  final bool isUserApproved;
  final List<String> roles;
  final String message;

  ApprovedEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.lastname,
    required this.isUserApproved,
    required this.roles,
    required this.message,
  });
}
