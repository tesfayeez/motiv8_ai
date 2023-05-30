import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/controllers/user_controllers.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/custom_platform_specific_date_picker.dart';

class AccountScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AccountScreen());

  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final usernameTextFieldController = TextEditingController();
  final emailTextFieldController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    usernameTextFieldController.text = '';
    emailTextFieldController.text = '';
  }

  @override
  void dispose() {
    usernameTextFieldController.dispose();
    emailTextFieldController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final userController = ref.read(userControllerProvider.notifier);
    final currentUserModel = ref.watch(currentUserModelProvider);
    final currentUser = currentUserModel.when(
      data: (user) => user,
      loading: () => null,
      error: (_, __) => null,
    );

    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: usernameTextFieldController.text.trim(),
        email: emailTextFieldController.text.trim(),
      );

      await userController.updateUser(updatedUser);
      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentUserModel = ref.watch(currentUserModelProvider);
      final username = currentUserModel.when(
        data: (user) => user?.name ?? '',
        loading: () => '', // Placeholder value during loading state
        error: (_, __) => '', // Placeholder value on error
      );
      final email = currentUserModel.when(
        data: (user) => user?.email ?? '',
        loading: () => '', // Placeholder value during loading state
        error: (_, __) => '', // Placeholder value on error
      );

      if (usernameTextFieldController.text.isEmpty &&
          emailTextFieldController.text.isEmpty) {
        usernameTextFieldController.text = username;
        emailTextFieldController.text = email;
      }

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
                    child: Column(
                      children: [
                        // Add an avatar image at the top
                        GestureDetector(
                          onTap: () {
                            print("add image");
                          },
                          child: const CircleAvatar(
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
                        // Icon(_isEditing ? Icons.close : Icons.edit)
                        TextButton(
                          child: Text(
                            _isEditing ? 'Save Update' : 'Edit Profile',
                            style: GoogleFonts.poppins(
                                color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                        ),
                        Visibility(
                          visible: !_isEditing,
                          child: CustomTextField(
                            leftIcon: const Icon(Icons.person),
                            controller: usernameTextFieldController,
                            hintText: 'User name',
                            enabled: false,
                            initialValue: username,
                          ),
                        ),
                        Visibility(
                          visible: _isEditing,
                          child: CustomTextField(
                            leftIcon: const Icon(Icons.person),
                            controller: usernameTextFieldController,
                            hintText: 'User name',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: !_isEditing,
                          child: CustomTextField(
                            leftIcon: const Icon(Icons.mail),
                            controller: emailTextFieldController,
                            hintText: 'Email',
                            enabled: false,
                            initialValue: email,
                          ),
                        ),
                        Visibility(
                          visible: _isEditing,
                          child: CustomTextField(
                            leftIcon: const Icon(Icons.mail),
                            controller: emailTextFieldController,
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomDatePicker(),
                      ],
                    ),
                  ),
                ),
              ),
              // Move the 'Continue' button to the bottom of the screen
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  text: 'Continue',
                  onPressed: _isEditing ? _updateProfile : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
