// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:motiv8_ai/models/goaltask_models.dart';

class Goal {
  final String id;
  final String name;
  final String userID;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String reminderFrequency;
  final List<GoalTask>? tasks;
  final String? milestones;
  final String? taskBreakdownPreference;
  final String? definitionOfSuccess;
  final String? strategiesApproaches;
  final String? timelineFlexibility;
  final String? timeCommitment;

  Goal({
    required this.id,
    required this.name,
    required this.userID,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.reminderFrequency = '',
    this.tasks = const [],
    this.milestones,
    this.taskBreakdownPreference,
    this.definitionOfSuccess,
    this.strategiesApproaches,
    this.timelineFlexibility,
    this.timeCommitment,
  });

  Goal copyWith({
    String? id,
    String? name,
    String? userID,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? reminderFrequency,
    List<GoalTask>? tasks,
    String? milestones,
    String? taskBreakdownPreference,
    String? definitionOfSuccess,
    String? strategiesApproaches,
    String? timelineFlexibility,
    String? timeCommitment,
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
      strategiesApproaches: strategiesApproaches ?? this.strategiesApproaches,
      timelineFlexibility: timelineFlexibility ?? this.timelineFlexibility,
      timeCommitment: timeCommitment ?? this.timeCommitment,
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
      'milestones': milestones,
      'taskBreakdownPreference': taskBreakdownPreference,
      'definitionOfSuccess': definitionOfSuccess,
      'strategiesApproaches': strategiesApproaches,
      'timelineFlexibility': timelineFlexibility,
      'timeCommitment': timeCommitment,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as String,
      name: map['name'] as String,
      userID: map['userID'] as String,
      description: map['description'] as String,
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : null,
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      reminderFrequency: map['reminderFrequency'] as String,
      tasks: map['tasks'] != null
          ? List<GoalTask>.from(map['tasks'] as List<GoalTask>)
          : null,
      milestones:
          map['milestones'] != null ? map['milestones'] as String : null,
      taskBreakdownPreference: map['taskBreakdownPreference'] != null
          ? map['taskBreakdownPreference'] as String
          : null,
      definitionOfSuccess: map['definitionOfSuccess'] != null
          ? map['definitionOfSuccess'] as String
          : null,
      strategiesApproaches: map['strategiesApproaches'] != null
          ? map['strategiesApproaches'] as String
          : null,
      timelineFlexibility: map['timelineFlexibility'] != null
          ? map['timelineFlexibility'] as String
          : null,
      timeCommitment: map['timeCommitment'] != null
          ? map['timeCommitment'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Goal.fromJson(String source) =>
      Goal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Goal(id: $id, name: $name, userID: $userID, description: $description, startDate: $startDate, endDate: $endDate, reminderFrequency: $reminderFrequency, tasks: $tasks, milestones: $milestones, taskBreakdownPreference: $taskBreakdownPreference, definitionOfSuccess: $definitionOfSuccess, strategiesApproaches: $strategiesApproaches, timelineFlexibility: $timelineFlexibility, timeCommitment: $timeCommitment)';
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
        other.strategiesApproaches == strategiesApproaches &&
        other.timelineFlexibility == timelineFlexibility &&
        other.timeCommitment == timeCommitment;
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
        strategiesApproaches.hashCode ^
        timelineFlexibility.hashCode ^
        timeCommitment.hashCode;
  }
}
// / factory Goal.fromMap(Map<String, dynamic> data) {
  //   final int? startDateMillis = data['startDate'] as int?;
  //   final int? endDateMillis = data['endDate'] as int?;

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

  

  // String _convertToDateString(DateTime date) {
  //   return DateFormat('yyyy-MM-dd').format(date);
  // }