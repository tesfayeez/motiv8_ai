// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:motiv8_ai/api/auth_api.dart';
// import 'package:motiv8_ai/commons/global_providers.dart';
// import 'package:motiv8_ai/commons/typedef.dart';
// import 'package:motiv8_ai/models/goals_model.dart';
// import 'package:motiv8_ai/models/goaltask_models.dart';

// final goalApiProvider =
//     Provider((ref) => GoalAPI(db: ref.watch(firebaseFirestoreProvider)));

// abstract class IGoalAPI {
//   FutureEither<Goal> createGoal(Goal goal);
//   FutureEither<void> deleteGoal(String goalId);
//   FutureEither<void> updateGoal(Goal goal);
//   FutureEither<GoalTask> createGoalTask(String goalId, GoalTask task);
//   Stream<DocumentSnapshot<Map<String, dynamic>>> singleGoalStream(
//       String goalID);
//   Stream<QuerySnapshot<Map<String, dynamic>>> goalsStream(String userID);
//   FutureEither<void> updateGoalTaskSubtasks(
//       String goalId, String taskId, List<String> subtasks);
//   Future<Either<Failure, Goal>> getGoal(String goalId);
// }

// class GoalAPI implements IGoalAPI {
//   final FirebaseFirestore _db;

//   GoalAPI({
//     required FirebaseFirestore db,
//   }) : _db = db;

//   late final _goalsCollection = _db.collection('goals');

//   @override
//   FutureEither<Goal> createGoal(Goal goal) async {
//     try {
//       final goalDocument =
//           _goalsCollection.doc(goal.id); // Use user.id as the document ID
//       await goalDocument.set(goal.toMap());

//       final goalSnapshot = await goalDocument.get();
//       final createdGoal =
//           Goal.fromMap(goalSnapshot.data()!..['id'] = goalSnapshot.id);
//       return right(createdGoal);
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }

//   @override
//   FutureEither<void> deleteGoal(String goalId) async {
//     try {
//       await _goalsCollection.doc(goalId).delete();
//       return right(unit);
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }

//   @override
//   FutureEither<void> updateGoal(Goal goal) async {
//     try {
//       await _goalsCollection.doc(goal.id).update(goal.toMap());
//       return right(unit);
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }

//   @override
//   Stream<QuerySnapshot<Map<String, dynamic>>> goalsStream(String userID) {
//     return _goalsCollection.where('userID', isEqualTo: userID).snapshots();
//   }

//   @override
//   Stream<DocumentSnapshot<Map<String, dynamic>>> singleGoalStream(
//       String goalID) {
//     return _goalsCollection.doc(goalID).snapshots();
//   }

//   @override
//   FutureEither<GoalTask> createGoalTask(String goalId, GoalTask task) async {
//     try {
//       final goalDocument = _goalsCollection.doc(goalId);

//       final goalSnapshot = await goalDocument.get();
//       if (!goalSnapshot.exists) {
//         print('Goal does not exist');
//       }

//       final goalData = goalSnapshot.data()!;
//       final List<Map<String, dynamic>> tasks =
//           List.from(goalData['tasks'] ?? []);

//       // Check if the task already exists
//       final existingTask = tasks.firstWhere(
//         (taskData) => taskData['id'] == task.id,
//         orElse: () => {},
//       );
//       if (existingTask.isNotEmpty) {
//         return left(const Failure('Task Already Exists'));
//       }
//       tasks.add(task.toMap());
//       await goalDocument.update({'tasks': tasks});
//       return right(task);
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }

//   @override
//   FutureEither<void> updateGoalTaskSubtasks(
//       String goalId, String taskId, List<String> subtasks) async {
//     try {
//       final goalDocument = _goalsCollection.doc(goalId);
//       final goalSnapshot = await goalDocument.get();

//       if (!goalSnapshot.exists) {
//         return left(const Failure('Goal does not exist'));
//       }

//       final goalData = goalSnapshot.data()!;
//       final List<Map<String, dynamic>> tasks =
//           List.from(goalData['tasks'] ?? []);

//       // Find the task with the provided taskId
//       final taskIndex =
//           tasks.indexWhere((taskData) => taskData['id'] == taskId);

//       if (taskIndex == -1) {
//         return left(const Failure('Task not found'));
//       }

//       // Update the subtasks of the found task
//       tasks[taskIndex]['subtasks'] = subtasks;

//       await goalDocument.update({'tasks': tasks});
//       return right(unit);
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }

//   @override
//   Future<Either<Failure, Goal>> getGoal(String goalId) async {
//     try {
//       DocumentSnapshot documentSnapshot =
//           await _goalsCollection.doc(goalId).get();

//       if (!documentSnapshot.exists) {
//         return Left(Failure('Goal not found'));
//       }

//       Map<String, dynamic>? data =
//           documentSnapshot.data() as Map<String, dynamic>?;

//       if (data == null) {
//         return Left(Failure('Failed to retrieve goal data'));
//       }

//       data['id'] = documentSnapshot.id;

//       Goal goal = Goal.fromMap(data);

//       return Right(goal);
//     } catch (e) {
//       return Left(Failure(e.toString()));
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/global_providers.dart';
import 'package:motiv8_ai/commons/typedef.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';

final goalApiProvider =
    Provider((ref) => GoalAPI(db: ref.watch(firebaseFirestoreProvider)));

abstract class IGoalAPI {
  FutureEither<Goal> createGoal(Goal goal);
  FutureEither<void> deleteGoal(String goalId);
  FutureEither<void> updateGoal(Goal goal);
  FutureEither<GoalTask> createGoalTask(String goalId, GoalTask task);
  Stream<DocumentSnapshot<Map<String, dynamic>>> singleGoalStream(
      String goalID);
  Stream<QuerySnapshot<Map<String, dynamic>>> goalsStream(String userID);
  FutureEither<void> updateGoalTaskSubtasks(
      String goalId, String taskId, List<String> subtasks);
  Future<Either<Failure, Goal>> getGoal(String goalId);
}

class GoalAPI implements IGoalAPI {
  final FirebaseFirestore _db;

  GoalAPI({
    required FirebaseFirestore db,
  }) : _db = db;

  late final _goalsCollection = _db.collection('goals');

  @override
  FutureEither<Goal> createGoal(Goal goal) async {
    try {
      final goalDocument =
          _goalsCollection.doc(goal.id); // Use user.id as the document ID
      await goalDocument.set(goal.toMap());

      final goalSnapshot = await goalDocument.get();
      final createdGoal =
          Goal.fromMap(goalSnapshot.data()!..['id'] = goalSnapshot.id);
      return right(createdGoal);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> deleteGoal(String goalId) async {
    try {
      await _goalsCollection.doc(goalId).delete();
      return right(unit);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> updateGoal(Goal goal) async {
    try {
      await _goalsCollection.doc(goal.id).update(goal.toMap());
      return right(unit);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> goalsStream(String userID) {
    return _goalsCollection.where('userID', isEqualTo: userID).snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> singleGoalStream(
      String goalID) {
    return _goalsCollection.doc(goalID).snapshots();
  }

  @override
  FutureEither<GoalTask> createGoalTask(String goalId, GoalTask task) async {
    try {
      final goalDocument = _goalsCollection.doc(goalId);

      final goalSnapshot = await goalDocument.get();
      if (!goalSnapshot.exists) {
        return left(const Failure('Goal does not exist'));
      }

      final goalData = goalSnapshot.data()!;
      final List<Map<String, dynamic>> tasks =
          List.from(goalData['tasks'] ?? []);

      // Check if the task already exists
      final existingTask = tasks.firstWhere(
        (taskData) => taskData['id'] == task.id,
        orElse: () => {},
      );
      if (existingTask.isNotEmpty) {
        return left(const Failure('Task Already Exists'));
      }
      tasks.add(task.toMap());
      await goalDocument.update({'tasks': tasks});
      return right(task);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> updateGoalTaskSubtasks(
      String goalId, String taskId, List<String> subtasks) async {
    try {
      final goalDocument = _goalsCollection.doc(goalId);
      final goalSnapshot = await goalDocument.get();

      if (!goalSnapshot.exists) {
        return left(const Failure('Goal does not exist'));
      }

      final goalData = goalSnapshot.data()!;
      final List<Map<String, dynamic>> tasks =
          List.from(goalData['tasks'] ?? []);

      // Find the task with the provided taskId
      final taskIndex =
          tasks.indexWhere((taskData) => taskData['id'] == taskId);

      if (taskIndex == -1) {
        return left(const Failure('Task not found'));
      }

      // Update the subtasks of the found task
      tasks[taskIndex]['subtasks'] = subtasks;

      await goalDocument.update({'tasks': tasks});
      return right(unit);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<Either<Failure, Goal>> getGoal(String goalId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _goalsCollection.doc(goalId).get();

      if (!documentSnapshot.exists) {
        return Left(Failure('Goal not found'));
      }

      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        return Left(Failure('Failed to retrieve goal data'));
      }

      data['id'] = documentSnapshot.id;

      Goal goal = Goal.fromMap(data);

      return Right(goal);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
