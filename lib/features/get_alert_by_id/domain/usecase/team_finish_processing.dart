import 'package:image_picker/image_picker.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/team_finish_processing.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/team_finish_precessing.dart';

class TeamFinishProcessingUseCase {
  final TeamFinishProcessingRepository repository;

  TeamFinishProcessingUseCase(this.repository);

  Future<TeamFinishProcessingEntity> call({
    required String alertId,
    required String userId,
    required String description,
    List<XFile>? files,
  }) async {
    return await repository.teamFinishProcessing(
      alertId: alertId,
      userId: userId,
      description: description,
      files: files,
    );
  }
}