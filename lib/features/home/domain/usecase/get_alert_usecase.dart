import 'package:test3/features/home/data/model/get_alert_model.dart';

import '../repositories/get_alert_repository.dart';
import '../entities/get_alert_entity.dart';

class GetAlertsUseCase {
  final GetAlertRepository repository;

  GetAlertsUseCase(this.repository);

  Future<List<GetAlertEntity>> call(GetAlertRequestModel request) {
    return repository.getAlerts(request);
  }
}
