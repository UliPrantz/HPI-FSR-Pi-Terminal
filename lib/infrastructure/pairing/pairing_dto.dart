import 'package:json_annotation/json_annotation.dart';

import 'package:terminal_frontend/domain/pairing/pairing_data.dart';

part 'pairing_dto.g.dart';

@JsonSerializable(createFactory: false)
class PairingDto {
  @JsonKey(ignore: true)
  final String tokenId;
  final String pairingCode;

  PairingDto({required this.tokenId, required this.pairingCode});

  factory PairingDto.fromDomain({required PairingData pairingData}) {
    return PairingDto(
      tokenId: pairingData.tokenId, 
      pairingCode: pairingData.pairingCode
    );
  }

  Map<String, dynamic> toJson() => _$PairingDtoToJson(this);
}