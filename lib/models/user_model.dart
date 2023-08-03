// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePic;
  final UserSettings? userSettings;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    this.userSettings,
  });
  UserModel.empty()
      : id = '',
        name = '',
        email = '',
        profilePic = '',
        userSettings = UserSettings.empty();

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePic,
    UserSettings? userSettings,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      userSettings: userSettings ?? this.userSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'userSettings': userSettings?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String,
      userSettings: map['userSettings'] != null
          ? UserSettings.fromMap(map['userSettings'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePic: $profilePic, userSettings: $userSettings)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profilePic == profilePic &&
        other.userSettings == userSettings;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePic.hashCode ^
        userSettings.hashCode;
  }
}

class UserSettings {
  final String? fcmToken;
  final int? motivationalQuoteReminderFrequency;
  final DateTime? motivationalQuoteStartTime;
  final DateTime? motivationalQuoteEndTime;
  final DateTime? goalCheckUpReminderTime;
  final DateTime? taskCheckUpReminderTime;

  UserSettings({
    this.fcmToken,
    this.motivationalQuoteReminderFrequency,
    this.motivationalQuoteStartTime,
    this.motivationalQuoteEndTime,
    this.goalCheckUpReminderTime,
    this.taskCheckUpReminderTime,
  });

  UserSettings copyWith({
    String? fcmToken,
    int? motivationalQuoteReminderFrequency,
    DateTime? motivationalQuoteStartTime,
    DateTime? motivationalQuoteEndTime,
    DateTime? goalCheckUpReminderTime,
    DateTime? taskCheckUpReminderTime,
  }) {
    return UserSettings(
      fcmToken: fcmToken ?? this.fcmToken,
      motivationalQuoteReminderFrequency: motivationalQuoteReminderFrequency ??
          this.motivationalQuoteReminderFrequency,
      motivationalQuoteStartTime:
          motivationalQuoteStartTime ?? this.motivationalQuoteStartTime,
      motivationalQuoteEndTime:
          motivationalQuoteEndTime ?? this.motivationalQuoteEndTime,
      goalCheckUpReminderTime:
          goalCheckUpReminderTime ?? this.goalCheckUpReminderTime,
      taskCheckUpReminderTime:
          taskCheckUpReminderTime ?? this.taskCheckUpReminderTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fcmToken': fcmToken,
      'motivationalQuoteReminderFrequency': motivationalQuoteReminderFrequency,
      'motivationalQuoteStartTime':
          motivationalQuoteStartTime?.millisecondsSinceEpoch,
      'motivationalQuoteEndTime':
          motivationalQuoteEndTime?.millisecondsSinceEpoch,
      'goalCheckUpReminderTime':
          goalCheckUpReminderTime?.millisecondsSinceEpoch,
      'taskCheckUpReminderTime':
          taskCheckUpReminderTime?.millisecondsSinceEpoch,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      motivationalQuoteReminderFrequency:
          map['motivationalQuoteReminderFrequency'] != null
              ? map['motivationalQuoteReminderFrequency'] as int
              : null,
      motivationalQuoteStartTime: map['motivationalQuoteStartTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['motivationalQuoteStartTime'] as int)
          : null,
      motivationalQuoteEndTime: map['motivationalQuoteEndTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['motivationalQuoteEndTime'] as int)
          : null,
      goalCheckUpReminderTime: map['goalCheckUpReminderTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['goalCheckUpReminderTime'] as int)
          : null,
      taskCheckUpReminderTime: map['taskCheckUpReminderTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['taskCheckUpReminderTime'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSettings.fromJson(String source) =>
      UserSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserSettings(fcmToken: $fcmToken, motivationalQuoteReminderFrequency: $motivationalQuoteReminderFrequency, motivationalQuoteStartTime: $motivationalQuoteStartTime, motivationalQuoteEndTime: $motivationalQuoteEndTime, goalCheckUpReminderTime: $goalCheckUpReminderTime, taskCheckUpReminderTime: $taskCheckUpReminderTime)';
  }

  @override
  bool operator ==(covariant UserSettings other) {
    if (identical(this, other)) return true;

    return other.fcmToken == fcmToken &&
        other.motivationalQuoteReminderFrequency ==
            motivationalQuoteReminderFrequency &&
        other.motivationalQuoteStartTime == motivationalQuoteStartTime &&
        other.motivationalQuoteEndTime == motivationalQuoteEndTime &&
        other.goalCheckUpReminderTime == goalCheckUpReminderTime &&
        other.taskCheckUpReminderTime == taskCheckUpReminderTime;
  }

  @override
  int get hashCode {
    return fcmToken.hashCode ^
        motivationalQuoteReminderFrequency.hashCode ^
        motivationalQuoteStartTime.hashCode ^
        motivationalQuoteEndTime.hashCode ^
        goalCheckUpReminderTime.hashCode ^
        taskCheckUpReminderTime.hashCode;
  }

  UserSettings.empty()
      : fcmToken = null,
        motivationalQuoteReminderFrequency = null,
        motivationalQuoteStartTime = null,
        motivationalQuoteEndTime = null,
        goalCheckUpReminderTime = null,
        taskCheckUpReminderTime = null;
}
// UserModel.empty()
//       : id = '',
//         name = '',
//         email = '',
//         profilePic = '',
//         fcmToken = null,
//         motivationalQuoteReminderFrequency = null,
//         motivationalQuoteStartTime = null,
//         motivationalQuoteEndTime = null;