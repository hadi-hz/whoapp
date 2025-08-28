import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';

abstract class TeamRepository {
  Future<Either<String, List<TeamsEntity>>> getTeamByAlertType(int alertType);
}
