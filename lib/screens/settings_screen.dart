import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/screens/account_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void logout(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    Widget appBar = AppBar(
      title: const Text('Settings'),
    );

    if (isIOS) {
      appBar = const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text('Settings'),
        backgroundColor: Colors.transparent,
        border: null,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: appBar,
      ),
      body: _buildSettingsList(context, isIOS, ref),
    );
  }

  Widget _buildSettingsList(BuildContext context, bool isIOS, WidgetRef ref) {
    final tiles = [
      ListTile(
        leading: isIOS
            ? const Icon(CupertinoIcons.person_fill)
            : const Icon(Icons.person),
        title: const Text('Account'),
        onTap: () {
          Navigator.of(context).push(AccountScreen.route());
        },
      ),
      ListTile(
        leading: isIOS
            ? const Icon(CupertinoIcons.bell_fill)
            : const Icon(Icons.notifications),
        title: const Text('Notifications'),
        onTap: () {
          // TODO: Navigate to notifications screen
        },
      ),
      ListTile(
        leading: isIOS
            ? const Icon(CupertinoIcons.clock_fill)
            : const Icon(Icons.access_time),
        title: const Text('Reminder Frequency'),
        onTap: () {
          // TODO: Navigate to reminder frequency screen
        },
      ),
      ListTile(
        leading: isIOS
            ? const Icon(CupertinoIcons.arrow_left_circle_fill)
            : const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () => logout(context, ref),
      ),
    ];

    if (isIOS) {
      return CupertinoScrollbar(
        child: ListView.separated(
          itemCount: tiles.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            return tiles[index];
          },
        ),
      );
    } else {
      return Scrollbar(
        child: ListView.builder(
          itemCount: tiles.length,
          itemBuilder: (BuildContext context, int index) {
            return tiles[index];
          },
        ),
      );
    }
  }
}
