import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class PairingInfoText extends StatelessWidget {
  const PairingInfoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Please enter your pairing code "
        "which can be generated here: 'wallet.myhpi.de'",
        textAlign: TextAlign.center,
        style: TextStyles.normalTextBlack,
      ),
    );
  }
}