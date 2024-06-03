import 'package:json_annotation/json_annotation.dart';
import 'package:terminal_frontend/domain/user/user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(name: 'id')
  final int? userId;

  @JsonKey(name: 'token_id')
  final String tokenId;

  @JsonKey(name: 'created_at')
  final DateTime? creationDate;

  final int balance;

  @JsonKey(name: 'paired_user')
  final String? username;

  @JsonKey(name: 'pairing_url')
  final String? pairingURL;

  UserDto({
    this.userId,
    required this.tokenId,
    this.creationDate,
    required this.balance,
    this.username,
    this.pairingURL,
  });

  User toDomain() {
    return User(
      userId: userId,
      tokenId: tokenId,
      creationDate: creationDate,
      balance: balance,
      username: username,
      pairingURL: pairingURL,
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) {
    // remove the data wrapper
    // json = json['data'];
    return _$UserDtoFromJson(json);
  }
}
