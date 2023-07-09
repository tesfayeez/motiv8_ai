import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/animated_loading_indicator.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/goal_header_widget.dart';
import 'package:motiv8_ai/widgets/time_line_widget.dart';
import '../controllers/goal_controllers.dart';

class GoalTasksScreen extends ConsumerStatefulWidget {
  final bool isDirectNavigation;
  final Goal goal;

  GoalTasksScreen(
      {this.isDirectNavigation = false, required this.goal, Key? key})
      : super(key: key);

  static Route route(Goal goal) {
    return MaterialPageRoute(builder: (context) => GoalTasksScreen(goal: goal));
  }

  @override
  _GoalTasksScreenState createState() => _GoalTasksScreenState();
}

class _GoalTasksScreenState extends ConsumerState<GoalTasksScreen> {
  void addGoal(Goal goal, BuildContext context) {
    ref.read(goalControllerProvider.notifier).createGoal(
          goal: goal,
          context: context,
        );
    ref.read(taskListProvider.notifier).clear();
    ref.read(goalTaskListProvider.notifier).clear();
    Navigator.of(context).pushAndRemoveUntil(
      HomeViewScreen.route(),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.onBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... your code
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: GoalHeader(
                    goal: widget.goal,
                    addGoalCallback: () {
                      addGoal(widget.goal, context);
                    },
                    addTaskCallback: () {},
                  ),
                ),
              ),
              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Tasks & Timelines 📝 🕒',
                  style: GoogleFonts.poppins(
                      fontSize: 20, color: theme.colorScheme.tertiary),
                ),
              ),
              const SizedBox(height: 25),
              Consumer(
                builder: (context, ref, child) {
                  final taskListAsyncValue = ref
                      .watch(generateGoalTasksControllerProvider(widget.goal));
                  final taskList = ref.watch(taskListProvider);

                  return taskListAsyncValue.when(
                    data: (_) {
                      if (taskList.isNotEmpty) {
                        return Timeline(tasks: taskList);
                      } else {
                        return Center(
                            child: Column(
                          children: [
                            Text(
                              "No Tasks Available",
                              style: GoogleFonts.poppins(
                                  color: theme.colorScheme.onTertiary),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              splashColor: Colors.white,
                              onTap: () {},
                              child: Text(
                                '💡🗒️ AI Tasks',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            )
                          ],
                        ));
                      }
                    },
                    loading: () {
                      return Center(
                        child: AnimatedEmojiLoadingIndicator(hintText: 'tasks'),
                      );
                    },
                    error: (error, stackTrace) {
                      return const Center(child: Text("Error occurred"));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
