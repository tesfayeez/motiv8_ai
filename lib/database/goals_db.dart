import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/database/init_db.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

final goalDatabaseProvider = Provider<GoalDatabase>((ref) {
  final database = ref.watch(databaseProvider).maybeWhen(
        data: (value) => value,
        orElse: () => null,
      );
  if (database != null) {
    return GoalDatabase(database: database);
  } else {
    throw Exception('Failed to obtain database');
  }
});

class GoalDatabase {
  final Database _database;

  GoalDatabase({required Database database}) : _database = database;

  Future<String> getDatabaseFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    print('Database File Path: $path'); // Print the database file path
    return path;
  }

  Future<List<Goal>> getAllGoals(String userID) async {
    final directoryPath = await getDatabaseFilePath();
    final databasePath = '$directoryPath/goals.db';
    print("databasePath $databasePath");
    final List<Map<String, dynamic>> goalMaps = await _database.query(
      'goals',
      where: 'userID = ?',
      whereArgs: [userID],
    );

    return goalMaps.map((goalMap) => Goal.fromMap(goalMap)).toList();
  }

  Future<int> createGoal(Goal goal) async {
    final Map<String, dynamic> goalMap = goal.toMap();
    final directoryPath = await getDatabaseFilePath();
    final databasePath = '$directoryPath/goals.db';
    print("databasePath $databasePath");

    return await _database.insert('goals', goalMap);
  }

  Future<void> updateGoal(Goal goal) async {
    final Map<String, dynamic> goalMap = goal.toMap();
    await _database.update(
      'goals',
      goalMap,
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<void> deleteGoal(String goalId) async {
    await _database.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [goalId],
    );
  }
}
