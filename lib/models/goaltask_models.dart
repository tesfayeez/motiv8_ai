// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class GoalTask {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String goalId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final List<String>? subtasks;
  @HiveField(6)
  final bool isCompleted;
  @HiveField(7)
  final DateTime taskReminderTime;

  GoalTask({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.goalId,
    required this.taskReminderTime,
    this.subtasks,
    this.isCompleted = false,
  });

  GoalTask copyWith(
      {String? id,
      String? goalId,
      String? name,
      String? description,
      DateTime? date,
      List<String>? subtasks,
      bool? isCompleted,
      DateTime? taskReminderTime}) {
    return GoalTask(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      subtasks: subtasks ?? this.subtasks,
      isCompleted: isCompleted ?? this.isCompleted,
      taskReminderTime: taskReminderTime ?? this.taskReminderTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'goalId': goalId,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'subtasks': subtasks,
      'isCompleted': isCompleted,
      'taskReminderTime': taskReminderTime.millisecondsSinceEpoch
    };
  }

  factory GoalTask.fromMap(Map<String, dynamic> map) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(map['date'] as int);
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    print(
        'task reminder time ${DateTime.fromMillisecondsSinceEpoch(map['taskReminderTime'] as int)}');
    return GoalTask(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      goalId: map['goalId'] as String,
      date: dateOnly,
      subtasks: map['subtasks'] != null
          ? List<String>.from(
              (map['subtasks'] as List<dynamic>).map((e) => e.toString()))
          : null,
      isCompleted: map['isCompleted'] as bool,
      taskReminderTime:
          DateTime.fromMillisecondsSinceEpoch(map['taskReminderTime'] as int),
    );
  }
  String toJson() => json.encode(toMap());

  factory GoalTask.fromJson(String source) =>
      GoalTask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GoalTask(id: $id, name: $name, description: $description, date: $date, subtasks: $subtasks)';
  }

  @override
  bool operator ==(covariant GoalTask other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.date == date &&
        other.isCompleted == isCompleted &&
        listEquals(other.subtasks, subtasks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        date.hashCode ^
        subtasks.hashCode ^
        isCompleted.hashCode;
  }
}

class GoalTaskAdapter extends TypeAdapter<GoalTask> {
  @override
  final typeId = 1;

  @override
  GoalTask read(BinaryReader reader) {
    final String id = reader.readString();
    final String goalId = reader.readString();
    final String name = reader.readString();
    final String description = reader.readString();
    final DateTime date = DateTime.parse(reader.readString());

    // Read the list of subtasks, handling the possibility that it might be empty
    final List<String> subtasks = reader.readList()?.cast<String>() ?? [];

    final bool isCompleted = reader.readBool();
    final DateTime taskReminderTime = DateTime.parse(reader.readString());

    return GoalTask(
      id: id,
      goalId: goalId,
      name: name,
      description: description,
      date: date,
      subtasks: subtasks,
      isCompleted: isCompleted,
      taskReminderTime: taskReminderTime,
    );
  }

  @override
  void write(BinaryWriter writer, GoalTask obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.goalId);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.date.toIso8601String());

    // Check if subtasks is null and write accordingly
    final subtasks = obj.subtasks ?? [];
    writer.writeList(subtasks);

    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.taskReminderTime.toIso8601String());
  }
}
