import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

import '../main.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final bool isBackPresent;
  final bool isClosePresent;
  final bool isCenterTitle;
  final bool isBottomLinePresent;

  CustomAppBar({
    required this.title,
    this.backgroundColor = Colors.white,
    this.isBackPresent = true,
    this.isClosePresent = false,
    this.isCenterTitle = false,
    this.isBottomLinePresent = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final navigatorKey = ref.watch(navigatorKeyProvider);
    return AppBar(
      backgroundColor: theme.colorScheme.onBackground,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      actions: [
        // TextButton(
        //   onPressed: () {
        //     ref.read(themeProvider.notifier).changeTheme(AppTheme.dark);
        //   },
        //   child: const Text("Dark mode"),
        // ),
        // TextButton(
        //   onPressed: () {
        //     ref.read(themeProvider.notifier).changeTheme(AppTheme.light);
        //   },
        //   child: const Text("Light mode"),
        // )
      ],
      leading: isBackPresent
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onTertiary,
                size: 30,
              ),
              onPressed: () => navigatorKey.currentState!.pop(),
            )
          : isClosePresent
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.onTertiary,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
      title: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 22, color: theme.colorScheme.tertiary),
      ),
      centerTitle: isCenterTitle,
      bottom: isBottomLinePresent
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: theme.colorScheme.onTertiary.withOpacity(0.6),
                height: 1.0,
              ),
            )
          : null,
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10.0);
}
