import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/pairing/pairing_cubit.dart';
import 'package:terminal_frontend/application/pairing/pairing_state.dart';
import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/infrastructure/pairing/pairing_service.dart';
import 'package:terminal_frontend/presentation/core/fsr_wallet_app_bar.dart';
import 'package:terminal_frontend/presentation/core/snack_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/pairing_screen/numpad.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_code_display.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_info_text.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_succeeded_overlay.dart';

class PairingScreen extends StatelessWidget {
  static const int millisecondsToShowPairingSucceededConfirmation = 1500;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final String tokenId;
  final PairingCubit pairingCubit;

  PairingScreen({ 
    Key? key,
    required this.tokenId
  }) : 
    pairingCubit = PairingCubit(
      pairingService: GetIt.I<PairingService>(),
      tokenId: tokenId
    ),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PairingCubit, PairingState>(
      bloc: pairingCubit,
      listener: pairingStateChanged,
      child: Scaffold(
        key: scaffoldKey,
        appBar: FsrWalletAppBar(showLogout: true, showBack: true,),
        body: Row(
          children: [
            const Expanded(
              child: PairingInfoText()
            ),

            Container(
              color: AppColors.darkGrey,
              width: 1,  
            ),

            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PairingCodeDisplay(
                    pairingCubit: pairingCubit,
                    numberOfDigits: PairingCubit.maxPairCodeLength,
                  ),
                  Numpad(
                    onKeyboardTap: _onNumberPressed,
                    rightButtonFn: _onPairPressed,
                    leftButtonFn: _onRemovePressed,
                    rightIcon: const Icon(Icons.check),
                    leftIcon: const Icon(Icons.backspace_rounded),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onNumberPressed(String number) {
    pairingCubit.addCharacter(number);
  }

  void _onRemovePressed() {
    pairingCubit.removeCharacter();
  }

  void _onPairPressed() {
    pairingCubit.pairChip();
  }

  void pairingStateChanged(BuildContext context, PairingState state) async {
    switch (state.pairingProcessState) {
      case PairingProcessState.notPairedYet:
        break;
      
      case PairingProcessState.pairingNotPossible:
        showSnackBar(scaffoldKey: scaffoldKey, text: "Pairing currently not possible. Please try later again.");
        break;
      
      case PairingProcessState.pairingTokenNotFound:
        showSnackBar(scaffoldKey: scaffoldKey, text: "Pairing-Token was not found or is already expired/used.");
        break;

      case PairingProcessState.pairingSucceeded:
        await showSuccessDialog(context);
        AutoRouter.of(context).pop<User>(state.user);
        break;
    }
  }

  Future<void> showSuccessDialog(BuildContext context) async {
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (_) => const PairingSucceededOverlay()
    );

    Overlay.of(context)?.insert(overlayEntry);

    await Future.delayed(const Duration(milliseconds: millisecondsToShowPairingSucceededConfirmation));

    overlayEntry.remove();
  }
}