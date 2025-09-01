import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/data/datasource/notification_datasource.dart';
import 'package:test3/features/home/data/repositories/notification_repository_impl.dart';
import 'package:test3/features/home/domain/entities/notification_entity.dart';
import 'package:test3/features/home/domain/usecase/delete_notification_usecase.dart';
import 'package:test3/features/home/domain/usecase/notification_usecase.dart';

class NotificationController extends GetxController {
  late final DeleteNotificationUseCase _deleteNotificationUseCase;
  var isDeleting = <String, bool>{}.obs;
  late final GetNotificationsUseCase _getNotificationsUseCase;

  var notifications = <NotificationEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;

  var showUnreadOnly = false.obs;
  var selectedType = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _initializeUseCase();
  }

  void _initializeUseCase() {
    final dataSource = NotificationDataSourceImpl();
    final repository = NotificationRepositoryImpl(dataSource);
    _getNotificationsUseCase = GetNotificationsUseCase(repository);
    _deleteNotificationUseCase = DeleteNotificationUseCase(repository);
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      isDeleting[notificationId] = true;
      isDeleting.refresh();

      final success = await _deleteNotificationUseCase.call(notificationId);
      if (success) {
        notifications.removeWhere((n) => n.id == notificationId);
        Get.snackbar(
          'success'.tr,
          'notification_deleted_successfully'.tr,
          colorText: AppColors.background,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_delete_notification'.tr,
        backgroundColor: Colors.red,
        colorText: AppColors.background,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isDeleting.remove(notificationId);
    }
  }

  Future<void> getAllNotifications(String userId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await _getNotificationsUseCase.call(
        userId: userId,
        isRead: null,
      );

      notifications.value = result;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error getting notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleUnreadFilter() {
    showUnreadOnly.value = !showUnreadOnly.value;
    _applyFilters();
  }

  void filterByType(int? type) {
    selectedType.value = type;
    _applyFilters();
  }

  void _applyFilters() {
    // Apply filters to notifications list
    // This is a client-side filter, you could also call API with filters
  }

  List<NotificationEntity> get unreadNotifications =>
      notifications.where((notif) => !notif.isRead).toList();

  List<NotificationEntity> get readNotifications =>
      notifications.where((notif) => notif.isRead).toList();

  int get unreadCount => notifications.where((notif) => !notif.isRead).length;

  void clearFilters() {
    showUnreadOnly.value = false;
    selectedType.value = null;
  }

  Future<void> refreshNotifications(String userId) async {
    await getAllNotifications(userId);
  }
}
