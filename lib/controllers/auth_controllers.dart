import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/models/user_model.dart';
import 'package:motiv8_ai/screens/general_login_screen.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/screens/login_screen.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
  );
});

final currentUserProviderStream = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUserStream();
});

final currentUserProvider = Provider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentUser();
});
// final currentUserProvider = FutureProvider<UserModel?>((ref) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.getCurrentUser();
// });

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;
  AuthController(
      {required AuthAPI authAPI,
      required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey})
      : _authAPI = authAPI,
        _scaffoldMessengerKey = scaffoldMessengerKey,
        super(false);

  User? getCurrentUser() => _authAPI.getCurrentUser();
  // Future<UserModel?> getCurrentUser() => _authAPI.getCurrentUser();
  Stream<User?> currentUserStream() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signup(
        email: email, password: password, username: username);
    state = false;
    res.fold(
      (l) {
        print(l.stackTrace.toString());
        showSnackBar(l.message);
      },
      (r) {
        print("Account Created succesfully");
        Navigator.push(context, LoginScreen.route());
      },
    );
  }

  void login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    res.fold(
      (l) {
        print(l.stackTrace.toString());
        showSnackBar(l.message);
      },
      (r) {
        print("Home View");
        Navigator.pushReplacement(
          context,
          HomeViewScreen.route(),
        );
      },
    );
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.signoutUser();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        GeneralLoginScreen.route(),
        (route) => false,
      );
    });
  }

  void resetPassword(
      {required BuildContext context, required String email}) async {
    final res = await _authAPI.resetPassword(email);
    res.fold(
      (l) {
        print(l.stackTrace.toString());
        showSnackBar(l.message);
      },
      (r) {
        showSnackBar(
            "Password reset email has been sent to $email.text. Please check your inbox.");
        print("Password reset email sent");
        // Navigate to login screen or show a dialog notifying the user about the password reset email
      },
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
