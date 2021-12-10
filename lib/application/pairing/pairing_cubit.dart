import "package:bloc/bloc.dart";
import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/application/chip_scan/chip_scan_cubit.dart';
import 'package:terminal_frontend/application/pairing/pairing_state.dart';
import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/pairing/pairing_service_interface.dart';
import 'package:terminal_frontend/domain/user/user.dart';

class PairingCubit extends Cubit<PairingState> {
  final PairingServiceInterface pairingService;
  final ShoppingCubit shoppingCubit;

  PairingCubit({
    required this.pairingService,
    required ChipScanCubit chipScanCubit,
    required this.shoppingCubit
  }) : super(PairingState.init(tokenId: chipScanCubit.state.chipScanData.uuid));

  void pairChip() async {
    Either<HttpFailure, User> result = await pairingService.pairUser(state.pairingData);
    result.fold(
      (failure) {
        // TODO add error handling here
      }, 
      (user) {
        shoppingCubit.registerUserFromPairing(user);
      });
  }

  void addCharacter(String character) {
    String newCode = state.pairingData.pairingCode + character;
    
    final PairingState newState = 
      state.copyWith(pairingData: state.pairingData.copyWith(pairingCode: newCode));
    emit(newState);
  }

  void removeCharacter() {
    String newCode = state.pairingData.pairingCode;
    newCode = newCode.substring(0, newCode.length);

    PairingState newState = 
      state.copyWith(pairingData: state.pairingData.copyWith(pairingCode: newCode));
    emit(newState);
  }
}