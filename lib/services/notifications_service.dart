import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:motiv8_ai/api/user_api.dart';
import 'package:motiv8_ai/constants/notification_topics.dart';
import 'package:motiv8_ai/models/user_model.dart';

import 'global_functions.dart';

class NotificationService {
  final firestore = FirebaseFirestore.instance;
  final messaging = FirebaseMessaging.instance;
  final _globalFunctions = GlobalFunctions();
  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;
  Future<bool> initializeNotificationsPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
      return true;
    } else {
      log('User declined or has not accepted permission');
      return false;
    }
  }

  Future<void> init() async {
    try {
      // * initialization
      if (currentUid == null) return;
      await initializeNotificationsPermissions();
      await _globalFunctions.initializeNotification();
      String? messagingToken = await getMessagingToken();

      if (messagingToken != null) {
        log("Updating messaging token");
        await updateNotificationToken(token: messagingToken);
      }
      messaging.onTokenRefresh
          .listen((token) async => await updateNotificationToken(token: token));
      await subscribeToNotificationTopicsAccordingToUserPreferences();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async =>
          _globalFunctions.showNotification(message));

      log("Notifications initialized");
    } catch (e) {
      log("Error initializing notifications");
      log(e.toString());
    }
  }

  Future<String?> getMessagingToken() async {
    log("generating messaging token");
    String? messagingToken = await messaging.getToken();
    log('messagingToken: $messagingToken');
    return messagingToken;
  }

  Future<void> subscribeToTopic({
    required String topic,
  }) async {
    log("subscribing to topic: $topic");
    try {
      await messaging.subscribeToTopic(topic);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> unsubscribeFromTopic({required String topic}) async {
    try {
      await messaging.unsubscribeFromTopic(topic);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateNotificationToken({required String token}) async {
    try {
      if (currentUid == null) return;
      await firestore
          .collection('users')
          .doc(currentUid)
          .update({'userSettings.fcmToken': token});
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> subscribeToNotificationTopicsAccordingToUserPreferences() async {
    final currentUser =
        await firestore.collection('users').doc(currentUid).get();

    UserModel user =
        UserModel.fromMap(currentUser.data() as Map<String, dynamic>);
    log("subscribing to topics according to user preferences which is ${user.userSettings?.motivationalQuoteReminderFrequency}");
    await _subscribeToTopics(
        user.userSettings?.motivationalQuoteReminderFrequency ?? 3);
  }

  Future<void> _subscribeToTopics(int notificationFrequency) async {
    switch (notificationFrequency) {
      case 3:
        await _subscribeToThreeNotificationsPerDay();
        break;
      case 4:
        await _subscribeToFourNotificationsPerDay();
        break;
      case 5:
        await _subscribeToFiveNotificationsPerDay();
        break;
      case 6:
        await _subscribeToSixNotificationsPerDay();
        break;
      case 7:
        await _subscribeToSevenNotificationsPerDay();
        break;
      default:
        await _subscribeToThreeNotificationsPerDay();
    }
  }

  Future<void> _subscribeToThreeNotificationsPerDay() async {
    await subscribeToTopic(topic: NotificationTopics.twelvePmTopic);
    await subscribeToTopic(topic: NotificationTopics.threePmTopic);
    await subscribeToTopic(topic: NotificationTopics.sixPmTopic);
  }

  Future<void> _subscribeToFourNotificationsPerDay() async {
    await _subscribeToThreeNotificationsPerDay();
    await subscribeToTopic(topic: NotificationTopics.ninePmTopic);
  }

  Future<void> _subscribeToFiveNotificationsPerDay() async {
    await _subscribeToFourNotificationsPerDay();
    await subscribeToTopic(topic: NotificationTopics.twelveAmTopic);
  }

  Future<void> _subscribeToSixNotificationsPerDay() async {
    await _subscribeToFiveNotificationsPerDay();
    await subscribeToTopic(topic: NotificationTopics.threeAmTopic);
  }

  Future<void> _subscribeToSevenNotificationsPerDay() async {
    await _subscribeToSixNotificationsPerDay();
    await subscribeToTopic(topic: NotificationTopics.sixAmTopic);
  }

  Future<void> unsubscribeFromAllTopics() async {
    // call this on logout
    await unsubscribeFromTopic(topic: NotificationTopics.twelvePmTopic);
    await unsubscribeFromTopic(topic: NotificationTopics.threePmTopic);
    await unsubscribeFromTopic(topic: NotificationTopics.sixPmTopic);
    await unsubscribeFromTopic(topic: NotificationTopics.ninePmTopic);
    await unsubscribeFromTopic(topic: NotificationTopics.twelveAmTopic);
    await unsubscribeFromTopic(topic: NotificationTopics.threeAmTopic);
    await unsubscribeFromTopic(topic: NotificationTopics.sixAmTopic);
  }

  Future<void> removeFCMTokenFromFirebase() async {
    await updateNotificationToken(token: "");
  }
}
