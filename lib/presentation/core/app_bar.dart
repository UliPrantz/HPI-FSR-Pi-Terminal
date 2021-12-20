import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';

import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/presentation/core/app_bar_button.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class FsrWalletAppBar extends AppBar {
  final bool showLogout;
  final bool showPairing;
  final bool showBack;

  final VoidCallback? pairingPressedCallback;

  FsrWalletAppBar({
    Key? key, 
    this.showLogout=false, 
    this.showPairing=false, 
    this.showBack=false,
    this.pairingPressedCallback,
  }) : 
  assert(!(showPairing && showBack), "Only one of 'showPairing' and 'showBack' can be true!"),
  assert(!showPairing || (pairingPressedCallback != null), "When pairing button should be shown, then the callback must be also provided!"),
  super(
    key: key,
    automaticallyImplyLeading: false,
    title: Builder(
      builder: (context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showLogout)
              AppBarButton(text: "Logout", callback: () => _logoutCallback(context)),

            const Spacer(),

            Text(
              GetIt.I<StartScreenCubit>().state.terminalMetaData.name,
              style: TextStyles.appBarText
            ),
            
            const Spacer(),

            if (showPairing)
              AppBarButton(text: "Pairing", callback: pairingPressedCallback!),
            if (showBack)
              AppBarButton(text: "Back", callback: () => _backCallback(context)),
          ],
        );
      }
    ),
    backgroundColor: AppColors.fsrYellow
  );

  static void _logoutCallback(BuildContext context) {
    logoutRoute(context);
  }

  static void _backCallback(BuildContext context) {
    AutoRouter.of(context).pop();
  }
}