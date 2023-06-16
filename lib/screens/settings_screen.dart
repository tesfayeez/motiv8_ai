import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/account_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';

class SettingsScreen extends ConsumerWidget {
  final bool isDirectNavigation;

  const SettingsScreen({Key? key, this.isDirectNavigation = false})
      : super(key: key);

  void logout(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final theme = ref.watch(themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
        isCenterTitle: true,
        title: 'Settings',
        isBackPresent: isDirectNavigation
            ? false
            : ModalRoute.of(context)?.canPop ?? false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Account Settings',
                  style: GoogleFonts.poppins(
                    color: theme.colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomContainer(
                tileItemColor: theme.colorScheme.primary,
                containerColor: theme.colorScheme.primaryContainer,
                listTileData: [
                  ListTileData(
                    icon: Icons.person,
                    text: 'Account',
                    onPressed: () => Navigator.of(context).push(
                      AccountScreen.route(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'App Settings',
                  style: GoogleFonts.poppins(
                    color: theme.colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CustomContainer(
                tileItemColor: theme.colorScheme.primary,
                containerColor: theme.colorScheme.primaryContainer,
                listTileData: [
                  ListTileData(
                    icon: Icons.alarm,
                    text: 'Notification',
                    onPressed: () => Navigator.of(context).push(
                      AccountScreen.route(),
                    ),
                  ),
                  ListTileData(
                    icon: Icons.colorize,
                    text: 'App Theme',
                    onPressed: () => Navigator.of(context).push(
                      ThemeScreen.route(),
                    ),
                  )
                ],
              )
            ]),
      )),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Color containerColor;
  final Color tileItemColor;

  final List<ListTileData> listTileData;

  CustomContainer({
    required this.containerColor,
    required this.listTileData,
    required this.tileItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: listTileData.map((data) {
          return ListTile(
            leading: Icon(data.icon),
            title: Text(
              data.text,
              style: GoogleFonts.poppins(
                  color: tileItemColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: tileItemColor,
              size: 25,
            ), // Indicator on the right
            onTap: data.onPressed,
          );
        }).toList(),
      ),
    );
  }
}

class ListTileData {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  ListTileData({
    required this.text,
    required this.icon,
    required this.onPressed,
  });
}
