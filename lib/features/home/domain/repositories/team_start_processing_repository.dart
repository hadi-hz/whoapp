import 'package:test3/features/home/domain/entities/team_start_processing.dart';

abstract class TeamStartProcessingRepository {
  Future<TeamStartProcessingResponse> teamStartProcessing(TeamStartProcessingRequest request);
}