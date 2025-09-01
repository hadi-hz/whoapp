import 'package:dartz/dartz.dart';
import '../entities/team_by_id_response_entity.dart';

abstract class GetTeamByIdRepository {
  Future<Either<String, TeamByIdResponseEntity>> getTeamById(String teamId);
}
