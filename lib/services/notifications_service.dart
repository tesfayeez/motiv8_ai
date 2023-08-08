import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
      // get user settings and then subscribe to topics according to settings
      // could be 1,2,3,4
      // await subscribeToTopic();
      if (messagingToken != null) {
        log("Updating messaging token");
        await updateNotificationToken(token: messagingToken);
      }
      messaging.onTokenRefresh
          .listen((token) async => await updateNotificationToken(token: token));

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
}
