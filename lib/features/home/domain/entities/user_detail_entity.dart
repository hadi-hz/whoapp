class UserDetailEntity {
  final String id;
  final String email;
  final String name;
  final String lastname;
  final String phoneNumber;
  final int preferredLanguage;
  final bool isUserApproved;
  final bool emailConfirmed;
  final List<String> roles;
  final String profileImageUrl;

  UserDetailEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.lastname,
    required this.phoneNumber,
    required this.preferredLanguage,
    required this.isUserApproved,
    required this.emailConfirmed,
    required this.roles,
    required this.profileImageUrl,
  });

  String get fullName => '$name $lastname'.trim();
  String get displayName => fullName.isNotEmpty ? fullName : email;
  bool get hasProfileImage => profileImageUrl.isNotEmpty;
  String get languageDisplayName {
    switch (preferredLanguage) {
      case 0: return 'English';
      case 1: return 'French';
      case 2: return 'Italian';
      default: return 'Unknown';
    }
  }
}
