class RegisterRequest {
  final String name;
  final String lastname;
  final String phoneNumber;
  final String email;
  final String password;
  final String deviceTokenId;
  final int platform;
  final int preferredLanguage;

  RegisterRequest({
    required this.name,
    required this.lastname,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.deviceTokenId,
    required this.platform,
    required this.preferredLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "lastname": lastname,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
      "deviceTokenId": deviceTokenId,
      "platform": platform,
      "preferredLanguage": preferredLanguage,
    };
  }
}
