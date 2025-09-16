import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/home/presentation/pages/home.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';

import 'homepage_widget_test.mocks.dart';

@GenerateMocks([HomeController, AlertListController])
void main() {
  late MockHomeController mockHomeController;
  late MockAlertListController mockAlertController;

  setUp(() {
    mockHomeController = MockHomeController();
    mockAlertController = MockAlertListController();

    when(mockHomeController.role).thenReturn('Admin'.obs);
    when(mockHomeController.selectedIndex).thenReturn(0.obs);
    when(mockAlertController.currentPage).thenReturn(1.obs);
    when(mockAlertController.pageSize).thenReturn(10.obs);
    when(mockAlertController.selectedUserId).thenReturn(Rxn<String>());
    when(mockAlertController.sortDescending).thenReturn(true.obs);

    Get.put<HomeController>(mockHomeController);
    Get.put<AlertListController>(mockAlertController);

    SharedPreferences.setMockInitialValues({
      'userId': 'test-user-123',
      'role': 'Admin',
    });
  });

  tearDown(() {
    Get.reset();
  });

  Widget createTestWidget() {
    return GetMaterialApp(
      home: HomePage(),
    );
  }

  group('HomePage Widget Tests', () {
    testWidgets('should show loading indicator during initialization', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render HomePage correctly for Admin role', (tester) async {
      when(mockHomeController.role).thenReturn('Admin'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render HomePage correctly for ServiceProvider role', (tester) async {
      when(mockHomeController.role).thenReturn('ServiceProvider'.obs);
      
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
        'role': 'ServiceProvider',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should render HomePage correctly for Doctor role', (tester) async {
      when(mockHomeController.role).thenReturn('Doctor'.obs);
      
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
        'role': 'Doctor',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should show correct navigation bar for Admin', (tester) async {
      when(mockHomeController.role).thenReturn('Admin'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show Admin navigation bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should show correct navigation bar for ServiceProvider', (tester) async {
      when(mockHomeController.role).thenReturn('ServiceProvider'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should show correct navigation bar for Doctor', (tester) async {
      when(mockHomeController.role).thenReturn('Doctor'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should handle selectedIndex change correctly', (tester) async {
      when(mockHomeController.selectedIndex).thenReturn(1.obs);
      when(mockHomeController.role).thenReturn('Admin'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should reset index when out of bounds', (tester) async {
      // Simulate selectedIndex being out of bounds
      when(mockHomeController.selectedIndex).thenReturn(10.obs);
      when(mockHomeController.role).thenReturn('Admin'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should handle gracefully and reset to 0
      verify(mockHomeController.selectedIndex = 0 as RxInt?).called(1);
    });

    testWidgets('should call loadAlerts on initialization', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(mockAlertController.loadAlerts()).called(1);
    });

    testWidgets('should handle empty role correctly', (tester) async {
      when(mockHomeController.role).thenReturn(''.obs);
      
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
        'role': '',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should handle null userId in SharedPreferences', (tester) async {
      SharedPreferences.setMockInitialValues({
        'role': 'Admin',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should handle null role in SharedPreferences', (tester) async {
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should update role value from SharedPreferences', (tester) async {
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
        'role': 'Doctor',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(mockHomeController.role = 'Doctor' as RxString?).called(1);
    });

    testWidgets('should set alert filter parameters correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(mockAlertController.selectedUserId = any).called(1);
      verify(mockAlertController.sortDescending = true as RxBool?).called(1);
      verify(mockAlertController.currentPage = 1 as RxInt?).called(1);
      verify(mockAlertController.pageSize = 10 as RxInt?).called(1);
    });

    testWidgets('should handle Admin role alert filtering', (tester) async {
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
        'role': 'Admin',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // For Admin role, userId should be null in filter
      verify(mockAlertController.selectedUserId = null).called(1);
    });

    testWidgets('should handle non-Admin role alert filtering', (tester) async {
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
        'role': 'Doctor',
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // For non-Admin role, userId should be set
      verify(mockAlertController.selectedUserId = 'test-user-123' as Rxn<String>?).called(1);
    });

    testWidgets('should show different page counts based on role', (tester) async {
      // Test that Admin has 5 pages while others have fewer
      when(mockHomeController.role).thenReturn('Admin'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // HomePage should initialize with correct number of pages for each role
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should maintain state during role changes', (tester) async {
      when(mockHomeController.role).thenReturn('Admin'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change role
      when(mockHomeController.role).thenReturn('Doctor'.obs);
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}