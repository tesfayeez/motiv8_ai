import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final navigatorKey = ref.watch(navigatorKeyProvider);
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      leading: isBackPresent
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => navigatorKey.currentState!.pop(),
            )
          : isClosePresent
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () =>
                      ref.watch(navigatorKeyProvider).currentState!.pop(),
                )
              : null,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      centerTitle: isCenterTitle,
      bottom: isBottomLinePresent
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.black45,
                height: 1.0,
              ),
            )
          : null,
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10.0);
}
