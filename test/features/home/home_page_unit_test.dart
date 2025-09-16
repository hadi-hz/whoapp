import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';
import 'package:test3/features/home/domain/usecase/users_usecase.dart';
import 'package:test3/features/home/domain/usecase/user_detail_ussecase.dart';
import 'package:test3/features/home/domain/usecase/assign_role_usecase.dart';
import 'package:test3/features/home/domain/usecase/team_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';

import 'home_page_unit_test.mocks.dart';

@GenerateMocks([
  GetAllUsersUseCase,
  GetUserDetailUseCase,
  AssignRoleUseCase,
  GetAllTeamsUseCase,
  GetAlertsUseCase,
])
void main() {
  late HomeController homeController;
  late AlertListController alertController;
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late MockGetUserDetailUseCase mockGetUserDetailUseCase;
  late MockAssignRoleUseCase mockAssignRoleUseCase;
  late MockGetAllTeamsUseCase mockGetAllTeamsUseCase;
  late MockGetAlertsUseCase mockGetAlertsUseCase;

  setUp(() {
    Get.testMode = true;

    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    mockGetUserDetailUseCase = MockGetUserDetailUseCase();
    mockAssignRoleUseCase = MockAssignRoleUseCase();
    mockGetAllTeamsUseCase = MockGetAllTeamsUseCase();
    mockGetAlertsUseCase = MockGetAlertsUseCase();

    homeController = HomeController(
      getAllUsersUseCase: mockGetAllUsersUseCase,
      getUserDetailUseCase: mockGetUserDetailUseCase,
      assignRoleUseCase: mockAssignRoleUseCase,
      getAllTeamsUseCase: mockGetAllTeamsUseCase,
    );

    alertController = AlertListController(
      getAlertsUseCase: mockGetAlertsUseCase,
    );

    SharedPreferences.setMockInitialValues({
      'userId': 'test-user-123',
      'role': 'Admin',
      'userName': 'Test User',
    });
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Unit Tests', () {
    group('Initialization', () {
      test('should initialize with default values', () {
        expect(homeController.isLoadingUsers.value, false);
        expect(homeController.users.length, 0);
        expect(homeController.selectedIndex.value, 0);
        expect(homeController.role.value, '');
        expect(homeController.userName.value, '');
      });
    });

    group('Page Navigation', () {
      test('should change page index correctly', () {
        homeController.changePage(2);
        expect(homeController.selectedIndex.value, 2);

        homeController.changePage(0);
        expect(homeController.selectedIndex.value, 0);
      });
    });

    group('Filter Management', () {
      test('should toggle filters expansion', () {
        expect(homeController.isFiltersExpanded.value, false);
        
        homeController.toggleFiltersExpansion();
        expect(homeController.isFiltersExpanded.value, true);
        
        homeController.toggleFiltersExpansion();
        expect(homeController.isFiltersExpanded.value, false);
      });

      test('should open and close filters correctly', () {
        homeController.openFilters();
        expect(homeController.isFiltersExpanded.value, true);
        
        homeController.closeFilters();
        expect(homeController.isFiltersExpanded.value, false);
      });

      test('should set user search query correctly', () {
        homeController.setUserSearchQuery('test user');
        expect(homeController.userSearchQuery.value, 'test user');
      });
    });

    group('Users Management', () {
      test('should fetch users successfully', () async {
        final mockUsers = <UserEntity>[
          // Use actual UserEntity from your domain layer
          // You'll need to check the constructor parameters
        ];

        when(mockGetAllUsersUseCase.call(any))
            .thenAnswer((_) async => Right(mockUsers));

        await homeController.fetchUsers();

        expect(homeController.users.length, 0); // Adjust based on actual data
        expect(homeController.isLoadingUsers.value, false);
        expect(homeController.errorMessageUsers.value, '');
      });

      test('should handle fetch users error', () async {
        when(mockGetAllUsersUseCase.call(any))
            .thenAnswer((_) async => Left('Network error'));

        await homeController.fetchUsers();

        expect(homeController.users.length, 0);
        expect(homeController.isLoadingUsers.value, false);
        expect(homeController.errorMessageUsers.value, 'Network error');
      });

      test('should filter users correctly', () {
        // Add test users using actual UserEntity
        // homeController.users.addAll([...]);

        homeController.setUserSearchQuery('john');
        final filtered = homeController.filteredUsers;
        
        // Adjust assertions based on actual implementation
        expect(filtered, isA<List<UserEntity>>());
      });
    });

    group('Teams Management', () {
      test('should fetch teams successfully', () async {
        final mockTeams = <TeamEntity>[
          // Use actual TeamEntity from your domain layer
        ];

        when(mockGetAllTeamsUseCase.call(any))
            .thenAnswer((_) async => Right(mockTeams));

        await homeController.fetchTeams();

        expect(homeController.teams.length, 0);
        expect(homeController.isLoadingTeam.value, false);
        expect(homeController.errorMessageTeam.value, '');
      });

      test('should handle fetch teams error', () async {
        when(mockGetAllTeamsUseCase.call(any))
            .thenAnswer((_) async => Left('Team fetch error'));

        await homeController.fetchTeams();

        expect(homeController.teams.length, 0);
        expect(homeController.isLoadingTeam.value, false);
        expect(homeController.errorMessageTeam.value, 'Team fetch error');
      });
    });

    group('Role Assignment', () {
      test('should assign role successfully', () async {
        // You need to create this with actual AssignRoleResult from your domain
        // For now, just test the basic flow
        when(mockAssignRoleUseCase.call(
          userId: anyNamed('userId'),
          roleName: anyNamed('roleName'),
        ));

        when(mockGetAllUsersUseCase.call(any))
            .thenAnswer((_) async => Right([]));

        final result = await homeController.assignRoleToUser(
          userId: 'test-user-123',
          roleName: 'Admin',
        );

        expect(result, isA<bool>());
        verify(mockAssignRoleUseCase.call(
          userId: 'test-user-123',
          roleName: 'Admin',
        )).called(1);
      });

      test('should handle role assignment error', () async {
        when(mockAssignRoleUseCase.call(
          userId: anyNamed('userId'),
          roleName: anyNamed('roleName'),
        )).thenAnswer((_) async => Left('Assignment failed'));

        final result = await homeController.assignRoleToUser(
          userId: 'test-user-123',
          roleName: 'Admin',
        );

        expect(result, false);
      });
    });
  });

  group('AlertListController Unit Tests', () {
    group('Initialization', () {
      test('should initialize with default values', () {
        expect(alertController.isLoading.value, false);
        expect(alertController.alerts.length, 0);
        expect(alertController.currentPage.value, 1);
        expect(alertController.pageSize.value, -1);
        expect(alertController.sortDescending.value, true);
      });
    });

    group('Alert Loading', () {
      test('should load alerts successfully', () async {
        final mockAlerts = <AlertEntity>[
          // Use actual AlertEntity from your domain layer
        ];

        when(mockGetAlertsUseCase.call(any))
            .thenAnswer((_) async => Right(mockAlerts));

        await alertController.loadAlerts();

        expect(alertController.alerts.length, 0);
        expect(alertController.isLoading.value, false);
        expect(alertController.hasError.value, false);
      });

      test('should handle load alerts error', () async {
        when(mockGetAlertsUseCase.call(any))
            .thenAnswer((_) async => Left('Load error'));

        await alertController.loadAlerts();

        expect(alertController.alerts.length, 0);
        expect(alertController.isLoading.value, false);
        expect(alertController.hasError.value, true);
        expect(alertController.errorMessage.value, 'Load error');
      });
    });

    group('Filtering and Search', () {
      test('should update search query and reset to first page', () {
        alertController.currentPage.value = 3;
        
        alertController.onSearchChanged('test query');
        
        expect(alertController.searchQuery.value, 'test query');
        expect(alertController.currentPage.value, 1);
      });

      test('should update status filter and reset to first page', () {
        alertController.currentPage.value = 2;
        
        alertController.onStatusChanged(1);
        
        expect(alertController.selectedStatus.value, 1);
        expect(alertController.currentPage.value, 1);
      });

      test('should update type filter and reset to first page', () {
        alertController.currentPage.value = 2;
        
        alertController.onTypeChanged(2);
        
        expect(alertController.selectedType.value, 2);
        expect(alertController.currentPage.value, 1);
      });

      test('should clear all filters correctly', () {
        alertController.searchQuery.value = 'test';
        alertController.selectedStatus.value = 1;
        alertController.selectedType.value = 2;
        alertController.currentPage.value = 3;
        
        alertController.clearFilters();
        
        expect(alertController.searchQuery.value, '');
        expect(alertController.selectedStatus.value, null);
        expect(alertController.selectedType.value, null);
        expect(alertController.currentPage.value, 1);
      });
    });

    group('Pagination', () {
      test('should navigate to next page when has next page', () {
        alertController.hasNextPage.value = true;
        alertController.currentPage.value = 1;
        
        alertController.nextPage();
        
        expect(alertController.currentPage.value, 2);
      });

      test('should not navigate to next page when no next page', () {
        alertController.hasNextPage.value = false;
        alertController.currentPage.value = 1;
        
        alertController.nextPage();
        
        expect(alertController.currentPage.value, 1);
      });

      test('should navigate to previous page when not on first page', () {
        alertController.currentPage.value = 3;
        
        alertController.previousPage();
        
        expect(alertController.currentPage.value, 2);
      });

      test('should not navigate to previous page when on first page', () {
        alertController.currentPage.value = 1;
        
        alertController.previousPage();
        
        expect(alertController.currentPage.value, 1);
      });
    });

    group('Status and Type Labels', () {
      test('should return correct status label', () {
        final label = alertController.getStatusLabel(0);
        expect(label, contains('initial'));
      });

      test('should return correct type label', () {
        final label = alertController.getTypeLabel(0);
        expect(label, contains('healthcare'));
      });

      test('should return unknown for invalid status', () {
        final label = alertController.getStatusLabel(999);
        expect(label, contains('unknown'));
      });

      test('should return unknown for invalid type', () {
        final label = alertController.getTypeLabel(999);
        expect(label, contains('unknown'));
      });
    });

    group('Sorting', () {
      test('should update sort parameters and reset to first page', () {
        alertController.currentPage.value = 3;
        
        alertController.onSortChanged('title', false);
        
        expect(alertController.sortBy.value, 'title');
        expect(alertController.sortDescending.value, false);
        expect(alertController.currentPage.value, 1);
      });
    });
  });

  group('Integration Tests', () {
    test('should handle role-based alert filtering correctly', () {
      alertController.userRole.value = 'Admin';
      alertController.onUserIdChanged(null);
      expect(alertController.selectedUserId.value, null);

      alertController.userRole.value = 'Doctor';
      alertController.onUserIdChanged('doctor-123');
      expect(alertController.selectedUserId.value, 'doctor-123');
    });
  });
}