import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/pairing_screen/digit_container.dart';

class PairingCodeInput extends StatelessWidget {
  final int numberOfDigits;

  const PairingCodeInput({ Key? key, required this.numberOfDigits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(numberOfDigits, (index) {
        return DigitContainer();
      })
    );
  }
}

