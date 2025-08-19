import 'package:test3/features/add_report/data/datasource/alert_remote_datasource.dart';
import 'package:test3/features/add_report/data/model/alert_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:test3/features/add_report/domain/repositories/alert_repository.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource remoteDataSource;

  AlertRepositoryImpl(this.remoteDataSource);

  @override
  Future<dynamic> submitAlert(AlertModel request, {List<XFile>? files}) async {

    final response = await remoteDataSource.submitAlert(request, files: files);
    return response; 
  }
}
