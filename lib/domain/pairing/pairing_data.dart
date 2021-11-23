import 'package:equatable/equatable.dart';

class PairingData with EquatableMixin {
  final String uuid;
  final String pairingCode;

  PairingData({required this.uuid, required this.pairingCode});
  PairingData.empty() : this(uuid: "", pairingCode: "");

  @override
  List<Object?> get props => [uuid, pairingCode];
}