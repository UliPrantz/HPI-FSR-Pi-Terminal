import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:terminal_frontend/injection_container.dart';
import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/core/styles/text_styles.dart';

@RoutePage()
class PairingScreen extends StatelessWidget {
  static const int millisecondsToShowPairingSucceededConfirmation = 1500;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final String tokenId;

  PairingScreen({super.key, required this.tokenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.mainColor,
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "Please scan the QR code to pair your transponder before using the terminal",
                  style: TextStyles.mainTextBigBright,
                  textAlign: TextAlign.center),
              const Padding(padding: EdgeInsets.only(bottom: 20.0)),
              QrImageView(
                data: qrUrl(tokenId),
                version: QrVersions.auto,
                size: 150.0,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20.0)),
              FloatingActionButton.extended(
                  label: const Text(
                    "Done",
                    style: TextStyles.mainTextBigDark,
                  ),
                  icon: const Icon(
                    Icons.done,
                    size: 30,
                  ),
                  onPressed: () {
                    logoutRoute(context);
                  }),
            ],
          ),
        ));
  }

  String qrUrl(String tokenId) {
    return "${GetIt.I<EnvironmentConfig>().pairingUrlPrefix}$tokenId/";
  }
}
