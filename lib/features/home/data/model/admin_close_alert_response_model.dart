import 'package:test3/features/home/domain/entities/admin_close_alert.dart';

class AdminCloseAlertResponseModel extends AdminCloseAlertResponse {
  AdminCloseAlertResponseModel({required super.message, required super.id});

  factory AdminCloseAlertResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminCloseAlertResponseModel(
      message: json['message'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
