import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/add_member_model.dart';
import 'package:test3/features/home/data/model/create_team_model.dart';
import 'package:test3/features/home/data/model/team_model.dart';

abstract class CreateTeamRemoteDataSource {
  Future<TeamModel> createTeam(CreateTeamModel model);
  Future<void> addMembers(AddMembersModel model);
}

class CreateTeamRemoteDataSourceImpl implements CreateTeamRemoteDataSource {
  final Dio _dio = DioBase().dio;
  

  CreateTeamRemoteDataSourceImpl();

  @override
  Future<TeamModel> createTeam(CreateTeamModel model) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.teamsCreate,
        data: model.toJson(),
      );
      return TeamModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create team: $e');
    }
  }

  @override
  Future<void> addMembers(AddMembersModel model) async {
    try {
      await _dio.post(
        ApiEndpoints.addMembers,
        data: model.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to add members: $e');
    }
  }
}
