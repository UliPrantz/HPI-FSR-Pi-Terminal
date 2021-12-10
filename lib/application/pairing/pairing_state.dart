import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/pairing/pairing_data.dart';

class PairingState with EquatableMixin {
  final PairingData pairingData;

  PairingState({required this.pairingData});
  PairingState.init({required String tokenId}) : this(
    pairingData: PairingData.empty(tokenId: tokenId)
  );

  PairingState copyWith({
    PairingData? pairingData,
  }) {
    return PairingState(pairingData: pairingData ?? this.pairingData);
  }

  @override
  List<Object?> get props => [pairingData];
}