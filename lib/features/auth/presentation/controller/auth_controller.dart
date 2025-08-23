import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:test3/features/auth/domain/usecase/register_usecase.dart';
import 'package:test3/features/auth/presentation/pages/check_user_is_approved.dart';
import 'package:test3/features/home/presentation/pages/home.dart';

class AuthController extends GetxController {
  RxBool showHello = false.obs;
  RxBool showWelcome = false.obs;
  RxBool showSignIn = false.obs;
  RxBool isLoadingGoogle = false.obs;

  late final RegisterUseCase _registerUseCase;
  late final LoginUseCase _loginUseCase;
  late final ApprovedUseCase _approvedUseCase;
  late final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  late final GetAllEnums _getAllEnums;


  final TextEditingController name = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  var userEmail = "".obs;
  var token = "".obs;


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

    final remoteDataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _registerUseCase = RegisterUseCase(repository);
    _loginUseCase = LoginUseCase(repository);
    _approvedUseCase = ApprovedUseCase(repository);
    _loginWithGoogleUseCase = LoginWithGoogleUseCase(repository);
    _getAllEnums = GetAllEnums(repository);
    fetchAllEnums();
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

  Future<void> fetchAllEnums() async {
    isLoading.value = true;
    final result = await _getAllEnums();
    print('result : ${result}');
    result.fold((failure) => errorMessage.value = failure, (data) {
      enumsResponse.value = data;
      alertTypes.assignAll(data.alertType);
    });
    isLoading.value = false;
  }

  Future<void> registerUser({
    required String name,
    required String lastname,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty ||
        lastname.isEmpty ||
        phoneNumber.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Get.snackbar('error'.tr, 'all_fields_required'.tr); 
      return;
    }

    isLoading.value = true;

    final request = RegisterRequest(
      name: name,
      lastname: lastname,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      deviceTokenId: "string", 
      platform: 0,
      preferredLanguage: 0,
    );

    try {
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
      deviceTokenId: "string", 
      platform: 0,
    );

    try {
      final loginUser = await _loginUseCase(request);
      currentLoginUser.value = loginUser;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', loginUser.id);
      print("currentLoginUser ID: ${currentLoginUser.value?.id}");

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

        print("✅ Login Success: ${loginUser.name} (${loginUser.email})");
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
          duration: const Duration(milliseconds: 400),
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
        isLoading.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('google_token_failed'.tr); 
      }

      userEmail.value = googleUser.email;

      final AuthEntity response = await _loginWithGoogleUseCase(
        idToken: idToken,
        deviceTokenId: "test-device-id", // TODO: مقدار واقعی
        platform: 0, 
      );

      token.value = response.accessToken;
     
    } catch (e) {
  
    } finally {
      isLoadingGoogle.value = false;
    }
  }
}