import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:terminal_frontend/application/pairing/pairing_cubit.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class QrCodeInfo extends StatelessWidget {
  final PairingCubit pairingCubit;

  const QrCodeInfo({
    Key? key,
    required this.pairingCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Please enter your pairing code "
                "which can be generated here: '${pairingCubit.getServerUri()}' "
                "or scan the QR-Code to pair your HPI-Token",
                textAlign: TextAlign.center,
                style: TextStyles.normalTextBlack,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: QrImage(
                data: pairingCubit.generateQrCodeData(),
                version: 9,
                size: 135,
                errorCorrectionLevel: QrErrorCorrectLevel.Q,
              ),
            ),
          ),
        ],
      )
    );
  }
}