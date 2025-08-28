import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/assign_team.dart';

abstract class AssignTeamRepository {
  Future<Either<String, AssignTeamEntity>> assignTeamToAlert({
    required String alertId,
    required String teamId,
    required String userId,
  });
}