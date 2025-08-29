import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_team_member.dart';

abstract class VisitedByTeamMemberRepository {
  Future<VisitedByTeamMemberResponse> visitedByTeamMember(VisitedByTeamMemberRequest request);
}
