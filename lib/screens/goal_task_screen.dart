import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/widgets/animated_loading_indicator.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/goal_header_widget.dart';

import 'package:motiv8_ai/widgets/time_line_widget.dart';
import 'package:uuid/uuid.dart';

import '../controllers/goal_controllers.dart';

class GoalTasksScreen extends ConsumerStatefulWidget {
  final bool isDirectNavigation;
  final Goal? goal;

  GoalTasksScreen({this.isDirectNavigation = false, this.goal, Key? key})
      : super(key: key);

  static Route route(Goal? goal) {
    return MaterialPageRoute(builder: (context) => GoalTasksScreen(goal: goal));
  }

  @override
  _GoalTasksScreenState createState() => _GoalTasksScreenState();
}

class _GoalTasksScreenState extends ConsumerState<GoalTasksScreen> {
  @override
  void initState() {
    super.initState();
    generateRandomWeeklyTasks(widget.goal!);
  }

  List<GoalTask> tasks = [];
  List<GoalTask> generateRandomWeeklyTasks(Goal goal) {
    DateTime currentDate = goal.startDate ?? DateTime.now();
    DateTime endDate = goal.endDate ?? DateTime.now();
    Random random = Random();

    while (currentDate.isBefore(endDate)) {
      // Generate a random task for each week
      if (goal.taskBreakdownPreference == 'Weekly') {
        int randomDay = random.nextInt(7) + 1; // Generate a random day (1-7)
        tasks.add(
          GoalTask(
            id: const Uuid().v4(),
            name: 'Weekly Task $randomDay',
            description: 'This is a random task for ${currentDate.weekday}',
            date: currentDate.add(
              Duration(days: randomDay),
            ),
          ),
        );
      }

      // Move to the next week
      currentDate = currentDate.add(const Duration(days: 7));
    }

    return tasks;
  }

  bool isDoneLoadingTasks = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isCenterTitle: true,
        title: 'Goal Builder 🚀',
        isBackPresent: true,
        isClosePresent: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: GoalHeader(
                    goal: widget.goal,
                    goalTaskCallback: () {
                      ref.watch(goalControllerProvider.notifier).createGoal(
                          name: widget.goal!.name,
                          description: widget.goal!.description,
                          startDate: widget.goal!.startDate,
                          endDate: widget.goal!.endDate,
                          reminderFrequency: '',
                          tasks: [],
                          context: context,
                          userID: ref.watch(currentUserProvider)!.uid);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Tasks & Timelines 📝 🕒',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Timeline(
              //   tasks: tasks,
              // ),
              Consumer(
                builder: (context, ref, child) {
                  final taskListAsyncValue = ref
                      .watch(generateGoalTasksControllerProvider(widget.goal!));

                  return taskListAsyncValue.when(
                    data: (tasks) {
                      if (tasks.isNotEmpty) {
                        isDoneLoadingTasks = true;

                        return Timeline(tasks: tasks);
                      } else {
                        return const Center(
                          child: Text("No tasks available"),
                        );
                      }
                    },
                    loading: () =>
                        Center(child: AnimatedEmojiLoadingIndicator()),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              if (isDoneLoadingTasks)
                Center(
                  child: CustomButton(text: 'Add Goal', onPressed: () {}),
                )
            ],
          ),
        ),
      ),
    );
  }
}


// Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: taskListAsyncValue != null
//             ? taskListAsyncValue!.when(
//                 data: (tasks) {
//                   // Render the list of tasks

//                   if (tasks.isNotEmpty) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: tasks.length,
//                       itemBuilder: (context, index) {
//                         final task = tasks[index];

//                         return ListTile(
//                           title: Text(task.name),
//                           subtitle: Text(task.description),
//                           trailing: Text(task.date.toString()),
//                         );
//                       },
//                     );
//                   } else {
//                     return Center(
//                       child: Text("No tasks available"),
//                     );
//                   }
//                 },
//                 loading: () => const Center(child: CircularProgressIndicator()),
//                 error: (error, stackTrace) {
//                   // Handle error state
//                   return Text('Error: $error');
//                 },
//               )
//             : Center(
//                 child: Text("No tasks available"),
//               ),
//       )