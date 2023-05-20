import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LineWithText extends StatelessWidget {
  final String text;

  const LineWithText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontStyle: FontStyle.normal,
              fontSize: 14,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
