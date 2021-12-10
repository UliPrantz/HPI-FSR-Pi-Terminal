import 'dart:collection';

import "package:bloc/bloc.dart";
import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/application/chip_scan/chip_scan_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/shopping/shopping_data.dart';
import 'package:terminal_frontend/domain/shopping/shopping_service_interface.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/domain/user/user_service_interface.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  final ShoppingServiceInterface shoppingService;
  final UserServiceInterface userService;

  ShoppingCubit({
    required this.shoppingService, 
    required this.userService,
    required ChipScanCubit chipScanCubit,
  }) : super(ShoppingState.init(tokenId: chipScanCubit.state.chipScanData.uuid)) {
    getUserBalance();
  }

  void getUserBalance() async {
    final String tokenId = state.user.tokenId;
    final Either<HttpFailure, User> result = await userService.getUserInfo(tokenId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            userState: UserState.loadingUserFailed,
            user: state.user.copyWith(tokenId: tokenId),
          )
        );
      }, 
      (user) {
        final UserState newUserState = 
          user.username == null ? 
          UserState.loadedaAnonymousUser : UserState.loadedPairedUser;

        emit(state.copyWith(
          userState: newUserState,
          user: user
        ));
      }
    );
  }

  void registerUserFromPairing(User user) {
    emit(state.copyWith(user: user));
  }

  void addItemToCart(Item item) {
    int newItemCount = state.shoppingData.overallItemCount + 1;
    int newPurchaseCost = state.shoppingData.purchaseCost + item.price;
    Map<Item, int> tmpSelectedItems = state.shoppingData.selectedItems;
    
    if (tmpSelectedItems.containsKey(item)) { //actually this should always be true!
      tmpSelectedItems[item] = tmpSelectedItems[item]! + 1;
    } 

    final ShoppingData newShoppingData = state.shoppingData.copyWith(
      overallItemCount: newItemCount,
      purchaseCost: newPurchaseCost,
      selectedItems: UnmodifiableMapView(tmpSelectedItems),
    );

    emit(state.copyWith(shoppingData: newShoppingData));
  }

  void resetShoppingCart() {
    int newItemCount = 0;
    int newPurchaseCost = 0;
    Map<Item, int> tmpSelectedItems = state.shoppingData.selectedItems;
    tmpSelectedItems.map((key, value) => MapEntry(key, 0));

    final ShoppingData newShoppingData = state.shoppingData.copyWith(
      overallItemCount: newItemCount,
      purchaseCost: newPurchaseCost,
      selectedItems: UnmodifiableMapView(tmpSelectedItems),
    );

    emit(state.copyWith(shoppingData: newShoppingData));
  }

  void checkout() {
    assert(state.userState != UserState.loadingUser, "Always wait until some kind of data is loaded before calling checkout!");
    shoppingService.sendCheckoutTransaction(state.shoppingData, state.user.tokenId);
  }
}