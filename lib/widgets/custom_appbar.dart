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
  final bool isCloseOnTheRight;
  final bool isTralingPresent;
  final VoidCallback? onSave;
  final VoidCallback? onBackTapped;

  CustomAppBar({
    required this.title,
    this.backgroundColor = Colors.white,
    this.isBackPresent = true,
    this.isClosePresent = false,
    this.isCenterTitle = false,
    this.isBottomLinePresent = false,
    this.isCloseOnTheRight = false,
    this.isTralingPresent = false,
    this.onSave,
    this.onBackTapped,
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
        if (isTralingPresent && onSave != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: GestureDetector(
              child: Text(
                'Save',
                style: GoogleFonts.poppins(color: theme.colorScheme.primary),
              ),
              onTap: onSave,
            ),
          )
        ],
        if (isCloseOnTheRight) ...[
          GestureDetector(
            child: Icon(
              Icons.close,
              color: theme.colorScheme.onTertiary,
              size: 30,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(
            width: 10,
          )
        ]

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
          ? GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onTertiary,
                size: 30,
              ),
              onTap: isTralingPresent == false && onBackTapped == null
                  ? () => Navigator.of(context).pop()
                  : onBackTapped,
            )
          : isClosePresent
              ? GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: theme.colorScheme.onTertiary,
                    size: 30,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                )
              : null,
      title: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 18, color: theme.colorScheme.tertiary),
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
