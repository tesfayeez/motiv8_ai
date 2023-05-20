import 'package:uuid/uuid.dart';

class ChatModel {
  final String id;
  final String text;
  final DateTime timestamp;
  final String role;

  ChatModel({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.role,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final id = const Uuid().v4();
    final timestamp = DateTime.now();
    final text = json['text'] as String;
    final role = json['role'] as String;
    return ChatModel(
      id: id,
      text: text,
      timestamp: timestamp,
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'role': role,
    };
  }
}
