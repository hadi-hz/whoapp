import 'package:test3/features/get_alert_by_id/data/datasource/team_finish_processing.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/team_finish_processing.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/team_finish_precessing.dart';

class TeamFinishProcessingRepositoryImpl
    implements TeamFinishProcessingRepository {
  final TeamFinishProcessingRemoteDataSource remoteDataSource;

  TeamFinishProcessingRepositoryImpl(this.remoteDataSource);

  @override
  Future<TeamFinishProcessingEntity> teamFinishProcessing({
    required String alertId,
    required String userId,
    required String description,
    List<String>? files,
  }) async {
    return await remoteDataSource.teamFinishProcessing(
      alertId: alertId,
      userId: userId,
      description: description,
      files: files,
    );
  }
}
