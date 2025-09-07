import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/register_page.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';

/// Mock controller for RegisterPage tests.
/// Extends AuthController to avoid implementing all methods.
/// Only overrides the ones used in this UI.
class MockAuthController extends AuthController {
  MockAuthController();

  bool registerCalled = false;
  bool googleRegisterCalled = false;

  @override
  Future<void> registerUser({
    required String name,
    required String lastname,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    registerCalled = true;
  }

  @override
  Future<void> registerWithGoogle() async {
    googleRegisterCalled = true;
  }

  @override
  void runAnimations() {
    // Skip animations for tests
  }

  @override
  void onInit() {
    // Skip parent init logic
  }
}

void main() {
  late MockAuthController mockController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockController = MockAuthController();
    Get.put<AuthController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Register page shows main UI elements', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const RegisterPage()));
    await tester.pumpAndSettle();

    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Register Account'), findsOneWidget);
    expect(find.text('Register with Google'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Validation: empty fields should show errors', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const RegisterPage()));
    await tester.pumpAndSettle();

    // Tap register button
    await tester.tap(find.byType(BoxNeumorphysm).first);
    await tester.pump();

    expect(find.text('First name is required'), findsOneWidget);
    expect(find.text('Last name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Successful register: registerUser should be called', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const RegisterPage()));
    await tester.pumpAndSettle();

    mockController.name.text = 'John';
    mockController.lastName.text = 'Doe';
    mockController.email.text = 'john@test.com';
    mockController.password.text = '123456';

    await tester.tap(find.byType(BoxNeumorphysm).first); // Tap register button
    await tester.pump();

    expect(mockController.registerCalled, isTrue);
  });

  testWidgets('Google register button should call registerWithGoogle', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: const RegisterPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BoxNeumorphysm).at(1)); // Tap google button
    await tester.pump();

    expect(mockController.googleRegisterCalled, isTrue);
  });
}
