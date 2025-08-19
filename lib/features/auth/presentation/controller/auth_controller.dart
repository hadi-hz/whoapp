import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:test3/features/auth/data/model/approved_request.dart';
import 'package:test3/features/auth/data/model/login_request.dart';
import 'package:test3/features/auth/data/model/register_request.dart';
import 'package:test3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test3/features/auth/domain/entities/approved.dart';
import 'package:test3/features/auth/domain/entities/login.dart';
import 'package:test3/features/auth/domain/entities/user.dart';
import 'package:test3/features/auth/domain/usecase/approved_usecase.dart';
import 'package:test3/features/auth/domain/usecase/login_usecase.dart';
import 'package:test3/features/auth/domain/usecase/register_usecase.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';
import 'package:test3/features/home/presentation/pages/home.dart';

class AuthController extends GetxController {
  RxBool showHello = false.obs;
  RxBool showWelcome = false.obs;
  RxBool showSignIn = false.obs;

  late final RegisterUseCase _registerUseCase;
  late final LoginUseCase _loginUseCase;
  late final ApprovedUseCase _approvedUseCase;

  //Register
  final TextEditingController name = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  //Login
  final TextEditingController emailLogin = TextEditingController();
  final TextEditingController passwordLogin = TextEditingController();

  var isLoading = false.obs;
  var isLoadingLogin = false.obs;
  Rxn<User> currentUser = Rxn<User>();
  Rxn<LoginEntity> currentLoginUser = Rxn<LoginEntity>();
  Rxn<ApprovedEntity> currentUserIsApproved = Rxn<ApprovedEntity>();

  @override
  void onInit() {
    super.onInit();

    final remoteDataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _registerUseCase = RegisterUseCase(repository);
    _loginUseCase = LoginUseCase(repository);
    _approvedUseCase = ApprovedUseCase(repository);
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
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    isLoading.value = true;

    final request = RegisterRequest(
      name: name,
      lastname: lastname,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      deviceTokenId: "string", // بعداً باید FCM token بشه
      platform: 0,
      preferredLanguage: 0,
    );

    try {
      final user = await _registerUseCase(request);
      currentUser.value = user;

      Get.snackbar(
        'Success',
        'Register Account created for ${user.email}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      Get.to(const LoginPage());

      print("✅ Register Success: ${user.id} (${user.email})");
    } catch (e) {
      String errorMessage = "Register Account failed";

      if (e is DioError && e.response != null) {
        final data = e.response!.data;
        if (data != null && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );

      print("❌ Register Error: $errorMessage");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    if (emailLogin.text.isEmpty || passwordLogin.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    isLoadingLogin.value = true;

    final request = LoginRequest(
      email: email,
      password: password,
      deviceTokenId: "string", // بعداً باید FCM token بشه
      platform: 0,
    );

    try {
      final loginUser = await _loginUseCase(request);
      currentLoginUser.value = loginUser;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', loginUser.id);
      print("loginUser ID: ${loginUser.id}");

      if (loginUser.isUserApproved) {
        Get.snackbar(
          'Success',
          'Welcome back, ${loginUser.name}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        Get.to(HomePage());

        print("✅ Login Success: ${loginUser.name} (${loginUser.email})");
      } else {
        Get.snackbar(
          'Not Approved ❌',
          'You are not approved yet, ${loginUser.name}.',
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
      String errorMessage = "Login failed. Please try again.";

      if (e is DioError && e.response != null) {
        final data = e.response!.data;
        if (data != null && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );

      print("❌ Login Error: $errorMessage");
    } finally {
      isLoadingLogin.value = false;
    }
  }

  Future<void> checkUserIsApproved({required String userId}) async {
    isLoadingLogin.value = true;

    final request = ApprovedRequest(userId: userId);

    try {
      final checkUserIsApproved = await _approvedUseCase(request);
      currentUserIsApproved.value = checkUserIsApproved;

      if (checkUserIsApproved.isUserApproved) {
        Get.snackbar(
          'Approved ✅',
          'You are approved. Welcome ${checkUserIsApproved.name}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        Get.to(HomePage());

        print(
          "✅ Approved: ${checkUserIsApproved.name} (${checkUserIsApproved.email})",
        );
      } else {
        Get.snackbar(
          'Not Approved ❌',
          'You are not approved yet, ${checkUserIsApproved.name}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        print(
          "⚠️ Not Approved: ${checkUserIsApproved.name} (${checkUserIsApproved.email})",
        );
      }
    } catch (e) {
      String errorMessage = "Request failed. Please try again.";

      if (e is DioError && e.response != null) {
        final data = e.response!.data;
        if (data != null && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );

      print("❌ Error: $errorMessage");
    } finally {
      isLoadingLogin.value = false;
    }
  }
}
