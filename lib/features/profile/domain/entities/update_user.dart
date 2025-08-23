class UserUpdate {
  final String id;
  final String name;
  final String lastname;
  final String? phoneNumber;
  final String? profilePhotoUrl;

  UserUpdate({
    required this.id,
    required this.name,
    required this.lastname,
    this.phoneNumber,
    this.profilePhotoUrl,
  });

  factory UserUpdate.fromJson(Map<String, dynamic> json) {
    return UserUpdate(
      id: json["id"],
      name: json["name"],
      lastname: json["lastname"],
      phoneNumber: json["phoneNumber"],
      profilePhotoUrl: json["profilePhotoUrl"],
    );
  }
}
