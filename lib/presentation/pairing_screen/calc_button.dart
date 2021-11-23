import 'package:flutter/material.dart';

typedef KeyboardTapCallback = void Function(String text);

class CalcButton extends StatelessWidget {
  final String value;
  final Color textColor;
  final KeyboardTapCallback onKeyboardTap;

  const CalcButton(
    this.value,
    {Key? key, 
    required this.textColor,
    required this.onKeyboardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: () {
        onKeyboardTap(value);
      },
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        child: Text(
          value,
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
      )
    );
  }
}