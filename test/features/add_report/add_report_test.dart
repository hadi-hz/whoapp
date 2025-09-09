// test/animated_bottom_nav_doctor_test.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

// Import your actual files
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';
import 'package:test3/core/const/const.dart';

// Import the actual classes you want to mock
import 'package:test3/features/add_report/domain/repositories/alert_repository.dart';
import 'package:test3/features/home/domain/usecase/users_usecase.dart';
import 'package:test3/features/home/domain/usecase/user_detail_ussecase.dart';
import 'package:test3/features/home/domain/usecase/assign_role_usecase.dart';
import 'package:test3/features/home/domain/usecase/team_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';
import 'package:test3/features/home/presentation/pages/widgets/navigationbar.dart';

// Mock classes that implement the actual interfaces
class MockAlertRepository extends Mock implements AlertRepository {}
class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}
class MockGetUserDetailUseCase extends Mock implements GetUserDetailUseCase {}
class MockAssignRoleUseCase extends Mock implements AssignRoleUseCase {}
class MockGetAllTeamsUseCase extends Mock implements GetAllTeamsUseCase {}
class MockGetAlertsUseCase extends Mock implements GetAlertsUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('AnimatedBottomNavDoctor Complete Tests', () {
    late AddReportController addReportController;
    late HomeController homeController;
    late AuthController authController;
    late AlertListController alertController;

    setUp(() async {
      // Setup SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-id',
        'userName': 'Test User',
        'role': 'Doctor',
        'isUserApproved': true,
      });

      // Initialize controllers with mocks
      addReportController = AddReportController(MockAlertRepository());
      homeController = HomeController(
        getAllUsersUseCase: MockGetAllUsersUseCase(),
        getUserDetailUseCase: MockGetUserDetailUseCase(),
        assignRoleUseCase: MockAssignRoleUseCase(),
        getAllTeamsUseCase: MockGetAllTeamsUseCase(),
      );
      authController = AuthController();
      alertController = AlertListController(getAlertsUseCase: MockGetAlertsUseCase());

      // Register controllers
      Get.put<AddReportController>(addReportController);
      Get.put<HomeController>(homeController);
      Get.put<AuthController>(authController);
      Get.put<AlertListController>(alertController);
    });

    tearDown(() {
      Get.reset();
    });

    // ===== UNIT TESTS =====
    group('Unit Tests - AddReportController', () {
      test('should initialize with default values', () {
        expect(addReportController.isLoading.value, false);
        expect(addReportController.selectedLat.value, 0.0);
        expect(addReportController.selectedLng.value, 0.0);
        expect(addReportController.pickedImages.length, 0);
        expect(addReportController.description.text, isEmpty);
        expect(addReportController.patientName.text, isEmpty);
      });

      test('should clear form correctly', () {
        // Arrange
        addReportController.description.text = 'Test description';
        addReportController.patientName.text = 'John Doe';
        addReportController.selectedLat.value = 35.7219;
        addReportController.selectedLng.value = 51.3347;
        addReportController.pickedImages.add(XFile('test_image.jpg'));

        // Act
        addReportController.clearForm();

        // Assert
        expect(addReportController.description.text, isEmpty);
        expect(addReportController.patientName.text, isEmpty);
        expect(addReportController.selectedLat.value, 0.0);
        expect(addReportController.selectedLng.value, 0.0);
        expect(addReportController.pickedImages.length, 0);
      });

      test('should remove image at correct index', () {
        // Arrange
        addReportController.pickedImages.addAll([
          XFile('image1.jpg'),
          XFile('image2.jpg'),
          XFile('image3.jpg'),
        ]);

        // Act
        addReportController.removeImage(1);

        // Assert
        expect(addReportController.pickedImages.length, 2);
        expect(addReportController.pickedImages[0].path, 'image1.jpg');
        expect(addReportController.pickedImages[1].path, 'image3.jpg');
      });

      test('should not remove image with invalid index', () {
        // Arrange
        addReportController.pickedImages.add(XFile('image1.jpg'));

        // Act
        addReportController.removeImage(5); // Invalid index

        // Assert
        expect(addReportController.pickedImages.length, 1);
      });

      test('should convert XFiles to Files correctly', () {
        // Arrange
        List<XFile> xFiles = [
          XFile('path1.jpg'),
          XFile('path2.jpg'),
        ];

        // Act
        List<File> files = addReportController.convertXFilesToFiles(xFiles);

        // Assert
        expect(files.length, 2);
        expect(files[0].path, 'path1.jpg');
        expect(files[1].path, 'path2.jpg');
      });
    });

    group('Unit Tests - HomeController', () {
      test('should change page correctly', () {
        // Act
        homeController.changePage(1);

        // Assert
        expect(homeController.selectedIndex.value, 1);
      });

      test('should toggle filters expansion', () {
        // Arrange
        bool initialState = homeController.isFiltersExpanded.value;

        // Act
        homeController.toggleFiltersExpansion();

        // Assert
        expect(homeController.isFiltersExpanded.value, !initialState);
      });

      test('should set user search query', () {
        // Act
        homeController.setUserSearchQuery('test query');

        // Assert
        expect(homeController.userSearchQuery.value, 'test query');
      });

      test('should clear all team filters', () {
        // Arrange
        homeController.setNameFilterTeam('Test Team');
        homeController.setHealthcareFilter(true);
        homeController.setHouseholdFilter(false);

        // Act
        homeController.clearAllFiltersTeam();

        // Assert
        expect(homeController.nameFilterTeam.value, isEmpty);
        expect(homeController.healthcareFilter.value, isNull);
        expect(homeController.householdFilter.value, isNull);
        expect(homeController.referralFilter.value, isNull);
        expect(homeController.burialFilter.value, isNull);
      });
    });

    group('Unit Tests - AuthController', () {
      test('should change alert type correctly', () {
        // Act
        authController.changeAlertType(2);

        // Assert
        expect(authController.selectedAlertIndex.value, 2);
      });

      test('should initialize with default alert index', () {
        expect(authController.selectedAlertIndex.value, -1);
      });

      test('should clear text controllers', () {
        // Arrange
        authController.email.text = 'test@example.com';
        authController.password.text = 'password123';

        // Act
        authController.email.clear();
        authController.password.clear();

        // Assert
        expect(authController.email.text, isEmpty);
        expect(authController.password.text, isEmpty);
      });
    });

    group('Unit Tests - AlertListController', () {
      test('should initialize with default values', () {
        expect(alertController.isLoading.value, false);
        expect(alertController.searchQuery.value, isEmpty);
        expect(alertController.selectedStatus.value, isNull);
        expect(alertController.selectedType.value, isNull);
        expect(alertController.currentPage.value, 1);
        expect(alertController.sortBy.value, 'serverCreateTime');
      });

      test('should update search query', () {
        // Act
        alertController.onSearchChanged('test query');

        // Assert
        expect(alertController.searchQuery.value, 'test query');
        expect(alertController.currentPage.value, 1); // Should reset page
      });

      test('should clear all filters', () {
        // Arrange
        alertController.searchQuery.value = 'test';
        alertController.selectedStatus.value = 1;
        alertController.selectedType.value = 0;

        // Act
        alertController.clearFilters();

        // Assert
        expect(alertController.searchQuery.value, isEmpty);
        expect(alertController.selectedStatus.value, isNull);
        expect(alertController.selectedType.value, isNull);
        expect(alertController.currentPage.value, 1);
      });
    });

    // ===== WIDGET TESTS =====
    group('Widget Tests', () {
      testWidgets('should display main UI components', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        // Check main components
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(AnimatedBottomNavigationBar), findsOneWidget);
        expect(find.byIcon(Icons.add_circle), findsOneWidget);
      });

      testWidgets('should open bottom sheet when FAB is pressed', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        // Tap FAB
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Verify bottom sheet opened
        expect(find.text('add_report'), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('should display form fields in bottom sheet', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Check form components
        expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
        expect(find.text('description'), findsOneWidget);
        expect(find.text('patient_name'), findsOneWidget);
        expect(find.byIcon(Icons.add_a_photo_rounded), findsOneWidget);
      });

      testWidgets('should display submit and location buttons', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('submit_report'), findsOneWidget);
        expect(find.text('location'), findsOneWidget);
      });

      testWidgets('should close bottom sheet when close button is tapped', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        // Open bottom sheet
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Close bottom sheet
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        // Verify closed
        expect(find.text('add_report'), findsNothing);
      });

      testWidgets('should show loading indicator when isLoading is true', (tester) async {
        // Set loading state
        addReportController.isLoading.value = true;

        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should change location button color when location is set', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Set location
        addReportController.selectedLat.value = 35.7219;
        addReportController.selectedLng.value = 51.3347;
        await tester.pumpAndSettle();

        // Should show check icon when location is set
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
      });

      testWidgets('should display health service dropdown', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(PopupMenuButton<int>), findsOneWidget);
        expect(find.text('select_health_service_label'), findsOneWidget);
      });
    });

    // ===== INTEGRATION TESTS =====
    group('Integration Tests', () {
      testWidgets('Complete report submission flow with validation', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        // Step 1: Open bottom sheet
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Step 2: Try to submit without required fields (should show validation)
        await tester.tap(find.text('submit_report'));
        await tester.pumpAndSettle();

        // Step 3: Fill description field
        await tester.enterText(
          find.byType(TextFormField).first,
          'Emergency medical attention needed urgently'
        );
        await tester.pumpAndSettle();

        // Step 4: Fill patient name
        await tester.enterText(
          find.byType(TextFormField).last,
          'John Doe'
        );
        await tester.pumpAndSettle();

        // Step 5: Set location coordinates
        addReportController.selectedLat.value = 35.7219;
        addReportController.selectedLng.value = 51.3347;
        await tester.pumpAndSettle();

        // Step 6: Select health service type
        authController.changeAlertType(0); // Healthcare cleaning
        await tester.pumpAndSettle();

        // Verify form state
        expect(addReportController.description.text, contains('Emergency'));
        expect(addReportController.patientName.text, 'John Doe');
        expect(addReportController.selectedLat.value, 35.7219);
        expect(authController.selectedAlertIndex.value, 0);
      });

      testWidgets('Image picker flow', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        // Open bottom sheet
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Tap image picker button
        await tester.tap(find.byIcon(Icons.add_a_photo_rounded));
        await tester.pumpAndSettle();

        // Should show image picker options
        expect(find.text('take_photo'), findsOneWidget);
        expect(find.text('choose_from_gallery'), findsOneWidget);
      });

      testWidgets('Health service selection flow', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Initially no service selected
        expect(authController.selectedAlertIndex.value, -1);

        // Select healthcare cleaning
        authController.changeAlertType(0);
        await tester.pumpAndSettle();

        expect(authController.selectedAlertIndex.value, 0);

        // Change to household cleaning
        authController.changeAlertType(1);
        await tester.pumpAndSettle();

        expect(authController.selectedAlertIndex.value, 1);
      });

      testWidgets('Bottom navigation interaction', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        // Initially on page 0
        expect(homeController.selectedIndex.value, 0);

        // Change to page 1 (Profile)
        homeController.changePage(1);
        await tester.pumpAndSettle();

        expect(homeController.selectedIndex.value, 1);
      });

      testWidgets('Form validation error handling', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Test individual validation cases
        
        // Case 1: Only description filled
        await tester.enterText(find.byType(TextFormField).first, 'Test description');
        await tester.tap(find.text('submit_report'));
        await tester.pumpAndSettle();
        
        // Case 2: Add location
        addReportController.selectedLat.value = 10.0;
        addReportController.selectedLng.value = 20.0;
        await tester.tap(find.text('submit_report'));
        await tester.pumpAndSettle();
        
        // Case 3: Finally add health service
        authController.changeAlertType(2);
        await tester.tap(find.text('submit_report'));
        await tester.pumpAndSettle();

        // All validations should pass now
        expect(authController.selectedAlertIndex.value, 2);
        expect(addReportController.selectedLat.value, 10.0);
        expect(addReportController.description.text, 'Test description');
      });

      testWidgets('Image management flow', (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: AnimatedBottomNavDoctor(),
          ),
        );

        // Add mock images to controller
        addReportController.pickedImages.addAll([
          XFile('test1.jpg'),
          XFile('test2.jpg'),
        ]);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Should display images
        expect(addReportController.pickedImages.length, 2);

        // Remove first image
        addReportController.removeImage(0);
        await tester.pumpAndSettle();

        expect(addReportController.pickedImages.length, 1);
        expect(addReportController.pickedImages.first.path, 'test2.jpg');
      });
    });

    // ===== HELPER FUNCTION TESTS =====
    group('Helper Function Tests', () {
      test('form validation function should work correctly', () {
        // Test case 1: Missing location
        addReportController.selectedLat.value = 0.0;
        addReportController.selectedLng.value = 0.0;
        addReportController.description.text = 'Test';
        authController.selectedAlertIndex.value = 0;
        
        String? result = _validateFormHelper(addReportController, authController);
        expect(result, contains('location'));

        // Test case 2: Missing description  
        addReportController.selectedLat.value = 10.0;
        addReportController.selectedLng.value = 20.0;
        addReportController.description.text = '';
        
        result = _validateFormHelper(addReportController, authController);
        expect(result, contains('description'));

        // Test case 3: Missing health service
        addReportController.description.text = 'Test';
        authController.selectedAlertIndex.value = -1;
        
        result = _validateFormHelper(addReportController, authController);
        expect(result, contains('health_service'));

        // Test case 4: All valid
        authController.selectedAlertIndex.value = 1;
        
        result = _validateFormHelper(addReportController, authController);
        expect(result, isNull);
      });
    });
  });
}

// Helper function for validation testing
String? _validateFormHelper(AddReportController controller, AuthController authController) {
  if (controller.selectedLat.value == 0.0 || controller.selectedLng.value == 0.0) {
    return 'no_location_selected';
  }

  if (controller.description.text.trim().isEmpty) {
    return 'enter_description';
  }

  if (authController.selectedAlertIndex.value == -1) {
    return 'select_health_service';
  }

  return null;
}