
import 'package:test3/features/auth/domain/entities/auth_by_google.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: userId,
        );

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      userId: json["userId"] ?? "",
    );
  }
}
