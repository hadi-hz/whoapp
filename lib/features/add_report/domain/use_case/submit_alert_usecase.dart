

import 'package:test3/features/add_report/data/model/alert_model.dart';
import 'package:test3/features/add_report/domain/repositories/alert_repository.dart';

class SubmitAlertUseCase {
  final AlertRepository repository;

  SubmitAlertUseCase(this.repository);

  Future<void> call(AlertModel alert) async {
    return repository.submitAlert(alert);
  }
}
