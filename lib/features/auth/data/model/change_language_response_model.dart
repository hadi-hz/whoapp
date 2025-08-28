import 'package:test3/features/auth/domain/entities/change_language.dart';

class ChangeLanguageResponseModel {
  final String message;

  ChangeLanguageResponseModel({
    required this.message,
  });

  factory ChangeLanguageResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangeLanguageResponseModel(
      message: json['message'] ?? '',
    );
  }

  ChangeLanguageResponse toEntity() {
    return ChangeLanguageResponse(
      message: message,
    );
  }
}