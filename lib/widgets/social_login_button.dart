import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon leadingIcon;

  const SocialLoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.75,
      height: 55, // set the height as per your requirement
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0), // light grey shadow
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.grey), // icon color
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.grey, // border color
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(
                  20), // Set the borderRadius as per your requirement for circular borders
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            leadingIcon,
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
