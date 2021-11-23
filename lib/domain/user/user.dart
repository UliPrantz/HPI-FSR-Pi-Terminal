import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  final String uuid;
  final String tokenId;
  final DateTime creationDate;
  final double balance;
  final bool paired;

  User({
    required this.uuid,
    required this.tokenId,
    required this.creationDate,
    required this.balance,
    required this.paired,
  });

  User.empty() : this(
    uuid: "",
    tokenId: "",
    creationDate: DateTime.fromMillisecondsSinceEpoch(0),
    balance: 0,
    paired: false,
  );

  @override
  List<Object?> get props => [uuid, tokenId, creationDate, balance, paired];
}