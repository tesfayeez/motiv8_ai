import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/global_providers.dart';
import 'package:motiv8_ai/commons/typedef.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/user_model.dart';

final userApiProvider =
    Provider((ref) => UserAPI(db: ref.watch(firebaseFirestoreProvider)));

abstract class IUserAPI {
  FutureEither<UserModel> createUser(UserModel user);
  FutureEither<void> deleteUser(String userId);
  FutureEither<void> updateUser(UserModel user);
  Stream<QuerySnapshot<Map<String, dynamic>>> usersStream();
  Future<bool> userExists(String uid);
  Stream<UserModel> getUser(String uid);
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _db;
  final Map<String, Stream<UserModel>> _cache = {};

  UserAPI({
    required FirebaseFirestore db,
  }) : _db = db;

  late final _usersCollection = _db.collection('users');

  @override
  Future<bool> userExists(String uid) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return userSnapshot.exists;
  }

  @override
  FutureEither<UserModel> createUser(UserModel user) async {
    try {
      final userDocument = _usersCollection.doc(user.id);
      user.copyWith(
          userSettings: UserSettings(
              fcmToken: null,
              goalCheckUpReminderTime: null,
              motivationalQuoteEndTime: null,
              motivationalQuoteReminderFrequency: 3,
              motivationalQuoteStartTime: null,
              taskCheckUpReminderTime: null)); // Use user.id as the document ID
      await userDocument.set(user.toMap()); // Set the document data
      final userSnapshot = await userDocument.get();
      final createdUser =
          UserModel.fromMap(userSnapshot.data()!..['id'] = userSnapshot.id);
      saveUserIdToPrefs(userSnapshot.id);
      return right(createdUser);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> deleteUser(String userId) async {
    try {
      _cache.remove(userId);
      await _usersCollection.doc(userId).delete();
      saveUserIdToPrefs('');
      return right(unit);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> updateUser(UserModel user) async {
    try {
      _cache.remove(user.id);
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

  Stream<UserModel> getUser(String uid) {
    // print("user id is $uid");

    // if (_cache.containsKey(uid)) {
    //   return _cache[uid]!;
    // } else {
    //   final userStream = _usersCollection.doc(uid).snapshots().map((snapshot) {
    //     if (snapshot.exists) {
    //       return UserModel.fromMap(snapshot.data()!..['id'] = snapshot.id);
    //     } else {
    //       throw Exception('User not found');
    //     }
    //   });

    //   _cache[uid] = userStream;
    //   return userStream;
    // }
    final userStream = _usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!..['id'] = snapshot.id);
      } else {
        throw Exception('User not found');
      }
    });

    _cache[uid] = userStream;
    return userStream;
  }

  void clearCache() {
    _cache.clear();
  }
}
