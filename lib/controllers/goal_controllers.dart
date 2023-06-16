import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/chat_api.dart';
import 'package:motiv8_ai/api/goal_api.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:uuid/uuid.dart';

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

final getGoalTasStreamProvider =
    StreamProvider.family<List<GoalTask>, String>((ref, goalId) {
  final goalController = ref.watch(goalControllerProvider.notifier);
  return goalController.getSingleGoalsStream(goalId);
});

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
    required String name,
    required String description,
    required DateTime? startDate,
    required DateTime? endDate,
    required String reminderFrequency,
    required List<GoalTask> tasks,
    required BuildContext context,
    required String userID,
  }) async {
    state = true;
    Goal goal = Goal(
      id: const Uuid().v4(),
      name: name,
      userID: userID,
      description: description,
      startDate: startDate,
      endDate: endDate,
      reminderFrequency: '',
      tasks: tasks,
    );

    final res = await _goalAPI.createGoal(goal);
    res.fold((l) => showSnackBar(l.message), (r) {
      goal = r;
      showSnackBar('Goal created');
    });

    state = false;
  }

  Future<void> createGoalTask({
    required String goalId,
    required GoalTask goalTask,
  }) async {
    state = true;

    final res = await _goalAPI.createGoalTask(goalId, goalTask);
    res.fold((l) => showSnackBar(l.message), (r) {
      showSnackBar('Task Added');
    });

    state = false;
  }

  Future<void> updateGoal({
    required Goal goal,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _goalAPI.updateGoal(goal);
    res.fold((l) => showSnackBar(l.message), (r) {
      showSnackBar('Goal updated');
    });
    state = false;
  }

  Future<void> deleteGoal({
    required String goalId,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _goalAPI.deleteGoal(goalId);
    res.fold((l) => showSnackBar(l.message), (r) {
      showSnackBar('Goal deleted');
    });
    state = false;
  }

  Stream<List<Goal>> getGoalsStream(String userID, DateTime? selectedDate) {
    // print("here at getGoalsStream $userID");
    // print("here at getGoalsStream $selectedDate");

    return _goalAPI.goalsStream(userID).map((snapshot) {
      List<Goal> goals = snapshot.docs
          .map((doc) => Goal.fromMap(doc.data()..['id'] = doc.id))
          .where((goal) {
        if (selectedDate != null) {
          return goal.startDate?.day == selectedDate.day &&
              goal.startDate?.month == selectedDate.month &&
              goal.startDate?.year == selectedDate.year;
        } else {
          // Handle the case when selectedDate is null
          // For example, you can choose to include all goals
          return true;
        }
      }).toList();

      goals.forEach((goal) => print(goal)); // Print each goal

      return goals;
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

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black.withOpacity(0.4),
    );
    _ref
        .watch(scaffoldMessengerKeyProvider)
        .currentState
        ?.showSnackBar(snackBar);
  }
  //TODO: fix this current implementation of showSnackBar
}
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:motiv8_ai/api/goal_api.dart';
// import 'package:motiv8_ai/commons/utils.dart';
// import 'package:motiv8_ai/controllers/auth_controllers.dart';
// import 'package:motiv8_ai/database/goals_db.dart';
// import 'package:motiv8_ai/main.dart';
// import 'package:motiv8_ai/models/goals_model.dart';
// import 'package:motiv8_ai/screens/add_goals_screen.dart';
// import 'package:motiv8_ai/widgets/caledarView_widget.dart';
// import 'package:uuid/uuid.dart';

// final goalsProvider = StreamProvider<List<Goal>>((ref) {
//   final goalController = ref.watch(goalControllerProvider.notifier);
//   final selectedDate = ref.watch(calendarStateProvider).selectedDay;
//   final userID = ref.watch(currentUserProvider)!.uid;

//   return goalController.getGoalsStream(userID, selectedDate);
// });

// final goalControllerProvider =
//     StateNotifierProvider<GoalController, bool>((ref) {
//   return GoalController(
//     ref: ref,
//     goalAPI: ref.watch(goalApiProvider),
//     goalDatabase: ref.watch(goalDatabaseProvider),
//   );
// });

// class GoalController extends StateNotifier<bool> {
//   final GoalAPI _goalAPI;
//   final GoalDatabase _goalDatabase;
//   final Ref _ref;

//   GoalController({
//     required Ref ref,
//     required GoalAPI goalAPI,
//     required GoalDatabase goalDatabase,
//   })  : _ref = ref,
//         _goalAPI = goalAPI,
//         _goalDatabase = goalDatabase,
//         super(false);

//   Future<void> createGoal({
//     required String name,
//     required String description,
//     required DateTime? startDate,
//     required DateTime? endDate,
//     required String reminderFrequency,
//     required List<String> tasks,
//     required BuildContext context,
//     required String userID,
//   }) async {
//     state = true;
//     Goal goal = Goal(
//       id: const Uuid().v4(),
//       userID: userID,
//       name: name,
//       description: description,
//       startDate: startDate,
//       endDate: endDate,
//       reminderFrequency: '',
//       tasks: tasks,
//     );

//     final int id = await _goalDatabase.createGoal(goal);
//     goal = goal.copyWith(id: id.toString());

//     showSnackBar('Goal created');
//     state = false;
//   }

//   Future<void> updateGoal({
//     required Goal goal,
//     required BuildContext context,
//   }) async {
//     state = true;
//     await _goalDatabase.updateGoal(goal);

//     showSnackBar('Goal updated');
//     state = false;
//   }

//   Future<void> deleteGoal({
//     required String goalId,
//     required BuildContext context,
//   }) async {
//     state = true;
//     await _goalDatabase.deleteGoal(goalId);

//     showSnackBar('Goal deleted');
//     state = false;
//   }

//   Stream<List<Goal>> getGoalsStream(
//       String userID, DateTime? selectedDate) async* {
//     print("selected date is $selectedDate");
//     final List<Goal> goals = await _goalDatabase.getAllGoals(userID);
//     print(goals);

//     if (selectedDate != null) {
//       final filteredGoals = goals.where((goal) =>
//           goal.startDate?.year == selectedDate.year &&
//           goal.startDate?.month == selectedDate.month &&
//           goal.startDate?.day == selectedDate.day);

//       yield filteredGoals.toList();
//     } else {
//       yield goals;
//     }
//   }

//   void showSnackBar(String message) {
//     final snackBar = SnackBar(content: Text(message));
//     _ref
//         .watch(scaffoldMessengerKeyProvider)
//         .currentState
//         ?.showSnackBar(snackBar);
//   }
// }
