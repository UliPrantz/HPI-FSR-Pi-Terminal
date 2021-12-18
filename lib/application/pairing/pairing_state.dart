import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/pairing/pairing_data.dart';
import 'package:terminal_frontend/domain/user/user.dart';

enum PairingProcessState {
  notPairedYet,
  pairingNotPossible,
  pairingTokenNotFound,
  pairingSucceeded,
}
class PairingState with EquatableMixin {
  final PairingProcessState pairingProcessState;
  final PairingData pairingData;
  final User user;

  PairingState({
    required this.pairingProcessState, 
    required this.pairingData, 
    required this.user
  });
  PairingState.init({required String tokenId}) : this(
    pairingProcessState: PairingProcessState.notPairedYet,
    pairingData: PairingData.empty(tokenId: tokenId),
    user: User.empty(),
  );

  PairingState copyWith({
    PairingProcessState? pairingProcessState,
    PairingData? pairingData,
    User? user,
  }) {
    return PairingState(
      pairingProcessState: pairingProcessState ?? this.pairingProcessState,
      pairingData: pairingData ?? this.pairingData,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [pairingProcessState, pairingData];
}