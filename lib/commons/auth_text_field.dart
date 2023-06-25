// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:motiv8_ai/commons/pallete_colors.dart';

// class CustomTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final bool isObescure;
//   final String? errorText;
//   final Icon? leftIcon;
//   final double? textFieldHeight;
//   final bool? readOnly;
//   final VoidCallback? onTap;

//   const CustomTextField(
//       {Key? key,
//       required this.controller,
//       required this.hintText,
//       this.isObescure = false,
//       this.errorText,
//       this.leftIcon,
//       this.textFieldHeight = 60.0,
//       this.readOnly = false,
//       this.onTap})
//       : super(key: key);

//   @override
//   _CustomTextFieldState createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _obsecureText = false;

//   @override
//   void initState() {
//     super.initState();
//     _obsecureText = widget.isObescure;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       height: widget.textFieldHeight,
//       child: TextFormField(
//         onTap: widget.onTap,
//         controller: widget.controller,
//         obscureText: _obsecureText,
//         style: GoogleFonts.poppins(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: Colors.grey,
//           fontStyle: FontStyle.normal,
//         ),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: const Color(0xFFF0F0F0),
//           prefixIcon: widget.leftIcon?.color == null
//               ? widget.leftIcon
//               : Icon(widget.leftIcon?.icon, color: Colors.grey),
//           suffixIcon: widget.isObescure
//               ? GestureDetector(
//                   onTap: () => setState(() => _obsecureText = !_obsecureText),
//                   child: Icon(
//                     _obsecureText ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey,
//                   ),
//                 )
//               : null,
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(
//               color: Colors.red,
//               width: 3,
//             ),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(
//               color: Colors.red,
//               width: 3,
//             ),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//           hintText: widget.hintText,
//           hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
//           errorText: widget.errorText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

class CustomTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final String? errorText;
  final Icon? leftIcon;
  final double? textFieldHeight;
  final bool? enabled;
  final String? initialValue; // Add initialValue property
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.errorText,
    this.leftIcon,
    this.textFieldHeight = 60.0,
    this.enabled,
    this.initialValue, // Define initialValue property
    this.onTap,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
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

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    return Container(
      decoration:
          customAuthTextfieldDecoration(theme.colorScheme.onSecondaryContainer),
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
          filled: true,
          fillColor: isDark
              ? theme.colorScheme.onSecondaryContainer
              : Color(0x26AAAAAA),
          prefixIcon: widget.leftIcon?.color == null
              ? widget.leftIcon
              : Icon(widget.leftIcon?.icon, color: Colors.grey),
          suffixIcon: widget.isObscure
              ? GestureDetector(
                  onTap: () => setState(() => _obscureText = !_obscureText),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
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
            borderRadius: BorderRadius.circular(12),
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
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
