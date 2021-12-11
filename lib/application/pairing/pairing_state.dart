import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/pairing/pairing_data.dart';

enum PairingProcessState {
  notPairedYet,
  pairingFaild,
  pairingSucceeded,
}
class PairingState with EquatableMixin {
  final PairingProcessState pairingProcessState;
  final PairingData pairingData;

  PairingState({required this.pairingProcessState, required this.pairingData});
  PairingState.init({required String tokenId}) : this(
    pairingProcessState: PairingProcessState.notPairedYet,
    pairingData: PairingData.empty(tokenId: tokenId)
  );

  PairingState copyWith({
    PairingProcessState? pairingProcessState,
    PairingData? pairingData,
  }) {
    return PairingState(
      pairingProcessState: pairingProcessState ?? this.pairingProcessState,
      pairingData: pairingData ?? this.pairingData
    );
  }

  @override
  List<Object?> get props => [pairingProcessState, pairingData];
}