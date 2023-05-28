import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';

class CustomHomeScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;
  final String subtitle;
  final String message;

  CustomHomeScreenAppBar(
      {required this.name, required this.subtitle, required this.message});

  @override
  Size get preferredSize => Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome $name',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: const [
        CircleAvatar(
          radius: 25, // Reduced the radius
          // Add your avatar image here
          backgroundColor: Colors.grey,
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
