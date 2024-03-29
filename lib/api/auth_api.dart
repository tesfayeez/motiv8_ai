import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motiv8_ai/api/user_api.dart';
import 'package:motiv8_ai/commons/global_providers.dart';
import 'package:fpdart/fpdart.dart';
import 'package:motiv8_ai/commons/typedef.dart';
import 'package:motiv8_ai/models/user_model.dart';

final authAPIProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final userApi = ref.watch(userApiProvider);
  return AuthAPI(auth: auth, userAPI: userApi);
});

abstract class IAuthAPI {
  FutureEither signup(
      {required String email,
      required String password,
      required String username});

  FutureEither<UserCredential> login(
      {required String email, required String password});

  Stream<User?> currentUserAccount();

  FutureEither<void> signoutUser();

  FutureEither<UserCredential> signInWithGoogle();
  FutureEither<void> resetPassword(String email);

  // FutureEither<UserCredential> signInWithApple();
  // Future<UserModel?> getCurrentUser();
  User? getCurrentUser();
}

class AuthAPI implements IAuthAPI {
  final FirebaseAuth _auth;
  final UserAPI _userApi;
  AuthAPI({required FirebaseAuth auth, required UserAPI userAPI})
      : _auth = auth,
        _userApi = userAPI;

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  Stream<User?> currentUserAccount() {
    return _auth.authStateChanges();
  }

  // @override
  // Future<UserModel?> getCurrentUser() async {
  //   final firebaseUser = _auth.currentUser;
  //   if (firebaseUser != null) {
  //     print('firebaseuser ${firebaseUser.uid}');
  //     return await _userApi.getUser(firebaseUser.uid);
  //   }
  //   return null;
  // }

  @override
  FutureEither<User> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _userApi.createUser(UserModel(
          id: userCredential.user!.uid,
          name: username, // You'll need to get the name from somewhere
          email: email,
          profilePic: ''
          // You'll need to get the interests from somewhere
          ));
      return right(userCredential.user!);
    } on FirebaseAuthException catch (e, stackTrace) {
      print('Error creating user with email and password: $e');
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<UserCredential> login(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(userCredential);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<void> signoutUser() async {
    try {
      await _auth.signOut();
      _userApi.clearCache();

      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  Future<GoogleSignInAccount?> _getGoogleUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    return googleSignIn.signIn();
  }

  Future<AuthCredential> _getGoogleAuthCredential(
      GoogleSignInAccount user) async {
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  @override
  FutureEither<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _getGoogleUser();
      if (googleUser == null) {
        throw FirebaseAuthException(
            code: "ERROR_ABORTED_BY_USER", message: "Sign in aborted by user");
      }

      final googleAuthCredential = await _getGoogleAuthCredential(googleUser);
      final userCredential =
          await _auth.signInWithCredential(googleAuthCredential);
      await _userApi.createUser(UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email ?? '',
          profilePic: googleUser.photoUrl ??
              '' // You'll need to get the interests from somewhere
          ));
      return right(userCredential);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}

class Failure {
  final String message;
  final StackTrace stackTrace;
  const Failure(this.message, [StackTrace? stackTrace])
      : stackTrace = stackTrace ?? StackTrace.empty;
}
