import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/assign_team.dart';
import '../repositories/assign_team_repository.dart';

class AssignTeamUseCase {
  final AssignTeamRepository repository;

  AssignTeamUseCase({required this.repository});

  Future<Either<String, AssignTeamEntity>> call({
    required String alertId,
    required String teamId,
    required String userId,
  }) async {
    return await repository.assignTeamToAlert(
      alertId: alertId,
      teamId: teamId,
      userId: userId,
    );
  }
}