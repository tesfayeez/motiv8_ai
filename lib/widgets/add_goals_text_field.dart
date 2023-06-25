import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

/// A custom text field for goal entry with flexible height and optional suffix icon.
class GoalsTextField extends ConsumerWidget {
  final String hintText;
  final bool hasSuffixIcon;
  final TextEditingController controller;
  final bool isHeightGrow;
  final FocusNode? focusNode;

  // The custom border to be used by the text field.
  static const OutlineInputBorder customBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Color.fromARGB(255, 175, 228, 254)),
  );

  const GoalsTextField({
    required this.hintText,
    this.hasSuffixIcon = false,
    required this.controller,
    this.isHeightGrow = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final textField = _buildTextField(theme);

    return isHeightGrow
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: textField,
          )
        : SizedBox(height: 60, child: textField);
  }

  TextField _buildTextField(ThemeData themeData) {
    final isDarkTheme = themeData.brightness == Brightness.dark;
    return TextField(
      keyboardType: TextInputType.text,
      focusNode: focusNode,
      cursorHeight: 20,
      inputFormatters: [
        LengthLimitingTextInputFormatter(isHeightGrow ? 200 : 40),
      ],
      maxLines: isHeightGrow ? null : 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 18),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 22.5, 10, 22.5),
        filled: true,
        fillColor: themeData.colorScheme.onSecondaryContainer,
        border: customBorder,
        enabledBorder: customBorder.copyWith(
          borderSide: BorderSide(
            color: controller.text.isNotEmpty
                ? themeData.colorScheme.primary
                : isDarkTheme
                    ? themeData.colorScheme.onSecondaryContainer
                    : themeData.colorScheme.secondary,
          ),
        ),
        focusedBorder: customBorder.copyWith(
          borderSide: BorderSide(color: themeData.colorScheme.primary),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            color: themeData.colorScheme.onTertiary, fontSize: 18),
        suffixIcon: hasSuffixIcon
            ? Icon(Icons.add, color: themeData.colorScheme.primary, size: 35)
            : null,
      ),
    );
  }
}
