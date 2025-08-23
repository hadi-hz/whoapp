import 'package:get/get.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';

class HomeController extends GetxController {
  var selectedIndex = 1.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  final GetAllAlerts getAllAlerts;

  HomeController({required this.getAllAlerts});

  var alerts = <Alert>[].obs;
  var filteredAlerts = <Alert>[].obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;

 
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

  Future<void> fetchAlerts({
    required String userId,
    required bool sortDescending,
    required int page,
    required int pageSize,
    String? registerDateFrom,
    String? registerDateTo,
    String? sortBy,
    String? teamId,
    int? status,
    int? type,
  }) async {
    isLoading.value = true;
    errorMessage.value = "";

    final result = await getAllAlerts(
      userId: userId,
      sortDescending: sortDescending,
      page: page,
      pageSize: pageSize,
      registerDateFrom: registerDateFrom,
      registerDateTo: registerDateTo,
      sortBy: sortBy,
      status: status,
      teamId: teamId,
      type: type,
    );

    result.fold(
      (error) => errorMessage.value = error,
      (data) {
        alerts.value = data;
        applyFilters();
      },
    );

    isLoading.value = false;
  }

 
  void applyFilters() {
    List<Alert> filtered = alerts.toList();

    
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase().trim();
      filtered = filtered.where((alert) {
        String doctorName = (alert.doctorName ?? '').toLowerCase();
        String teamName = (alert.teamName ?? '').toLowerCase();
        return doctorName.contains(query) || teamName.contains(query);
      }).toList();
    }

  
    if (selectedStatusFilter.value != null) {
      filtered = filtered.where((alert) => 
        alert.alertStatus == selectedStatusFilter.value
      ).toList();
    }

  
    if (selectedTypeFilter.value != null) {
      filtered = filtered.where((alert) => 
        alert.alertType == selectedTypeFilter.value
      ).toList();
    }

    filteredAlerts.value = filtered;
  }

  void changeStatusFilter(int? status) {
    selectedStatusFilter.value = status;
    applyFilters();
  }

 
  void changeTypeFilter(int? type) {
    selectedTypeFilter.value = type;
    applyFilters();
  }

 
  void changeSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }


  void clearFilters() {
    selectedStatusFilter.value = null;
    selectedTypeFilter.value = null;
    searchQuery.value = "";
    applyFilters();
  }
}