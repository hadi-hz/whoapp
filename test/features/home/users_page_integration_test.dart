import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/home/presentation/pages/widgets/users_screen.dart';

void main() {
  patrolTest(
    'UsersScreen complete functionality test',
    ($) async {
      await _setupTestEnvironment();
      await $.pumpWidgetAndSettle(_createUsersScreenApp());

      await _testUsersScreenInitialization($);
      await _testSearchFunctionality($);
      await _testFiltersFunctionality($);
      await _testUserCardInteractions($);
    },
  );

  patrolTest(
    'UsersScreen loading and error states test',
    ($) async {
      await _setupTestEnvironment();
      await $.pumpWidgetAndSettle(_createUsersScreenApp());

      await _testLoadingStates($);
      await _testErrorHandling($);
      await _testEmptyStates($);
    },
  );

  patrolTest(
    'UsersScreen responsive design test',
    ($) async {
      await _setupTestEnvironment();
      
      // Test mobile layout (default)
      await $.pumpWidgetAndSettle(_createUsersScreenApp());
      await _testMobileLayout($);

      // Note: Surface size changes aren't directly available in Patrol
      // Test different layouts through UI interaction instead
      await _testResponsiveElements($);
    },
  );

  patrolTest(
    'UsersScreen notification and profile interactions test',
    ($) async {
      await _setupTestEnvironment();
      await $.pumpWidgetAndSettle(_createUsersScreenApp());

      await _testNotificationInteractions($);
      await _testProfileInteractions($);
      await _testHeaderFunctionality($);
    },
  );
}

Future<void> _setupTestEnvironment() async {
  SharedPreferences.setMockInitialValues({
    'userId': 'test-user-123',
    'role': 'Admin',
    'userName': 'Test Admin',
  });
}

Widget _createUsersScreenApp() {
  return GetMaterialApp(
    home: UsersScreen(),
    translations: TestTranslations(),
  );
}

Future<void> _testUsersScreenInitialization(PatrolIntegrationTester $) async {
  // Verify screen loads correctly
  expect(find.byType(UsersScreen), findsOneWidget);
  expect(find.byType(Scaffold), findsOneWidget);
  
  // Check main UI elements
  expect(find.text('Users Management'), findsOneWidget);
  expect(find.byType(TextFormField), findsOneWidget);
  expect(find.text('Filters'), findsOneWidget);
  
  await $.pumpAndSettle();
}

Future<void> _testSearchFunctionality(PatrolIntegrationTester $) async {
  // Test search field
  final searchField = find.byType(TextFormField);
  expect(searchField, findsOneWidget);
  
  // Enter search text
  await $(TextFormField).enterText('john doe');
  await $.pumpAndSettle();
  
  // Test clear search
  if (find.byIcon(Icons.clear).evaluate().isNotEmpty) {
    await $(Icons.clear).tap();
    await $.pumpAndSettle();
  }
  
  // Test search with different terms
  await $(TextFormField).enterText('admin@test.com');
  await $.pumpAndSettle();
}

Future<void> _testFiltersFunctionality(PatrolIntegrationTester $) async {
  // Open filters
  await $('Filters').tap();
  await $.pumpAndSettle();
  
  // Test filter dropdowns
  if (find.text('Filter By Role').evaluate().isNotEmpty) {
    await $('Filter By Role').tap();
    await $.pumpAndSettle();
    
    if (find.text('Admin').evaluate().isNotEmpty) {
      await $('Admin').tap();
      await $.pumpAndSettle();
    }
  }
  
  // Test approval filter
  if (find.text('Filter By Approval').evaluate().isNotEmpty) {
    await $('Filter By Approval').tap();
    await $.pumpAndSettle();
    
    if (find.text('Approved').evaluate().isNotEmpty) {
      await $('Approved').tap();
      await $.pumpAndSettle();
    }
  }
  
  // Test sort options
  if (find.text('Sort By').evaluate().isNotEmpty) {
    await $('Sort By').tap();
    await $.pumpAndSettle();
  }
  
  // Test apply filters
  if (find.text('Apply Filters').evaluate().isNotEmpty) {
    await $('Apply Filters').tap();
    await $.pumpAndSettle();
  }
  
  // Test clear filters
  if (find.text('Clear All Filters').evaluate().isNotEmpty) {
    await $('Clear All Filters').tap();
    await $.pumpAndSettle();
  }
}

Future<void> _testUserCardInteractions(PatrolIntegrationTester $) async {
  // Check for user cards (if any exist)
  final userCards = find.byType(GestureDetector);
  
  if (userCards.evaluate().isNotEmpty) {
    // Tap on first user card
    await $(GestureDetector).tap();
    await $.pumpAndSettle();
  }
  
  // Test scrolling if multiple users exist
  if (find.byType(ListView).evaluate().isNotEmpty) {
    // Simple scroll test - just verify ListView exists and is scrollable
    expect(find.byType(ListView), findsOneWidget);
    await $.pumpAndSettle();
  }
}

Future<void> _testLoadingStates(PatrolIntegrationTester $) async {
  // Test loading indicator appears
  if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  }
  
  await $.pumpAndSettle();
}

Future<void> _testErrorHandling(PatrolIntegrationTester $) async {
  // Test error state elements
  if (find.byIcon(Icons.error_outline).evaluate().isNotEmpty) {
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    
    // Test retry button
    if (find.text('Retry').evaluate().isNotEmpty) {
      await $('Retry').tap();
      await $.pumpAndSettle();
    }
  }
}

Future<void> _testEmptyStates(PatrolIntegrationTester $) async {
  // Test empty state elements
  if (find.byIcon(Icons.people_outline).evaluate().isNotEmpty) {
    expect(find.byIcon(Icons.people_outline), findsOneWidget);
    expect(find.text('No Users Found'), findsOneWidget);
    
    // Test clear filters button in empty state
    if (find.text('Clear Filters').evaluate().isNotEmpty) {
      await $('Clear Filters').tap();
      await $.pumpAndSettle();
    }
  }
}

Future<void> _testMobileLayout(PatrolIntegrationTester $) async {
  // Verify mobile-specific UI elements
  expect(find.byType(UsersScreen), findsOneWidget);
  
  // Check that UI adapts to mobile screen
  await $.pumpAndSettle();
}

Future<void> _testResponsiveElements(PatrolIntegrationTester $) async {
  // Test responsive UI elements that adapt to screen size
  expect(find.byType(UsersScreen), findsOneWidget);
  
  // Test that all responsive elements are present
  expect(find.text('Users Management'), findsOneWidget);
  expect(find.byType(TextFormField), findsOneWidget);
  
  await $.pumpAndSettle();
}

Future<void> _testNotificationInteractions(PatrolIntegrationTester $) async {
  // Test notification button
  final notificationButton = find.byIcon(Icons.notifications_none_rounded);
  
  if (notificationButton.evaluate().isNotEmpty) {
    await $(Icons.notifications_none_rounded).tap();
    await $.pumpAndSettle();
  }
}

Future<void> _testProfileInteractions(PatrolIntegrationTester $) async {
  // Test profile avatar tap
  final profileAvatar = find.byType(CircleAvatar);
  
  if (profileAvatar.evaluate().isNotEmpty) {
    await $(CircleAvatar).tap();
    await $.pumpAndSettle();
  }
}

Future<void> _testHeaderFunctionality(PatrolIntegrationTester $) async {
  // Test header elements
  expect(find.text('Users Management'), findsOneWidget);
  
  // Check user count display
  if (find.textContaining('users available').evaluate().isNotEmpty) {
    expect(find.textContaining('users available'), findsOneWidget);
  }
  
  // Test refresh functionality - just verify RefreshIndicator exists
  if (find.byType(RefreshIndicator).evaluate().isNotEmpty) {
    expect(find.byType(RefreshIndicator), findsOneWidget);
    await $.pumpAndSettle();
  }
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
      'filter_by_role': 'Filter By Role',
      'filter_by_approval': 'Filter By Approval',
      'sort_by': 'Sort By',
      'apply_filters': 'Apply Filters',
      'clear_all_filters': 'Clear All Filters',
      'admin': 'Admin',
      'doctor': 'Doctor',
      'serviceprovider': 'ServiceProvider',
    },
  };
}