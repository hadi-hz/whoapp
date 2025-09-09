import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/get_alert_by_id/presentation/pages/get_alert_detail.dart';
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

    // Handle notification tap when app is background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notification tap when app is terminated
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
          '${message.data['type']},${message.data['alert_id']},${message.data['user_id']}',
    );
  }

  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      List<String> data = response.payload!.split(',');
      String type = data[0];
      String? alertId = data.length > 1 ? data[1] : null;
      String? userId = data.length > 2 ? data[2] : null;

      _navigateToPage(type, alertId, userId);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    String? type = message.data['type'];
    String? alertId = message.data['alert_id'];
    String? userId = message.data['user_id'];

    _navigateToPage(type, alertId, userId);
  }

  static void _navigateToPage(String? type, String? alertId, String? userId)async {
    print("Navigation attempt: type=$type, alertId=$alertId");

    // چک کن app ready هست یا نه
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      // App هنوز ready نیست، صبر کن
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 1500), () {
          _navigateToPage(type, alertId, userId);
        });
      });
      return;
    }

     final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_navigation', true);
    await prefs.setString('notification_route', '$type,$alertId,$userId');

    // اگه GetX context آماده نیست
    if (Get.context == null) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _navigateToPage(type, alertId, userId);
      });
      return;
    }

    if (type == 'create_alert' && alertId != null) {
      Get.offAll(() => AlertDetailPage(alertId: alertId));
    } else if (type == 'register_user' && userId != null) {
      Get.offAll(() => UserDetailScreen(userId: userId));
    }
  }
}
