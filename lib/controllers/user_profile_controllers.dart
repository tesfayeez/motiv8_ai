import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

class UserProfile {
  final WidgetRef ref;
  final String userId;

  UserProfile({required this.ref, required this.userId});

  Future<String> uploadImage(File image) async {
    final refe =
        ref.read(firebaseStorageProvider).ref('profile_pictures/$userId');
    final uploadTask = refe.putFile(image);

    final snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Uploaded to $downloadUrl');
      return downloadUrl;
    } else {
      print('Failed to upload image');
      throw Exception('Failed to upload image');
    }
  }

  Future<String> getImage() async {
    final refe =
        ref.read(firebaseStorageProvider).ref('profile_pictures/$userId');
    final downloadUrl = await refe.getDownloadURL();
    return downloadUrl;
  }
}
