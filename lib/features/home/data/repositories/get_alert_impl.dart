import 'package:test3/features/home/data/datasource/get_alert_datasource.dart';
import 'package:test3/features/home/data/model/get_alert_model.dart';


import '../../domain/entities/get_alert_entity.dart';
import '../../domain/repositories/get_alert_repository.dart';

class GetAlertRepositoryImpl implements GetAlertRepository {
  final GetAlertRemoteDataSource remoteDataSource;

  GetAlertRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GetAlertEntity>> getAlerts(GetAlertRequestModel request) async {
    final response = await remoteDataSource.getAlerts(request);


    return response.map((e) => GetAlertEntity(
      id: e.id,
      alertDescriptionByDoctor: e.alertDescriptionByDoctor,
      alertStatus: e.alertStatus,
      alertType: e.alertType,
      serverCreateTime: e.serverCreateTime,
      isDoctor: e.isDoctor,
      isTeamMember: e.isTeamMember,
    )).toList();
  }
}
