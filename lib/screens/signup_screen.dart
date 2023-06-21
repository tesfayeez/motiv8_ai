import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/commons/pallete_colors.dart';
import 'package:motiv8_ai/commons/validators.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/screens/userwalk_through_screen.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/horizontal_with_text_widget.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';
import 'package:motiv8_ai/widgets/social_login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Import any other required classes and widgets here

class SignUpScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const SignUpScreen());
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
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
            username: usernameController.text,
            context: context,
          );
    }
  }

  bool _isTermsAndPolicyAccepted = false;

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                  height: 50,
                ),
                Text(
                  'Create an Account',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 28,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Join our community and start your journey',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: theme.colorScheme.onTertiary),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isLoading) CustomProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    leftIcon: const Icon(Icons.person),
                    controller: usernameController,
                    hintText: 'User name',
                    errorText: emailError),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                    leftIcon: const Icon(Icons.mail),
                    controller: emailController,
                    hintText: 'Enter Email',
                    errorText: emailError),
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
                ListTile(
                  leading: Transform.scale(
                    scale: 1.2, // Adjust the scale to make checkbox bigger
                    child: Checkbox(
                      checkColor: theme.colorScheme.surface,
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            3), // Adjust the border radius to make checkbox rounded
                      ),
                      value: _isTermsAndPolicyAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTermsAndPolicyAccepted = value!;
                        });
                      },
                    ),
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'I agree to the company ',
                            style: GoogleFonts.poppins(
                              color: theme.colorScheme.onTertiary,
                              fontSize: 14,
                            )),
                        TextSpan(
                          text: 'Terms of Service',
                          style: GoogleFonts.poppins(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(
                                  'https://ezex55.wixsite.com/my-site-1');
                            },
                        ),
                        TextSpan(
                            text: ' and ',
                            style: GoogleFonts.poppins(
                              color: theme.colorScheme.onTertiary,
                              fontSize: 14,
                            )),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.tertiary,
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(
                                  'https://www.example.com/privacy-policy');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(text: 'Sign Up', onPressed: onSignUp),
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
                  text: 'Sign up With Google',
                  onPressed: () {},
                  svgAssetName: 'assets/google_logo.svg',
                ),
                const SizedBox(
                  height: 15,
                ),
                SocialLoginButton(
                  text: 'Sign up With Apple',
                  onPressed: () {},
                  svgAssetName: 'assets/apple_logo.svg',
                ),
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: theme.colorScheme.onTertiary,
                    ),
                    children: [
                      TextSpan(
                        text: ' Login',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(LoginScreen.route());
                          },
                      )
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
