import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';

/// A mock controller that extends the real AuthController.
/// This way we don't need to re-implement all methods,
/// only the ones we use in our tests.
class MockAuthController extends AuthController {
  MockAuthController();

  bool loginCalled = false;
  bool googleLoginCalled = false;

  @override
  Future<void> loginUser({required String email, required String password}) async {
    loginCalled = true;
  }

  @override
  Future<void> loginWithGoogle() async {
    googleLoginCalled = true;
  }

  @override
  void runAnimations() {
    // Do nothing for tests
  }

  @override
  void onInit() {
    // Skip parent initialization to avoid real side effects
  }
}

void main() {
  late MockAuthController mockController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockController = MockAuthController();
    // Register the mock so that Get.find<AuthController>() returns it
    Get.put<AuthController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Login page shows main UI elements', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const LoginPage()));
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Login with Google'), findsOneWidget);
  });

  testWidgets('Validation: empty email and password should show errors', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const LoginPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BoxNeumorphysm).first); // Tap login button
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Successful login: loginUser should be called', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const LoginPage()));
    await tester.pumpAndSettle();

    // Set test values directly on the controller
    mockController.emailLogin.text = 'test@test.com';
    mockController.passwordLogin.text = '123456';

    await tester.tap(find.byType(BoxNeumorphysm).first); // Tap login button
    await tester.pump();

    expect(mockController.loginCalled, isTrue);
  });

  testWidgets('Google login button should call loginWithGoogle', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const LoginPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BoxNeumorphysm).last); // Tap google button
    await tester.pump();

    expect(mockController.googleLoginCalled, isTrue);
  });
}
