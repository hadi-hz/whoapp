import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/auth/domain/entities/login.dart';
import 'package:test3/features/home/presentation/pages/widgets/users_screen.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';

import 'users_page_widget_test.mocks.dart';

@GenerateMocks([HomeController, AuthController])
void main() {
  late MockHomeController mockHomeController;
  late MockAuthController mockAuthController;

  setUp(() {
    mockHomeController = MockHomeController();
    mockAuthController = MockAuthController();

    // Setup default mocks
    when(mockHomeController.isLoadingUsers).thenReturn(false.obs);
    when(mockHomeController.users).thenReturn(<UserEntity>[].obs);
    when(mockHomeController.errorMessageUsers).thenReturn(''.obs);
    when(mockHomeController.nameFilter).thenReturn(''.obs);
    when(mockHomeController.emailFilter).thenReturn(''.obs);
    when(mockHomeController.roleFilter).thenReturn(''.obs);
    when(mockHomeController.isApprovedFilter).thenReturn(Rxn<bool>());
    when(mockHomeController.isFiltersExpanded).thenReturn(false.obs);
    when(mockHomeController.sortBy).thenReturn('Email'.obs);
    when(mockHomeController.sortDesc).thenReturn(true.obs);
    when(mockHomeController.isNotificationSelected).thenReturn(false.obs);
    when(mockHomeController.isProfileSelected).thenReturn(true.obs);
    when(mockHomeController.roleOptions).thenReturn(['Admin', 'Doctor', 'ServiceProvider']);
    when(mockHomeController.sortOptions).thenReturn(['Email', 'Lastname']);
    when(mockAuthController.currentLoginUser).thenReturn(Rxn());

    Get.put<HomeController>(mockHomeController);
    Get.put<AuthController>(mockAuthController);

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
      home: UsersScreen(),
      translations: TestTranslations(),
    );
  }

  group('UsersScreen Widget Tests', () {
    testWidgets('should render users screen correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(UsersScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Users Management'), findsOneWidget);
    });

    testWidgets('should show search field with correct hint text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Search By Name Or Email'), findsOneWidget);
    });

    testWidgets('should show filters header', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Filters'), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });

    testWidgets('should expand filters when filter header is tapped', (tester) async {
      when(mockHomeController.isFiltersExpanded).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();

      verify(mockHomeController.toggleFiltersExpansion()).called(1);
    });

    testWidgets('should show loading indicator when loading users', (tester) async {
      when(mockHomeController.isLoadingUsers).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when there is an error', (tester) async {
      when(mockHomeController.errorMessageUsers).thenReturn('Network error'.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should show no users message when users list is empty', (tester) async {
      when(mockHomeController.users).thenReturn(<UserEntity>[].obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      expect(find.text('No Users Found'), findsOneWidget);
    });

    testWidgets('should show clear filters button when filters are applied', (tester) async {
      when(mockHomeController.users).thenReturn(<UserEntity>[].obs);
      when(mockHomeController.nameFilter).thenReturn('test'.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Clear Filters'), findsOneWidget);
    });

    testWidgets('should display user cards when users exist', (tester) async {
      final mockUsers = [
        UserEntity(
          id: '1',
          fullName: 'John Doe',
          email: 'john@test.com',
          isApproved: true,
          roles: ['Admin'],
          profileImageUrl: '',
          isEmailConfirmed: true

        ),
        UserEntity(
          id: '2',
          fullName: 'Jane Smith',
          email: 'jane@test.com',
          isApproved: false,
          roles: ['Doctor'],
          profileImageUrl: '',
          isEmailConfirmed: true
        ),
      ];
      
      when(mockHomeController.users).thenReturn(mockUsers.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@test.com'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(find.text('jane@test.com'), findsOneWidget);
    });

    testWidgets('should show approved/pending status correctly', (tester) async {
      final mockUsers = [
        UserEntity(
          id: '1',
          fullName: 'Approved User',
          email: 'approved@test.com',
          isApproved: true,
          roles: ['Admin'],
          profileImageUrl: '',
          isEmailConfirmed: true

        ),
        UserEntity(
          id: '2',
          fullName: 'Pending User',
          email: 'pending@test.com',
          isApproved: false,
          roles: ['Doctor'],
          profileImageUrl: '',
          isEmailConfirmed: true

        ),
      ];
      
      when(mockHomeController.users).thenReturn(mockUsers.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('should show role badges correctly', (tester) async {
      final mockUsers = [
        UserEntity(
          id: '1',
          fullName: 'Admin User',
          email: 'admin@test.com',
          isApproved: true,
          roles: ['Admin'],
          profileImageUrl: '',
          isEmailConfirmed: true

        ),
      ];
      
      when(mockHomeController.users).thenReturn(mockUsers.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('should call fetchUsers on refresh', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      verify(mockHomeController.fetchUsers()).called(1);
    });

    testWidgets('should update search filter when search field changes', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField), 'test search');
      
      verify(mockHomeController.setNameFilter('test search')).called(1);
    });

    testWidgets('should clear search when clear button is tapped', (tester) async {
      when(mockHomeController.nameFilter).thenReturn('test'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.clear));
      
      verify(mockHomeController.setNameFilter('')).called(1);
    });

    testWidgets('should show retry button when there is an error', (tester) async {
      when(mockHomeController.errorMessageUsers).thenReturn('Network error'.obs);

      await tester.pumpWidget(createTestWidget());

      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      verify(mockHomeController.fetchUsers()).called(1);
    });

    testWidgets('should show user count in header', (tester) async {
      final mockUsers = [
        UserEntity(
          id: '1',
          fullName: 'User 1',
          email: 'user1@test.com',
          isApproved: true,
          roles: ['Admin'],
          profileImageUrl: '',
          isEmailConfirmed: true

        ),
        UserEntity(
          id: '2',
          fullName: 'User 2',
          email: 'user2@test.com',
          isApproved: false,
          roles: ['Doctor'],
          profileImageUrl: '',
          isEmailConfirmed: true

        ),
      ];
      
      when(mockHomeController.users).thenReturn(mockUsers.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.textContaining('2'), findsOneWidget);
      expect(find.textContaining('users available'), findsOneWidget);
    });

    testWidgets('should show notification badge when there are unread messages', (tester) async {
      final mockLoginUser = MockLoginUser();
      when(mockLoginUser.unReadMessagesCount).thenReturn(5);
      when(mockAuthController.currentLoginUser).thenReturn(mockLoginUser.obs as Rxn<LoginEntity>);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should handle tablet layout correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(UsersScreen), findsOneWidget);
      
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show active filters count', (tester) async {
      when(mockHomeController.nameFilter).thenReturn('test'.obs);
      when(mockHomeController.roleFilter).thenReturn('Admin'.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('2'), findsOneWidget); // Active filters count
    });
  });

  group('Filter Tests', () {
    testWidgets('should show filter content when expanded', (tester) async {
      when(mockHomeController.isFiltersExpanded).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Filter By Role'), findsOneWidget);
      expect(find.text('Filter By Approval'), findsOneWidget);
      expect(find.text('Sort By'), findsOneWidget);
      expect(find.text('Apply Filters'), findsOneWidget);
      expect(find.text('Clear All Filters'), findsOneWidget);
    });

    testWidgets('should call apply filters when apply button is tapped', (tester) async {
      when(mockHomeController.isFiltersExpanded).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Apply Filters'));
      
      verify(mockHomeController.applyFiltersUsers()).called(1);
    });

    testWidgets('should call clear filters when clear button is tapped', (tester) async {
      when(mockHomeController.isFiltersExpanded).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Clear All Filters'));
      
      verify(mockHomeController.clearAllFilters()).called(1);
    });
  });
}

class TestTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'users_management': 'Users Management',
      'users_available': 'users available',
      'search_by_name_or_email': 'Search By Name Or Email',
      'filters': 'Filters',
      'no_users_found': 'No Users Found',
      'clear_filters': 'Clear Filters',
      'retry': 'Retry',
      'approved': 'Approved',
      'pending': 'Pending',
      'no_name': 'No Name',
      'filter_by_role': 'Filter By Role',
      'filter_by_approval': 'Filter By Approval',
      'sort_by': 'Sort By',
      'sort_order': 'Sort Order',
      'descending': 'Descending',
      'apply_filters': 'Apply Filters',
      'clear_all_filters': 'Clear All Filters',
      'all_roles': 'All Roles',
      'all_statuses': 'All Statuses',
      'email': 'Email',
      'lastname': 'Last Name',
    },
  };
}

class MockLoginUser {
  int unReadMessagesCount = 0;
}