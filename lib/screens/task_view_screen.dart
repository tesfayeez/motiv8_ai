import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/animated_loading_indicator.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/goal%20header%20widgets/goal_header_master_widget.dart';
import 'package:motiv8_ai/widgets/goal_header_widget.dart';

class GoalOrTaskScreen extends ConsumerWidget {
  final GoalTask? goalTask;
  final Goal? goal;
  const GoalOrTaskScreen({Key? key, this.goal, this.goalTask})
      : super(key: key);

  static Route route({Goal? goal, GoalTask? goalTask}) {
    return MaterialPageRoute(
      builder: (context) => GoalOrTaskScreen(
        goal: goal,
        goalTask: goalTask,
      ),
    );
  }

  dynamic getGoalOrTask() {
    if (goalTask != null) {
      return goalTask;
    } else if (goal != null) {
      return goal;
    } else {
      print('Both goal and goalTask cannot be null');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalOrTask = getGoalOrTask();
    final isGoal = goal != null;
    final isGoalTask = goalTask != null;
    final theme = ref.read(themeProvider);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: goalOrTask.name ?? 'Your Goal',
        isBackPresent: true,
        isBottomLinePresent: true,
        isCenterTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5, top: 10),
          child: Column(children: [
            StyledContainer(
                child: PaddedColumn(children: [
                  HeaderRow(
                    title: isGoal ? 'Your Goal 🎯' : goalTask!.name,
                    actionButtonColor: theme.colorScheme.primary,
                    showSubTask: isGoalTask,
                    showAddTask: isGoal,
                    showAddGoal: false,
                  ),
                  const SizedBox(height: 8.0),
                  GoalDescriptionText(
                    description:
                        isGoal ? goal!.description : goalTask!.description,
                    isGoalPresent: isGoal,
                    color: theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 10),
                  if (isGoal) ...[
                    GoalDateRow(
                      startDate: goal!.startDate,
                      endDate: goal!.endDate,
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (isGoal) ...[
                    TaskListConsumer(
                      goalTaskList: goal!.tasks!,
                      isGoalPresent: isGoal,
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
                  if (isGoalTask) ...[
                    SubtaskGenerator(
                      goalTask: goalTask!,
                    )
                  ]
                ]),
                color: theme.colorScheme.onSecondaryContainer)
          ]),
        ),
      )),
    );
  }
}

class SubtaskNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final GoalTask goalTask;
  final ProviderContainer container;

  SubtaskNotifier(this.container, this.goalTask) : super(AsyncValue.data([]));

  void generateSubtasks() async {
    state = const AsyncValue.loading();
    final tasksFuture = container
        .read(generateGoalTaskSubtasksControllerProvider(goalTask).future);
    state = await AsyncValue.guard(() => tasksFuture);
  }

  void addOneSubtask(String subtask) {
    state.whenData((subtasks) {
      // Add the new subtask to the existing list
      final newSubtasks = List<String>.from(subtasks)..add(subtask);
      state = AsyncValue.data(newSubtasks);
    });
  }

  void addSubtasks(List<String> newSubtasks) {
    state.whenData((subtasks) {
      // Add all new subtasks to the existing list
      final updatedSubtasks = List<String>.from(subtasks)..addAll(newSubtasks);
      state = AsyncValue.data(updatedSubtasks);
    });
  }

  void deleteSubtask(String subtask) {
    state.whenData((subtasks) {
      // Remove the subtask from the list
      final newSubtasks = List<String>.from(subtasks);
      newSubtasks.remove(subtask);
      state = AsyncValue.data(newSubtasks);
    });
  }
}

final subtaskNotifierProvider = StateNotifierProvider.family<SubtaskNotifier,
    AsyncValue<List<String>>, GoalTask>((ref, task) {
  return SubtaskNotifier(ref.container, task);
});

class SubtaskGenerator extends ConsumerWidget {
  final GoalTask goalTask;

  const SubtaskGenerator({Key? key, required this.goalTask}) : super(key: key);

  void saveSubTasks(bool isLocally, List<String> subtasks) {
    if (isLocally) {
      final newGoalTask = goalTask.copyWith(subtasks: subtasks);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeProvider);
    var subtaskProvider = subtaskNotifierProvider(goalTask);
    final subtaskNotifier = ref.watch(subtaskProvider);

    return subtaskNotifier.when(
      data: (subtasks) {
        return Column(
          children: [
            if (subtasks.isEmpty)
              Center(
                child: TextButton(
                  child: Text(
                    'Generate Subtasks',
                    style: GoogleFonts.poppins(),
                  ),
                  onPressed: () {
                    ref.watch(subtaskProvider.notifier).generateSubtasks();
                  },
                ),
              ),
            if (subtasks.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        ref
                            .watch(subtaskProvider.notifier)
                            .addSubtasks(subtasks);
                      },
                      child: Text('Save Subtasks')),
                ],
              ),
              for (String subtask in subtasks)
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  padding: EdgeInsets.all(10),
                  decoration: goalCardTimeLineboxDecoration(
                      false, theme.colorScheme.secondary),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          subtask,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      InkWell(
                        child: Ink(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            height: 20,
                            width: 20,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {},
                      )
                    ],
                  ),
                ),
            ],
            if (subtasks.isEmpty)
              Text(
                "No subtasks Available",
                style: GoogleFonts.poppins(color: theme.colorScheme.onTertiary),
              ),
          ],
        );
      },
      error: (error, stacktrace) {
        return const Center(child: Text("Error occurred"));
      },
      loading: () {
        return Center(child: AnimatedEmojiLoadingIndicator('subtasks'));
      },
    );
  }
}
