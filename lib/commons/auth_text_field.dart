import 'package:flutter/material.dart';
import 'package:motiv8_ai/commons/pallete_colors.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObescure;
  final String? errorText;
  final Icon? leftIcon;
  final double? textFieldHeight;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isObescure = false,
    this.errorText,
    this.leftIcon,
    this.textFieldHeight = 60.0,
  }) : super(key: key);

  @override
  _AuthTextFieldState createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obsecureText = false;

  @override
  void initState() {
    super.initState();
    _obsecureText = widget.isObescure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.textFieldHeight,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obsecureText,
        style: TextStyle(
          color: Colors.grey,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF0F0F0),
          prefixIcon: widget.leftIcon?.color == null
              ? widget.leftIcon
              : Icon(widget.leftIcon?.icon, color: Colors.grey),
          suffixIcon: widget.isObescure
              ? IconButton(
                  icon: Icon(
                    _obsecureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () =>
                      setState(() => _obsecureText = !_obsecureText),
                )
              : null,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red,
              width: 3,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.red,
              width: 3,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
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
