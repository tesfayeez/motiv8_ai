import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/goal_api.dart';
import 'package:motiv8_ai/commons/snack_bar_provider.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:uuid/uuid.dart';

final selectedTaskProvider = StateProvider<GoalTask?>((ref) => null);
final getGoalProgressStreamProvider =
    StreamProvider.autoDispose.family<GoalProgress, String>((ref, userID) {
  final goalController = ref.watch(goalControllerProvider.notifier);
  final selectedDate = ref.watch(calendarStateProvider).selectedDay;
  // print("Selected date $selectedDate");
  return goalController.getGoalTaskProgressStream(userID, selectedDate);
});

final goalControllerProvider =
    StateNotifierProvider<GoalController, bool>((ref) {
  return GoalController(
    ref: ref,
    goalAPI: ref.watch(goalApiProvider),
    scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
    navigatorKey: ref.watch(navigatorKeyProvider),
  );
});

final getGoalsStreamProvider =
    StreamProvider.autoDispose.family<List<Goal>, String>((ref, userID) {
  final goalController = ref.watch(goalControllerProvider.notifier);
  final selectedDate = ref.watch(calendarStateProvider).selectedDay;
  // print("Selected date $selectedDate");
  return goalController.getGoalsStream(userID, selectedDate);
});

final getAllGoalsStreamProvider =
    StreamProvider.autoDispose.family<List<Goal>, String>((ref, userID) {
  final goalController = ref.watch(goalControllerProvider.notifier);
  return goalController.getAllGoalsStream(userID);
});

final getGoalTaskStreamProvider =
    StreamProvider.autoDispose.family<List<GoalTask>, String>((ref, userID) {
  final goalController = ref.watch(goalControllerProvider.notifier);
  final selectedDate = ref.watch(calendarStateProvider).selectedDay;
  // print("Selected date $selectedDate");
  return goalController.getGoalTaskStream(userID, selectedDate);
});

final getGoalTaskSubtasksProvider =
    FutureProvider.autoDispose.family<List<String>, GoalTask>((ref, task) {
  final goalController = ref.watch(goalControllerProvider.notifier);

  // print("Selected date $selectedDate");
  return goalController.getGoalTaskSubtasks(task);
});

// final getGoalTaskStreamProvider =
//     StreamProvider.family<List<GoalTask>, String>((ref, goalId) {
//   final goalController = ref.watch(goalControllerProvider.notifier);
//   return goalController.getSingleGoalsStream(goalId);
// });

class GoalController extends StateNotifier<bool> {
  final GoalAPI _goalAPI;
  final Ref _ref;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;
  final GlobalKey<NavigatorState> _navigatorKey;

  GoalController({
    required Ref ref,
    required GoalAPI goalAPI,
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _ref = ref,
        _goalAPI = goalAPI,
        _scaffoldMessengerKey = scaffoldMessengerKey,
        _navigatorKey = navigatorKey,
        super(false);

  Future<void> createGoal({
    required BuildContext context,
    required Goal goal,
  }) async {
    state = true;
    final addedGoalTaskList = _ref.read(goalTaskListProvider);
    final String newGoalId = const Uuid().v4(); // Generate new Goal id

    // Check if addedGoalTaskList is not empty
    List<GoalTask>? updatedGoalTaskList;
    if (addedGoalTaskList.isNotEmpty) {
      // Update each GoalTask with the new Goal id
      updatedGoalTaskList = addedGoalTaskList.map((task) {
        DateTime combinedDateTime = DateTime(task.date.year, task.date.month,
            task.date.day, goal.reminderTime.hour, goal.reminderTime.minute);
        return task.copyWith(
          goalId: newGoalId,
          taskReminderTime: combinedDateTime,
        );
      }).toList();
    }

    Goal userGoal = goal.copyWith(id: newGoalId, tasks: updatedGoalTaskList);

    final res = await _goalAPI.createGoal(userGoal);
    res.fold(
      (l) => showSnackBar(l.message, context),
      (r) {
        goal = r;
        showSnackBar('Goal created', context);
      },
    );

    state = false;
  }

  Future<void> createGoalTask(
      {required String goalId,
      required GoalTask goalTask,
      required BuildContext context}) async {
    state = true;

    final res = await _goalAPI.createGoalTask(goalId, goalTask);
    res.fold((l) => showSnackBar(l.message, context), (r) {
      showSnackBar('Task Added', context);
    });

    state = false;
  }

  Future<void> updateGoal({
    required Goal goal,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _goalAPI.updateGoal(goal);
    res.fold((l) => showSnackBar(l.message, context), (r) {
      showSnackBar('Goal updated', context);
    });
    state = false;
  }

  Future<void> deleteGoal({
    required String goalId,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _goalAPI.deleteGoal(goalId);
    res.fold((l) => showSnackBar(l.message, context), (r) {
      showSnackBar('Goal deleted', context);
    });
    state = false;
  }

  // Stream<List<Goal>> getGoalsStream(String userID, DateTime? selectedDate) {
  //   // print("here at getGoalsStream $userID");
  //   // print("here at getGoalsStream $selectedDate");

  //   return _goalAPI.goalsStream(userID).map((snapshot) {
  //     List<Goal> goals = snapshot.docs
  //         .map((doc) => Goal.fromMap(doc.data()..['id'] = doc.id))
  //         .where((goal) {
  //       if (selectedDate != null) {
  //         return goal.startDate.day == selectedDate.day &&
  //             goal.startDate.month == selectedDate.month &&
  //             goal.startDate.year == selectedDate.year;
  //       } else {
  //         // Handle the case when selectedDate is null
  //         // For example, you can choose to include all goals
  //         return true;
  //       }
  //     }).toList();

  //     goals.forEach((goal) => print(goal)); // Print each goal

  //     return goals;
  //   });
  // }
  Stream<List<Goal>> getGoalsStream(String userID, DateTime? selectedDate) {
    return _goalAPI.goalsStream(userID).map((goals) {
      return goals.where((goal) {
        if (selectedDate != null) {
          return goal.startDate.day == selectedDate.day &&
              goal.startDate.month == selectedDate.month &&
              goal.startDate.year == selectedDate.year;
        } else {
          // Handle the case when selectedDate is null
          // For example, you can choose to include all goals
          return true;
        }
      }).toList();
    });
  }

  // Stream<List<Goal>> getAllGoalsStream(String userID) {
  //   return _goalAPI.goalsStream(userID).map((snapshot) {
  //     List<Goal> goals = snapshot.docs
  //         .map((doc) => Goal.fromMap(doc.data()..['id'] = doc.id))
  //         .toList();

  //     goals.sort((a, b) => a.startDate.compareTo(b.startDate));

  //     goals.forEach((goal) => print(goal)); // Print each goal

  //     return goals;
  //   });
  // }
  Stream<List<Goal>> getAllGoalsStream(String userID) {
    return _goalAPI.goalsStream(userID).map((goals) {
      goals.sort((a, b) => a.startDate.compareTo(b.startDate));

      return goals;
    });
  }

  // Stream<List<GoalTask>> getGoalTaskStream(
  //     String userID, DateTime? selectedDate) {
  //   return _goalAPI.goalsStream(userID).map((snapshot) {
  //     List<GoalTask> goalTasks = [];

  //     snapshot.docs.forEach((doc) {
  //       final goal = Goal.fromMap(doc.data()..['id'] = doc.id);
  //       final tasks = goal.tasks ?? []; // Retrieve the tasks from the goal

  //       final filteredTasks = tasks.where((task) =>
  //           task.date.day == selectedDate?.day &&
  //           task.date.month == selectedDate?.month &&
  //           task.date.year == selectedDate?.year);

  //       goalTasks
  //           .addAll(filteredTasks); // Add filtered tasks to the goalTasks list
  //     });

  //     goalTasks.forEach((goalTask) => print(goalTask)); // Print each goal task

  //     return goalTasks;
  //   });
  // }
  Stream<List<GoalTask>> getGoalTaskStream(
      String userID, DateTime? selectedDate) {
    return _goalAPI.goalsStream(userID).map((goals) {
      List<GoalTask> goalTasks = [];

      goals.forEach((goal) {
        final tasks = goal.tasks ?? []; // Retrieve the tasks from the goal

        final filteredTasks = tasks.where((task) {
          if (selectedDate != null) {
            return task.date.day == selectedDate.day &&
                task.date.month == selectedDate.month &&
                task.date.year == selectedDate.year;
          } else {
            // Handle the case when selectedDate is null
            // For example, you can choose to include all tasks
            return true;
          }
        });

        goalTasks
            .addAll(filteredTasks); // Add filtered tasks to the goalTasks list
      });

      return goalTasks;
    });
  }

  Stream<List<GoalTask>> getSingleGoalsStream(String goalId) {
    return _goalAPI.singleGoalStream(goalId).map((snapshot) {
      final goalData = snapshot.data();
      if (goalData == null || !goalData.containsKey('tasks')) {
        return []; // Return an empty list if the goal document or tasks field doesn't exist
      }

      final List<Map<String, dynamic>> tasks =
          List.from(goalData['tasks'] ?? []);

      final goalTasks =
          tasks.map((taskData) => GoalTask.fromMap(taskData)).toList();

      goalTasks.sort((a, b) => a.date
          .compareTo(b.date)); // Sort the goal tasks by date in ascending order

      // goalTasks.forEach((task) => print(task)); // Print each goal task

      return goalTasks;
    });
  }

  Future<List<String>> getGoalTaskSubtasks(GoalTask goalTask) async {
    try {
      final goalSnapshot =
          await _goalAPI.singleGoalStream(goalTask.goalId).first;
      final goalData = goalSnapshot.data();

      if (goalData == null || !goalData.containsKey('tasks')) {
        return []; // Return an empty list if the goal document or tasks field doesn't exist
      }

      final List<Map<String, dynamic>> tasks =
          List.from(goalData['tasks'] ?? []);

      // Find the specific task with the provided taskId
      final List<GoalTask> matchingTasks = tasks
          .map((taskData) => GoalTask.fromMap(taskData))
          .where((task) => task.id == goalTask.id)
          .toList();

      final GoalTask? matchingGoalTask =
          matchingTasks.isNotEmpty ? matchingTasks.first : null;

      if (matchingGoalTask == null || matchingGoalTask.subtasks == null) {
        return []; // Return an empty list if the task's subtasks don't exist
      }

      return matchingGoalTask.subtasks!;
    } catch (e) {
      print('Failed to get subtasks: $e');
      return [];
    }
  }

  Future<void> updateGoalTaskSubtasks(
      {required String goalId,
      required String taskId,
      required List<String> subtasks,
      required BuildContext context}) async {
    state = true;

    final res = await _goalAPI.updateGoalTaskSubtasks(goalId, taskId, subtasks);
    res.fold((l) => showSnackBar(l.message, context), (r) {
      showSnackBar('Subtasks Saved', context);
    });

    state = false;
  }

  Future<void> completeGoalTask({
    required GoalTask goalTask,
    required bool isComplete,
    required BuildContext context,
  }) async {
    state = true;

    // Get the goal that the task belongs to
    final goalRes = await _goalAPI.getGoal(goalTask.goalId);
    Goal goal = goalRes.fold((l) {
      showSnackBar(l.message, context);
      throw Exception('Failed to get goal');
    }, (r) => r);

    // Check if the tasks list in the goal is null
    if (goal.tasks == null) {
      // Handle the case when goal.tasks is null
      state = false;
      return;
    }

    // Find the index of the goalTask in the tasks list
    final taskIndex = goal.tasks!.indexWhere((task) => task.id == goalTask.id);
    if (taskIndex == -1) {
      // Handle the case when the task is not found
      state = false;
      return;
    }

    // Create a copy of the tasks list and update the specific task
    final updatedTasks = List<GoalTask>.from(goal.tasks!);
    updatedTasks[taskIndex] = goalTask.copyWith(isCompleted: isComplete);

    // Calculate the completed tasks count
    final completedTasksCount =
        updatedTasks.where((task) => task.isCompleted).length;
    print("$completedTasksCount completed task count");

    // Update the completed tasks count and tasks list in the goal
    final updatedGoal = goal.copyWith(
      completedTasks: completedTasksCount,
      tasks: updatedTasks,
    );

    // Update the goal in the database
    final res = await _goalAPI.updateGoal(updatedGoal);
    res.fold((l) => showSnackBar(l.message, context), (r) {});

    state = false;
  }

  Future<void> updateGoalTask({
    required GoalTask updatedGoalTask,
    required BuildContext context,
  }) async {
    try {
      // Get the goal that the task belongs to
      final goalRes = await _goalAPI.getGoal(updatedGoalTask.goalId);
      Goal goal = goalRes.fold((l) {
        showSnackBar(l.message, context);
        throw Exception('Failed to get goal');
      }, (r) => r);

      // Check if the tasks list in the goal is null
      if (goal.tasks == null) {
        // Handle the case when goal.tasks is null
        return;
      }

      // Find the index of the goalTask in the tasks list
      final taskIndex =
          goal.tasks!.indexWhere((task) => task.id == updatedGoalTask.id);
      if (taskIndex == -1) {
        // Handle the case when the task is not found
        return;
      }

      // Create a copy of the tasks list and update the specific task
      final updatedTasks = List<GoalTask>.from(goal.tasks!);
      updatedTasks[taskIndex] = updatedGoalTask;

      // Calculate the completed tasks count
      final completedTasksCount =
          updatedTasks.where((task) => task.isCompleted).length;

      // Update the completed tasks count and tasks list in the goal
      final updatedGoal = goal.copyWith(
        completedTasks: completedTasksCount,
        tasks: updatedTasks,
      );

      // Update the goal in the database
      final res = await _goalAPI.updateGoal(updatedGoal);
      res.fold((l) => showSnackBar(l.message, context),
          (r) => showSnackBar("Task Updated", context));
    } catch (e) {
      // Handle any errors here
      print(e);
    }
  }

  // state = false;
  // Stream<GoalProgress> getGoalTaskProgressStream(
  //     String userID, DateTime? selectedDate) {
  //   return _goalAPI.goalsStream(userID).map((snapshot) {
  //     List<GoalTask> goalTasks = [];
  //     int completedTaskCount = 0;

  //     snapshot.docs.forEach((doc) {
  //       final goal = Goal.fromMap(doc.data()..['id'] = doc.id);
  //       final tasks = goal.tasks ?? []; // Retrieve the tasks from the goal

  //       final filteredTasks = tasks.where((task) =>
  //           task.date.day == selectedDate?.day &&
  //           task.date.month == selectedDate?.month &&
  //           task.date.year == selectedDate?.year);

  //       goalTasks
  //           .addAll(filteredTasks); // Add filtered tasks to the goalTasks list

  //       // Increment the completedTaskCount if the task is completed
  //       filteredTasks.forEach((task) {
  //         if (task.isCompleted == true) {
  //           completedTaskCount++;
  //         }
  //       });
  //     });

  //     // goalTasks.forEach((goalTask) => print(goalTask)); // Print each goal task

  //     return GoalProgress(
  //         total: goalTasks.length,
  //         tasks: goalTasks,
  //         completedTaskCount: completedTaskCount);
  //   });
  // }
  Stream<GoalProgress> getGoalTaskProgressStream(
      String userID, DateTime? selectedDate) {
    return _goalAPI.goalsStream(userID).map((goals) {
      List<GoalTask> goalTasks = [];
      int completedTaskCount = 0;

      goals.forEach((goal) {
        final tasks = goal.tasks ?? []; // Retrieve the tasks from the goal

        final filteredTasks = tasks.where((task) {
          if (selectedDate != null) {
            return task.date.day == selectedDate.day &&
                task.date.month == selectedDate.month &&
                task.date.year == selectedDate.year;
          } else {
            // Handle the case when selectedDate is null
            // For example, you can choose to include all tasks
            return true;
          }
        });

        goalTasks
            .addAll(filteredTasks); // Add filtered tasks to the goalTasks list

        // Increment the completedTaskCount if the task is completed
        filteredTasks.forEach((task) {
          if (task.isCompleted == true) {
            completedTaskCount++;
          }
        });
      });

      return GoalProgress(
          total: goalTasks.length,
          tasks: goalTasks,
          completedTaskCount: completedTaskCount);
    });
  }

  void showSnackBar(String message, BuildContext context) {
    final snackbarController = _ref.watch(snackbarProvider.notifier);
    snackbarController.show(context, message);
  }
}

class GoalProgress {
  final List<GoalTask> tasks;
  final int total;
  final int completedTaskCount;

  GoalProgress(
      {required this.tasks,
      required this.completedTaskCount,
      required this.total});
}
