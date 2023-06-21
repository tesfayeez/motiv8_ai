import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  return await DatabaseProvider.database;
});

class DatabaseProvider {
  static const String databaseName = 'goals.db';
  static const int databaseVersion = 1;

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, databaseName);

    final database = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS goals (
          id TEXT PRIMARY KEY,
          userID TEXT,
          name TEXT,
          description TEXT,
          startDate INTEGER,
          endDate INTEGER,
          reminderFrequency TEXT,
          tasks TEXT
        )
      ''');
      },
    );

    return database;
  }
}
