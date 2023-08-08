import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/goal%20header%20widgets/goal_header_master_widget.dart';
import 'package:motiv8_ai/widgets/goal_header_widget.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGoal = goal != null;
    final isGoalTask = goalTask != null;
    final theme = ref.watch(themeProvider);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: isGoal ? goal!.name : (goalTask?.name ?? 'Your Task'),
        isBackPresent: true,
        isBottomLinePresent: false,
        isCenterTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5, top: 5),
          child: Column(
            children: [
              StyledContainer(
                  child: PaddedColumn(
                    children: [
                      HeaderRow(
                        title: isGoal ? 'Your Goal 🎯' : goalTask!.name,
                        actionButtonColor: theme.colorScheme.primary,
                        showSubTask: isGoalTask,
                        showAddTask: isGoal,
                        showAddGoal: false,
                        showMarkComplete: isGoalTask,
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
                      ],
                      if (isGoal) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5, top: 5),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: CalendarView(),
                          ),
                        ),
                      ]
                    ],
                  ),
                  color: theme.colorScheme.onSecondaryContainer),
            ],
          ),
        ),
      )),
    );
  }
}

class SubtaskNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final GoalTask goalTask;
  final ProviderContainer container;
  bool areSubtasksSaved = false;
  bool areSubtasksGenerated = false;
  SubtaskNotifier(this.container, this.goalTask) : super(AsyncValue.data([])) {
    getSubtasks();
  }
  void markSubtasksAsSaved() {
    areSubtasksSaved = true;
    areSubtasksGenerated = false;
    print(
        "markSubtasksAsSaved has been called. areSubtasksSaved is now: $areSubtasksSaved");
  }

  void getSubtasks() async {
    state = const AsyncValue.loading();
    final tasksFuture =
        container.read(getGoalTaskSubtasksProvider(goalTask).future);
    final result = await AsyncValue.guard(() => tasksFuture);
    state = result;
  }

  void generateSubtasks() async {
    state = const AsyncValue.loading();
    final tasksFuture = container
        .read(generateGoalTaskSubtasksControllerProvider(goalTask).future);
    state = await AsyncValue.guard(() => tasksFuture);
    areSubtasksGenerated = true;
  }

  // void getSubtasks() async {
  //   state = const AsyncValue.loading();
  //   final tasksFuture = container
  //       .read(generateGoalTaskSubtasksControllerProvider(goalTask).future);
  //   state = await AsyncValue.guard(() => tasksFuture);
  // }

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

  void clearSubtasks() {
    state = AsyncValue.data([]);
  }
}

final subtaskNotifierProvider = StateNotifierProvider.family<SubtaskNotifier,
    AsyncValue<List<String>>, GoalTask>((ref, task) {
  return SubtaskNotifier(ref.container, task);
});

class SubtaskGenerator extends ConsumerWidget {
  final GoalTask goalTask;
  final bool showAddSubtask;
  final bool generateSubtasks;

  const SubtaskGenerator({
    Key? key,
    required this.goalTask,
    this.showAddSubtask = false,
    this.generateSubtasks = false,
  }) : super(key: key);

  void saveSubTasks(
      WidgetRef ref,
      bool isLocally,
      List<String> subtasks,
      BuildContext context,
      StateNotifierProvider<SubtaskNotifier, AsyncValue<List<String>>>
          subtaskProvider) {
    if (isLocally) {
      final newGoalTask = goalTask.copyWith(subtasks: subtasks);
    } else {
      final goalController = ref.read(goalControllerProvider.notifier);
      goalController.updateGoalTaskSubtasks(
          goalId: goalTask.goalId,
          taskId: goalTask.id,
          subtasks: subtasks,
          context: context);
    }
    ref.watch(subtaskProvider.notifier).markSubtasksAsSaved();
    print(
        "saveSubTasks has been called. markSubtasksAsSaved should have been called.");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isChecked = false;
    final theme = ref.watch(themeProvider);
    var subtaskProvider = subtaskNotifierProvider(goalTask);
    final subtaskNotifier = ref.watch(subtaskProvider);
    final areSubtasksTasksSaved =
        ref.watch(subtaskProvider.notifier).areSubtasksSaved;

    final areSubtasksGenerated =
        ref.watch(subtaskProvider.notifier).areSubtasksGenerated;

    return subtaskNotifier.when(
      data: (subtasks) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
            if (subtasks.isNotEmpty &&
                !areSubtasksTasksSaved &&
                areSubtasksGenerated) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      saveSubTasks(
                          ref, false, subtasks, context, subtaskProvider);
                    },
                    child: Text(
                      'Save Subtasks',
                      style: GoogleFonts.poppins(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (subtasks.isNotEmpty) ...[
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
                    ],
                  ),
                ),
            ],
            if (subtasks.isEmpty && showAddSubtask)
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
        return Center(child: CustomProgressIndicator());
      },
    );
  }
}
