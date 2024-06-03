import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/shopping/shopping_data.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/domain/user/user.dart';

enum UserState { loadingUser, loadingUserFailed, missingUser, loadedPairedUser }

class ShoppingState with EquatableMixin {
  final UserState userState;
  final ShoppingData shoppingData;
  final User user;

  ShoppingState(
      {required this.userState,
      required this.shoppingData,
      required this.user});
  ShoppingState.init(
      {required String tokenId, required String tag, required List<Item> items})
      : this(
            userState: UserState.loadingUser,
            shoppingData: ShoppingData.empty(items: items, tag: tag),
            user: User.empty(tokenId: tokenId));

  ShoppingState copyWith({
    UserState? userState,
    ShoppingData? shoppingData,
    User? user,
  }) {
    return ShoppingState(
        userState: userState ?? this.userState,
        shoppingData: shoppingData ?? this.shoppingData,
        user: user ?? this.user);
  }

  @override
  List<Object?> get props => [userState, shoppingData, user];
}
