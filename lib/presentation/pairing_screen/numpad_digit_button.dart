import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/pairing_screen/numpad_base_button.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumpadDigitButton extends StatelessWidget {
  final String value;
  final Color textColor;
  final KeyboardTapCallback onKeyboardTap;

  const NumpadDigitButton(
    this.value,
    {Key? key, 
    required this.textColor,
    required this.onKeyboardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumpadBaseButton(
      callback: () => onKeyboardTap(value), 
      child: Text(
          value,
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
    );
  }
}