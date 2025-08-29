import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/get_alert_by_id/data/model/visited_by_admin_model.dart';

abstract class VisitedByAdminRemoteDataSource {
  Future<VisitedByAdminResponseModel> visitedByAdmin(VisitedByAdminModel model);
}

class VisitedByAdminRemoteDataSourceImpl implements VisitedByAdminRemoteDataSource {
  final Dio dio;

  VisitedByAdminRemoteDataSourceImpl(this.dio);

  @override
  Future<VisitedByAdminResponseModel> visitedByAdmin(VisitedByAdminModel model) async {
    try {
      final response = await dio.post(
        ApiEndpoints.visitedAdmin,
        data: model.toJson(),
      );
      return VisitedByAdminResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to mark as visited by admin: $e');
    }
  }
}