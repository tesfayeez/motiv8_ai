import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseInitializerProvider = Provider((ref) => Firebase.initializeApp());

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);
