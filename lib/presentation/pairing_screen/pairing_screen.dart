import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/pairing/pairing_cubit.dart';
import 'package:terminal_frontend/application/pairing/pairing_state.dart';
import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/infrastructure/pairing/pairing_service.dart';
import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/pairing_screen/numpad.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_code_input.dart';
import 'package:terminal_frontend/presentation/pairing_screen/qr_code_info.dart';

class PairingScreen extends StatelessWidget {
  final PairingCubit pairingCubit;

  PairingScreen({ 
    Key? key,
    required String tokenId
  }) : 
    pairingCubit = PairingCubit(
      pairingService: GetIt.I<PairingService>(),
      tokenId: tokenId
    ),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PairingCubit, PairingState>(
      bloc: pairingCubit,
      listener: pairingStateChanged,
      builder: (context, state) {
        return Scaffold(
          appBar: FsrWalletAppBar(showLogout: true, showBack: true,),
          body: Row(
            children: [
              Expanded(
                child: QrCodeInfo()
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
                    PairingCodeInput(numberOfDigits: 8,),
                    Numpad(
                      onKeyboardTap: (String key) {},
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  void onKeyPressed(String key) {

  }

  void pairingStateChanged(BuildContext context, PairingState state) {
    // TODO add error handling
    if (state.pairingProcessState == PairingProcessState.pairingSucceeded) {
      AutoRouter.of(context).pop<User>();
    }
  }
}