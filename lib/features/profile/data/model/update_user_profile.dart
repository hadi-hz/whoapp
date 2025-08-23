import 'package:test3/features/profile/domain/entities/update_user.dart';

class UserUpdateModel extends UserUpdate {
  UserUpdateModel({
    required super.id,
    required super.name,
    required super.lastname,
    super.phoneNumber,
    required super.profilePhotoUrl,
  });

  factory UserUpdateModel.fromJson(Map<String, dynamic> json) {
    return UserUpdateModel(
      id: json["id"],
      name: json["name"],
      lastname: json["lastname"],
      phoneNumber: json["phoneNumber"],
      profilePhotoUrl: json["profilePhotoUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "lastname": lastname,
      "phoneNumber": phoneNumber,
      "profilePhotoUrl": phoneNumber,
    };
  }
}
