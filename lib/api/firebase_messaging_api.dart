// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:motiv8/commons/global_providers.dart';

// final firebaseMessagingServiceProvider =
//     Provider<FirebaseMessagingService>((ref) {
//   final firebaseMessaging = ref.read(firebaseMessagingProvider);
//   return FirebaseMessagingService(firebaseMessaging);
// });

// class FirebaseMessagingService {
//   FirebaseMessagingService(this._firebaseMessaging);

//   final FirebaseMessaging _firebaseMessaging;

//   Future initialize() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message: ${message.notification?.body}');
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message opened app: ${message.notification?.body}');
//     });
//   }
// }
