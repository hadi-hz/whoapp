import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/add_report/data/datasource/alert_remote_datasource.dart';
import 'package:test3/features/add_report/data/repositories/alert_repository_impl.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/data/datasource/change_language_datasource.dart';
import 'package:test3/features/auth/data/repositories/change_language_repository_impl.dart';
import 'package:test3/features/auth/domain/repositories/change_language_repository.dart';
import 'package:test3/features/auth/domain/usecase/change_language_usecase.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/controller/locale_change_language.dart';
import 'package:test3/features/auth/presentation/controller/translation_controller.dart';
import 'package:test3/features/auth/presentation/pages/splashscreen_page.dart';
import 'package:test3/features/get_alert_by_id/data/datasource/assign_team_datesource.dart';
import 'package:test3/features/get_alert_by_id/data/datasource/get_alert_by_id_datasource.dart';
import 'package:test3/features/get_alert_by_id/data/datasource/get_team_by_alert_type.dart';
import 'package:test3/features/get_alert_by_id/data/repositories/assign_team_repository.dart';
import 'package:test3/features/get_alert_by_id/data/repositories/get_alert_by_id_repository_impl.dart';
import 'package:test3/features/get_alert_by_id/data/repositories/get_team_by_alert_type_repository_impl.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/assign_team_repository.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/get_team_by_alert_type.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/assign_team._usecase.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/get_alert_by_id_usecase.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/get_team_by_alert_type.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/get_alert_by_id_controller.dart';
import 'package:test3/features/home/data/datasource/assign_role_datasource.dart';
import 'package:test3/features/home/data/datasource/create_team_datasource.dart';
import 'package:test3/features/home/data/datasource/get_alert_datasource.dart'
    hide AlertRemoteDataSourceImpl, AlertRemoteDataSource;
import 'package:test3/features/home/data/datasource/get_team_by_id.dart';
import 'package:test3/features/home/data/datasource/get_teams_by_member_id.dart';
import 'package:test3/features/home/data/datasource/team_datasource.dart';
import 'package:test3/features/home/data/datasource/team_start_processing_datasource.dart';
import 'package:test3/features/home/data/datasource/user_detail_datasource.dart';
import 'package:test3/features/home/data/datasource/users_datasource.dart';
import 'package:test3/features/home/data/repositories/assign_role_repository_impl.dart';
import 'package:test3/features/home/data/repositories/create_team_repository_impl.dart';
import 'package:test3/features/home/data/repositories/get_alert_impl.dart'
    hide AlertRepositoryImpl;
import 'package:test3/features/home/data/repositories/get_teams_by_member_id_repository_impl.dart';
import 'package:test3/features/home/data/repositories/team_repository_impl.dart';
import 'package:test3/features/home/data/repositories/team_start_processing_repository_impl.dart';
import 'package:test3/features/home/data/repositories/user_detail_repository_impl.dart';
import 'package:test3/features/home/data/repositories/users_repository_impl.dart';
import 'package:test3/features/home/domain/repositories/assign_role_repository.dart';
import 'package:test3/features/home/domain/repositories/create_team_repository.dart';
import 'package:test3/features/home/domain/repositories/get_alert_repository.dart';
import 'package:test3/features/home/domain/repositories/get_teams_by_member_id.dart';
import 'package:test3/features/home/domain/repositories/team_repository.dart';
import 'package:test3/features/home/domain/repositories/team_start_processing_repository.dart';
import 'package:test3/features/home/domain/repositories/user_detail_repository.dart';
import 'package:test3/features/home/domain/repositories/users_repository.dart';
import 'package:test3/features/home/domain/usecase/add_members_usecase.dart';
import 'package:test3/features/home/domain/usecase/assign_role_usecase.dart';
import 'package:test3/features/home/domain/usecase/create_team_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_team_by_id.dart';
import 'package:test3/features/home/domain/usecase/get_teams_by_member_id_usecase.dart';
import 'package:test3/features/home/domain/usecase/team_start_processing.dart';
import 'package:test3/features/home/domain/usecase/team_usecase.dart';
import 'package:test3/features/home/domain/usecase/user_detail_ussecase.dart';
import 'package:test3/features/home/domain/usecase/users_usecase.dart';
import 'package:test3/features/home/presentation/controller/create_team_controller.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';
import 'package:test3/features/home/presentation/controller/get_teams_by_member_id_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/controller/team_start_processing_controller.dart';
import 'package:test3/features/profile/data/datasource/get_user_info_remote_datasource.dart';
import 'package:test3/features/profile/data/repositories/get-user_info_repository_impl.dart';
import 'package:test3/features/profile/domain/usecase/chnage_password_usecase.dart';
import 'package:test3/features/profile/domain/usecase/get_user_info_usecase.dart';
import 'package:test3/features/profile/domain/usecase/update_user_profile_usecase.dart';
import 'package:test3/features/profile/presentation/controller/profile_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<Dio>(DioBase().dio);

  Get.put<AlertDetailRemoteDataSourceImpl>(AlertDetailRemoteDataSourceImpl());
  Get.put<AlertDetailRepositoryImpl>(
    AlertDetailRepositoryImpl(Get.find<AlertDetailRemoteDataSourceImpl>()),
  );
  Get.put<GetAlertDetailUseCase>(
    GetAlertDetailUseCase(Get.find<AlertDetailRepositoryImpl>()),
  );

  Get.lazyPut<TeamRemoteDataSource>(() => TeamRemoteDataSourceImpl());
  Get.lazyPut<TeamRepository>(
    () => TeamRepositoryImpl(remoteDataSource: Get.find()),
  );
  Get.lazyPut<GetTeamByAlertType>(
    () => GetTeamByAlertType(repository: Get.find()),
  );

  Get.lazyPut<AssignTeamRemoteDataSource>(
    () => AssignTeamRemoteDataSourceImpl(),
  );
  Get.lazyPut<AssignTeamRepository>(
    () => AssignTeamRepositoryImpl(remoteDataSource: Get.find()),
  );
  Get.lazyPut<AssignTeamUseCase>(
    () => AssignTeamUseCase(repository: Get.find()),
  );

  Get.put<AlertDetailController>(
    AlertDetailController(
      assignTeamUseCase: Get.find(),
      getTeamByAlertType: Get.find(),
      getAlertDetailUseCase: Get.find<GetAlertDetailUseCase>(),
    ),
  );

  Get.put(AuthController());

  final remoteDataSource = UserRemoteDataSourceImpl();
  final repository = UserRepositoryImpl(remoteDataSource);
  final getUserProfile = GetUserProfile(repository);
  final updateUserProfile = UpdateUserProfile(repository);
  final changePassword = ChangePasswordUseCase(repository);
  Get.put(ProfileController(getUserProfile, updateUserProfile, changePassword));

  Get.lazyPut<UsersRemoteDataSource>(() => UsersRemoteDataSourceImpl());
  Get.lazyPut<UsersRepository>(
    () => UsersRepositoryImpl(remoteDataSource: Get.find()),
  );
  Get.lazyPut<GetAllUsersUseCase>(
    () => GetAllUsersUseCase(repository: Get.find()),
  );
  Get.lazyPut<UserDetailRemoteDataSource>(
    () => UserDetailRemoteDataSourceImpl(),
  );
  Get.lazyPut<UserDetailRepository>(
    () => UserDetailRepositoryImpl(remoteDataSource: Get.find()),
  );
  Get.lazyPut<GetUserDetailUseCase>(
    () => GetUserDetailUseCase(repository: Get.find()),
  );

  Get.lazyPut<AssignRoleRemoteDataSource>(
    () => AssignRoleRemoteDataSourceImpl(),
  );
  Get.lazyPut<AssignRoleRepository>(
    () => AssignRoleRepositoryImpl(remoteDataSource: Get.find()),
  );
  Get.lazyPut<AssignRoleUseCase>(
    () => AssignRoleUseCase(repository: Get.find()),
  );

  Get.lazyPut<TeamsRemoteDataSource>(() => TeamsRemoteDataSourceImpl());
  Get.lazyPut<TeamRemoteDataSourceTeamId>(
    () => TeamRemoteDataSourceImplTeamId(),
  );

  Get.lazyPut<TeamsRepository>(
    () => TeamsRepositoryImpl(
      remoteDataSource: Get.find(),
      remoteDataSourceTeamById: Get.find(),
    ),
  );

  Get.lazyPut<GetAllTeamsUseCase>(
    () => GetAllTeamsUseCase(repository: Get.find()),
  );
  Get.lazyPut<GetTeamByIdUseCase>(
    () => GetTeamByIdUseCase(Get.find<TeamsRepository>()),
  );

  Get.put(
    HomeController(
      getAllTeamsUseCase: Get.find(),
      getAllUsersUseCase: Get.find(),
      getUserDetailUseCase: Get.find(),
      assignRoleUseCase: Get.find(),
      getTeamByIdUseCase: Get.find(),
    ),
  );

  Get.lazyPut<GetTeamsByUserRemoteDataSource>(
    () => GetTeamsByUserRemoteDataSourceImpl(),
  );

  Get.lazyPut<GetTeamsByUserRepository>(
    () => GetTeamsByUserRepositoryImpl(
      Get.find<GetTeamsByUserRemoteDataSource>(),
    ),
  );

  Get.lazyPut<GetTeamsByUserUseCase>(
    () => GetTeamsByUserUseCase(Get.find<GetTeamsByUserRepository>()),
  );

  Get.lazyPut<GetTeamsByUserController>(
    () => GetTeamsByUserController(Get.find<GetTeamsByUserUseCase>()),
  );

  Get.lazyPut<CreateTeamRemoteDataSource>(
    () => CreateTeamRemoteDataSourceImpl(),
  );

  Get.lazyPut<CreateTeamRepository>(
    () => CreateTeamRepositoryImpl(Get.find<CreateTeamRemoteDataSource>()),
  );

  Get.lazyPut<CreateTeamUseCase>(
    () => CreateTeamUseCase(Get.find<CreateTeamRepository>()),
  );

  Get.lazyPut<AddMembersUseCase>(
    () => AddMembersUseCase(Get.find<CreateTeamRepository>()),
  );

  Get.lazyPut<CreateTeamController>(
    () => CreateTeamController(
      Get.find<CreateTeamUseCase>(),
      Get.find<AddMembersUseCase>(),
    ),
  );

  final alertRepository = AlertRepositoryImpl(AlertRemoteDataSourceImpl());
  Get.put(AddReportController(alertRepository));

  Get.lazyPut<TeamStartProcessingRemoteDataSource>(
    () => TeamStartProcessingRemoteDataSourceImpl(Get.find<Dio>()),
  );

  Get.lazyPut<TeamStartProcessingRepository>(
    () => TeamStartProcessingRepositoryImpl(
      Get.find<TeamStartProcessingRemoteDataSource>(),
    ),
  );

  Get.lazyPut<TeamStartProcessingUseCase>(
    () => TeamStartProcessingUseCase(Get.find<TeamStartProcessingRepository>()),
  );

  Get.lazyPut<TeamStartProcessingController>(
    () => TeamStartProcessingController(Get.find<TeamStartProcessingUseCase>()),
  );

  Get.lazyPut<ChangeLanguageRemoteDataSource>(
    () => ChangeLanguageRemoteDataSourceImpl(Get.find<Dio>()),
  );

  Get.lazyPut<ChangeLanguageRepository>(
    () => ChangeLanguageRepositoryImpl(
      Get.find<ChangeLanguageRemoteDataSource>(),
    ),
  );
  Get.lazyPut<ChangeLanguageUseCase>(
    () => ChangeLanguageUseCase(Get.find<ChangeLanguageRepository>()),
  );
  Get.put<LanguageController>(
    LanguageController(Get.find<ChangeLanguageUseCase>()),
    permanent: true,
  );

  Get.lazyPut<GetAlertRemoteDataSource>(
    () => GetAlertRemoteDataSourceImpl(dio: Get.find()),
  );

  Get.lazyPut<AlertListRepository>(
    () => AlertListRepositoryImpl(remoteDataSource: Get.find()),
  );

  Get.lazyPut(() => GetAlertsUseCase(Get.find()));

  Get.lazyPut(() => AlertListController(getAlertsUseCase: Get.find()));

  Get.put<AlertListController>(
    AlertListController(getAlertsUseCase: Get.find()),
    permanent: true,
  );

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
