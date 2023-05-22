import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/pallete_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObescure;
  final String? errorText;
  final Icon? leftIcon;
  final double? textFieldHeight;
  final bool? readOnly;
  final VoidCallback? onTap;

  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.isObescure = false,
      this.errorText,
      this.leftIcon,
      this.textFieldHeight = 60.0,
      this.readOnly = false,
      this.onTap})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obsecureText = false;

  @override
  void initState() {
    super.initState();
    _obsecureText = widget.isObescure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      height: widget.textFieldHeight,
      child: TextFormField(
        onTap: widget.onTap,
        controller: widget.controller,
        obscureText: _obsecureText,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          fontStyle: FontStyle.normal,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF0F0F0),
          prefixIcon: widget.leftIcon?.color == null
              ? widget.leftIcon
              : Icon(widget.leftIcon?.icon, color: Colors.grey),
          suffixIcon: widget.isObescure
              ? GestureDetector(
                  onTap: () => setState(() => _obsecureText = !_obsecureText),
                  child: Icon(
                    _obsecureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                )
              : null,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 3,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 3,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
          errorText: widget.errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
