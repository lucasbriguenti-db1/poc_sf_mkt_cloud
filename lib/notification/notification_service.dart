import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:poc_sf_push/notification/marketing_cloud_notification.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: android),
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<void> showNotification(MarketingCloudNotification notification) async {
    const androidDetails = AndroidNotificationDetails(
      'push-marketing-cloud',
      'Push Mkt Cloud',
      importance: Importance.max,
      channelDescription: 'Essa é uma notificação do mkt cloud',
      priority: Priority.max,
    );

    await flutterLocalNotificationsPlugin.show(
      100,
      notification.title,
      notification.body,
      const NotificationDetails(android: androidDetails),
    );
  }

  void checkForNotifications() async {
    final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.payload);
    }
  }

  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print(payload);
    }
  }
}
