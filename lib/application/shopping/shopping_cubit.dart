import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import "package:bloc/bloc.dart";
import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/shopping/shopping_data.dart';
import 'package:terminal_frontend/domain/shopping/shopping_service_interface.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/domain/user/user_service_interface.dart';
import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/application/core/data_formatter_extension.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  static const int secondsToShowCheckoutScreen = 3;

  final ShoppingServiceInterface shoppingService;
  final UserServiceInterface userService;

  ShoppingCubit({
    required this.shoppingService,
    required this.userService,
    required String tokenId,
    required String tag,
    required List<Item> items,
  }) : super(ShoppingState.init(tokenId: tokenId, items: items, tag: tag)) {
    getUserBalance();
  }

  void getUserBalance() async {
    final String tokenId = state.user.tokenId;
    final Either<HttpFailure, User> result =
        await userService.getUserInfo(tokenId);

    result.fold((failure) {
      final UserState newUserState = failure is UserNotFound
          ? UserState.missingUser
          : UserState.loadingUserFailed;

      emit(state.copyWith(
        userState: newUserState,
        user: state.user.copyWith(tokenId: tokenId),
      ));
    }, (user) {
      final UserState newUserState = user.username == null
          ? UserState.missingUser
          : UserState.loadedPairedUser;

      emit(state.copyWith(userState: newUserState, user: user));
    });
  }

  void registerUserFromPairing(User user) {
    emit(state.copyWith(userState: UserState.loadedPairedUser, user: user));
  }

  void addItemToCart(Item item) {
    int newItemCount = state.shoppingData.overallItemCount + 1;
    int newPurchaseCost = state.shoppingData.purchaseCost + item.price;
    Map<Item, int> tmpSelectedItems =
        Map.from(state.shoppingData.selectedItems);

    // increase the counter of the corresponding item
    if (tmpSelectedItems.containsKey(item)) {
      //actually this should always be true!
      tmpSelectedItems[item] = tmpSelectedItems[item]! + 1;
    }

    final String newDescription = createDescriptionString(tmpSelectedItems);

    final ShoppingData newShoppingData = state.shoppingData.copyWith(
      overallItemCount: newItemCount,
      purchaseCost: newPurchaseCost,
      selectedItems: UnmodifiableMapView(tmpSelectedItems),
      transactionDescription: newDescription,
    );

    emit(state.copyWith(shoppingData: newShoppingData));
  }

  bool canCheckout() {
    return state.shoppingData.overallItemCount > 0;
  }

  String createDescriptionString(Map<Item, int> itemMap) {
    final List<String> itemStrings = [];
    itemMap.forEach((key, value) {
      if (value != 0) {
        itemStrings.add("$value x ${key.name}");
      }
    });

    // Limiting the description to 100 characters
    // since this is required by the backend
    return itemStrings.join(', ').limitCharacters(100, "...");
  }

  void clearShoppingCart() {
    int newItemCount = 0;
    int newPurchaseCost = 0;
    Map<Item, int> resetedMap = Map.from(
        state.shoppingData.selectedItems.map((key, value) => MapEntry(key, 0)));

    final ShoppingData newShoppingData = state.shoppingData.copyWith(
      overallItemCount: newItemCount,
      purchaseCost: newPurchaseCost,
      selectedItems: UnmodifiableMapView(resetedMap),
    );

    emit(state.copyWith(shoppingData: newShoppingData));
  }

  int checkout() {
    assert(state.userState != UserState.loadingUser,
        "Always wait until some kind of data is loaded before calling checkout!");
    shoppingService.sendCheckoutTransaction(
        state.shoppingData, state.user.tokenId);

    int newBalance = state.user.balance - state.shoppingData.purchaseCost;
    return newBalance;
  }

  void showCheckoutScreen(BuildContext context, int newBalance) {
    AutoRouter.of(context).push(CheckoutRoute(
        newBalance: newBalance, username: state.user.username ?? ""));

    // register a future which navigates back to the chip scan screen
    Future.delayed(const Duration(seconds: secondsToShowCheckoutScreen), () {
      logoutRoute(context);
    });
  }
}
