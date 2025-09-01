class LoginGoogleEntity {
  final String id;
  final String email;
  final String name;
  final String lastname;
  final int preferredLanguage;
  final bool isUserApproved;
  final List<String> roles;
  final String message;
  final String profileImageUrl;
  final int unReadMessagesCount;

  LoginGoogleEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.lastname,
    required this.preferredLanguage,
    required this.isUserApproved,
    required this.roles,
    required this.message,
    required this.profileImageUrl,
    required this.unReadMessagesCount,
  });
}
