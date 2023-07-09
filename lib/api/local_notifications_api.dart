import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  // service.initNotification();
  return service;
});

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {});
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
  }) async {
    return notificationsPlugin.show(id, title, body, notificationDetails(),
        payload: payload);
  }

  Future<void> showNotificationAtTime(
      {required int id,
      required String? title,
      required String? body,
      required DateTime scheduledTime,
      String? payload}) async {
    await notificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(scheduledTime, tz.local), notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  Future onSelectNotification(String? payload) async {
    // Handle what happens when a notification is tapped by the user
    // For example, you could navigate to a specific screen or open a dialog
    // The payload parameter contains any data you attached to the notification when you showed it
  }
}
