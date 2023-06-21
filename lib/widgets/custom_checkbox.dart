import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onChanged(!value),
      child: Container(
        width: 24.0, // define your size
        height: 24.0, // define your size
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: color,
            width: 1.0,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: 20.0,
                color: color,
              )
            : null,
      ),
    );
  }
}
