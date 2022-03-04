import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class QrCodeInfo extends StatelessWidget {
  static const String pairingEndpoint = "/pos/wallets/token/";
  final String tokenId;
  final Uri serverUri;

  const QrCodeInfo({
    Key? key,
    required this.serverUri,
    required this.tokenId
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
                "which can be generated here: '${serverUri.host}' "
                "or scan the QR-Code to pair your HPI-Token",
                textAlign: TextAlign.center,
                style: TextStyles.normalTextBlack,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: QrImage(
                data: serverUri.replace(path: "$pairingEndpoint$tokenId").toString(),
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