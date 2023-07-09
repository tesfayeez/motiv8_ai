import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:motiv8_ai/commons/snack_bar_provider.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/user_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/account_textfields.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/custom_platform_specific_date_picker.dart';
import 'package:motiv8_ai/widgets/logout_confirmation_dialog.dart';

class AccountScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AccountScreen());

  final bool isDirectNavigation;

  const AccountScreen({Key? key, this.isDirectNavigation = false})
      : super(key: key);
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
    final currentUseris = ref.watch(currentUserProvider);
    final currentUserModel =
        ref.watch(currentUserModelProvider(currentUseris!));
    final scaffolMessengerKey = ref.watch(scaffoldMessengerKeyProvider);
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

      final snackbarController = ref.watch(snackbarProvider.notifier);
      snackbarController.show(context, 'Profile updated successfully');
    }
  }

  void logout(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Consumer(builder: (context, ref, child) {
      final currentUseris = ref.watch(currentUserProvider);
      final currentUserModel =
          ref.watch(currentUserModelProvider(currentUseris!));
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
      final profilePic = currentUserModel.when(
        data: (user) => user?.profilePic ?? '',
        loading: () => '', // Placeholder value during loading state
        error: (_, __) => '', // Placeholder value on error
      );

      if (usernameTextFieldController.text.isEmpty &&
          emailTextFieldController.text.isEmpty) {
        usernameTextFieldController.text = username;
        emailTextFieldController.text = email;
      }

      return Scaffold(
        backgroundColor: theme.colorScheme.onBackground,
        appBar: CustomAppBar(
          isCenterTitle: true,
          title: 'Account',
          isBackPresent: widget.isDirectNavigation
              ? false
              : ModalRoute.of(context)?.canPop ?? false,
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
                            pickImage();
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey,
                            backgroundImage: profilePic.isNotEmpty
                                ? NetworkImage(profilePic)
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        // Icon(_isEditing ? Icons.close : Icons.edit)
                        TextButton(
                          child: Text(
                            'Edit Profile',
                            style: GoogleFonts.poppins(
                                color: theme.colorScheme.primary, fontSize: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                        ),
                        Visibility(
                          visible: !_isEditing,
                          child: AccountTextField(
                            leftIcon: const Icon(Icons.person),
                            controller: usernameTextFieldController,
                            hintText: 'User name',
                            enabled: false,
                            initialValue: username,
                          ),
                        ),
                        Visibility(
                          visible: _isEditing,
                          child: AccountTextField(
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
                          child: AccountTextField(
                            leftIcon: const Icon(Icons.mail),
                            controller: emailTextFieldController,
                            hintText: 'Email',
                            enabled: false,
                            initialValue: email,
                          ),
                        ),
                        Visibility(
                          visible: _isEditing,
                          child: AccountTextField(
                            leftIcon: const Icon(Icons.mail),
                            controller: emailTextFieldController,
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: GestureDetector(
                            child: Text(
                              "Log out",
                              style: GoogleFonts.poppins(
                                  color: theme.colorScheme.error, fontSize: 14),
                            ),
                            onTap: () {
                              LogoutConfirmationDialog.show(
                                context,
                                () {
                                  logout(context, ref);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Move the 'Continue' button to the bottom of the screen
              _isEditing
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: CustomButton(
                        text: 'Update Profile',
                        onPressed: _isEditing ? _updateProfile : null,
                      ))
                  : SizedBox()
            ],
          ),
        ),
      );
    });
  }
}
