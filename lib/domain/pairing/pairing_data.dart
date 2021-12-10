import 'package:equatable/equatable.dart';

class PairingData with EquatableMixin {
  final String tokenId;
  final String pairingCode;

  PairingData({required this.tokenId, required this.pairingCode});
  PairingData.empty({String? tokenId}) : this(
    tokenId: tokenId ?? "", 
    pairingCode: ""
  );

  PairingData copyWith({
    String? tokenId,
    String? pairingCode,
  }) {
    return PairingData(
      tokenId: tokenId ?? this.tokenId, 
      pairingCode: pairingCode ?? this.pairingCode
    );
  }

  @override
  List<Object?> get props => [pairingCode];
}