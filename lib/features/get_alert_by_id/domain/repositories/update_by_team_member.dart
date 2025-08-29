import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member_response.dart';

abstract class UpdateAlertByTeamMemberRepository {
  Future<UpdateAlertByTeamMemberResponse> updateAlertByTeamMember(UpdateAlertByTeamMemberRequest request);
}