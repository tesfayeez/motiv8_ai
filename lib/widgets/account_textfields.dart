import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final String? errorText;
  final Icon? leftIcon;
  final double? textFieldHeight;
  final bool? enabled;
  final String? initialValue; // Add initialValue property
  final VoidCallback? onTap;
  final Color fillColor;
  final Color hintColor;

  const AccountTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.isObscure = false,
      this.errorText,
      this.leftIcon,
      this.textFieldHeight = 60.0,
      this.enabled,
      this.initialValue, // Define initialValue property
      this.onTap,
      this.fillColor = Colors.white,
      this.hintColor = Colors.black45})
      : super(key: key);

  @override
  _AccountTextFieldState createState() => _AccountTextFieldState();
}

class _AccountTextFieldState extends State<AccountTextField> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscure;
    _controller = widget.controller;
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  static const OutlineInputBorder customBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Color.fromARGB(255, 175, 228, 254)),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      height: widget.textFieldHeight,
      child: TextFormField(
          onTap: widget.onTap,
          controller: _controller,
          obscureText: _obscureText,
          enabled: widget.enabled ?? true,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            fontStyle: FontStyle.normal,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
            filled: true,
            fillColor: widget.fillColor,
            border: customBorder,
            enabledBorder: customBorder.copyWith(
              borderSide: BorderSide(
                color: _controller.text.isNotEmpty
                    ? Colors.blue
                    : Color.fromARGB(255, 175, 228, 254),
              ),
            ),
            focusedBorder: customBorder.copyWith(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            hintStyle:
                GoogleFonts.poppins(color: widget.hintColor, fontSize: 14),
          )),
    );
  }
}
