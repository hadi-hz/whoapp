import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:patrol/patrol.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/auth/domain/entities/login.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';
import 'package:test3/features/home/presentation/controller/create_team_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/teams_screen.dart';

@GenerateMocks([HomeController, AuthController, CreateTeamController])
import 'teams_page_patrol_test.mocks.dart';

void main() {
  group('TeamsScreen Patrol Tests', () {
    late MockHomeController mockHomeController;
    late MockAuthController mockAuthController;
    late MockCreateTeamController mockCreateTeamController;

    // Helper methods defined before usage
    void setupDefaultMocks() {
      when(mockHomeController.isLoadingTeam).thenReturn(false.obs);
      when(mockHomeController.filteredTeams).thenReturn(<TeamEntity>[].obs);
      when(mockHomeController.teams).thenReturn(<TeamEntity>[].obs);
      when(mockHomeController.errorMessageTeam).thenReturn(''.obs);
      when(mockHomeController.nameFilterTeam).thenReturn(''.obs);
      when(mockHomeController.healthcareFilter).thenReturn(Rxn<bool>(null));
      when(mockHomeController.householdFilter).thenReturn(Rxn<bool>(null));
      when(mockHomeController.referralFilter).thenReturn(Rxn<bool>(null));
      when(mockHomeController.burialFilter).thenReturn(Rxn<bool>(null));
      when(mockHomeController.isFiltersExpandedTeam).thenReturn(false.obs);
      when(mockHomeController.totalTeams).thenReturn(0);
      when(mockHomeController.isNotificationSelected).thenReturn(false.obs);
      when(mockHomeController.isProfileSelected).thenReturn(true.obs);
      when(mockHomeController.userSearchQuery).thenReturn(''.obs);
      when(mockHomeController.isLoadingUsers).thenReturn(false.obs);
      when(mockHomeController.users).thenReturn(<UserEntity>[].obs);

      when(
        mockAuthController.currentLoginUser,
      ).thenReturn(Rxn<LoginEntity>(null));

      when(mockCreateTeamController.selectedRepresentative).thenReturn(''.obs);
      when(
        mockCreateTeamController.descriptionController,
      ).thenReturn(TextEditingController());
      when(
        mockCreateTeamController.nameController,
      ).thenReturn(TextEditingController());
      when(
        mockCreateTeamController.searchController,
      ).thenReturn(TextEditingController());
      when(mockCreateTeamController.isBurial).thenReturn(false.obs);
      when(mockCreateTeamController.isHealthcare).thenReturn(false.obs);
      when(mockCreateTeamController.isHousehold).thenReturn(false.obs);
      when(mockCreateTeamController.isReferral).thenReturn(false.obs);
      when(mockCreateTeamController.selectedMembers).thenReturn(<String>[].obs);
      when(mockCreateTeamController.isLoading).thenReturn(false.obs);
      when(mockCreateTeamController.errorMessage).thenReturn(''.obs);
    }

    Widget createApp() {
      return GetMaterialApp(
        home: TeamsScreen(),
        translations: TestTranslations(),
      );
    }

    List<TeamEntity> createMockTeams() {
      return [
        TeamEntity(
          id: 'team-1',
          name: 'Healthcare Team',
          description: 'Healthcare specialists',
          memberCount: 5,
          isHealthcareCleaningAndDisinfection: true,
          isHouseholdCleaningAndDisinfection: false,
          isPatientsReferral: true,
          isSafeAndDignifiedBurial: false,
          isDelete: false,
          createTime: '2024-01-01T00:00:00Z',
        ),
        TeamEntity(
          id: 'team-2',
          name: 'Emergency Team',
          description: 'Emergency response team',
          memberCount: 3,
          isHealthcareCleaningAndDisinfection: false,
          isHouseholdCleaningAndDisinfection: true,
          isPatientsReferral: false,
          isSafeAndDignifiedBurial: true,
          isDelete: false,
          createTime: '2024-01-02T00:00:00Z',
        ),
      ];
    }

    List<UserEntity> createMockUsers() {
      return [
        UserEntity(
          id: 'user-1',
          fullName: 'John Doe',
          email: 'john@test.com',
          isApproved: true,
          roles: ['Doctor'],

          isEmailConfirmed: true,
          profileImageUrl: '',
        ),
        UserEntity(
          id: 'user-2',
          fullName: 'Jane Smith',
          email: 'jane@test.com',
          isApproved: true,
          roles: ['Admin'],

          isEmailConfirmed: true,
          profileImageUrl: '',
        ),
      ];
    }

    void setupTeamCreationMocks() {
      when(mockHomeController.isLoadingUsers).thenReturn(false.obs);
      when(mockHomeController.users).thenReturn(createMockUsers().obs);
      when(mockCreateTeamController.isLoading).thenReturn(false.obs);
    }

    setUp(() {
      mockHomeController = MockHomeController();
      mockAuthController = MockAuthController();
      mockCreateTeamController = MockCreateTeamController();

      Get.reset();
      Get.put<HomeController>(mockHomeController);
      Get.put<AuthController>(mockAuthController);
      Get.put<CreateTeamController>(mockCreateTeamController);

      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-123',
        'userName': 'Test User',
        'role': 'Admin',
      });

      setupDefaultMocks();
    });

    tearDown(() {
      Get.reset();
    });

    patrolTest('complete teams screen flow', ($) async {
      await $.pumpWidgetAndSettle(createApp());

      // Step 1: Verify initial screen load
      await $('Teams Management').waitUntilVisible();
      expect($('teams available'), findsOneWidget);

      // Step 2: Verify search functionality
      await $(TextFormField).enterText('Healthcare');
      verify(mockHomeController.setNameFilterTeam('Healthcare')).called(1);

      // Step 3: Test search clear
      when(mockHomeController.nameFilterTeam).thenReturn('Healthcare'.obs);
      await $.pump();
      await $(Icons.clear).tap();
      verify(mockHomeController.setNameFilterTeam('')).called(1);
    });

    patrolTest('team creation workflow', ($) async {
      setupTeamCreationMocks();

      await $.pumpWidgetAndSettle(createApp());

      // Step 1: Open create team bottom sheet
      await $(Icons.add).tap();
      await $.pump();

      // Step 2: Verify bottom sheet content
      await $('Create New Team').waitUntilVisible();
      expect($('Team Name'), findsOneWidget);
      expect($('Description'), findsOneWidget);

      // Step 3: Fill team information - use find by hint text
      final nameFields = find.byType(TextFormField);
      await $.tester.enterText(nameFields.first, 'Test Team');

      final descFields = find.byType(TextFormField);
      await $.tester.enterText(descFields.last, 'Test Description');

      // Step 4: Select services
      await $('Healthcare Cleaning').$(CheckboxListTile).tap();
      await $('Household Cleaning').$(CheckboxListTile).tap();

      // Step 5: Select members
      when(mockHomeController.isLoadingUsers).thenReturn(false.obs);
      when(mockHomeController.users).thenReturn(createMockUsers().obs);
      await $.pump();

      // Select first user as member
      await $(Checkbox).first.tap();
      verify(mockCreateTeamController.toggleMemberSelection(any)).called(1);

      // Select representative
      await $(Radio).first.tap();
      verify(mockCreateTeamController.setRepresentative(any)).called(1);

      // Step 6: Create team
      await $('Create Team').tap();
      verify(mockCreateTeamController.createTeamWithMembers()).called(1);
    });

    patrolTest('filters functionality', ($) async {
      await $.pumpWidgetAndSettle(createApp());

      // Step 1: Expand filters
      await $(Icons.tune).tap();
      verify(mockHomeController.toggleFiltersExpansionTeam()).called(1);

      // Step 2: Simulate filters expanded
      when(mockHomeController.isFiltersExpandedTeam).thenReturn(true.obs);
      await $.pump();

      // Step 3: Verify filter options
      await $('Healthcare Cleaning').waitUntilVisible();
      await $('Household Cleaning').waitUntilVisible();
      await $('Patient Referral').waitUntilVisible();
      await $('Burial Services').waitUntilVisible();

      // Step 4: Select filter options
      await $('Yes').first.tap();
      await $('No').at(1).tap();

      // Step 5: Apply filters
      await $('Apply Filters').tap();
      verify(mockHomeController.applyFiltersTeam()).called(1);

      // Step 6: Clear filters
      await $('Clear All Filters').tap();
      verify(mockHomeController.clearAllFiltersTeam()).called(1);
    });

    patrolTest('loading states', ($) async {
      when(mockHomeController.isLoadingTeam).thenReturn(true.obs);

      await $.pumpWidgetAndSettle(createApp());

      expect($(CircularProgressIndicator), findsOneWidget);
    });

    patrolTest('error states and retry', ($) async {
      when(mockHomeController.isLoadingTeam).thenReturn(false.obs);
      when(mockHomeController.errorMessageTeam).thenReturn('Network error'.obs);

      await $.pumpWidgetAndSettle(createApp());

      // Verify error UI
      await $('Network error').waitUntilVisible();
      expect($(Icons.error_outline), findsOneWidget);
      expect($('Retry'), findsOneWidget);

      // Test retry
      await $('Retry').tap();
      verify(mockHomeController.fetchTeams()).called(1);
    });

    patrolTest('empty state', ($) async {
      when(mockHomeController.filteredTeams).thenReturn(<TeamEntity>[].obs);

      await $.pumpWidgetAndSettle(createApp());

      await $('No teams found').waitUntilVisible();
      expect($(Icons.groups_outlined), findsOneWidget);
    });

    patrolTest('teams display', ($) async {
      when(mockHomeController.filteredTeams).thenReturn(createMockTeams().obs);

      await $.pumpWidgetAndSettle(createApp());

      // Verify teams are displayed
      await $('Healthcare Team').waitUntilVisible();
      await $('Emergency Team').waitUntilVisible();
      expect($('5 members'), findsOneWidget);
      expect($('3 members'), findsOneWidget);
    });

    patrolTest('team card interaction', ($) async {
      when(mockHomeController.filteredTeams).thenReturn(createMockTeams().obs);

      await $.pumpWidgetAndSettle(createApp());

      // Tap on team card
      await $('Healthcare Team').tap();
      // Navigation would be tested in integration environment
    });

    patrolTest('notification badge', ($) async {
      final mockUser = LoginEntity(
        id: 'user-123',
        name: 'Test User',
        email: 'test@example.com',
        lastname: 'User',
        isUserApproved: true,
        roles: ['Admin'],
        preferredLanguage: 0,
        profileImageUrl: '',
        message: '',
        unReadMessagesCount: 5,
      );

      when(
        mockAuthController.currentLoginUser,
      ).thenReturn(Rxn<LoginEntity>(mockUser));

      await $.pumpWidgetAndSettle(createApp());

      // Verify notification badge
      expect($('5'), findsOneWidget);
      expect($(Icons.notifications_none_rounded), findsOneWidget);

      // Test notification tap
      await $(Icons.notifications_none_rounded).tap();
      verify(mockHomeController.isNotificationSelected.value = true).called(1);
      verify(mockHomeController.isProfileSelected.value = false).called(1);
    });

    patrolTest('active filters count', ($) async {
      when(mockHomeController.nameFilterTeam).thenReturn('test'.obs);
      when(mockHomeController.healthcareFilter).thenReturn(Rxn<bool>(true));
      when(mockHomeController.householdFilter).thenReturn(Rxn<bool>(false));

      await $.pumpWidgetAndSettle(createApp());

      // Should show active filters count badge
      expect(
        $('3'),
        findsOneWidget,
      ); // name + healthcare + household = 3 filters
    });

    patrolTest('clear filters from empty state', ($) async {
      when(mockHomeController.filteredTeams).thenReturn(<TeamEntity>[].obs);
      when(mockHomeController.nameFilterTeam).thenReturn('search'.obs);
      when(mockHomeController.healthcareFilter).thenReturn(Rxn<bool>(true));

      await $.pumpWidgetAndSettle(createApp());

      await $('No teams found').waitUntilVisible();
      await $('Clear Filters').tap();

      verify(mockHomeController.clearAllFiltersTeam()).called(1);
    });
  });
}

class TestTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'teams_management': 'Teams Management',
      'teams_available': 'teams available',
      'search_teams': 'Search teams',
      'add_team': 'Add Team',
      'capability_filters': 'Capability Filters',
      'no_teams_found': 'No teams found',
      'clear_filters': 'Clear Filters',
      'retry': 'Retry',
      'members': 'members',
      'healthcare_cleaning': 'Healthcare Cleaning',
      'household_cleaning': 'Household Cleaning',
      'patient_referral': 'Patient Referral',
      'burial_services': 'Burial Services',
      'apply_filters': 'Apply Filters',
      'clear_all_filters': 'Clear All Filters',
      'all': 'All',
      'yes': 'Yes',
      'no': 'No',
      'create_new_team': 'Create New Team',
      'create_team': 'Create Team',
      'team_name': 'Team Name',
      'description': 'Description',
      'select_members': 'Select Members',
      'selected': 'selected',
      'search_users': 'Search users',
      'team_services': 'Team Services',
      'enter_team_name': 'Enter team name',
      'enter_description': 'Enter description',
    },
  };
}
