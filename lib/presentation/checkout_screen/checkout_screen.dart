import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/fsr_wallet_app_bar.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class CheckoutScreen extends StatelessWidget {
  final String newBalance;
  final Color textColor;

  CheckoutScreen({
    Key? key, 
    required int newBalance
  }) : 
    newBalance = newBalance.toEuroString(),
    textColor = newBalance.isNegative ? Colors.red : Colors.green,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FsrWalletAppBar(),
      backgroundColor: AppColors.darkGrey,
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "New Balance:\n",
            style: TextStyles.checkOutScreenText,
            children: [
              TextSpan(
                text: newBalance,
                style: TextStyles.checkOutScreenText.copyWith(color: textColor)
              )
            ]
          ) 
        )
      ),
    );
  }
}