// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GoalTask {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final List<String>? subtasks;

  GoalTask({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.subtasks,
  });

  GoalTask copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? date,
    List<String>? subtasks,
  }) {
    return GoalTask(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      subtasks: subtasks ?? this.subtasks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'subtasks': subtasks,
    };
  }

  factory GoalTask.fromMap(Map<String, dynamic> map) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(map['date'] as int);
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    return GoalTask(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      date: dateOnly,
      subtasks: map['subtasks'] != null
          ? List<String>.from((map['subtasks'] as List<String>))
          : null,
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
        listEquals(other.subtasks, subtasks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        date.hashCode ^
        subtasks.hashCode;
  }
}
