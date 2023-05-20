import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/commons/pallete_colors.dart';
import 'package:motiv8_ai/commons/validators.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/screens/signup_screen.dart';

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
      Navigator.of(context).push(HomeViewScreen.route());
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthTextField(
                        controller: emailController,
                        hintText: 'Email',
                        errorText: emailError,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      AuthTextField(
                        isObescure: true,
                        controller: passwordController,
                        hintText: 'Password',
                        errorText: passwordError,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: onLogin,
                          child: const Text('Login'),
                        ),
                        // RoundedSmallButton(onTap: onLogin, label: 'Done'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: onLoginWithGoogle,
                        icon: const Icon(Icons.login),
                        label: const Text('Continue with Google'),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: const TextStyle(
                              fontSize: 16, color: Pallete.greyColor),
                          children: [
                            TextSpan(
                              text: ' Sign up',
                              style: const TextStyle(
                                  color: Pallete.blueColor, fontSize: 16),
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
