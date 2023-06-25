import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';

import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';

import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/models/goals_model.dart';

import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/screens/goal_creation_screen.dart';
import 'package:motiv8_ai/screens/goal_task_screen.dart';
import 'package:motiv8_ai/screens/goals_screen.dart';
import 'package:motiv8_ai/screens/task_view_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';
import 'package:motiv8_ai/widgets/home_screen_appbar.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
    final isDark = theme.colorScheme.brightness == Brightness.dark;

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
          backgroundColor: theme.colorScheme.primary,
          onPressed: () {
            // Add your onPressed code here!
            Goal sampleGoal = Goal(
              id: '1',
              name: 'Fitness Journey',
              userID: '123',
              description: 'Achieve a healthy and fit lifestyle',
              startDate: DateTime(2023, 1, 1),
              endDate: DateTime(2023, 12, 31),
              reminderFrequency: 'Daily',
              tasks: [],
              milestones: 'Lose 10 pounds',
              taskBreakdownPreference: 'Weekly',
              definitionOfSuccess: 'Improved stamina and strength',
              strategiesApproaches: 'Work with a personal trainer',
              timelineFlexibility: 'Moderate',
              timeCommitment: '1 hour per day',
            );
            HapticFeedback.heavyImpact();
            // Navigator.of(context).push(GoalTasksScreen.route(sampleGoal));
            // Navigator.of(context).push(GoalCreationScreen.route());

            navigateToGoalCreationScreen(context);
          },
          child: Icon(
            Icons.add,
            size: 30,
            color: theme.colorScheme.surface,
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.onBackground,
      appBar: CustomHomeScreenAppBar(
        appBarColor: theme.colorScheme.onBackground,
        textColor: theme.colorScheme.tertiary,
        message: 'Have a nice day!',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration:
                goalCardDarkThemeDecoration(theme.colorScheme.primary, isDark)
                    .copyWith(borderRadius: BorderRadius.circular(30)),
            height: MediaQuery.of(context).size.width * 0.28,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/dogerblue.jpg',
                      fit: BoxFit
                          .cover, // Use this to have the image cover the entire Stack.
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Daily Progress",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.surface),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Total Tasks dones",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: theme.colorScheme.surface),
                            ),
                            Row(
                              children: [
                                Text(
                                  "8",
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.surface),
                                ),
                                Text(
                                  "Tasks",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.surface),
                                )
                              ],
                            )
                          ],
                        ),
                        CircularStepProgressIndicator(
                          totalSteps: 10,
                          currentStep: 8,
                          stepSize: 8,
                          selectedColor: theme.colorScheme.surface,
                          unselectedColor: Colors.transparent,
                          padding: 0,
                          width: 80,
                          height: 80,
                          selectedStepSize: 7,
                          roundedCap: (_, __) => true,
                          child: Center(
                              child: Text(
                            '10%',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.surface,
                              fontSize: 20,
                            ),
                          )),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: motivationalQuoteAsync.when(
          //       loading: () => [const SizedBox()],
          //       error: (error, stack) => [const SizedBox()],
          //       data: (quote) => [
          //         if (quote.isNotEmpty) ...[
          //           _buildQuoteWidget(
          //             quote: quote,
          //             color: theme.colorScheme.tertiary,
          //           ),
          //         ] else ...[
          //           _buildQuoteWidget(
          //             quote:
          //                 "\"Dream big, work hard, stay focused and surround yourself with positive people who believe in you'",
          //             color: theme.colorScheme.tertiary,
          //           ),
          //         ],
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              thickness: 0.9,
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 10.0),
          CalendarView(key: widget.key),

          const SizedBox(height: 10.0),
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
                              'Today',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/uit_calender.svg",
                                  color: theme.colorScheme.onTertiary,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  DateFormat('EEEE, MMM d, yyyy')
                                      .format(DateTime.now()),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: theme.colorScheme.onTertiary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'My Tasks',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
                                onTap: () {
                                  Navigator.of(context).push(
                                      GoalOrTaskScreen.route(
                                          goalTask: goalTask));
                                },
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
                              color: theme.colorScheme.tertiary,
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

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   User? currentUser;
//   String motivationQuote = "";

//   Widget _buildQuoteWidget({required String quote, required Color color}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SvgPicture.asset("assets/quotes.svg"),
//         const SizedBox(height: 5.0),
//         Text(
//           quote,
//           style: GoogleFonts.poppins(
//               fontSize: 14, color: color, fontWeight: FontWeight.w400),
//         ),
//       ],
//     );
//   }

//   void navigateToGoalCreationScreen(BuildContext context) {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             GoalCreationScreen(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0, 1),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final showNotificationOnClick = ref.read(notificationButtonProvider);
//     final theme = ref.watch(themeProvider);

//     if (ref.watch(currentUserProvider) != null) {
//       currentUser = ref.watch(currentUserProvider);
//     }
//     final motivationalQuoteAsync =
//         ref.watch(getMotivationalQuoteProvider('Random'));
//     return Scaffold(
//         floatingActionButton: SizedBox(
//           height: 50,
//           width: 50,
//           child: FloatingActionButton(
//             heroTag: null,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             backgroundColor: theme.primaryColor,
//             onPressed: () {
//               // Add your onPressed code here!

//               HapticFeedback.heavyImpact();
//               Navigator.of(context).push(GoalCreationScreen.route());

//               // navigateToGoalCreationScreen(context);
//             },
//             child: Icon(
//               Icons.add,
//               size: 30,
//               color: theme.colorScheme.surface,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         appBar: CustomHomeScreenAppBar(message: 'exana'),
//         body: SafeArea(
//             child: CustomScrollView(slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: motivationalQuoteAsync.when(
//                     loading: () => [const SizedBox()],
//                     error: (error, stack) => [const SizedBox()],
//                     data: (quote) => [
//                           if (quote.isNotEmpty) ...[
//                             _buildQuoteWidget(
//                                 quote: quote, color: Colors.black),
//                           ] else ...[
//                             _buildQuoteWidget(
//                               quote:
//                                   "\"Dream big, work hard, stay focused and surround yourself with positive people who believe in you'",
//                               color: Colors.black,
//                             )
//                           ]
//                         ]),
//               ),
//             ),
//           ),
//           const SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.0),
//               child: Divider(
//                 thickness: 0.9,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//           SliverPersistentHeader(
//             delegate: _SliverAppBarDelegate(
//               minHeight: 60.0,
//               maxHeight: 200.0,
//               child: Container(
//                 color: Colors.white,
//                 child: CalendarView(key: widget.key),
//               ),
//             ),
//             pinned: true,
//           ),
//           const SliverPadding(
//             padding: EdgeInsets.only(top: 10.0),
//           ),
//           ref.watch(getGoalTaskStreamProvider(currentUser!.uid)).when(
//                 data: (goalTasks) {
//                   if (goalTasks.isNotEmpty) {
//                     if (goalTasks.isNotEmpty) {
//                       Random random = Random();
//                       int randomHour = random.nextInt(24);
//                       int randomMinute = random.nextInt(60);
//                       int percentage = random.nextInt(10);
//                       DateTime goalDate =
//                           DateTime.now().add(Duration(days: goalTasks.length));
//                       String alarmTime = "${randomHour}:${randomMinute} pm";
//                       String currentTime =
//                           "${DateTime.now().hour}:${DateTime.now().minute} pm";

//                       return SliverToBoxAdapter(
//                         child: Align(
//                           alignment: Alignment.topCenter,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10.0),
//                                 child: Text(
//                                   'My Tasks',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 25,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               ...goalTasks.map((goalTask) => GoalCard(
//                                     goalTaskModel: goalTask,
//                                     goalDate: goalTask.date,
//                                     alarmTime: alarmTime,
//                                     currentTime: currentTime,
//                                     percentage: 100,
//                                   )),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                   } else {
//                     return SliverToBoxAdapter(
//                       child: Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               navigateToGoalCreationScreen(context);
//                             },
//                             child: SvgPicture.asset('assets/nogoals.svg',
//                                 semanticsLabel: 'Acme Logo'),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             "Tap + to add your Goal",
//                             style: GoogleFonts.poppins(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           )
//                         ],
//                       ),
//                     );
//                   }
//                   return Container();
//                 },
//                 loading: () => SliverFillRemaining(
//                   child: CustomProgressIndicator(),
//                 ),
//                 error: (error, _) => SliverFillRemaining(
//                   child: Text('Error: $error'),
//                 ),
//               )
//         ])));
//   }
// }

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: MyDelegate(),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item ${index + 1}'),
                  );
                },
                childCount: 100, // number of items in the list
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 150.0,
      color: Colors.lightBlue,
      alignment: Alignment.center,
      child: Text(
        'I stick',
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 150.0;

  @override
  double get minExtent => 150.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
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