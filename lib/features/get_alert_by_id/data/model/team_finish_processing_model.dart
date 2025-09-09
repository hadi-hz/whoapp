import 'package:test3/features/get_alert_by_id/domain/entities/team_finish_processing.dart';

class TeamFinishProcessingModel extends TeamFinishProcessingEntity {
  const TeamFinishProcessingModel({required super.message, required super.id});

  factory TeamFinishProcessingModel.fromJson(Map<String, dynamic> json) {
    return TeamFinishProcessingModel(
      message: json['message'] ?? '',
      id: json['id'] ?? '',
      
    );
  }
}
