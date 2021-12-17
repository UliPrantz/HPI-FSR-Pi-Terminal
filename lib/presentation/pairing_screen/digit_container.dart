import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class DigitContainer extends StatelessWidget {
  final String digit;

  const DigitContainer({
    Key? key,
    required this.digit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0,
      height: 52.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
          ),
          BoxShadow(
            color: Colors.white,
            spreadRadius: -1.0,
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(6.0))
      ),
      child: Center(
        child: Text(
          digit,
          style: TextStyles.normalTextBlack,
        ),
      ),
    );
  }
}