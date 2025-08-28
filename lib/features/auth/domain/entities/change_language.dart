class ChangeLanguageRequest {
  final String userId;
  final int newLanguage;

  ChangeLanguageRequest({
    required this.userId,
    required this.newLanguage,
  });
}

class ChangeLanguageResponse {
  final String message;

  ChangeLanguageResponse({
    required this.message,
  });
}