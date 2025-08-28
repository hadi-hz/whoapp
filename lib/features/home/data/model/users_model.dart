import 'package:test3/features/home/domain/entities/users_entity.dart';



class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String email,
    required String fullName,
    required bool isApproved,
    required bool isEmailConfirmed,
    required List<String> roles,
    required String profileImageUrl,
  }) : super(
          id: id,
          email: email,
          fullName: fullName,
          isApproved: isApproved,
          isEmailConfirmed: isEmailConfirmed,
          roles: roles,
          profileImageUrl: profileImageUrl,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      isApproved: json['isApproved'] ?? false,
      isEmailConfirmed: json['isEmailConfirmed'] ?? false,
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
      'fullName': fullName,
      'isApproved': isApproved,
      'isEmailConfirmed': isEmailConfirmed,
      'roles': roles,
      'profileImageUrl': profileImageUrl,
    };
  }
}
