import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/fsr_wallet_app_bar.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

@RoutePage()
class CheckoutScreen extends StatelessWidget {
  final String newBalance;
  final Color textColor;
  final String username;

  CheckoutScreen({super.key, required int newBalance, required this.username})
      : newBalance = newBalance.toEuroString(),
        textColor = newBalance.isNegative ? Colors.red : Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FsrWalletAppBar(
          showLogout: false,
          showTerminalName: false,
          trailing: Text(
            username,
            textAlign: TextAlign.center,
            style: TextStyles.boldTextMediumBright,
          )),
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  text: "New Balance\n",
                  style: TextStyles.checkOutScreenText,
                  children: [])),
          FloatingActionButton.extended(
            onPressed: null,
            icon: Icon(Icons.credit_card,
                size: TextStyles.checkOutScreenText.fontSize),
            backgroundColor: Colors.white,
            label: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: newBalance,
                    style: TextStyles.checkOutScreenText
                        .copyWith(color: textColor))),
          )
        ]),
      ),
    );
  }
}
