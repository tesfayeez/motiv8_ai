import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/global_providers.dart';
import 'package:motiv8_ai/commons/typedef.dart';
import 'package:motiv8_ai/models/user_model.dart';

final userApiProvider =
    Provider((ref) => UserAPI(db: ref.watch(firebaseFirestoreProvider)));

abstract class IUserAPI {
  FutureEither<UserModel> createUser(UserModel user);
  FutureEither<void> deleteUser(String userId);
  FutureEither<void> updateUser(UserModel user);
  Stream<QuerySnapshot<Map<String, dynamic>>> usersStream();
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _db;

  UserAPI({
    required FirebaseFirestore db,
  }) : _db = db;

  late final _usersCollection = _db.collection('users');

  @override
  FutureEither<UserModel> createUser(UserModel user) async {
    try {
      final userDocument = await _usersCollection.add(user.toMap());
      final userSnapshot = await userDocument.get();
      final createdUser =
          UserModel.fromMap(userSnapshot.data()!..['id'] = userSnapshot.id);
      return right(createdUser);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      return right(unit);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toMap());
      return right(unit);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> usersStream() {
    return _usersCollection.snapshots();
  }
}
