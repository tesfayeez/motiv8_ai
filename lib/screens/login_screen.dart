
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/commons/pallete_colors.dart';
import 'package:motiv8_ai/commons/validators.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/screens/forgot_password.screen.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/screens/signup_screen.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/horizontal_with_text_widget.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';
import 'package:motiv8_ai/widgets/social_login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static route() =>
      MaterialPageRoute(builder: (context) => const LoginScreen());

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void onLoginWithGoogle() async {
    final authAPI = ref.read(authAPIProvider);
    final result = await authAPI.signInWithGoogle();

    result.fold((failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message)),
      );
    }, (user) {
      // handle successful login
      Navigator.of(context).pushReplacement(HomeViewScreen.route());
    });
  }

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

  void onLogin() {
    setState(() {
      emailError = InputValidator.validateEmail(emailController.text);
      passwordError = InputValidator.validatePassword(passwordController.text);
    });
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  bool checkIfValid() {
    return emailError == null &&
        passwordError == null &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
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
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 28),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Welcome back you\'ve been missed',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Pallete.greyColor),
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
                  isObescure: true,
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
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Pallete.greyColor,
                    ),
                    children: [
                      TextSpan(
                        text: ' Sign up',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              SignUpScreen.route(),
                            );
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
