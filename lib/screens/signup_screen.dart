import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/commons/pallete_colors.dart';
import 'package:motiv8_ai/commons/validators.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/screens/login_screen.dart';

// Import any other required classes and widgets here

class SignUpScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const SignUpScreen());
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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

  void onSignUp() {
    setState(() {
      emailError = InputValidator.validateEmail(emailController.text);
      passwordError = InputValidator.validatePassword(passwordController.text);
    });

    if (emailError == null && passwordError == null) {
      ref.read(authControllerProvider.notifier).signUp(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );
    }
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
                        'Sign up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthTextField(
                          controller: emailController,
                          hintText: 'Email',
                          errorText: emailError),
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
                          onPressed: onSignUp,
                          child: const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account?',
                          style: const TextStyle(
                              fontSize: 16, color: Pallete.greyColor),
                          children: [
                            TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                    color: Pallete.blueColor, fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context, LoginScreen.route());
                                  }),
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
