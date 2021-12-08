import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  final String uuid;
  final String tokenId;
  final DateTime creationDate;
  final double balance;
  final String? username;

  User({
    required this.uuid,
    required this.tokenId,
    required this.creationDate,
    required this.balance,
    this.username,
  });

  User.empty() : this(
    uuid: "",
    tokenId: "",
    creationDate: DateTime.fromMillisecondsSinceEpoch(0),
    balance: 0,
  );

  @override
  List<Object?> get props => [uuid, tokenId, creationDate, balance, username];
}