import 'package:get/get.dart';
import 'package:test3/features/home/domain/usecase/notification_read_usecase.dart';

class NotificationReadController extends GetxController {
  final MarkNotificationReadByAlertUseCase markByAlertUseCase;
  final MarkNotificationReadByUserUseCase markByUserUseCase;
  final MarkNotificationReadByIdUseCase markByIdUseCase;

  NotificationReadController({
    required this.markByAlertUseCase,
    required this.markByUserUseCase,
    required this.markByIdUseCase,
  });

  var isMarkingByAlert = false.obs;
  var isMarkingByUser = false.obs;
  var isMarkingById = false.obs;

  var errorMessage = ''.obs;

  var successMessage = ''.obs;

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  Future<bool> markAsReadByAlert({
    required String alertId,
    required String currentUserId,
  }) async {
    try {
      clearMessages();
      isMarkingByAlert.value = true;

      final result = await markByAlertUseCase.call(
        alertId: alertId,
        currentUserId: currentUserId,
      );

      if (result.success) {
        successMessage.value = result.message;
        
        return true;
      } else {
        errorMessage.value = result.message;
      
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    
      return false;
    } finally {
      isMarkingByAlert.value = false;
    }
  }

  Future<bool> markAsReadByUser({
    required String currentUserId,
    required String relatedToUserId,
  }) async {
    try {
      clearMessages();
      isMarkingByUser.value = true;

      final result = await markByUserUseCase.call(
        currentUserId: currentUserId,
        relatedToUserId: relatedToUserId,
      );

      if (result.success) {
        successMessage.value = result.message;
   
        return true;
      } else {
        errorMessage.value = result.message;
      
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
     
      return false;
    } finally {
      isMarkingByUser.value = false;
    }
  }

  Future<bool> markAsReadById({required String notificationId}) async {
    try {
      clearMessages();
      isMarkingById.value = true;

      final result = await markByIdUseCase.call(notificationId: notificationId);

      if (result.success) {
        successMessage.value = result.message;
     
        return true;
      } else {
        errorMessage.value = result.message;
     
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
   
      return false;
    } finally {
      isMarkingById.value = false;
    }
  }



}
