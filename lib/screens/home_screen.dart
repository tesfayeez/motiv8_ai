import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';
import 'package:motiv8_ai/widgets/home_screen_appbar.dart';

final notificationButtonProvider = Provider<Function>((ref) {
  final notificationService = ref.read(notificationServiceProvider);

  void showNotificationOnClick() {
    notificationService.showNotification(
      id: 1,
      title: 'Motiv8-AI',
      body: 'This is a motivational notification',
      payload: 'notification_payload',
    );
  }

  return showNotificationOnClick;
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  User? currentUser;

  List<Widget> generateRandomGoalCards(int count) {
    List<Widget> cards = [];
    Random random = Random();

    for (int i = 0; i < count; i++) {
      int randomHour = random.nextInt(24);
      int randomMinute = random.nextInt(60);
      double percentage = random.nextDouble();
      String title = "Goal ${i + 1}";
      String description = "Description for Goal ${i + 1}";
      DateTime goalDate = DateTime.now().add(Duration(days: i));
      String alarmTime = "${randomHour}:${randomMinute} pm";
      String currentTime = "${DateTime.now().hour}:${DateTime.now().minute} pm";

      cards.add(GoalCard(
        title: title,
        description: description,
        goalDate: goalDate,
        alarmTime: alarmTime,
        currentTime: currentTime,
        percentage: percentage,
      ));
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    final showNotificationOnClick = ref.read(notificationButtonProvider);
    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomHomeScreenAppBar(
          name: "Ezana",
          subtitle: DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
          message: 'Have a nice day!'),
      // floatingActionButton: SizedBox(
      //   height: 50.0, // Specify the height of the button
      //   width: 50.0, // Specify the width of the button
      //   child: FittedBox(
      //     child: FloatingActionButton(
      //       onPressed: () => Navigator.of(context).push(AddGoalScreen.route()),
      //       // Set the shape of the button to be square
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       child: const Icon(
      //         Icons.add,
      //         color: Colors.blue,
      //       ),
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Create and check daily goals',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              CalendarView(key: widget.key),
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 0.9,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: generateRandomGoalCards(10),
              )

              // Card(
              //   elevation: 1.0,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Tasks for the day',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(
              //           height: 10,
              //         ),
              //         // List your goals for the day here
              //         ref.watch(getGoalsStreamProvider(currentUser!.uid)).when(
              //               data: (goals) {
              //                 return ListView.builder(
              //                   shrinkWrap: true,
              //                   itemCount: goals.length,
              //                   itemBuilder: (context, index) {
              //                     final goal = goals[index];

              //                     return GoalCard(goal: goal);
              //                   },
              //                 );
              //               },
              //               loading: () => const CircularProgressIndicator(),
              //               error: (error, _) => Text('Error: $error'),
              //             ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
