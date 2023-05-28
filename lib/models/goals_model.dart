// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Goal {
  final String id;
  final String name;
  final String userID;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String reminderFrequency;
  final List<String>? tasks;

  Goal({
    required this.id,
    required this.name,
    required this.userID,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.reminderFrequency = '',
    this.tasks = const [],
  });

  // factory Goal.fromMap(Map<String, dynamic> data) {
  //   return Goal(
  //     id: data['id'],
  //     name: data['name'],
  //     userID: data['userID'],
  //     description: data['description'],
  //     startDate:
  //         data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
  //     endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
  //     reminderFrequency: data['reminderFrequency'],
  //     tasks: List<String>.from(data['tasks']),
  //   );
  // }
  // factory Goal.fromMap(Map<String, dynamic> data) {
  //   final startDateMillis = data['startDate'] is int ? data['startDate'] : null;
  //   final endDateMillis = data['endDate'] is int ? data['endDate'] : null;

  //   return Goal(
  //     id: data['id'] as String,
  //     name: data['name'] as String,
  //     userID: data['userID'] as String,
  //     description: data['description'] as String,
  //     startDate: startDateMillis != null
  //         ? DateTime.fromMillisecondsSinceEpoch(startDateMillis)
  //         : null,
  //     endDate: endDateMillis != null
  //         ? DateTime.fromMillisecondsSinceEpoch(endDateMillis)
  //         : null,
  //     reminderFrequency: data['reminderFrequency'] as String,
  //     tasks: List<String>.from(data['tasks'] as List<dynamic>),
  //   );
  // }
  factory Goal.fromMap(Map<String, dynamic> data) {
    final int? startDateMillis = data['startDate'] as int?;
    final int? endDateMillis = data['endDate'] as int?;

    return Goal(
      id: data['id'] as String,
      name: data['name'] as String,
      userID: data['userID'] as String,
      description: data['description'] as String,
      startDate: startDateMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(startDateMillis)
          : null,
      endDate: endDateMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(endDateMillis)
          : null,
      reminderFrequency: data['reminderFrequency'] as String,
      tasks: List<String>.from(data['tasks'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'userID': userID,
      'description': description,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'reminderFrequency': reminderFrequency,
      'tasks': tasks,
    };
  }

  String _convertToDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Goal copyWith({
    String? id,
    String? name,
    String? userID,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? reminderFrequency,
    List<String>? tasks,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      userID: userID ?? this.userID,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      tasks: tasks ?? this.tasks,
    );
  }

  String toJson() => json.encode(toMap());

  factory Goal.fromJson(String source) =>
      Goal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Goal(id: $id, name: $name, userID: $userID, description: $description, startDate: $startDate, endDate: $endDate, reminderFrequency: $reminderFrequency, tasks: $tasks)';
  }

  @override
  bool operator ==(covariant Goal other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.userID == userID &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.reminderFrequency == reminderFrequency &&
        listEquals(other.tasks, tasks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        userID.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        reminderFrequency.hashCode ^
        tasks.hashCode;
  }
}
