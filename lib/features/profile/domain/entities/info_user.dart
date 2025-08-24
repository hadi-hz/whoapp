
class UserInfo  {
  final String id;
  final String email;
  final String name;
  final String lastname;
  final String? phoneNumber;
  final int preferredLanguage;
  final bool isUserApproved;
  final bool emailConfirmed;
  final List<String> roles;
  final String? profileImageUrl;

  const UserInfo({
    required this.id,
    required this.email,
    required this.name,
    required this.lastname,
    this.phoneNumber,
    required this.preferredLanguage,
    required this.isUserApproved,
    required this.emailConfirmed,
    required this.roles,
    this.profileImageUrl,
  });


}
