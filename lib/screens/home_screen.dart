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
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/user_model.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';
import 'package:motiv8_ai/widgets/home_screen_appbar.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';

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
        name: 'Ezana',
        subtitle: DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
        message: 'Have a nice day!',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     'Create and check daily goals',
              //     style: GoogleFonts.poppins(
              //       fontSize: 28,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.format_quote_sharp,
                      size: 25,
                    ),
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
                  // Padding(
                  //   padding: EdgeInsets.zero,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: List.generate(
                  //       10, // Number of goals
                  //       (index) {
                  //         Goal goal = generateRandomGoals(10)[index];
                  //         Random random = Random();
                  //         int randomHour = random.nextInt(24);
                  //         int randomMinute = random.nextInt(60);
                  //         String alarmTime = "${randomHour}:${randomMinute} pm";
                  //         String currentTime =
                  //             "${DateTime.now().hour}:${DateTime.now().minute} pm";
                  //         return GoalCard(
                  //           goalModel: goal,
                  //           goalDate: goal.startDate!,
                  //           alarmTime: alarmTime, // Set your alarm time here
                  //           currentTime:
                  //               currentTime, // Set your current time here
                  //           percentage: 10, // Set your percentage here
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),

                  // List your goals for the day here
                  ref.watch(getGoalsStreamProvider(currentUser!.uid)).when(
                        data: (goals) {
                          if (goals != null) {
                            print(goals);
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: goals.length,
                              itemBuilder: (context, index) {
                                final goal = goals[index];
                                Random random = Random();
                                int randomHour = random.nextInt(24);
                                int randomMinute = random.nextInt(60);
                                int percentage = random.nextInt(10);
                                DateTime goalDate = DateTime.now()
                                    .add(Duration(days: goals.length));
                                String alarmTime =
                                    "${randomHour}:${randomMinute} pm";
                                String currentTime =
                                    "${DateTime.now().hour}:${DateTime.now().minute} pm";

                                return GoalCard(
                                  goalModel: goal,
                                  goalDate: goalDate,
                                  alarmTime: alarmTime,
                                  currentTime: currentTime,
                                  percentage: 100,
                                );
                              },
                            );
                          } else {
                            return Center(child: Text('No goals available'));
                          }
                        },
                        loading: () => Center(child: CustomProgressIndicator()),
                        error: (error, _) => Text('Errorrrr: $error'),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
