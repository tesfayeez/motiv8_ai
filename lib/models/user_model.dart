// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:collection/collection.dart';
import 'package:motiv8_ai/commons/enums/interests_enum.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<Interest> interests;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.interests,
  });

  // Create a new instance of the User class with updated values for some or all of its properties
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    List<Interest>? interests,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      interests: interests ?? this.interests,
    );
  }

  // Convert the User object to a map that can be stored in a database or sent over the network
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'interests': interests,
    };
  }

  // Create a new User object from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      interests: List<Interest>.from(
        (map['interests'] as List<Interest>),
      ),
    );
  }

  // Convert the User object to a string representation
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, interests: $interests)';
  }

  // Compare two User objects for equality
  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        listEquals(other.interests, interests);
  }

  // Compute a hash code for the User object
  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ interests.hashCode;
  }
}
