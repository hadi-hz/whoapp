import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/data/datasource/get_team_by_alert_type.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/get_team_by_alert_type.dart';


class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;

  TeamRepositoryImpl( {required this.remoteDataSource});

 @override
Future<Either<String, List<TeamsEntity>>> getTeamByAlertType(int alertType) async {
  try {
    final result = await remoteDataSource.getTeamByAlertType(alertType);
    return Right(result);
  } catch (e) {
    return Left(e.toString());
  }
}
}