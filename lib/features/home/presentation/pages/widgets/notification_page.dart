import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/get_alert_by_id/presentation/pages/get_alert_detail.dart';
import 'package:test3/features/home/presentation/controller/notification_controller.dart';
import 'package:test3/features/home/presentation/controller/notification_read_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/team_detail_screen.dart';
import 'package:test3/features/home/presentation/pages/widgets/user_detail.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with TickerProviderStateMixin {
  final NotificationController controller = Get.put(NotificationController());
  final NotificationReadController notificationReadController =
      Get.find<NotificationReadController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    if (userId.isNotEmpty) {
      await controller.getAllNotifications(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
        backgroundColor: isDark ? Colors.grey[900] : AppColors.primaryColor,
        foregroundColor: Colors.white,

        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('unread'.tr),
                    if (controller.unreadNotifications.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          controller.unreadNotifications.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Tab(text: 'all'.tr),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.grey[900]!, Colors.black]
                : [AppColors.primaryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildNotificationList(unreadOnly: true, isDark: isDark),
            _buildNotificationList(unreadOnly: false, isDark: isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList({
    required bool unreadOnly,
    required bool isDark,
  }) {
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: AppColors.primaryColor,
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadNotifications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    'retry'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final notifications = unreadOnly
            ? controller.unreadNotifications
            : controller.notifications;

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  unreadOnly ? Icons.notifications_none : Icons.inbox,
                  size: 64,
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  unreadOnly
                      ? 'no_unread_notifications'.tr
                      : 'no_notifications'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification, isDark);
          },
        );
      }),
    );
  }

  Widget _buildNotificationCard(notification, bool isDark) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(
              'delete'.tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteDialog(notification.id);
      },
      onDismissed: (direction) async {
        await controller.deleteNotification(notification.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isUnread
                ? AppColors.primaryColor.withOpacity(0.3)
                : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
            width: isUnread ? 1.2 : 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black12,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getNotificationIcon(
                  notification.notificationTemplatesType,
                  isDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread) ...[
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                          if (notification.isRead) ...[
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: Colors.green,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.message,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontWeight: isUnread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,

                                color: isDark ? Colors.grey : Colors.grey,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _formatDateTime(notification.createTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(notification) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString('userId') ?? '';

    if (currentUserId.isEmpty) return;

    bool success = false;

    if (notification.alertId != null && notification.alertId.isNotEmpty) {
      success = await notificationReadController.markAsReadByAlert(
        alertId: notification.alertId,
        currentUserId: currentUserId,
      );
    } else if (notification.relateToUserId != null &&
        notification.relateToUserId.isNotEmpty) {
      success = await notificationReadController.markAsReadByUser(
        currentUserId: currentUserId,
        relatedToUserId: notification.relateToUserId,
      );
    } else {
      success = await notificationReadController.markAsReadById(
        notificationId: notification.id,
      );
    }

    if (success) {
      await _loadNotifications();
    }

    if (notification.relateToUserId != null &&
        notification.relateToUserId.isNotEmpty) {
      Get.to(() => UserDetailScreen(userId: notification.relateToUserId));
    } else if (notification.alertId != null &&
        notification.alertId.isNotEmpty) {
      Get.to(() => AlertDetailPage(alertId: notification.alertId));
    } else if (notification.teamId != null && notification.teamId.isNotEmpty) {
      Get.to(TeamDetailsPage(teamId: notification.teamId));
    }
  }

  Widget _buildDeleteButton(String notificationId, bool isDark) {
    return Obx(() {
      final isDeleting = controller.isDeleting[notificationId] ?? false;

      return GestureDetector(
        onTap: isDeleting ? null : () => _showDeleteDialog(notificationId),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
          ),
          child: isDeleting
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                )
              : Icon(Icons.delete_outline, size: 18, color: Colors.red),
        ),
      );
    });
  }

  Future<bool?> _showDeleteDialog(String notificationId) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            Text(
              'delete_notification'.tr,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'are_you_sure_delete_notification'.tr,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'cancel'.tr,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, size: 16),
                const SizedBox(width: 4),
                Text(
                  'delete'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNotificationIcon(int type, bool isDark) {
    IconData icon;
    Color color;

    switch (type) {
      case 0: // NewUserForAdmin
        icon = Icons.person_add;
        color = Colors.blue;
        break;
      case 1: // UserApprovedByAdmin
        icon = Icons.verified_user;
        color = Colors.green;
        break;
      case 2: // NewAlertForAdmin
        icon = Icons.warning;
        color = Colors.orange;
        break;
      case 3: // NewAlertForDoctor
        icon = Icons.medical_services;
        color = Colors.red;
        break;
      case 4: // NewAlertForTeam
        icon = Icons.group_add;
        color = Colors.purple;
        break;
      case 5: // AlertModifiedForAdmin
        icon = Icons.edit_notifications;
        color = Colors.amber;
        break;
      case 6: // AlertModifiedForTeam
        icon = Icons.update;
        color = Colors.teal;
        break;
      case 7: // EmailVerified
        icon = Icons.mark_email_read;
        color = Colors.indigo;
        break;
      case 8: // Added To Team
        icon = Icons.groups;
        color = Colors.indigo;
        break;
      default:
        icon = Icons.notifications;
        color = AppColors.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),

        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final DateTime parsedDate = DateTime.parse(dateTime);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(parsedDate);

      if (difference.inDays > 7) {
        return DateFormat('MMM dd, yyyy').format(parsedDate);
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${'days_ago'.tr}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${'hours_ago'.tr}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${'minutes_ago'.tr}';
      } else {
        return 'just_now'.tr;
      }
    } catch (e) {
      return dateTime;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
