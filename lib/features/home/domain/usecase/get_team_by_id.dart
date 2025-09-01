import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/repositories/team_by_id_repository.dart';
import '../entities/team_by_id_response_entity.dart';

class GetTeamByIdUseCase {
  final GetTeamByIdRepository repository;

  GetTeamByIdUseCase(this.repository);

  Future<Either<String, TeamByIdResponseEntity>> call(String teamId) async {
    return await repository.getTeamById(teamId);
  }
}