import 'package:test3/features/get_alert_by_id/domain/entities/team_finish_processing.dart';

abstract class TeamFinishProcessingRepository {
  Future<TeamFinishProcessingEntity> teamFinishProcessing({
    required String alertId,
    required String userId,
    required String description,
    List<String>? files,
  });
}