import 'package:test3/features/home/data/model/get_alert_model.dart';

import '../entities/get_alert_entity.dart';

abstract class GetAlertRepository {
  Future<List<GetAlertEntity>> getAlerts(GetAlertRequestModel request);
}
