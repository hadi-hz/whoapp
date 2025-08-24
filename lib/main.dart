import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/add_report/data/datasource/alert_remote_datasource.dart';
import 'package:test3/features/add_report/data/repositories/alert_repository_impl.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/controller/translation_controller.dart';
import 'package:test3/features/auth/presentation/pages/splashscreen_page.dart';
import 'package:test3/features/get_alert_by_id/data/datasource/get_alert_by_id_datasource.dart';
import 'package:test3/features/get_alert_by_id/data/repositories/get_alert_by_id_repository_impl.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/get_alert_by_id_usecase.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/get_alert_by_id_controller.dart';
import 'package:test3/features/home/data/datasource/get_alert_datasource.dart'
    hide AlertRemoteDataSourceImpl;
import 'package:test3/features/home/data/repositories/get_alert_impl.dart'
    hide AlertRepositoryImpl;
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/profile/data/datasource/get_user_info_remote_datasource.dart';
import 'package:test3/features/profile/data/repositories/get-user_info_repository_impl.dart';
import 'package:test3/features/profile/domain/usecase/chnage_password_usecase.dart';
import 'package:test3/features/profile/domain/usecase/get_user_info_usecase.dart';
import 'package:test3/features/profile/domain/usecase/update_user_profile_usecase.dart';
import 'package:test3/features/profile/presentation/controller/profile_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<AlertDetailRemoteDataSourceImpl>(AlertDetailRemoteDataSourceImpl());
  Get.put<AlertDetailRepositoryImpl>(
    AlertDetailRepositoryImpl(Get.find<AlertDetailRemoteDataSourceImpl>()),
  );
  Get.put<GetAlertDetailUseCase>(
    GetAlertDetailUseCase(Get.find<AlertDetailRepositoryImpl>()),
  );
  Get.put<AlertDetailController>(
    AlertDetailController(
      getAlertDetailUseCase: Get.find<GetAlertDetailUseCase>(),
    ),
  );

  final alertRepository = AlertRepositoryImpl(AlertRemoteDataSourceImpl());
  Get.put(AuthController());
  final remoteDataSource = UserRemoteDataSourceImpl();
  final repository = UserRepositoryImpl(remoteDataSource);

  final getUserProfile = GetUserProfile(repository);
  final updateUserProfile = UpdateUserProfile(repository);
  final changePassword = ChangePasswordUseCase(repository);

  Get.put(ProfileController(getUserProfile, updateUserProfile, changePassword));

  Get.put(
    HomeController(
      getAllAlerts: GetAllAlerts(
        GetAlertRepositoryImpl(GetAlertRemoteDataSourceImpl()),
      ),
    ),
  );

  Get.put(AddReportController(alertRepository));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      home: SplashScreenPage(),
    );
  }
}
