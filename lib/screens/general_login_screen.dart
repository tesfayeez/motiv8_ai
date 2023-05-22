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
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/screens/signup_screen.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/horizontal_with_text_widget.dart';
import 'package:motiv8_ai/widgets/social_login_button.dart';

class GeneralLoginScreen extends ConsumerStatefulWidget {
  const GeneralLoginScreen({Key? key}) : super(key: key);
  static route() =>
      MaterialPageRoute(builder: (context) => const GeneralLoginScreen());

  @override
  ConsumerState<GeneralLoginScreen> createState() => _GeneralLoginScreenState();
}

class _GeneralLoginScreenState extends ConsumerState<GeneralLoginScreen> {
  void onLoginWithGoogle() async {
    if (!mounted) {
      return; // State is no longer active, exit the method
    }

    final authAPI = ref.read(authAPIProvider);
    final result = await authAPI.signInWithGoogle();

    if (!mounted) {
      return; // State is no longer active, exit the method
    }

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (user) {
        if (mounted) {
          // handle successful login
          Navigator.of(context).push(HomeViewScreen.route());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/login.png',
                        height: 300,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Sign In',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 28),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Pallete.greyColor),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                            text: 'Login',
                            onPressed: () {
                              Navigator.of(context).push(LoginScreen.route());
                            }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const LineWithText(
                        text: 'or use instant Sign IN',
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
                      const SizedBox(
                        height: 40,
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
                              style: const TextStyle(
                                  color: Colors.purple, fontSize: 16),
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
