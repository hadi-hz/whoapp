import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/entities/team_filter_entity.dart';
import 'package:test3/features/home/domain/entities/user_detail_entity.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';
import 'package:test3/features/home/domain/usecase/assign_role_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_team_by_id.dart';
import 'package:test3/features/home/domain/usecase/team_usecase.dart';
import 'package:test3/features/home/domain/usecase/user_detail_ussecase.dart';
import 'package:test3/features/home/domain/usecase/users_usecase.dart';

class HomeController extends GetxController {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetUserDetailUseCase getUserDetailUseCase;
  final AssignRoleUseCase assignRoleUseCase;
  final GetAllTeamsUseCase getAllTeamsUseCase;

  final Rx<TeamEntity?> currentTeam = Rx<TeamEntity?>(null);
  final RxBool isLoadingGetTeamById = false.obs;
  final RxString errorMessageGetTeamById = ''.obs;

  var isLoadingTeam = false.obs;
  var errorMessageTeam = ''.obs;
  var teams = <TeamEntity>[].obs;
  var filteredTeams = <TeamEntity>[].obs;

  var nameFilterTeam = ''.obs;
  var healthcareFilter = Rxn<bool>();
  var householdFilter = Rxn<bool>();
  var referralFilter = Rxn<bool>();
  var burialFilter = Rxn<bool>();
  var isFiltersExpandedTeam = false.obs;

  List<TeamEntity> get healthcareTeams =>
      teams.where((team) => team.isHealthcareCleaningAndDisinfection).toList();
  List<TeamEntity> get householdTeams =>
      teams.where((team) => team.isHouseholdCleaningAndDisinfection).toList();
  List<TeamEntity> get referralTeams =>
      teams.where((team) => team.isPatientsReferral).toList();
  List<TeamEntity> get burialTeams =>
      teams.where((team) => team.isSafeAndDignifiedBurial).toList();

  var isLoadingUsers = false.obs;
  var errorMessageUsers = ''.obs;
  var users = <UserEntity>[].obs;

  var isLoadingUserDetail = false.obs;
  var errorMessageUserDetail = ''.obs;
  Rxn<UserDetailEntity> userDetail = Rxn<UserDetailEntity>();

  var isAssigningRole = false.obs;
  var selectedRole = ''.obs;
  final List<String> availableRoles = ['Admin', 'Doctor', 'ServiceProvider'];

  var nameFilter = ''.obs;
  var emailFilter = ''.obs;
  var roleFilter = ''.obs;
  var isApprovedFilter = Rxn<bool>();
  var sortBy = 'Email'.obs;
  var sortDesc = true.obs;
  var registerDateFrom = Rxn<DateTime>();
  var registerDateTo = Rxn<DateTime>();
  var currentPage = 1.obs;
  var pageSize = 100.obs;

  final List<String> sortOptions = ['Email', 'Lastname'];
  final List<String> roleOptions = ['Admin', 'Doctor', 'ServiceProvider'];

  RxString role = ''.obs;
  RxString userName = ''.obs;
  @override
  void onInit() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId') ?? '';
    final String? savedRole = prefs.getString('role');
    final String? savedUserName = prefs.getString('userName');

    role.value = savedRole ?? '';
    userName.value = savedUserName ?? '';
    await fetchUsers();
    await fetchTeams();
    super.onInit();
  }

  var userSearchQuery = ''.obs;

  List<UserEntity> get filteredUsers {
    if (userSearchQuery.value.isEmpty) {
      return users;
    }
    return users
        .where(
          (user) =>
              user.fullName.toLowerCase().contains(
                userSearchQuery.value.toLowerCase(),
              ) ||
              (user.email?.toLowerCase().contains(
                    userSearchQuery.value.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  void setUserSearchQuery(String query) {
    userSearchQuery.value = query;
  }

  var isFiltersExpanded = false.obs;

  void toggleFiltersExpansion() {
    isFiltersExpanded.value = !isFiltersExpanded.value;
  }

  void closeFilters() {
    isFiltersExpanded.value = false;
  }

  void openFilters() {
    isFiltersExpanded.value = true;
  }

  var selectedIndex = 1.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  HomeController({
    required this.getAllUsersUseCase,
    required this.getUserDetailUseCase,
    required this.assignRoleUseCase,
    required this.getAllTeamsUseCase,
  });

  var isLoading = false.obs;
  var errorMessage = "".obs;

  var isLoadingDetail = false.obs;
  var errorMessageDetail = ''.obs;

  var selectedStatusFilter = Rxn<int>();
  var selectedTypeFilter = Rxn<int>();
  var searchQuery = "".obs;

  List<Map<String, dynamic>> get statusList => [
    {'value': null, 'name': 'all_status'.tr},
    {'value': 0, 'name': 'initial'.tr},
    {'value': 1, 'name': 'visited_by_admin'.tr},
    {'value': 2, 'name': 'assigned_to_team'.tr},
    {'value': 3, 'name': 'visited_by_team_member'.tr},
    {'value': 4, 'name': 'team_start_processing'.tr},
    {'value': 5, 'name': 'team_finish_processing'.tr},
    {'value': 6, 'name': 'admin_close'.tr},
  ];

  List<Map<String, dynamic>> get alertTypeList => [
    {'value': null, 'name': 'all_types'.tr},
    {'value': 0, 'name': 'healthcare_cleaning'.tr},
    {'value': 1, 'name': 'household_cleaning'.tr},
    {'value': 2, 'name': 'patient_referral'.tr},
    {'value': 3, 'name': 'safe_burial'.tr},
  ];

  Future<void> fetchUsers() async {
    isLoadingUsers.value = true;
    errorMessageUsers.value = '';

    final filter = UsersFilterEntity(
      name: nameFilter.value.isNotEmpty ? nameFilter.value : null,
      email: emailFilter.value.isNotEmpty ? emailFilter.value : null,
      role: roleFilter.value.isNotEmpty ? roleFilter.value : null,
      isApproved: isApprovedFilter.value,
      sortBy: sortBy.value,
      sortDesc: sortDesc.value,
      registerDateFrom: registerDateFrom.value,
      registerDateTo: registerDateTo.value,
      page: currentPage.value,
      pageSize: pageSize.value,
    );

    final result = await getAllUsersUseCase(filter);

    result.fold(
      (error) {
        errorMessageUsers.value = error;
        Get.snackbar(
          'error'.tr,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (usersList) {
        users.value = usersList;
      },
    );

    isLoadingUsers.value = false;
  }

  void setNameFilter(String name) {
    nameFilter.value = name;
    resetPagination();
  }

  void setEmailFilter(String email) {
    emailFilter.value = email;
    resetPagination();
  }

  void setRoleFilter(String role) {
    roleFilter.value = role;
    applyFiltersUsers();
    resetPagination();
  }

  void setApprovalFilter(bool? isApproved) {
    isApprovedFilter.value = isApproved;
    applyFiltersUsers();
    resetPagination();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    applyFiltersUsers();
    resetPagination();
  }

  void setSortDirection(bool desc) {
    sortDesc.value = desc;
    applyFiltersUsers();
    resetPagination();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    registerDateFrom.value = from;
    registerDateTo.value = to;
    applyFiltersUsers();
    resetPagination();
  }

  void resetPagination() {
    currentPage.value = 1;
  }

  void nextPage() {
    currentPage.value++;
    fetchUsers();
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchUsers();
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
    fetchUsers();
  }

  void clearAllFilters() {
    nameFilter.value = '';
    emailFilter.value = '';
    roleFilter.value = '';
    isApprovedFilter.value = null;
    registerDateFrom.value = null;
    registerDateTo.value = null;
    resetPagination();
    fetchUsers();
  }

  void applyFiltersUsers() {
    resetPagination();
    fetchUsers();
  }

  List<UserEntity> get approvedUsers =>
      users.where((user) => user.isApproved).toList();
  List<UserEntity> get pendingUsers =>
      users.where((user) => !user.isApproved).toList();
  List<UserEntity> get doctorUsers =>
      users.where((user) => user.roles.contains('Doctor')).toList();
  List<UserEntity> get adminUsers =>
      users.where((user) => user.roles.contains('Admin')).toList();

  int get totalUsers => users.length;
  int get approvedCount => approvedUsers.length;
  int get pendingCount => pendingUsers.length;

  Future<void> fetchUserDetail({
    required String userId,
    required String currentUserId,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getUserDetailUseCase(
      userId: userId,
      currentUserId: currentUserId,
    );

    result.fold(
      (error) {
        errorMessage.value = error;
        Get.snackbar(
          'error'.tr,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (user) {
        userDetail.value = user;
      },
    );

    isLoading.value = false;
  }

  void clearUserDetail() {
    userDetail.value = null;
    errorMessage.value = '';
  }

  Future<bool> assignRoleToUser({
    required String userId,
    required String roleName,
  }) async {
    isAssigningRole.value = true;
    final result = await assignRoleUseCase(userId: userId, roleName: roleName);
    isAssigningRole.value = false;
    return result.fold(
      (error) {
        Get.snackbar(
          'error'.tr,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      },
      (assignResult) async {
        Get.snackbar(
          'success'.tr,
          assignResult.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        final currentUser = userDetail.value;
        fetchUsers();
        if (currentUser != null) {
          final prefs = await SharedPreferences.getInstance();
          final currentUserId = prefs.getString('userId');
          if (currentUserId != null) {
            fetchUserDetail(
              userId: currentUser.id,
              currentUserId: currentUserId,
            );
          }
        }
        return true;
      },
    );
  }

  void setSelectedRole(String role) {
    selectedRole.value = role;
  }

  void clearSelectedRole() {
    selectedRole.value = '';
  }

  Future<void> fetchTeams() async {
    isLoading.value = true;
    errorMessage.value = '';

    final filter = TeamsFilterEntity(
      name: nameFilter.value.isNotEmpty ? nameFilter.value : null,
      isHealthcareCleaningAndDisinfection: healthcareFilter.value,
      isHouseholdCleaningAndDisinfection: householdFilter.value,
      isPatientsReferral: referralFilter.value,
      isSafeAndDignifiedBurial: burialFilter.value,
    );

    final result = await getAllTeamsUseCase(filter);

    result.fold(
      (error) {
        errorMessage.value = error;
        Get.snackbar(
          'error'.tr,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (teamsList) {
        teams.value = teamsList;
        applyLocalFilters();
      },
    );

    isLoading.value = false;
  }

  void applyLocalFilters() {
    List<TeamEntity> filtered = teams.toList();

    if (nameFilter.value.isNotEmpty) {
      String query = nameFilter.value.toLowerCase().trim();
      filtered = filtered.where((team) {
        return team.name.toLowerCase().contains(query) ||
            team.description.toLowerCase().contains(query);
      }).toList();
    }

    filteredTeams.value = filtered;
  }

  void setNameFilterTeam(String name) {
    nameFilter.value = name;
    applyLocalFilters();
  }

  void setHealthcareFilter(bool? value) {
    healthcareFilter.value = value;
  }

  void setHouseholdFilter(bool? value) {
    householdFilter.value = value;
  }

  void setReferralFilter(bool? value) {
    referralFilter.value = value;
  }

  void setBurialFilter(bool? value) {
    burialFilter.value = value;
  }

  void toggleFiltersExpansionTeam() {
    isFiltersExpandedTeam.value = !isFiltersExpandedTeam.value;
  }

  void applyFiltersTeam() {
    fetchTeams();
  }

  void clearAllFiltersTeam() {
    nameFilterTeam.value = '';
    healthcareFilter.value = null;
    householdFilter.value = null;
    referralFilter.value = null;
    burialFilter.value = null;
    fetchTeams();
  }

  int get totalTeams => teams.length;
  int get healthcareTeamsCount => healthcareTeams.length;
  int get householdTeamsCount => householdTeams.length;
  int get referralTeamsCount => referralTeams.length;
  int get burialTeamsCount => burialTeams.length;

  int get activeFiltersCount {
    int count = 0;
    if (nameFilter.value.isNotEmpty) count++;
    if (healthcareFilter.value != null) count++;
    if (householdFilter.value != null) count++;
    if (referralFilter.value != null) count++;
    if (burialFilter.value != null) count++;
    return count;
  }
}
