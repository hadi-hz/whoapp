class RegisterGoogleRequest {
  final String idToken;
  final String deviceTokenId;
  final int platform;

  RegisterGoogleRequest({
    required this.idToken,
    required this.deviceTokenId,
    required this.platform,
  });

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
    'deviceTokenId': deviceTokenId,
    'platform': platform,
  };
}
