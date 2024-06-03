import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  final int? userId;
  final String tokenId;
  final DateTime? creationDate;
  final int balance;
  final String? username;
  final String? pairingURL;

  User({
    this.userId,
    required this.tokenId,
    this.creationDate,
    required this.balance,
    this.username,
    this.pairingURL,
  });

  User.empty({String? tokenId})
      : this(
          tokenId: tokenId ?? "",
          balance: 0,
        );

  User copyWith({
    final int? userId,
    final String? tokenId,
    final DateTime? creationDate,
    final int? balance,
    final String? username,
  }) {
    return User(
      userId: userId ?? this.userId,
      tokenId: tokenId ?? this.tokenId,
      creationDate: creationDate ?? this.creationDate,
      balance: balance ?? this.balance,
      username: username ?? this.username,
    );
  }

  @override
  List<Object?> get props => [userId, tokenId, creationDate, balance, username];
}
