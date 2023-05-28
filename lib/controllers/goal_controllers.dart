// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:motiv8_ai/api/goal_api.dart';
// import 'package:motiv8_ai/commons/utils.dart';
// import 'package:motiv8_ai/controllers/auth_controllers.dart';
// import 'package:motiv8_ai/models/goals_model.dart';
// import 'package:motiv8_ai/widgets/caledarView_widget.dart';

// final goalControllerProvider =
//     StateNotifierProvider<GoalController, bool>((ref) {
//   return GoalController(
//     ref: ref,
//     goalAPI: ref.watch(goalApiProvider),
//   );
// });

// final getGoalsStreamProvider =
//     StreamProvider.autoDispose.family<List<Goal>, String>((ref, userID) {
//   final goalController = ref.watch(goalControllerProvider.notifier);
//   final selectedDate = ref.watch(calendarStateProvider).selectedDay;
//   print("Selected date $selectedDate");
//   return goalController.getGoalsStream(userID, selectedDate);
// });

// class GoalController extends StateNotifier<bool> {
//   final GoalAPI _goalAPI;
//   final Ref _ref;

//   GoalController({
//     required Ref ref,
//     required GoalAPI goalAPI,
//   })  : _ref = ref,
//         _goalAPI = goalAPI,
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
//       id: '',
//       userID: userID,
//       name: name,
//       description: description,
//       startDate: startDate,
//       endDate: endDate,
//       reminderFrequency: '',
//       tasks: tasks,
//     );

//     final res = await _goalAPI.createGoal(goal);
//     res.fold((l) => showSnackBar(l.message), (r) {
//       goal = r;
//       showSnackBar('Goal created');
//     });

//     state = false;
//   }

//   Future<void> updateGoal({
//     required Goal goal,
//     required BuildContext context,
//   }) async {
//     state = true;
//     final res = await _goalAPI.updateGoal(goal);
//     res.fold((l) => showSnackBar(l.message), (r) {
//       showSnackBar('Goal updated');
//     });
//     state = false;
//   }

//   Future<void> deleteGoal({
//     required String goalId,
//     required BuildContext context,
//   }) async {
//     state = true;
//     final res = await _goalAPI.deleteGoal(goalId);
//     res.fold((l) => showSnackBar(l.message), (r) {
//       showSnackBar('Goal deleted');
//     });
//     state = false;
//   }

//   Stream<List<Goal>> getGoalsStream(String userID, DateTime? selectedDate) {
//     print("here at getGoalsStream $userID");
//     print("here at getGoalsStream $selectedDate");

//     return _goalAPI.goalsStream(userID).map((snapshot) {
//       List<Goal> goals = snapshot.docs
//           .map((doc) => Goal.fromMap(doc.data()..['id'] = doc.id))
//           .where((goal) {
//         if (selectedDate != null) {
//           return goal.startDate?.day == selectedDate.day &&
//               goal.startDate?.month == selectedDate.month &&
//               goal.startDate?.year == selectedDate.year;
//         } else {
//           // Handle the case when selectedDate is null
//           // For example, you can choose to include all goals
//           return true;
//         }
//       }).toList();

//       goals.forEach((goal) => print(goal)); // Print each goal

//       return goals;
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/goal_api.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/database/goals_db.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:uuid/uuid.dart';

final goalsProvider = StreamProvider<List<Goal>>((ref) {
  final goalController = ref.watch(goalControllerProvider.notifier);
  final selectedDate = ref.watch(calendarStateProvider).selectedDay;
  final userID = ref.watch(currentUserProvider)!.uid;

  return goalController.getGoalsStream(userID, selectedDate);
});

final goalControllerProvider =
    StateNotifierProvider<GoalController, bool>((ref) {
  return GoalController(
    ref: ref,
    goalAPI: ref.watch(goalApiProvider),
    goalDatabase: ref.watch(goalDatabaseProvider),
  );
});

class GoalController extends StateNotifier<bool> {
  final GoalAPI _goalAPI;
  final GoalDatabase _goalDatabase;
  final Ref _ref;

  GoalController({
    required Ref ref,
    required GoalAPI goalAPI,
    required GoalDatabase goalDatabase,
  })  : _ref = ref,
        _goalAPI = goalAPI,
        _goalDatabase = goalDatabase,
        super(false);

  Future<void> createGoal({
    required String name,
    required String description,
    required DateTime? startDate,
    required DateTime? endDate,
    required String reminderFrequency,
    required List<String> tasks,
    required BuildContext context,
    required String userID,
  }) async {
    state = true;
    Goal goal = Goal(
      id: const Uuid().v4(),
      userID: userID,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      reminderFrequency: '',
      tasks: tasks,
    );

    final int id = await _goalDatabase.createGoal(goal);
    goal = goal.copyWith(id: id.toString());

    showSnackBar('Goal created');
    state = false;
  }

  Future<void> updateGoal({
    required Goal goal,
    required BuildContext context,
  }) async {
    state = true;
    await _goalDatabase.updateGoal(goal);

    showSnackBar('Goal updated');
    state = false;
  }

  Future<void> deleteGoal({
    required String goalId,
    required BuildContext context,
  }) async {
    state = true;
    await _goalDatabase.deleteGoal(goalId);

    showSnackBar('Goal deleted');
    state = false;
  }

  Stream<List<Goal>> getGoalsStream(
      String userID, DateTime? selectedDate) async* {
    print("selected date is $selectedDate");
    final List<Goal> goals = await _goalDatabase.getAllGoals(userID);
    print(goals);

    if (selectedDate != null) {
      final filteredGoals = goals.where((goal) =>
          goal.startDate?.year == selectedDate.year &&
          goal.startDate?.month == selectedDate.month &&
          goal.startDate?.day == selectedDate.day);

      yield filteredGoals.toList();
    } else {
      yield goals;
    }
  }

  void showSnackBar(String message) {
    // Show a snackbar with the provided message
    ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context)
        .showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
