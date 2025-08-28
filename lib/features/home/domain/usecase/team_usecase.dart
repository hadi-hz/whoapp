import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/team_filter_entity.dart';
import 'package:test3/features/home/domain/repositories/team_repository.dart';
import '../entities/team_entity.dart';

class GetAllTeamsUseCase {
  final TeamsRepository repository;

  GetAllTeamsUseCase({required this.repository});

  Future<Either<String, List<TeamEntity>>> call(TeamsFilterEntity filter) async {
    return await repository.getAllTeams(filter);
  }

 
}
