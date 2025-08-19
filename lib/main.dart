import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/add_report/data/datasource/alert_remote_datasource.dart';
import 'package:test3/features/add_report/data/repositories/alert_repository_impl.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/presentation/pages/splashscreen_page.dart';
import 'package:test3/features/home/data/datasource/get_alert_datasource.dart';
import 'package:test3/features/home/data/repositories/get_alert_impl.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final alertRepository = AlertRepositoryImpl(AlertRemoteDataSourceImpl());

  final homeController = Get.put(
    HomeController(
      getAlertsUseCase: GetAlertsUseCase(
        GetAlertRepositoryImpl(
          remoteDataSource: GetAlertRemoteDataSourceImpl(),
        ),
      ),
    ),
  );

  final AddReportController controllerAddReport = Get.put(
    AddReportController(alertRepository),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: SplashScreenPage());
  }
}
