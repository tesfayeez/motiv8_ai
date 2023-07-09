// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';

import 'package:motiv8_ai/models/goaltask_models.dart';

class Goal {
  final String id;
  final String name;
  final String userID;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay reminderTime;
  final String reminderFrequency;
  final List<GoalTask>? tasks;
  final String? milestones;
  final String? taskBreakdownPreference;
  final String? definitionOfSuccess;
  final String? strategiesApproaches;
  final String? timelineFlexibility;
  final String? timeCommitment;
  final int totalTasks;
  final int completedTasks;

  Goal({
    required this.id,
    required this.name,
    required this.userID,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.reminderTime,
    this.reminderFrequency = '',
    this.tasks = const [],
    this.milestones,
    this.taskBreakdownPreference,
    this.definitionOfSuccess,
    this.strategiesApproaches,
    this.timelineFlexibility,
    this.timeCommitment,
    this.totalTasks = 0,
    this.completedTasks = 0,
  });

  Goal copyWith({
    String? id,
    String? name,
    String? userID,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? reminderTime,
    String? reminderFrequency,
    List<GoalTask>? tasks,
    String? milestones,
    String? taskBreakdownPreference,
    String? definitionOfSuccess,
    String? timelineFlexibility,
    String? timeCommitment,
    int? totalTasks,
    int? completedTasks,
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
      milestones: milestones ?? this.milestones,
      taskBreakdownPreference:
          taskBreakdownPreference ?? this.taskBreakdownPreference,
      definitionOfSuccess: definitionOfSuccess ?? this.definitionOfSuccess,
      timelineFlexibility: timelineFlexibility ?? this.timelineFlexibility,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  Map<String, dynamic> toMap() {
    final tasksList = (tasks ?? []).map((task) => task.toMap()).toList();
    print(tasksList);

    final String reminderTime24HourFormat =
        "${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}";

    return <String, dynamic>{
      'id': id,
      'name': name,
      'userID': userID,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'reminderTime':
          reminderTime24HourFormat, // Use the converted string here.
      'reminderFrequency': reminderFrequency,
      'tasks': tasksList,
      'milestones': milestones,
      'taskBreakdownPreference': taskBreakdownPreference,
      'definitionOfSuccess': definitionOfSuccess,
      'timelineFlexibility': timelineFlexibility,
      'timeCommitment': timeCommitment,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    final List<String> timeParts = (map['reminderTime'] as String).split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final TimeOfDay reminderTime = TimeOfDay(hour: hour, minute: minute);
    print("reminder time is $reminderTime");

    return Goal(
      id: map['id'] as String,
      name: map['name'] as String,
      userID: map['userID'] as String,
      description: map['description'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      reminderTime: reminderTime,
      reminderFrequency: map['reminderFrequency'] as String,
      tasks: map['tasks'] != null
          ? (map['tasks'] as List<dynamic>)
              .map((task) => GoalTask.fromMap(task as Map<String, dynamic>))
              .toList()
          : null,
      milestones: map['milestones'] as String?,
      taskBreakdownPreference: map['taskBreakdownPreference'] as String?,
      definitionOfSuccess: map['definitionOfSuccess'] as String?,
      timelineFlexibility: map['timelineFlexibility'] as String?,
      timeCommitment: map['timeCommitment'] as String?,
      totalTasks: map['totalTasks'] as int,
      completedTasks: map['completedTasks'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Goal.fromJson(String source) =>
      Goal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Goal(id: $id, name: $name, userID: $userID, description: $description, startDate: $startDate, endDate: $endDate, reminderFrequency: $reminderFrequency, tasks: $tasks, milestones: $milestones, taskBreakdownPreference: $taskBreakdownPreference, definitionOfSuccess: $definitionOfSuccess, timelineFlexibility: $timelineFlexibility, timeCommitment: $timeCommitment)';
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
        listEquals(other.tasks, tasks) &&
        other.milestones == milestones &&
        other.taskBreakdownPreference == taskBreakdownPreference &&
        other.definitionOfSuccess == definitionOfSuccess &&
        other.timelineFlexibility == timelineFlexibility &&
        other.timeCommitment == timeCommitment &&
        other.totalTasks == totalTasks &&
        other.completedTasks == completedTasks;
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
        tasks.hashCode ^
        milestones.hashCode ^
        taskBreakdownPreference.hashCode ^
        definitionOfSuccess.hashCode ^
        timelineFlexibility.hashCode ^
        timeCommitment.hashCode ^
        totalTasks.hashCode ^
        completedTasks.hashCode;
  }
}
