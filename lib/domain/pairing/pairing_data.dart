import 'package:equatable/equatable.dart';

class PairingData with EquatableMixin {
  final String tokenId;
  final String pairingCode;

  PairingData({required this.tokenId, required this.pairingCode});
  PairingData.empty() : this(tokenId: "", pairingCode: "");

  @override
  List<Object?> get props => [pairingCode];
}