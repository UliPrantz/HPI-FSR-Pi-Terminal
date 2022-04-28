import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/pairing_screen/numpad_digit_button.dart';
import 'package:terminal_frontend/presentation/pairing_screen/numpad_base_button.dart';

class Numpad extends StatelessWidget {
  /// Color of the text [default = Colors.black]
  final Color textColor;

  /// Display a custom right icon
  final Icon? rightIcon;

  /// Action to trigger when right button is pressed
  final VoidCallback? rightButtonFn;

  /// Display a custom left icon
  final Icon? leftIcon;

  /// Action to trigger when left button is pressed
  final VoidCallback? leftButtonFn;

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  /// Main axis alignment [default = MainAxisAlignment.spaceEvenly]
  final MainAxisAlignment mainAxisAlignment;

  const Numpad(
      {Key? key,
      required this.onKeyboardTap,
      this.textColor = Colors.black,
      this.rightButtonFn,
      this.rightIcon,
      this.leftButtonFn,
      this.leftIcon,
      this.mainAxisAlignment = MainAxisAlignment.spaceEvenly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NumpadDigitButton('1', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              NumpadDigitButton('2', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              NumpadDigitButton('3', textColor: textColor, onKeyboardTap: onKeyboardTap,),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NumpadDigitButton('4', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              NumpadDigitButton('5', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              NumpadDigitButton('6', textColor: textColor, onKeyboardTap: onKeyboardTap,),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NumpadDigitButton('7', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              NumpadDigitButton('8', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              NumpadDigitButton('9', textColor: textColor, onKeyboardTap: onKeyboardTap,),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NumpadBaseButton(callback: leftButtonFn, child: leftIcon),
              NumpadDigitButton('0', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              NumpadBaseButton(callback: rightButtonFn, child: rightIcon),
            ],
          ),
        ],
      ),
    );
  }
}
