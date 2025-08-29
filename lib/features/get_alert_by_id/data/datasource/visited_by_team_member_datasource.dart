import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/get_alert_by_id/data/model/visited_by_team_member_model.dart';

abstract class VisitedByTeamMemberRemoteDataSource {
  Future<VisitedByTeamMemberResponseModel> visitedByTeamMember(VisitedByTeamMemberModel model);
}

class VisitedByTeamMemberRemoteDataSourceImpl implements VisitedByTeamMemberRemoteDataSource {
  final Dio dio;


  VisitedByTeamMemberRemoteDataSourceImpl(this.dio);

  @override
  Future<VisitedByTeamMemberResponseModel> visitedByTeamMember(VisitedByTeamMemberModel model) async {
    try {
      final response = await dio.post(
        ApiEndpoints.visitedTeamMember,
        data: model.toJson(),
      );
      return VisitedByTeamMemberResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to mark as visited by team member: $e');
    }
  }
}