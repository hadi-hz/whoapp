import 'package:get/get.dart';
import 'package:test3/features/home/data/model/get_alert_model.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/usecase/get_alert_usecase.dart';

class HomeController extends GetxController {
  var selectedIndex = 1.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  final GetAlertsUseCase getAlertsUseCase;

  HomeController({required this.getAlertsUseCase});

  var alerts = <GetAlertEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchAlerts(GetAlertRequestModel request) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await getAlertsUseCase.call(request);
      alerts.value = result;
      print('alerts.value : ${alerts.value}');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
