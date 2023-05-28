import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom text field for goal entry with flexible height and optional suffix icon.
class GoalsTextField extends StatelessWidget {
  final String hintText;
  final bool hasSuffixIcon;
  final TextEditingController controller;
  final bool isHeightGrow;

  // The custom border to be used by the text field.
  static const OutlineInputBorder customBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Color.fromARGB(255, 175, 228, 254)),
  );

  GoalsTextField({
    required this.hintText,
    this.hasSuffixIcon = false,
    required this.controller,
    this.isHeightGrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final textField = _buildTextField();
    return isHeightGrow
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: textField,
          )
        : SizedBox(height: 55, child: textField);
  }

  TextField _buildTextField() {
    return TextField(
      maxLines: isHeightGrow ? null : 1,
      controller: controller,
      keyboardType: isHeightGrow ? TextInputType.multiline : TextInputType.text,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        filled: true,
        fillColor: Colors.white,
        border: customBorder,
        enabledBorder: customBorder.copyWith(
          borderSide: BorderSide(
            color: controller.text.isNotEmpty
                ? Colors.blue
                : Color.fromARGB(255, 175, 228, 254),
          ),
        ),
        focusedBorder: customBorder.copyWith(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.black45, fontSize: 14),
        suffixIcon: hasSuffixIcon
            ? const Icon(Icons.add, color: Colors.blue, size: 35)
            : null,
      ),
    );
  }
}
