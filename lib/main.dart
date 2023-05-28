import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/commons/ThemeData.dart';
import 'package:motiv8_ai/commons/global_providers.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/screens/general_login_screen.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/screens/onboarding_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  // Firebase.initializeApp();
  await container.read(firebaseInitializerProvider);

  tz.initializeTimeZones();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // FirebaseMessaging.instance.getToken().then((String? token) {
  //   assert(token != null);
  //   print("FCM Registration Token: $token");
  // });

  // Initialize the Firebase Messaging service
  // final firebaseMessagingService =
  //     container.read(firebaseMessagingServiceProvider);
  // await firebaseMessagingService.initialize();

  // Initialize the Local Notification service
  final localNotificationService = container.read(notificationServiceProvider);
  localNotificationService.initNotification();
  // NotificationServices().initNotification();

  bool isFirstTime =
      await checkIfFirstTime(); // Add your logic to determine if it's the first time launching the app

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: isFirstTime ? const OnboardingScreen() : const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      theme: themeData,
      title: 'Motiv8',
      home: ref.watch(currentUserProviderStream).when(
            data: (user) {
              if (user != null) {
                return const HomeViewScreen();
              }
              return const GeneralLoginScreen();
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}

// class MyApp extends ConsumerWidget {
//   const MyApp({Key? key}) : super(key: key);

//   Future<String> getDatabaseFilePath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = directory.path;
//     return path;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

//     return MaterialApp(
//       scaffoldMessengerKey: scaffoldMessengerKey,
//       navigatorKey: navigatorKey,
//       theme: themeData,
//       title: 'Motiv8',
//       home: ref.watch(currentUserProviderStream).when(
//             data: (user) {
//               if (user != null) {
//                 return const HomeViewScreen();
//               }
//               return const GeneralLoginScreen();
//             },
//             error: (error, st) => ErrorText(error: error.toString()),
//             loading: () => const LoadingPage(),
//           ),
//     );
//   }
// }

class ErrorText extends StatelessWidget {
  final String error;
  const ErrorText({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorText(error: error),
    );
  }
}

class NotificationServices {
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
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}

Future<bool> checkIfFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    await prefs.setBool('isFirstTime', false);
  }

  return isFirstTime;
}
