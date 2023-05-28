import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final bool isBackPresent;
  final bool isCenterTitle;
  final bool isBottomLinePresent;

  CustomAppBar({
    required this.title,
    this.backgroundColor = Colors.white,
    this.isBackPresent = true,
    this.isCenterTitle = false,
    this.isBottomLinePresent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.0,
      leading: isBackPresent
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      centerTitle: isCenterTitle,
      bottom: isBottomLinePresent
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.black54,
                height: 1.0,
              ),
            )
          : null,
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10.0);
}
