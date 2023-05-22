import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackPresent;

  CustomAppBar({required this.title, this.isBackPresent = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // removes the shadow/border
      leading: isBackPresent
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              ), // your custom icon
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
      centerTitle: false,
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
