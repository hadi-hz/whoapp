class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final String userId;

  AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });
}
