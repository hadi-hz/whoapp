import '../../domain/entities/change_password.dart';

class ChangePasswordModel extends ChangePassword {
  ChangePasswordModel({required String message}) : super(message: message);

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      message: json['message'] ?? '',
    );
  }
}
