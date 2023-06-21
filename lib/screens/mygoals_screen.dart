import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';

class MyGoalsScreen extends ConsumerWidget {
  final bool isDirectNavigation;
  const MyGoalsScreen({Key? key, this.isDirectNavigation = false})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.onBackground,
      appBar: CustomAppBar(
        title: 'My Goals',
        isBackPresent: isDirectNavigation
            ? false
            : ModalRoute.of(context)?.canPop ?? false,
        isCenterTitle: true,
        isClosePresent: false,
        isBottomLinePresent: true,
      ),
      body: SingleChildScrollView(
          child: ref
              .watch(getAllGoalsStreamProvider(
                  ref.watch(currentUserProvider)!.uid))
              .when(
                data: (goal) {
                  if (goal.isNotEmpty) {
                    Random random = Random();
                    int randomHour = random.nextInt(24);
                    int randomMinute = random.nextInt(60);
                    int percentage = random.nextInt(10);
                    DateTime goalDate =
                        DateTime.now().add(Duration(days: goal.length));
                    String alarmTime = "${randomHour}:${randomMinute} pm";
                    String currentTime =
                        "${DateTime.now().hour}:${DateTime.now().minute} pm";
                    return Column(children: [
                      ListView.builder(
                        shrinkWrap:
                            true, // If you want to keep the list constrained to the minimum possible height
                        physics:
                            const NeverScrollableScrollPhysics(), // If you don't want the ListView to be scrollable
                        itemCount: goal.length,
                        itemBuilder: (context, index) {
                          final goals = goal[index];
                          return GoalCard(
                            goalModel: goals,
                            goalDate: goals.startDate,
                            alarmTime: alarmTime,
                            currentTime: currentTime,
                            percentage: 100,
                          );
                        },
                      )
                    ]);
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // navigateToGoalCreationScreen(context);
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
                                color: theme.colorScheme.onTertiary),
                          )
                        ],
                      ),
                    );
                  }
                },
                loading: () => Center(child: CustomProgressIndicator()),
                error: (error, _) => Text('Error: $error'),
              )),
    );
  }
}
