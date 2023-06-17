import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';

import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/models/goals_model.dart';

import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/screens/goal_creation_screen.dart';
import 'package:motiv8_ai/screens/goal_task_screen.dart';
import 'package:motiv8_ai/screens/goals_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';
import 'package:motiv8_ai/widgets/home_screen_appbar.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  User? currentUser;
  String motivationQuote = "";

  Widget _buildQuoteWidget({required String quote, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset("assets/quotes.svg"),
        const SizedBox(height: 5.0),
        Text(
          quote,
          style: GoogleFonts.poppins(
              fontSize: 14, color: color, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  void navigateToGoalCreationScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GoalCreationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final showNotificationOnClick = ref.read(notificationButtonProvider);
    final theme = ref.watch(themeProvider);

    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }

    final motivationalQuoteAsync =
        ref.watch(getMotivationalQuoteProvider('Random'));
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          heroTag: null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: theme.primaryColor,
          onPressed: () {
            // Add your onPressed code here!

            HapticFeedback.heavyImpact();
            Navigator.of(context).push(GoalCreationScreen.route());

            // navigateToGoalCreationScreen(context);
          },
          child: Icon(
            Icons.add,
            size: 30,
            color: theme.colorScheme.surface,
          ),
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
              children: motivationalQuoteAsync.when(
                loading: () => [const SizedBox()],
                error: (error, stack) => [const SizedBox()],
                data: (quote) => [
                  if (quote.isNotEmpty) ...[
                    _buildQuoteWidget(quote: quote, color: Colors.black),
                  ] else ...[
                    _buildQuoteWidget(
                      quote:
                          "\"Dream big, work hard, stay focused and surround yourself with positive people who believe in you'",
                      color: Colors.black,
                    ),
                  ],
                ],
              ),
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
          ref.watch(getGoalTaskStreamProvider(currentUser!.uid)).when(
                data: (goalTasks) {
                  if (goalTasks.isNotEmpty) {
                    Random random = Random();
                    int randomHour = random.nextInt(24);
                    int randomMinute = random.nextInt(60);
                    int percentage = random.nextInt(10);
                    DateTime goalDate =
                        DateTime.now().add(Duration(days: goalTasks.length));
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
                              'My Tasks',
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
                            itemCount: goalTasks.length,
                            itemBuilder: (context, index) {
                              final goalTask = goalTasks[index];
                              return GoalCard(
                                goalTaskModel: goalTask,
                                goalDate: goalTask.date,
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
                          GestureDetector(
                            onTap: () {
                              navigateToGoalCreationScreen(context);
                            },
                            child: SvgPicture.asset('assets/nogoals.svg',
                                semanticsLabel: 'Acme Logo'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Tap + to add your Goal",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
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
//  List<Goal> generateRandomGoals(int count) {
//     List<Goal> goals = [];
//     Random random = Random();

//     for (int i = 0; i < count; i++) {
//       int randomHour = random.nextInt(24);
//       int randomMinute = random.nextInt(60);
//       int percentage = random.nextInt(10);
//       String title = "Goal ${i + 1}";
//       String description = "Description for Goal ${i + 1}";
//       DateTime goalDate = DateTime.now().add(Duration(days: i));
//       String alarmTime = "${randomHour}:${randomMinute} pm";
//       String currentTime = "${DateTime.now().hour}:${DateTime.now().minute} pm";

//       goals.add(Goal(
//         id: i.toString(),
//         userID: '',
//         name: title,
//         description: description,
//         startDate: goalDate,
//         endDate: goalDate,
//       ));
//     }

//     return goals;
//   }final notificationButtonProvider = Provider<Function>((ref) {
//   final notificationService = ref.read(notificationServiceProvider);

//   void showNotificationOnClick() {
//     notificationService.showNotification(
//       id: 1,
//       title: 'Motiv8-AI',
//       body: 'This is a motivational notification',
//       payload: 'notification_payload',
//     );
//   }

//   return showNotificationOnClick;
// });