import 'package:test3/features/home/domain/entities/team_start_processing.dart';

class TeamStartProcessingModel {
  final String alertId;
  final String userId;

  TeamStartProcessingModel({
    required this.alertId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
      'userId': userId,
    };
  }

  factory TeamStartProcessingModel.fromRequest(TeamStartProcessingRequest request) {
    return TeamStartProcessingModel(
      alertId: request.alertId,
      userId: request.userId,
    );
  }
}

class TeamStartProcessingResponseModel {
  final String message;

  TeamStartProcessingResponseModel({
    required this.message,
  });

  factory TeamStartProcessingResponseModel.fromJson(Map<String, dynamic> json) {
    return TeamStartProcessingResponseModel(
      message: json['message'] ?? '',
    );
  }

  TeamStartProcessingResponse toEntity() {
    return TeamStartProcessingResponse(
      message: message,
    );
  }
}