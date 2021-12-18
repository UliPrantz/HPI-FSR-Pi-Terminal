import "package:bloc/bloc.dart";
import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/application/chip_scan/chip_scan_cubit.dart';
import 'package:terminal_frontend/application/pairing/pairing_state.dart';
import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/pairing/pairing_service_interface.dart';
import 'package:terminal_frontend/domain/user/user.dart';

class PairingCubit extends Cubit<PairingState> {
  static const int maxPairCodeLength = 8;
  final PairingServiceInterface pairingService;

  PairingCubit({
    required this.pairingService,
    required String tokenId,
  }) : super(PairingState.init(tokenId: tokenId));

  void pairChip() async {
    // this is just here that we have a change in state everytime this method is 
    // is called otherwise bloc would optimize that away and we couldn't show 
    // a snackbar
    emit(
      state.copyWith(
        pairingProcessState: PairingProcessState.notPairedYet,
      )
    );

    Either<HttpFailure, User> result = await pairingService.pairUser(state.pairingData);

    result.fold(
      (failure) {
        final PairingProcessState newPairingState = failure is PairingTokenNotFound ? 
            PairingProcessState.pairingTokenNotFound : PairingProcessState.pairingNotPossible;

        emit(
          state.copyWith(
            pairingProcessState: newPairingState,
          )
        );
      }, 
      (user) {
        emit(
          state.copyWith(
            pairingProcessState: PairingProcessState.pairingSucceeded,
            user: user
          )
        );
      });
  }

  void addCharacter(String character) {
    if (state.pairingData.pairingCode.length < 8) {
      String newCode = state.pairingData.pairingCode + character;
      
      final PairingState newState = 
        state.copyWith(pairingData: state.pairingData.copyWith(pairingCode: newCode));
      emit(newState);
    }
  }

  void removeCharacter() {
    String newCode = state.pairingData.pairingCode;
    if (newCode.isNotEmpty) {
      newCode = newCode.substring(0, newCode.length - 1);
    }

    PairingState newState = 
      state.copyWith(pairingData: state.pairingData.copyWith(pairingCode: newCode));
    emit(newState);
  }

  String getPairingCodeDigit(int index) {
    assert(index >= 0, "Index must be greater or equal 0!");
    
    final String pairingCode = state.pairingData.pairingCode;
    if (index >= pairingCode.length) {
      return '-';
    }
    return pairingCode[index];
  }
}