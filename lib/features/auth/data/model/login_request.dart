class LoginRequest {
  String email;
  String password;
  String deviceTokenId;
  int platform; 

  LoginRequest({
    required this.email,
    required this.password,
    required this.deviceTokenId,
    required this.platform,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "deviceTokenId": deviceTokenId,
        "platform": platform,
      };
}
