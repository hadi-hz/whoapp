import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/data/datasource/assign_team_datesource.dart';
import 'package:test3/features/get_alert_by_id/data/model/assign_team_request_model.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/assign_team.dart';
import '../../domain/repositories/assign_team_repository.dart';

class AssignTeamRepositoryImpl implements AssignTeamRepository {
  final AssignTeamRemoteDataSource remoteDataSource;

  AssignTeamRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, AssignTeamEntity>> assignTeamToAlert({
    required String alertId,
    required String teamId,
    required String userId,
  }) async {
    try {
      final request = AssignTeamRequest(
        alertId: alertId,
        teamId: teamId,
        userId: userId,
      );

      final result = await remoteDataSource.assignTeamToAlert(request);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
