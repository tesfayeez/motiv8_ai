import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.9,
      height: 55, // set the height as per your requirement
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(1), // light grey shadow
          backgroundColor:
              MaterialStateProperty.all(Colors.deepPurple), // button color
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20), // Set the borderRadius as per your requirement for circular borders
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
              color: Colors.white, fontStyle: FontStyle.normal, fontSize: 16),
        ),
      ),
    );
  }
}
