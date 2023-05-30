import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/user_model.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';
import 'package:motiv8_ai/widgets/home_screen_appbar.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';
import 'package:path_provider/path_provider.dart';

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

  List<Goal> generateRandomGoals(int count) {
    List<Goal> goals = [];
    Random random = Random();

    for (int i = 0; i < count; i++) {
      int randomHour = random.nextInt(24);
      int randomMinute = random.nextInt(60);
      int percentage = random.nextInt(10);
      String title = "Goal ${i + 1}";
      String description = "Description for Goal ${i + 1}";
      DateTime goalDate = DateTime.now().add(Duration(days: i));
      String alarmTime = "${randomHour}:${randomMinute} pm";
      String currentTime = "${DateTime.now().hour}:${DateTime.now().minute} pm";

      goals.add(Goal(
        id: i.toString(),
        userID: '',
        name: title,
        description: description,
        startDate: goalDate,
        endDate: goalDate,
      ));
    }

    return goals;
  }

  @override
  Widget build(BuildContext context) {
    final showNotificationOnClick = ref.read(notificationButtonProvider);

    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          print("Floating Action Button pressed");

          Navigator.of(context).push(
            AddGoalScreen.route(),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      backgroundColor: Colors.white,
      appBar: CustomHomeScreenAppBar(
        message: 'Have a nice day!',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/quotes.svg"),
                const SizedBox(height: 5.0),
                Text(
                  '\"Dream big,work hard,stay focused and surround your self with positive people who belive in you',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              thickness: 0.9,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10.0),
          CalendarView(key: widget.key),
          const SizedBox(height: 10.0),
          // List your goals for the day here

          //if you want to use sqllite
// ref.watch(goalsProvider).when(
          ref.watch(getGoalsStreamProvider(currentUser!.uid)).when(
                data: (goals) {
                  print("goals from home");
                  print(goals);
                  if (goals.isNotEmpty) {
                    Random random = Random();
                    int randomHour = random.nextInt(24);
                    int randomMinute = random.nextInt(60);
                    int percentage = random.nextInt(10);
                    DateTime goalDate =
                        DateTime.now().add(Duration(days: goals.length));
                    String alarmTime = "${randomHour}:${randomMinute} pm";
                    String currentTime =
                        "${DateTime.now().hour}:${DateTime.now().minute} pm";
                    return Column(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'My Goals',
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap:
                                true, // If you want to keep the list constrained to the minimum possible height
                            physics:
                                const NeverScrollableScrollPhysics(), // If you don't want the ListView to be scrollable
                            itemCount: goals.length,
                            itemBuilder: (context, index) {
                              final goal = goals[index];
                              return GoalCard(
                                goalModel: goal,
                                goalDate: goalDate,
                                alarmTime: alarmTime,
                                currentTime: currentTime,
                                percentage: 100,
                              );
                            },
                          ),
                        ],
                      )
                    ]);
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/nogoals.svg',
                              semanticsLabel: 'Acme Logo'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Tap + to add your Goal",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
                loading: () => Center(child: CustomProgressIndicator()),
                error: (error, _) => Text('Error: $error'),
              )
        ])),
      ),
    );
  }
}
