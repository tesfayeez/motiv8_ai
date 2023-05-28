import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/goal_api.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';

final goalControllerProvider =
    StateNotifierProvider<GoalController, bool>((ref) {
  return GoalController(
    ref: ref,
    goalAPI: ref.watch(goalApiProvider),
  );
});

final getGoalsStreamProvider =
    StreamProvider.autoDispose.family<List<Goal>, String>((ref, userID) {
  final goalController = ref.watch(goalControllerProvider.notifier);
  final selectedDate = ref.watch(calendarStateProvider).selectedDay;
  print("Selected date $selectedDate");
  return goalController.getGoalsStream(userID, selectedDate);
});

class GoalController extends StateNotifier<bool> {
  final GoalAPI _goalAPI;
  final Ref _ref;

  GoalController({
    required Ref ref,
    required GoalAPI goalAPI,
  })  : _ref = ref,
        _goalAPI = goalAPI,
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
      id: '',
      userID: userID,
      name: name,
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
    print("here at getGoalsStream $userID");
    print("here at getGoalsStream $selectedDate");

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
}
