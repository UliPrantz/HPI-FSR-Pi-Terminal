import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

import 'app_bar_button.dart';

class FsrWalletAppBar extends AppBar {
  final bool showLogout;
  final bool showPairing;

  FsrWalletAppBar({Key? key, this.showLogout=false, this.showPairing=false}) : super(
    key: key,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        AppBarButton(text: "Logout", callback: _logoutCallback),

        Text(
          "FSR Wallet",
          style: TextStyles.appBarText
        ),
        
        AppBarButton(text: "Pairing", callback: _pairingCallback),
      ],
    ),
    backgroundColor: AppColors.fsrYellow
  );

  static void _logoutCallback() {

  }

  static void _pairingCallback() {

  }
}