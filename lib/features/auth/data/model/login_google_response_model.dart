import 'package:test3/features/auth/domain/entities/login_google.dart';

class LoginGoogleResponseModel {
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

  LoginGoogleResponseModel({
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

  factory LoginGoogleResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginGoogleResponseModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      preferredLanguage: json['preferredLanguage'] ?? 0,
      isUserApproved: json['isUserApproved'] ?? false,
      roles: List<String>.from(json['roles'] ?? []),
      message: json['message'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      unReadMessagesCount: json['unReadMessagesCount'] ?? 0,
    );
  }

  LoginGoogleEntity toEntity() {
    return LoginGoogleEntity(
      id: id,
      email: email,
      name: name,
      lastname: lastname,
      preferredLanguage: preferredLanguage,
      isUserApproved: isUserApproved,
      roles: roles,
      message: message,
      profileImageUrl: profileImageUrl,
      unReadMessagesCount: unReadMessagesCount,
    );
  }
}