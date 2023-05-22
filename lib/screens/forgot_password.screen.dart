import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/commons/pallete_colors.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController emailTextController;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Forgot Password'),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          'assets/forgot.png',
                          height: 300,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Please Enter your username or email address to receive a verification code',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Pallete.greyColor),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                            leftIcon: Icon(Icons.mail_rounded),
                            controller: emailTextController,
                            hintText: 'Enter email or user name'),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        CustomButton(
                          text: 'Continue',
                          onPressed: () {
                            Navigator.of(context).push(LoginScreen.route());
                          },
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
