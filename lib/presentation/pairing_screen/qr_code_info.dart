import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QrCodeInfo extends StatelessWidget {
  const QrCodeInfo({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Ziemlich langer Text der hier hinkommt "
                "alles sowas hin dies das Annanas.",
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Center(
              child: QrImage(
                data: "Jo hier kommt sowas hin wie nen Link...",
                version: 20,
                size: 200,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
            ),
          ),
        ],
      )
    );
  }
}