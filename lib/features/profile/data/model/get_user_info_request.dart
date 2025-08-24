import 'package:test3/features/profile/domain/entities/info_user.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required super.id,
    required super.email,
    required super.name,
    required super.lastname,
    super.phoneNumber,
    required super.preferredLanguage,
    required super.isUserApproved,
    required super.emailConfirmed,
    required super.roles,
    super.profileImageUrl,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      lastname: json["lastname"],
      phoneNumber: json["phoneNumber"],
      preferredLanguage: json["preferredLanguage"],
      isUserApproved: json["isUserApproved"],
      emailConfirmed: json["emailConfirmed"],
      roles: List<String>.from(json["roles"]),
      profileImageUrl: json["profileImageUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "lastname": lastname,
      "phoneNumber": phoneNumber,
      "preferredLanguage": preferredLanguage,
      "isUserApproved": isUserApproved,
      "emailConfirmed": emailConfirmed,
      "roles": roles,
      "profileImageUrl": profileImageUrl,
    };
  }
}
