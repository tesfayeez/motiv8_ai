// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GoalTask {
  final String id;
  final String name;
  final String description;
  final DateTime date;

  GoalTask({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
  });

  GoalTask copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? date,
  }) {
    return GoalTask(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'date': date.millisecondsSinceEpoch,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalTask.fromJson(String source) =>
      GoalTask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GoalTask(id: $id, name: $name, description: $description, date: $date)';
  }

  @override
  bool operator ==(covariant GoalTask other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ date.hashCode;
  }
}
