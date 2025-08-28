import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/get_team_by_alert_type.dart';


class GetTeamByAlertType {
  final TeamRepository repository;

  GetTeamByAlertType({required this.repository});

  Future<Either<String, List<TeamsEntity>>> call(int alertType) async {
    return await repository.getTeamByAlertType(alertType);
  }
}