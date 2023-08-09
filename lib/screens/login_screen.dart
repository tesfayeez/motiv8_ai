import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/screens/forgot_password.screen.dart';
import 'package:motiv8_ai/screens/signup_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/screens/userwalk_through_screen.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/horizontal_with_text_widget.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';
import 'package:motiv8_ai/widgets/social_login_button.dart';

import '../main.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static route() =>
      MaterialPageRoute(builder: (context) => const LoginScreen());

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() async {
    HapticFeedback.selectionClick();
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  bool checkIfValid() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void onLoginWithGoogle() {
    ref.read(authControllerProvider.notifier).onLoginWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = ref.read(navigatorKeyProvider);
    final isLoading = ref.watch(authControllerProvider);
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.onBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Sign In to Your Account',
                  style: GoogleFonts.poppins(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Welcome back you\'ve been missed',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: theme.colorScheme.onTertiary),
                ),
                const SizedBox(
                  height: 25,
                ),
                if (isLoading) CustomProgressIndicator(),
                const SizedBox(
                  height: 65,
                ),
                CustomTextField(
                  leftIcon: const Icon(Icons.mail_rounded),
                  controller: emailController,
                  hintText: 'Email',
                  errorText: emailError,
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  leftIcon: const Icon(Icons.lock),
                  isObscure: true,
                  controller: passwordController,
                  hintText: 'Password',
                  errorText: passwordError,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            ForgotPasswordScreen.route(),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: 'Login',
                    onPressed: onLogin,
                  ),
                  // RoundedSmallButton(onTap: onLogin, label: 'Done'),
                ),
                const SizedBox(
                  height: 30,
                ),
                const LineWithText(
                  text: 'or',
                ),
                const SizedBox(
                  height: 30,
                ),
                SocialLoginButton(
                  text: 'Sign in With Google',
                  onPressed: onLoginWithGoogle,
                  svgAssetName: 'assets/google_logo.svg',
                ),
                const SizedBox(
                  height: 15,
                ),
                SocialLoginButton(
                  text: 'Sign in With Apple',
                  onPressed: () {},
                  svgAssetName: 'assets/apple_logo.svg',
                ),
                const SizedBox(
                  height: 55,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: theme.colorScheme.onTertiary,
                    ),
                    children: [
                      TextSpan(
                        text: ' Sign up',
                        style: GoogleFonts.poppins(
                            color: theme.colorScheme.primary, fontSize: 16),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(SignUpScreen.route());
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
