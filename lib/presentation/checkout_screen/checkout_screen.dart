import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';

class CheckoutScreen extends StatelessWidget {
  final String newBalance;

  CheckoutScreen({
    Key? key, 
    required int newBalance
  }) : 
    newBalance = newBalance.toEuroString(), 
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FsrWalletAppBar(),
      body: Center(
        child: Text(
          "Neues Guthaben:\n$newBalance€",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}