import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/pairing/pairing_cubit.dart';
import 'package:terminal_frontend/application/pairing/pairing_state.dart';
import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/infrastructure/pairing/pairing_service.dart';
import 'package:terminal_frontend/injection_container.dart';
import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/snack_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/pairing_screen/numpad.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_code_input.dart';
import 'package:terminal_frontend/presentation/pairing_screen/qr_code_info.dart';

class PairingScreen extends StatelessWidget {
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
            Expanded(
              child: QrCodeInfo(
                serverUri: GetIt.I<EnvironmentConfig>().serverUri,
                tokenId: tokenId,
              )
            ),

            Container(
              color: AppColors.darkGrey,
              width: 1,  
            ),

            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PairingCodeInput(
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

  void pairingStateChanged(BuildContext context, PairingState state) {
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
        AutoRouter.of(context).pop<User>(state.user);
        break;
    }
  }
}