import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/pairing_screen/calc_button.dart';

class Numpad extends StatelessWidget {
  /// Color of the text [default = Colors.black]
  final Color textColor;

  /// Display a custom right icon
  final Icon? rightIcon;

  /// Action to trigger when right button is pressed
  final Function()? rightButtonFn;

  /// Display a custom left icon
  final Icon? leftIcon;

  /// Action to trigger when left button is pressed
  final Function()? leftButtonFn;

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
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              CalcButton('1', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              CalcButton('2', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              CalcButton('3', textColor: textColor, onKeyboardTap: onKeyboardTap,),
            ],
          ),
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              CalcButton('4', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              CalcButton('5', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              CalcButton('6', textColor: textColor, onKeyboardTap: onKeyboardTap,),
            ],
          ),
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              CalcButton('7', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              CalcButton('8', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              CalcButton('9', textColor: textColor, onKeyboardTap: onKeyboardTap,),
            ],
          ),
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              InkWell(
                  borderRadius: BorderRadius.circular(45),
                  onTap: leftButtonFn,
                  child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: leftIcon)),
              CalcButton('0', textColor: textColor, onKeyboardTap: onKeyboardTap,),
              InkWell(
                  borderRadius: BorderRadius.circular(45),
                  onTap: rightButtonFn,
                  child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: rightIcon))
            ],
          ),
        ],
      ),
    );
  }
}