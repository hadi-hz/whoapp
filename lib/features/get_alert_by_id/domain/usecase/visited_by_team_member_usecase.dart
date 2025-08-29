import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/visited_by_team_member.dart';

class VisitedByTeamMemberUseCase {
  final VisitedByTeamMemberRepository repository;

  VisitedByTeamMemberUseCase(this.repository);

  Future<VisitedByTeamMemberResponse> call(
    VisitedByTeamMemberRequest request,
  ) async {
    return await repository.visitedByTeamMember(request);
  }
}
