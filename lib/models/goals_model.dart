// class Goal {
//   final String id;
//   final String name;
//   final String userID;
//   final String description;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final String reminderFrequency;
//   final List<String>? tasks;

//   Goal({
//     required this.id,
//     required this.userID,
//     required this.name,
//     required this.description,
//     required this.startDate,
//     required this.endDate,
//     this.reminderFrequency = '',
//     this.tasks = const [],
//   });

//   factory Goal.fromMap(Map<String, dynamic> data) {
//     return Goal(
//       id: data['id'],
//       name: data['name'],
//       userID: data['userID'],
//       description: data['description'],
//       startDate: data['startDate'] is String
//           ? DateTime.tryParse(data['startDate'])
//           : null,
//       endDate:
//           data['endDate'] is String ? DateTime.tryParse(data['endDate']) : null,
//       reminderFrequency: data['reminderFrequency'],
//       tasks: List<String>.from(data['tasks']),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userID': userID,
//       'name': name,
//       'description': description,
//       'startDate': startDate?.millisecondsSinceEpoch,
//       'endDate': endDate?.millisecondsSinceEpoch,
//       'reminderFrequency': reminderFrequency,
//       'tasks': tasks,
//     };
//   }

//   Goal copyWith({
//     String? id,
//     String? name,
//     String? userID,
//     String? description,
//     DateTime? startDate,
//     DateTime? endDate,
//     String? reminderFrequency,
//     List<String>? tasks,
//   }) {
//     return Goal(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       userID: userID ?? this.userID,
//       description: description ?? this.description,
//       startDate: startDate ?? this.startDate,
//       endDate: endDate ?? this.endDate,
//       reminderFrequency: reminderFrequency ?? this.reminderFrequency,
//       tasks: tasks ?? this.tasks,
//     );
//   }
// }

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
    required this.userID,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.reminderFrequency = '',
    this.tasks = const [],
  });

  factory Goal.fromMap(Map<String, dynamic> data) {
    return Goal(
      id: data['id'],
      name: data['name'],
      userID: data['userID'],
      description: data['description'],
      startDate: data['startDate'] != null
          ? DateTime(
              data['startDate'].year,
              data['startDate'].month,
              data['startDate'].day,
            )
          : null,
      endDate: data['endDate'] != null
          ? DateTime(
              data['endDate'].year,
              data['endDate'].month,
              data['endDate'].day,
            )
          : null,
      reminderFrequency: data['reminderFrequency'],
      tasks: List<String>.from(data['tasks']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'name': name,
      'description': description,
      'startDate': startDate != null ? _convertToDateString(startDate!) : null,
      'endDate': endDate != null ? _convertToDateString(endDate!) : null,
      'reminderFrequency': reminderFrequency,
      'tasks': tasks,
    };
  }

  String _convertToDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
