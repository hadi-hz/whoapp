import '../../domain/entities/user_detail_entity.dart';

class UserDetailModel extends UserDetailEntity {
  UserDetailModel({
    required String id,
    required String email,
    required String name,
    required String lastname,
    required String phoneNumber,
    required int preferredLanguage,
    required bool isUserApproved,
    required bool emailConfirmed,
    required List<String> roles,
    required String profileImageUrl,
  }) : super(
          id: id,
          email: email,
          name: name,
          lastname: lastname,
          phoneNumber: phoneNumber,
          preferredLanguage: preferredLanguage,
          isUserApproved: isUserApproved,
          emailConfirmed: emailConfirmed,
          roles: roles,
          profileImageUrl: profileImageUrl,
        );

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      preferredLanguage: json['preferredLanguage'] ?? 0,
      isUserApproved: json['isUserApproved'] ?? false,
      emailConfirmed: json['emailConfirmed'] ?? false,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((role) => role.toString())
          .toList() ?? [],
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'lastname': lastname,
      'phoneNumber': phoneNumber,
      'preferredLanguage': preferredLanguage,
      'isUserApproved': isUserApproved,
      'emailConfirmed': emailConfirmed,
      'roles': roles,
      'profileImageUrl': profileImageUrl,
    };
  }
}