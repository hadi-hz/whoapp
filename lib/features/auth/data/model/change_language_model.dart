import 'package:test3/features/auth/domain/entities/change_language.dart';

class ChangeLanguageModel {
  final String userId;
  final int newLanguage;

  ChangeLanguageModel({
    required this.userId,
    required this.newLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'newLanguage': newLanguage,
    };
  }

  factory ChangeLanguageModel.fromRequest(ChangeLanguageRequest request) {
    return ChangeLanguageModel(
      userId: request.userId,
      newLanguage: request.newLanguage,
    );
  }
}