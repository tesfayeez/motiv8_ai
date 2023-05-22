import 'package:flutter/material.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/custom_platform_specific_date_picker.dart';

class AccountScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AccountScreen());
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final usernameTextFieldController = TextEditingController();
  final emailTextFieldController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameTextFieldController.dispose();
    emailTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    // Add an avatar image at the top
                    GestureDetector(
                      onTap: () {
                        print("add image");
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                      leftIcon: const Icon(Icons.person),
                      controller: usernameTextFieldController,
                      hintText: 'User name ',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      leftIcon: const Icon(Icons.mail),
                      controller: emailTextFieldController,
                      hintText: 'Email ',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomDatePicker(),
                  ]),
                ),
              ),
            ),
            // Move the 'Continue' button to the bottom of the screen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'Continue',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
