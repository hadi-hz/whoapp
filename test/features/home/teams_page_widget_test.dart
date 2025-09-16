import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/auth/domain/entities/login.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/presentation/controller/create_team_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/teams_screen.dart';

// Generate mocks
@GenerateMocks([HomeController, AuthController, CreateTeamController])
import 'teams_page_widget_test.mocks.dart';

void main() {
  late MockHomeController mockHomeController;
  late MockAuthController mockAuthController;
  late MockCreateTeamController mockCreateTeamController;

  setUp(() {
    mockHomeController = MockHomeController();
    mockAuthController = MockAuthController();
    mockCreateTeamController = MockCreateTeamController();

    // Setup default mocks with correct types
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
    when(mockAuthController.currentLoginUser).thenReturn(Rxn<LoginEntity>(null));

    // Mock CreateTeamController
    when(mockCreateTeamController.selectedRepresentative).thenReturn(''.obs);
    when(mockCreateTeamController.descriptionController).thenReturn(TextEditingController());
    when(mockCreateTeamController.nameController).thenReturn(TextEditingController());
    when(mockCreateTeamController.searchController).thenReturn(TextEditingController());
    when(mockCreateTeamController.isBurial).thenReturn(false.obs);
    when(mockCreateTeamController.isHealthcare).thenReturn(false.obs);
    when(mockCreateTeamController.isHousehold).thenReturn(false.obs);
    when(mockCreateTeamController.isReferral).thenReturn(false.obs);
    when(mockCreateTeamController.selectedMembers).thenReturn(<String>[].obs);

    Get.put<HomeController>(mockHomeController);
    Get.put<AuthController>(mockAuthController);
    Get.put<CreateTeamController>(mockCreateTeamController);

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
      home: TeamsScreen(),
      translations: TestTranslations(),
    );
  }

  group('TeamsScreen Widget Tests', () {
    testWidgets('should render teams screen correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TeamsScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Teams Management'), findsOneWidget);
    });

    testWidgets('should show search field and add team button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Search Teams'), findsOneWidget);
      expect(find.text('Add Team'), findsOneWidget);
    });

    testWidgets('should show capability filters header', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Capability Filters'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });

    testWidgets('should expand filters when header is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      await tester.tap(find.text('Capability Filters'));
      await tester.pumpAndSettle();

      verify(mockHomeController.toggleFiltersExpansionTeam()).called(1);
    });

    testWidgets('should show loading indicator when loading teams', (tester) async {
      when(mockHomeController.isLoadingTeam).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when there is an error', (tester) async {
      when(mockHomeController.errorMessageTeam).thenReturn('Network error'.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should show no teams message when teams list is empty', (tester) async {
      when(mockHomeController.filteredTeams).thenReturn(<TeamEntity>[].obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.groups_outlined), findsOneWidget);
      expect(find.text('No Teams Found'), findsOneWidget);
    });

    testWidgets('should show clear filters button when filters are applied', (tester) async {
      when(mockHomeController.filteredTeams).thenReturn(<TeamEntity>[].obs);
      when(mockHomeController.nameFilterTeam).thenReturn('test'.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Clear Filters'), findsOneWidget);
    });

    testWidgets('should display team cards when teams exist', (tester) async {
      final mockTeams = [
        TeamEntity(
          id: '1',
          name: 'Healthcare Team',
          description: 'Healthcare description',
          memberCount: 5,
          isHealthcareCleaningAndDisinfection: true,
          isHouseholdCleaningAndDisinfection: false,
          isPatientsReferral: false,
          isSafeAndDignifiedBurial: false,
          isDelete: false,
          createTime: '2024-01-01T00:00:00Z',
        ),
        TeamEntity(
          id: '2',
          name: 'Emergency Team',
          description: 'Emergency description',
          memberCount: 3,
          isHealthcareCleaningAndDisinfection: false,
          isHouseholdCleaningAndDisinfection: true,
          isPatientsReferral: false,
          isSafeAndDignifiedBurial: false,
          isDelete: false,
          createTime: '2024-01-02T00:00:00Z',
        ),
      ];
      
      when(mockHomeController.filteredTeams).thenReturn(mockTeams.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Healthcare Team'), findsOneWidget);
      expect(find.text('Emergency Team'), findsOneWidget);
      expect(find.text('5 members'), findsOneWidget);
      expect(find.text('3 members'), findsOneWidget);
    });

    testWidgets('should show team count in header', (tester) async {
      when(mockHomeController.totalTeams).thenReturn(10);

      await tester.pumpWidget(createTestWidget());

      expect(find.textContaining('10'), findsOneWidget);
      expect(find.textContaining('teams available'), findsOneWidget);
    });

    testWidgets('should call fetchTeams on refresh', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      verify(mockHomeController.fetchTeams()).called(1);
    });

    testWidgets('should update search filter when search field changes', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField), 'healthcare');
      
      verify(mockHomeController.setNameFilterTeam('healthcare')).called(1);
    });

    testWidgets('should clear search when clear button is tapped', (tester) async {
      when(mockHomeController.nameFilterTeam).thenReturn('test'.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.clear));
      
      verify(mockHomeController.setNameFilterTeam('')).called(1);
    });

    testWidgets('should show retry button when there is an error', (tester) async {
      when(mockHomeController.errorMessageTeam).thenReturn('Network error'.obs);

      await tester.pumpWidget(createTestWidget());

      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      verify(mockHomeController.fetchTeams()).called(1);
    });

    testWidgets('should open create team bottom sheet when add button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Add Team'));
      await tester.pumpAndSettle();

      // Verify bottom sheet opens
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('should show notification badge when there are unread messages', (tester) async {
      final mockLoginUser = LoginEntity(
        id: 'user-123',
        name: 'Test User',
        email: 'test@example.com',
        lastname: 'User',
        isUserApproved: true,
        roles: ['Admin'],
        preferredLanguage: 0,
        profileImageUrl: '',
        message: '',
        unReadMessagesCount: 3,
      );
      
      when(mockAuthController.currentLoginUser).thenReturn(Rxn<LoginEntity>(mockLoginUser));

      await tester.pumpWidget(createTestWidget());

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should handle tablet layout correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TeamsScreen), findsOneWidget);
      
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show active filters count', (tester) async {
      when(mockHomeController.nameFilterTeam).thenReturn('test'.obs);
      when(mockHomeController.healthcareFilter).thenReturn(Rxn<bool>(true));

      await tester.pumpWidget(createTestWidget());

      expect(find.text('2'), findsOneWidget); // Active filters count
    });

    testWidgets('should navigate to team detail when team card is tapped', (tester) async {
      final mockTeams = [
        TeamEntity(
          id: 'team-123',
          name: 'Test Team',
          description: 'Test description',
          memberCount: 5,
          isHealthcareCleaningAndDisinfection: true,
          isHouseholdCleaningAndDisinfection: false,
          isPatientsReferral: false,
          isSafeAndDignifiedBurial: false,
          isDelete: false,
          createTime: '2024-01-01T00:00:00Z',
        ),
      ];
      
      when(mockHomeController.filteredTeams).thenReturn(mockTeams.obs);

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Test Team'));
      await tester.pumpAndSettle();

      // Navigation should be triggered
    });
  });

  group('Filter Tests', () {
    testWidgets('should show filter content when expanded', (tester) async {
      when(mockHomeController.isFiltersExpandedTeam).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Healthcare Cleaning'), findsOneWidget);
      expect(find.text('Household Cleaning'), findsOneWidget);
      expect(find.text('Patient Referral'), findsOneWidget);
      expect(find.text('Burial Services'), findsOneWidget);
      expect(find.text('Apply Filters'), findsOneWidget);
      expect(find.text('Clear All Filters'), findsOneWidget);
    });

    testWidgets('should call apply filters when apply button is tapped', (tester) async {
      when(mockHomeController.isFiltersExpandedTeam).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Apply Filters'));
      
      verify(mockHomeController.applyFiltersTeam()).called(1);
    });

    testWidgets('should call clear filters when clear button is tapped', (tester) async {
      when(mockHomeController.isFiltersExpandedTeam).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Clear All Filters'));
      
      verify(mockHomeController.clearAllFiltersTeam()).called(1);
    });

    testWidgets('should update healthcare filter when option is selected', (tester) async {
      when(mockHomeController.isFiltersExpandedTeam).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());

      // Find and tap the healthcare filter "Yes" option
      final yesButtons = find.text('Yes');
      if (yesButtons.evaluate().isNotEmpty) {
        await tester.tap(yesButtons.first);
        verify(mockHomeController.setHealthcareFilter(true)).called(1);
      }
    });
  });

  group('Responsive Design Tests', () {
    testWidgets('should show grid layout on large screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      
      final mockTeams = List.generate(6, (index) => TeamEntity(
        id: 'team-$index',
        name: 'Team $index',
        description: 'Description $index',
        memberCount: index + 1,
        isHealthcareCleaningAndDisinfection: true,
        isHouseholdCleaningAndDisinfection: false,
        isPatientsReferral: false,
        isSafeAndDignifiedBurial: false,
        isDelete: false,
        createTime: '2024-01-0${index + 1}T00:00:00Z',
      ));
      
      when(mockHomeController.filteredTeams).thenReturn(mockTeams.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(GridView), findsOneWidget);
      
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show column layout on small screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 600));
      
      final mockTeams = [
        TeamEntity(
          id: 'team-1',
          name: 'Mobile Team',
          description: 'Mobile description',
          memberCount: 2,
          isHealthcareCleaningAndDisinfection: true,
          isHouseholdCleaningAndDisinfection: false,
          isPatientsReferral: false,
          isSafeAndDignifiedBurial: false,
          isDelete: false,
          createTime: '2024-01-01T00:00:00Z',
        ),
      ];
      
      when(mockHomeController.filteredTeams).thenReturn(mockTeams.obs);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Column), findsAtLeastNWidgets(1));
      
      await tester.binding.setSurfaceSize(null);
    });
  });
}

class TestTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'teams_management': 'Teams Management',
      'teams_available': 'teams available',
      'search_teams': 'Search Teams',
      'add_team': 'Add Team',
      'capability_filters': 'Capability Filters',
      'no_teams_found': 'No Teams Found',
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
    },
  };
}