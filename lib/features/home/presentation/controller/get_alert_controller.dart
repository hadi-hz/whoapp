import 'package:get/get.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/entities/get_filter_alert.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';

class AlertListController extends GetxController {
  final GetAlertsUseCase getAlertsUseCase;

  AlertListController({required this.getAlertsUseCase});

  var isLoading = false.obs;
  var alerts = <AlertEntity>[].obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;

  var searchQuery = ''.obs;
  var selectedStatus = Rxn<int>();
  var selectedType = Rxn<int>();
  var selectedUserId = Rxn<String>();
  var selectedTeamId = Rxn<String>();
  var dateFrom = Rxn<DateTime>();
  var dateTo = Rxn<DateTime>();
  var sortBy = 'serverCreateTime'.obs;
  var sortDescending = true.obs;
  var currentPage = 1.obs;
  var pageSize = 150.obs;

  List<Map<String, dynamic>> get statusOptions => [
    {'value': null, 'label': 'all_status'.tr},
    {'value': 0, 'label': 'initial'.tr},
    {'value': 1, 'label': 'visited_by_admin'.tr},
    {'value': 2, 'label': 'assigned_to_team'.tr},
    {'value': 3, 'label': 'visited_by_team_member'.tr},
    {'value': 4, 'label': 'team_start_processing'.tr},
    {'value': 5, 'label': 'team_finish_processing'.tr},
    {'value': 6, 'label': 'admin_close'.tr},
  ];

  List<Map<String, dynamic>> get typeOptions => [
    {'value': null, 'label': 'all_types'.tr},
    {'value': 0, 'label': 'healthcare_cleaning'.tr},
    {'value': 1, 'label': 'household_cleaning'.tr},
    {'value': 2, 'label': 'patient_referral'.tr},
    {'value': 3, 'label': 'safe_burial'.tr},
  ];
  @override
  void onInit() {
    super.onInit();
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final filter = AlertFilterEntity(
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
      userId: selectedUserId.value,
      status: selectedStatus.value,
      type: selectedType.value,
      registerDateFrom: dateFrom.value,
      registerDateTo: dateTo.value,
      sortBy: sortBy.value,
      sortDescending: sortDescending.value,
      teamId: selectedTeamId.value,
      page: currentPage.value,
      pageSize: pageSize.value,
    );

    final result = await getAlertsUseCase(filter);

    result.fold(
      (error) {
        hasError.value = true;
        errorMessage.value = error;
        alerts.clear();
      },
      (alertList) {
        hasError.value = false;
        alerts.value = alertList;
      },
    );

    isLoading.value = false;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadAlerts();
  }

  void onStatusChanged(int? status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    loadAlerts();
  }

  void onTypeChanged(int? type) {
    selectedType.value = type;
    currentPage.value = 1;
    loadAlerts();
  }

  void onUserIdChanged(String? userId) {
    selectedUserId.value = userId;
    currentPage.value = 1;
    loadAlerts();
  }

  void onTeamIdChanged(String? teamId) {
    selectedTeamId.value = teamId;
    currentPage.value = 1;
    loadAlerts();
  }

  void onDateRangeChanged(DateTime? from, DateTime? to) {
    dateFrom.value = from;
    dateTo.value = to;
    currentPage.value = 1;
    loadAlerts();
  }

  void onSortChanged(String sortField, bool descending) {
    sortBy.value = sortField;
    sortDescending.value = descending;
    currentPage.value = 1;
    loadAlerts();
  }

  void nextPage() {
    currentPage.value++;
    loadAlerts();
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      loadAlerts();
    }
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedStatus.value = null;
    selectedType.value = null;
    selectedUserId.value = null;
    selectedTeamId.value = null;
    dateFrom.value = null;
    dateTo.value = null;
    currentPage.value = 1;
    loadAlerts();
  }

  void refreshAlerts() {
    currentPage.value = 1;
    loadAlerts();
  }

  String getStatusLabel(int status) {
    final statusOption = statusOptions.firstWhere(
      (option) => option['value'] == status,
      orElse: () => {'label': 'unknown'.tr},
    );
    return statusOption['label'] as String;
  }

  String getTypeLabel(int type) {
    final typeOption = typeOptions.firstWhere(
      (option) => option['value'] == type,
      orElse: () => {'label': 'unknown'.tr},
    );
    return typeOption['label'] as String;
  }
}
