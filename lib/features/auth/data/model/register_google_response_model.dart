import 'package:test3/features/auth/domain/entities/register_google.dart';

class RegisterGoogleResponse {
  final String id;
  final String message;
  final String email;

  RegisterGoogleResponse({
    required this.id,
    required this.message,
    required this.email,
  });

  factory RegisterGoogleResponse.fromJson(Map<String, dynamic> json) {
    return RegisterGoogleResponse(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      email: json['email'] ?? '',
    );
  }

  RegisterGoogleEntity toEntity() {
    return RegisterGoogleEntity(id: id, message: message, email: email);
  }
}
