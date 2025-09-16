import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/get_alert_by_id/presentation/pages/get_alert_detail.dart';
import 'package:test3/features/home/presentation/pages/home.dart';
import 'package:test3/features/home/presentation/pages/widgets/team_detail_screen.dart';
import 'package:test3/features/home/presentation/pages/widgets/user_detail.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground: ${message.notification?.title}");
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default Channel',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload:
          '${message.data['type']},${message.data['alert_id']},${message.data['user_id']},${message.data['team_id'] ?? ''}',
    );
  }

  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      List<String> data = response.payload!.split(',');
      String type = data[0];
      String? alertId = data.length > 1 && data[1].isNotEmpty ? data[1] : null;
      String? userId = data.length > 2 && data[2].isNotEmpty ? data[2] : null;
      String? teamId = data.length > 3 && data[3].isNotEmpty ? data[3] : null;

      _navigateToPage(type, alertId, userId, teamId);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    String? type = message.data['type'];
    String? alertId = message.data['alert_id'];
    String? userId = message.data['user_id'];
    String? teamId = message.data['team_id'];

    _navigateToPage(type, alertId, userId, teamId);
  }

  static void _navigateToPage(
    String? type,
    String? alertId,
    String? userId, [
    String? teamId,
  ]) async {
    print(
      "Navigation attempt: type=$type, alertId=$alertId, userId=$userId, teamId=$teamId",
    );

    // اگر app هنوز آماده نیست، منتظر بمان
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 1500), () {
          _navigateToPage(type, alertId, userId, teamId);
        });
      });
      return;
    }

    // اگر context آماده نیست، منتظر بمان
    if (Get.context == null) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _navigateToPage(type, alertId, userId, teamId);
      });
      return;
    }

    // ذخیره اطلاعات navigation برای بازیابی بعدی
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_navigation', true);
    await prefs.setString(
      'notification_route',
      '$type,${alertId ?? ''},${userId ?? ''},${teamId ?? ''}',
    );

    try {
      // اگر stack خالی است، ابتدا HomePage را اضافه کن
      if (Get.routing.route?.settings.name == '/' || !Get.isRegistered()) {
        Get.off(() => HomePage()); // یا Get.offAll(() => HomePage());
        await Future.delayed(Duration(milliseconds: 300));
      }

      // حالا صفحه مورد نظر را باز کن
      if (type == 'create_alert' && alertId != null) {
        Get.to(() => AlertDetailPage(alertId: alertId, alertType: 0));
      } else if (type == 'register_user' && userId != null) {
        Get.to(() => UserDetailScreen(userId: userId));
      } else if (type == 'add_to_team' && teamId != null) {
        print('teamId ============> ${teamId}');
        Get.to(() => TeamDetailsPage(teamId: teamId));
      }
    } catch (e) {
      print("Navigation error: $e");
      // در صورت خطا، فقط HomePage را باز کن
      Get.offAll(() => HomePage());
    }
  }

  // متد برای پردازش navigation های pending
  static Future<void> processPendingNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasNavigation = prefs.getBool('notification_navigation') ?? false;

    if (hasNavigation) {
      String? route = prefs.getString('notification_route');
      if (route != null) {
        List<String> data = route.split(',');
        if (data.isNotEmpty) {
          String type = data[0];
          String? alertId = data.length > 1 && data[1].isNotEmpty
              ? data[1]
              : null;
          String? userId = data.length > 2 && data[2].isNotEmpty
              ? data[2]
              : null;
          String? teamId = data.length > 3 && data[3].isNotEmpty
              ? data[3]
              : null;

          // پاک کردن navigation pending
          await prefs.remove('notification_navigation');
          await prefs.remove('notification_route');

          // انجام navigation
          await Future.delayed(Duration(milliseconds: 1000));
          _navigateToPage(type, alertId, userId, teamId);
        }
      }
    }
  }
}
