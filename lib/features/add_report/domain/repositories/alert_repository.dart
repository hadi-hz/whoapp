import 'package:image_picker/image_picker.dart';
import 'package:test3/features/add_report/data/model/alert_model.dart';

abstract class AlertRepository {
  Future<dynamic> submitAlert(AlertModel request, {List<XFile>? files});
}
