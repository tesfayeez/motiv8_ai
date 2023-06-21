import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

class SocialLoginButton extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;
  final String svgAssetName;

  const SocialLoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.svgAssetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    final theme = ref.watch(themeProvider);

    return SizedBox(
      width: screenWidth * 0.75,
      height: 55, // set the height as per your requirement
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0), // light grey shadow
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(
              theme.colorScheme.onTertiary), // icon color
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: theme.colorScheme.onTertiary, // border color
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
            SvgPicture.asset(
              svgAssetName,
              height: 24, // Adjust the size as needed
              width: 24, // Adjust the size as needed
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: theme.colorScheme.tertiary,
                fontStyle: FontStyle.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
