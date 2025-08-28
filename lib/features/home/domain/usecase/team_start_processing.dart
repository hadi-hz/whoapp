import 'package:test3/features/home/domain/entities/team_start_processing.dart';
import 'package:test3/features/home/domain/repositories/team_start_processing_repository.dart';

class TeamStartProcessingUseCase {
  final TeamStartProcessingRepository repository;

  TeamStartProcessingUseCase(this.repository);

  Future<TeamStartProcessingResponse> call(TeamStartProcessingRequest request) async {
    return await repository.teamStartProcessing(request);
  }
}