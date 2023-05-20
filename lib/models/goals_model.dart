
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
      startDate: DateTime.fromMillisecondsSinceEpoch(data['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(data['endDate']),
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
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'reminderFrequency': reminderFrequency,
      'tasks': tasks,
    };
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
}
