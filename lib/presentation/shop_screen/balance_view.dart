import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class BalanceView extends StatelessWidget {
  const BalanceView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Text(
          "Ihr Guthaben:\n10.00€",
          style: TextStyles.mainTextBig,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}