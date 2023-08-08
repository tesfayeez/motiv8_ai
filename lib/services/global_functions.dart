import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GlobalFunctions {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // * method use to show notifications
  Future<void> showNotification(
    RemoteMessage message,
  ) async {
    String title = message.notification?.title ?? "Gooseneck";
    String description = message.notification?.body ?? "New Notification";
    final androidPlatformChannelSpecific = AndroidNotificationDetails(
        'basic_channel', title,
        importance: Importance.high, priority: Priority.high);
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecific,
      iOS: iOSPlatformChannelSpecifics,
    );
    int messageId = int.tryParse(message.data['messageId']) ?? 0;
    // cut down the message id to 4 digits so that we can use it as Message id
    messageId = messageId % 10000;

    log("showing message with id: $messageId, title: $title, description: $description,");
    await flutterLocalNotificationsPlugin.show(
        messageId, title, description, notificationDetails);
  }

  Future<void> initializeNotification() async {
    try {
      AndroidInitializationSettings initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      DarwinInitializationSettings initializationSettingsIOS =
          const DarwinInitializationSettings();
      InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
