import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/global_providers.dart';
import 'package:motiv8_ai/commons/typedef.dart';
import 'package:motiv8_ai/models/goals_model.dart';

final goalApiProvider =
    Provider((ref) => GoalAPI(db: ref.watch(firebaseFirestoreProvider)));

abstract class IGoalAPI {
  FutureEither<Goal> createGoal(Goal goal);
  FutureEither<void> deleteGoal(String goalId);
  FutureEither<void> updateGoal(Goal goal);
  Stream<QuerySnapshot<Map<String, dynamic>>> goalsStream(String userID);
}

class GoalAPI implements IGoalAPI {
  final FirebaseFirestore _db;

  GoalAPI({
    required FirebaseFirestore db,
  }) : _db = db;

  late final _goalsCollection = _db.collection('goals');

  @override
  @override
  FutureEither<Goal> createGoal(Goal goal) async {
    try {
      final goalDocument = await _goalsCollection.add(goal.toMap());
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
}
