import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/account_screen.dart';
import 'package:motiv8_ai/screens/notifications_screen.dart';
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
                'Premium',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
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
                  iconData: Icons.restart_alt,
                  text: 'Restore Purchases',
                  onPressed: () => Navigator.of(context).push(
                    AccountScreen.route(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Account Settings',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
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
                  iconName: 'Profile.svg',
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
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
            ),
            CustomContainer(
              tileItemColor: theme.colorScheme.primary,
              containerColor: theme.colorScheme.primaryContainer,
              listTileData: [
                ListTileData(
                  iconName: 'notification.svg',
                  text: 'Notifications',
                  onPressed: () => Navigator.of(context).push(
                    NotificationsScreen.route(),
                  ),
                ),
                ListTileData(
                  iconName: 'theme.svg',
                  text: 'App Theme',
                  onPressed: () => Navigator.of(context).push(
                    ThemeScreen.route(),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Help & Support',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
            ),
            CustomContainer(
              tileItemColor: theme.colorScheme.primary,
              containerColor: theme.colorScheme.primaryContainer,
              listTileData: [
                ListTileData(
                  text: 'Rate Motive8 5 Stars',
                  iconData: Icons.star,
                  onPressed: () => Navigator.of(context).push(
                    NotificationsScreen.route(),
                  ),
                ),
                ListTileData(
                  text: 'Share with a friend',
                  iconData: Icons.share_sharp,
                  onPressed: () => Navigator.of(context).push(
                    ThemeScreen.route(),
                  ),
                ),
                ListTileData(
                  text: 'Contact Support',
                  iconData: Icons.support,
                  onPressed: () => Navigator.of(context).push(
                    ThemeScreen.route(),
                  ),
                ),
                ListTileData(
                  text: 'Request a feature',
                  iconData: Icons.help,
                  onPressed: () => Navigator.of(context).push(
                    ThemeScreen.route(),
                  ),
                )
              ],
            ),
            Center(
              child: Text(
                'v1.0.0',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.onTertiary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class CustomContainer extends ConsumerWidget {
  final Color containerColor;
  final Color tileItemColor;

  final List<ListTileData> listTileData;

  CustomContainer({
    required this.containerColor,
    required this.listTileData,
    required this.tileItemColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10.0),
      decoration: goalCardDarkThemeDecoration(
          theme.colorScheme.onSecondaryContainer, isDark),
      child: Column(
        children: listTileData.map((data) {
          if (isIOS) {
            return CupertinoListTile(
              iconData: data.iconData,
              svgName: data.iconName ?? '',
              text: data.text,
              onPressed: data.onPressed,
            );
          } else {
            return ListTile(
              leading: data.iconData == null
                  ? SvgPicture.asset('assets/${data.iconName}')
                  : Icon(data.iconData),
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
          }
        }).toList(),
      ),
    );
  }
}

class ListTileData {
  final String text;
  final String? iconName;
  final VoidCallback onPressed;
  final IconData? iconData;

  ListTileData({
    required this.text,
    this.iconName,
    required this.onPressed,
    this.iconData,
  });
}

class CupertinoListTile extends StatelessWidget {
  final String text;
  final String svgName;
  final IconData? iconData;

  final VoidCallback onPressed;

  CupertinoListTile(
      {required this.text,
      required this.svgName,
      required this.onPressed,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Row(
          children: <Widget>[
            if (iconData != null)
              Icon(
                iconData,
                size: 28,
                color: const Color(0xFF1988FF),
              ),
            if (iconData == null)
              SvgPicture.asset(
                'assets/$svgName',
                color: const Color(0xFF1988FF),
              ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(fontSize: 16.0),
              ),
            ),
            Icon(Icons.chevron_right, size: 28.0),
          ],
        ),
      ),
    );
  }
}
