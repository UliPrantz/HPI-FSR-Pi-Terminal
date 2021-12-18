import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

void showSnackBar({required GlobalKey<ScaffoldState> scaffoldKey, required String text}) {
  final BuildContext scaffoldContext = scaffoldKey.currentContext!;
  final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(scaffoldContext);

  final SnackBar snackBar = SnackBar(
    content: WillPopScope(
      onWillPop: () => _closeAllSnackBars(scaffoldMessenger),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyles.normalTextWhite,
      ),
    ),
  );

  scaffoldMessenger.showSnackBar(snackBar);
}

Future<bool> _closeAllSnackBars(ScaffoldMessengerState scaffoldMessenger) async {
  scaffoldMessenger.clearSnackBars();
  return true;
}