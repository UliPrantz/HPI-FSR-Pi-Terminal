import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class ChipScanScreen extends StatelessWidget {
  const ChipScanScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FsrWalletAppBar(),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Text(
            "Bitte den Transponder an das Lesegerät halten",
            style: TextStyles.mainTextBig,
            textAlign: TextAlign.center
          ),
        ),
      ),
    );
  }
}