import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/snack_bar_provider.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/general_login_screen.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/screens/new_Screen_for_special_someone.dart';
import 'package:motiv8_ai/screens/userwalk_through_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    ref: ref,
    scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
    navigatorKey: ref.watch(navigatorKeyProvider),
  );
});

final currentUserProviderStream = StreamProvider.autoDispose((ref) {
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
  final GlobalKey<NavigatorState> _navigatorKey;
  final Ref _ref;
  AuthController({
    required Ref ref,
    required AuthAPI authAPI,
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _authAPI = authAPI,
        _scaffoldMessengerKey = scaffoldMessengerKey,
        _navigatorKey = navigatorKey,
        _ref = ref,
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
        showSnackBar(l.message, context);
      },
      (r) {
        print("Account Created succesfully");
        Navigator.of(context).pushAndRemoveUntil(
          LoginScreen.route(),
          (route) => false,
        );
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    res.fold(
      (l) {
        print(l.stackTrace.toString());
        showSnackBar(l.message, context);
      },
      (r) {
        print("Home View");
        Navigator.of(context).pushAndRemoveUntil(
          HomeViewScreen.route(),
          (route) => false,
        );
      },
    );
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.signoutUser();
    GoogleSignIn().signOut();

    res.fold((l) => null, (r) {
      printNavigationStack(context);

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const GeneralLoginScreen()),
        (route) => false,
      );
      printNavigationStack(context);
    });
  }

  void printNavigationStack(BuildContext context) {
    final navigationStack = _navigatorKey.currentState!.toString();
    print(navigationStack);
  }

  void resetPassword(
      {required BuildContext context, required String email}) async {
    final res = await _authAPI.resetPassword(email);
    res.fold(
      (l) {
        print(l.stackTrace.toString());
        showSnackBar(l.message, context);
      },
      (r) {
        showSnackBar(
            "Password reset email has been sent to $email. Please check your inbox.",
            context);
        print("Password reset email sent");
        // Navigate to login screen or show a dialog notifying the user about the password reset email
      },
    );
  }

  void onLoginWithGoogle(BuildContext context) async {
    state = true;
    final result = await _authAPI.signInWithGoogle();
    state = false;

    result.fold(
      (failure) {
        showSnackBar(failure.message, context);
      },
      (user) async {
        String? users = user.user!.email;
        print(" email for special $users");
        // handle successful login
        bool isFirstTime = await checkIfFirstTime();
        UserWalkthroughScreen.route();
        if (user.user!.email == 'ezex.55@gmail.com') {
          print("its here at email");
          Navigator.of(context).pushReplacement(UserWalkthroughScreen.route());
        } else {
          Navigator.of(context).pushReplacement(UserWalkthroughScreen.route());
        }

        // _navigatorKey.currentState?.pushReplacement(
        //   isFirstTime ? UserWalkthroughScreen.route() : HomeViewScreen.route(),
        // );
      },
    );
  }

  void showSnackBar(String message, BuildContext context) {
    final snackbarController = _ref.watch(snackbarProvider.notifier);
    snackbarController.show(context, message);
  }

  Future<bool> checkIfFirstTimeLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('firstLogin') ?? true;

    if (isFirstTime) {
      await prefs.setBool('firstLogin', false);
    }

    return isFirstTime;
  }
}
