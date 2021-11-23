import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class FsrWalletAppBar extends AppBar {
  FsrWalletAppBar({Key? key }) : super(
    key: key,
    title: const Text(
      "FSR Wallet",
      style: TextStyles.appBarText
    ),
    backgroundColor: AppColors.fsrYellow
  );
}