import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:test3/features/auth/domain/entities/user.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/check_user_is_approved.dart';

/// Mock controller for ApprovedUserPage
class MockAuthController extends AuthController {
  bool checkApprovalCalled = false;

  @override
  Future<void> checkUserIsApproved({required String userId}) async {
    checkApprovalCalled = true;
  }

  // Mocked reactive variables
  @override
  var isLoadingCheckIsApproved = false.obs;

  @override
  var currentUser = Rxn<User>(); // use your actual User entity

  @override
  void onInit() {
    // skip parent init logic
  }
}

void main() {
  late MockAuthController mockController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockController = MockAuthController();
    mockController.currentUser.value =
        User(id: '123', email: 'test@test.com', message: 'ok'); // Fake user
    Get.put<AuthController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('ApprovedUserPage renders correctly', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: ApprovedUserPage()));
    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.text('register_success'.tr), findsOneWidget);
  });

  testWidgets('Pull to refresh calls checkUserIsApproved', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: ApprovedUserPage()));
    await tester.pump();

    // simulate pull-to-refresh
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
    await tester.pump(const Duration(seconds: 1)); // refresh indicator animation
    await tester.pumpAndSettle();

    expect(mockController.checkApprovalCalled, isTrue);
  });

  testWidgets('Loading state shows progress indicator', (tester) async {
    mockController.isLoadingCheckIsApproved.value = true;

    await tester.pumpWidget(GetMaterialApp(home: ApprovedUserPage()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('checking_approval_status'.tr), findsOneWidget);
  });

  testWidgets('Idle state shows pull down hint', (tester) async {
    mockController.isLoadingCheckIsApproved.value = false;

    await tester.pumpWidget(GetMaterialApp(home: ApprovedUserPage()));
    await tester.pump();

    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    expect(find.text('pull_down_to_check_status'.tr), findsOneWidget);
  });
}
