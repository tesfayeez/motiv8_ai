import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/screens/task_view_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';
import 'package:motiv8_ai/widgets/home_screen_appbar.dart';
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
        SvgPicture.asset(
          "assets/quotes.svg",
          color: Colors.white,
          height: 25,
        ),
        const SizedBox(height: 5.0),
        Text(
          quote,
          style: GoogleFonts.poppins(
              fontSize: 14, color: color, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  void initState() {
    super.initState();
    print('init state');
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await scheduleNotifications();
    // });
  }

  Future<void> scheduleNotifications() async {
    final quotesAsyncValue = ref.watch(getMotivationalQuotesProvider(''));
    quotesAsyncValue.whenData((quotes) async {
      print(quotes);
      for (int i = 0; i < quotes.length; i++) {
        String quote = quotes[i];
        print(quote);
        var scheduledTime = DateTime.now().add(Duration(minutes: 1 * i));

        // Schedule the notification
        await ref.read(notificationServiceProvider).showNotificationAtTime(
              id: i,
              title: 'Motivational Quote',
              body: quote,
              scheduledTime: scheduledTime,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final showNotificationOnClick = ref.read(notificationButtonProvider);
    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }

    bool noTasks = false;

    final goalTaskProgress =
        ref.watch(getGoalProgressStreamProvider(currentUser!.uid));

    int tasks = goalTaskProgress.value?.tasks.length ?? 0;

    int completedTaskCount = goalTaskProgress.value?.completedTaskCount ?? 0;

    int? previousPercentage;
    final motivationalQuoteAsync =
        ref.watch(getMotivationalQuoteProvider('Lose 5lbs'));
// Calculate the current percentage
    int currentPercentage =
        tasks != 0 ? ((completedTaskCount / tasks) * 100).round() : 0;

    final isDarkTheme = theme.colorScheme.brightness == Brightness.dark;
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

            HapticFeedback.heavyImpact();
            // navigateToGoalCreationScreen(context);
            showAddGoalModal(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FutureBuilder<List<String>>(
              //   future: ref.watch(getMotivationalQuotesProvider('').future),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       // Show a loading indicator while fetching the quotes
              //       return Center(
              //         child: CustomProgressIndicator(),
              //       );
              //     } else if (snapshot.hasError) {
              //       // Show an error message if an error occurred
              //       return Text('Error occurred: ${snapshot.error}');
              //     } else {
              //       // Quotes data is available, schedule notifications
              //       final quotes = snapshot.data;
              //       if (quotes != null) {
              //         for (int i = 0; i < quotes.length; i++) {
              //           String quote = quotes[i];
              //           var now = DateTime.now();
              //           var scheduledTime = now.add(Duration(minutes: 5 * i));

              //           // Schedule the notification
              //           ref
              //               .read(notificationServiceProvider)
              //               .showNotificationAtTime(
              //                 id: i,
              //                 title: 'Motivation',
              //                 body: quote,
              //                 scheduledTime: scheduledTime,
              //               );
              //         }
              //       }

              //       // Return the desired widget after scheduling notifications
              //       return Container();
              //     }
              //   },
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: goalCardDarkThemeDecoration(
                        theme.colorScheme.primary, isDark)
                    .copyWith(borderRadius: BorderRadius.circular(20)),
                height: MediaQuery.of(context).size.width * 0.3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
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
                    if (completedTaskCount == 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: motivationalQuoteAsync.when(
                              loading: () => [const SizedBox()],
                              error: (error, stack) => [const SizedBox()],
                              data: (quote) => [
                                _buildQuoteWidget(
                                  quote:
                                      "\"Dream big, work hard, stay focused and surround yourself with positive people who believe in you'",
                                  color: isDarkTheme
                                      ? theme.colorScheme.tertiary
                                      : Colors.white,
                                )
                                // if (quote.isNotEmpty) ...[
                                //   _buildQuoteWidget(
                                //     quote: quote,
                                //     color: isDarkTheme
                                //         ? theme.colorScheme.tertiary
                                //         : Colors.white,
                                //   ),
                                // ] else ...[
                                //   _buildQuoteWidget(
                                //     quote:
                                //         "\"Dream big, work hard, stay focused and surround yourself with positive people who believe in you'",
                                //     color: isDarkTheme
                                //         ? theme.colorScheme.tertiary
                                //         : Colors.white,
                                //   ),
                                // ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (completedTaskCount >= 1) ...[
                      GestureDetector(
                        onLongPress: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                    "Tasks for the day",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: theme.colorScheme.surface),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        tasks.toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.surface),
                                      ),
                                      Text(
                                        tasks == 1 ? "Task" : "Tasks",
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: theme.colorScheme.surface),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              CircularStepProgressIndicator(
                                  totalSteps: tasks == 0 ? 1 : tasks,
                                  currentStep: completedTaskCount,
                                  stepSize: 8,
                                  selectedColor: theme.colorScheme.surface,
                                  unselectedColor: Colors.transparent,
                                  padding: 0,
                                  width: 95,
                                  height: 95,
                                  selectedStepSize: 7,
                                  roundedCap: (_, __) => true,
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Text(
                                        "$currentPercentage%",
                                        key: ValueKey<int>(
                                            currentPercentage), // Unique key is required for AnimatedSwitcher to distinguish between different children
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.surface,
                                          fontSize: 20,
                                        ),
                                      ),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        previousPercentage = currentPercentage;
                                        return TweenAnimationBuilder<int>(
                                          tween: IntTween(
                                              begin: previousPercentage,
                                              end: currentPercentage),
                                          duration: Duration(milliseconds: 500),
                                          builder: (BuildContext context,
                                              int? value, Widget? child) {
                                            return Text(
                                              value != null ? "$value%" : '0%',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    theme.colorScheme.surface,
                                                fontSize: 20,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Divider(
              //     thickness: 0.9,
              //     color: theme.colorScheme.tertiary,
              //   ),
              // ),
              // const SizedBox(height: 10.0),
              // CalendarView(key: widget.key),
              const SizedBox(height: 10.0),
              ref.watch(getGoalTaskStreamProvider(currentUser!.uid)).when(
                    data: (goalTasks) {
                      if (goalTasks.isNotEmpty) {
                        Random random = Random();
                        int randomHour = random.nextInt(24);
                        int randomMinute = random.nextInt(60);

                        String alarmTime = "${randomHour}:${randomMinute} pm";
                        String currentTime =
                            "${DateTime.now().hour}:${DateTime.now().minute} pm";
                        return Column(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
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
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/uit_calender.svg",
                                              color:
                                                  theme.colorScheme.onTertiary,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              DateFormat('EEEE, MMM d, yyyy')
                                                  .format(DateTime.now()),
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: theme
                                                    .colorScheme.onTertiary,
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
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          'My Tasks',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: theme.colorScheme.tertiary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: InkWell(
                                      // onTap: () => throw Exception(),
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        showAddGoalTaskModal(context, null);
                                      },

                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: cardBoxDecoration(
                                            theme.colorScheme.onPrimary,
                                            isDark),
                                        height: 40,
                                        width: 100,
                                        child: Text(
                                          "Add Task",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                        setState(() {
                          noTasks = true;
                        });
                        return Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // navigateToGoalCreationScreen(context);
                                  showAddGoalTaskModal(context, null);
                                },
                                child: SvgPicture.asset('assets/nogoals.svg',
                                    semanticsLabel: 'no goals Logo'),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Tap + to add your Task",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onTertiary,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    loading: () => SizedBox(),
                    error: (error, _) => Text('Error: $error'),
                  ),
            ],
          ),
        ),
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