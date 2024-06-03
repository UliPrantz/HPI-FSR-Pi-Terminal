import 'package:flutter/material.dart';


import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/presentation/core/app_bar_button.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class FsrWalletAppBar extends AppBar {
  final bool showLogout;
  final bool showTerminalName;

  final VoidCallback? pairingPressedCallback;
  final Widget? trailing;

  FsrWalletAppBar({
    super.key,
    this.showLogout = false,
    this.pairingPressedCallback,
    this.trailing,
    this.showTerminalName = true,
  }) : super(
            automaticallyImplyLeading: false,
            title: Builder(builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showLogout)
                    AppBarButton(
                        text: "Logout",
                        callback: () => _logoutCallback(context)),
                  if (showTerminalName) Expanded(flex: 2, child: Container()),
                  if (trailing != null)
                    Expanded(
                      flex: 2,
                      child: trailing,
                    )
                ],
              );
            }),
            backgroundColor: AppColors.mainColor);

  static void _logoutCallback(BuildContext context) {
    logoutRoute(context);
  }
}
