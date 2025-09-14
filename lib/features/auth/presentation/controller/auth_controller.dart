import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:test3/features/auth/data/model/approved_request.dart';
import 'package:test3/features/auth/data/model/login_request.dart';
import 'package:test3/features/auth/data/model/register_request.dart';
import 'package:test3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test3/features/auth/domain/entities/approved.dart';
import 'package:test3/features/auth/domain/entities/auth_by_google.dart';
import 'package:test3/features/auth/domain/entities/enum.dart';
import 'package:test3/features/auth/domain/entities/login.dart';
import 'package:test3/features/auth/domain/entities/user.dart';
import 'package:test3/features/auth/domain/usecase/approved_usecase.dart';
import 'package:test3/features/auth/domain/usecase/enum_usecase.dart';
import 'package:test3/features/auth/domain/usecase/login_usecase.dart';
import 'package:test3/features/auth/domain/usecase/login_with_google_usecase.dart';
import 'package:test3/features/auth/domain/usecase/register_google_usecase.dart';
import 'package:test3/features/auth/domain/usecase/register_usecase.dart';
import 'package:test3/features/auth/presentation/controller/translation_controller.dart';
import 'package:test3/features/auth/presentation/pages/check_user_is_approved.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/home.dart';

class AuthController extends GetxController {
  RxBool showHello = false.obs;
  RxBool showWelcome = false.obs;
  RxBool showSignIn = false.obs;
  RxBool isLoadingGoogle = false.obs;
  RxBool isLoadingGoogleRegister = false.obs;

  late final RegisterUseCase _registerUseCase;
  late final LoginUseCase _loginUseCase;
  late final ApprovedUseCase _approvedUseCase;
  late final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  late final RegisterGoogleUseCase _registerGoogleUseCase;

  final TextEditingController name = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  var userEmail = "".obs;
  var token = "".obs;
  RxString? userName = "".obs;
  var fcmToken = "".obs;

  final TextEditingController emailLogin = TextEditingController();
  final TextEditingController passwordLogin = TextEditingController();

  var isLoadingEnums = false.obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;
  var isLoadingLogin = false.obs;
  var isLoadingCheckIsApproved = false.obs;
  Rxn<User> currentUser = Rxn<User>();
  Rxn<LoginEntity> currentLoginUser = Rxn<LoginEntity>();
  Rxn<ApprovedEntity> currentUserIsApproved = Rxn<ApprovedEntity>();
  var enumsResponse = Rxn<EnumsResponse>();

  var alertTypes = <EnumItem>[].obs;
  var selectedAlertIndex = (-1).obs;

  void changeAlertType(int index) {
    selectedAlertIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();

    final remoteDataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _registerUseCase = RegisterUseCase(repository);
    _loginUseCase = LoginUseCase(repository);
    _approvedUseCase = ApprovedUseCase(repository);
    _loginWithGoogleUseCase = LoginWithGoogleUseCase(repository);
    _registerGoogleUseCase = RegisterGoogleUseCase(repository);
  }

  Future<void> _initializeFCM() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      if (token != null) {
        fcmToken.value = token;
        print("FCM Token: $token");
      }
    } catch (e) {
      print("FCM Token Error: $e");
      fcmToken.value = "default-token";
    }
  }

  void runAnimations() {
    showHello.value = false;
    showWelcome.value = false;
    showSignIn.value = false;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!isClosed) showHello.value = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!isClosed) showWelcome.value = true;
    });
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!isClosed) showSignIn.value = true;
    });
  }

  void _clearRegistrationFields() {
    name.clear();
    lastName.clear();
    email.clear();
    password.clear();
  }

  Future<void> registerUser({
    required String name,
    required String lastname,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || lastname.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('error'.tr, 'all_fields_required'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final languageController = Get.find<LanguageController>();
      final selectedLanguage = await languageController
          .getSelectedLanguageForRegister();
      final languageCode = languageController.getLanguageCode(selectedLanguage);

      final request = RegisterRequest(
        name: name,
        lastname: lastname,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        deviceTokenId: fcmToken.value,
        platform: 0,
        preferredLanguage: languageCode,
      );

      final user = await _registerUseCase(request);
      currentUser.value = user;

      Get.snackbar(
        'success'.tr,
        '${'register_success_for'.tr} ${user.email}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      _clearRegistrationFields();
      Get.to(
        () => ApprovedUserPage(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 400),
      );
    } catch (e) {
      String errorMessage = 'register_failed'.tr;

      if (e is DioError && e.response != null) {
        final data = e.response!.data;
        if (data != null && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      Get.snackbar(
        'error'.tr,
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> quickLogout() async {
    final prefs = await SharedPreferences.getInstance();
    final controller = Get.find<AddReportController>();
    final homeController = Get.find<HomeController>();
    await prefs.clear();

    currentLoginUser.value = null;
    controller.pickedImages.value = [];
    homeController.selectedIndex.value = 0;
    homeController.isFiltersExpanded.value = false;
    homeController.isFiltersExpandedTeam.value = false;

    Get.offAll(() => LoginPage());

    Get.snackbar(
      'logged_out'.tr,
      'logged_out_successfully'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: AppColors.background,
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    if (emailLogin.text.isEmpty || passwordLogin.text.isEmpty) {
      Get.snackbar('error'.tr, 'all_fields_required'.tr);
      return;
    }

    isLoadingLogin.value = true;

    final request = LoginRequest(
      email: email,
      password: password,
      deviceTokenId: fcmToken.value,
      platform: 0,
    );
    print('=================== FCM TOKEN : ${fcmToken.value}');

    try {
      final loginUser = await _loginUseCase(request);
      currentLoginUser.value = loginUser;

      print(
        "currentLoginUser ID: ${currentLoginUser.value?.preferredLanguage}",
      );
      print("currentLoginUser ID: ${currentLoginUser.value?.id}");

      final languageController = Get.find<LanguageController>();
      await languageController.setLanguageFromLogin(
        loginUser.preferredLanguage ?? 0,
      );
      languageController.useSystemLocale.value = false;

      if (loginUser.isUserApproved) {
        Get.snackbar(
          'success'.tr,
          '${'welcome_back'.tr}, ${loginUser.name}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        Get.off(
          () => HomePage(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 400),
        );

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', loginUser.id);
        prefs.setString('userName', loginUser.name);
        prefs.setString('role', loginUser.roles.first);
        prefs.setBool('isUserApproved', loginUser.isUserApproved);

        print(
          "✅ Login Success: ${loginUser.name} (${loginUser.email} ${loginUser.roles.first})",
        );
      } else {
        Get.snackbar(
          'not_approved'.tr,
          '${'not_approved_yet'.tr}, ${loginUser.name}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        print("⚠️ Not Approved: ${loginUser.name} (${loginUser.email})");
      }
    } catch (e) {
      String errorMessage = 'login_failed'.tr;

      if (e is DioError && e.response != null) {
        final data = e.response!.data;
        if (data != null && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      Get.snackbar(
        'error'.tr,
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingLogin.value = false;
    }
  }

  Future<void> checkUserIsApproved({required String userId}) async {
    isLoadingCheckIsApproved.value = true;

    final request = ApprovedRequest(userId: userId);

    try {
      final checkUserIsApproved = await _approvedUseCase(request);
      currentUserIsApproved.value = checkUserIsApproved;

      if (checkUserIsApproved.isUserApproved) {
        Get.snackbar(
          'approved'.tr,
          '${'approved_welcome'.tr} ${checkUserIsApproved.name}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        Get.off(
          () => HomePage(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 600),
        );

        print(
          "✅ Approved: ${checkUserIsApproved.name} (${checkUserIsApproved.email})",
        );
      } else {
        Get.snackbar(
          'not_approved'.tr,
          '${'not_approved_yet'.tr}, ${checkUserIsApproved.name}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      String errorMessage = 'request_failed'.tr;

      if (e is DioError && e.response != null) {
        final data = e.response!.data;
        if (data != null && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      Get.snackbar(
        'error'.tr,
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingCheckIsApproved.value = false;
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> loginWithGoogle() async {
    try {
      isLoadingGoogle.value = true;

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoadingGoogle.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('google_token_failed'.tr);
      }

      userEmail.value = googleUser.email;

      final response = await _loginWithGoogleUseCase(
        idToken: idToken,
        deviceTokenId: fcmToken.value,
        platform: 0,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', response.id);
      await prefs.setString('userName', response.name);
      await prefs.setString('userEmail', response.email);
      await prefs.setBool('isUserApproved', response.isUserApproved ?? false);

      if (response.isUserApproved == true) {
        Get.snackbar(
          'success'.tr,
          '${'welcome_back'.tr}, ${googleUser.displayName}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        Get.offAll(
          () => HomePage(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 400),
        );

        print(
          "✅ Login Success: ${googleUser.displayName} (${googleUser.email})",
        );
      } else {
        Get.snackbar(
          'not_approved'.tr,
          '${'not_approved_yet'.tr}, ${googleUser.displayName}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        print(
          "⚠️ Not Approved: ${googleUser.displayName} (${googleUser.email})",
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString().contains('google_token_failed')
            ? e.toString()
            : 'login_failed'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingGoogle.value = false;
    }
  }

  Future<void> registerWithGoogle() async {
    try {
      isLoadingGoogleRegister.value = true;

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoadingGoogleRegister.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('google_token_failed'.tr);
      }

      final response = await _registerGoogleUseCase(
        idToken: idToken,
        deviceTokenId: fcmToken.value,
        platform: 0,
      );

      currentUser.value = User(
        id: response.id,
        message: response.message,
        email: response.email,
      );
      print("✅ User ID saved: ${response.id}");
      print("✅ User ID saved: ${currentUser.value?.id}");
      userEmail.value = response.email;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', response.id);

      await prefs.setString('userEmail', response.email);

      Get.snackbar(
        'success'.tr,
        '${'register_success_for'.tr} ${response.email}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );

      Get.to(
        () => ApprovedUserPage(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 400),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString().contains('google_token_failed')
            ? e.toString()
            : 'register_failed'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingGoogleRegister.value = false;
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');
    final role = prefs.getString('role');
    final isApproved = prefs.getBool('isUserApproved') ?? false;

    if (userId != null && userName != null) {
      currentLoginUser.value = LoginEntity(
        id: userId,
        name: userName,
        email: userEmail ?? '',
        isUserApproved: isApproved,
        roles: role != null ? [role] : [],
        lastname: '',
        preferredLanguage: 0,
        profileImageUrl: '',
        message: '',
        unReadMessagesCount: 0,
      );
    }
  }
}
