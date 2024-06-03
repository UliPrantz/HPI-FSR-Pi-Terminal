import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/infrastructure/shopping/shopping_service.dart';
import 'package:terminal_frontend/infrastructure/user/user_serivce.dart';
import 'package:terminal_frontend/presentation/core/fsr_wallet_app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';
import 'package:terminal_frontend/presentation/shop_screen/balance_header.dart';
import 'package:terminal_frontend/presentation/shop_screen/checkout_preview.dart';
import 'package:terminal_frontend/presentation/shop_screen/item_list.dart';

@RoutePage()
class ShopScreen extends StatelessWidget {
  final ShoppingCubit shoppingCubit;

  ShopScreen(
      {super.key,
      required String tokenId,
      required String tag,
      required List<Item> items})
      : shoppingCubit = ShoppingCubit(
          shoppingService: GetIt.I<ShoppingService>(),
          userService: GetIt.I<UserService>(),
          tokenId: tokenId,
          tag: tag,
          items: items,
        );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      bloc: shoppingCubit,
      builder: (context, state) => Scaffold(
          appBar: FsrWalletAppBar(
              showLogout: true,
              showTerminalName: false,
              trailing: BalanceHeader(shoppingCubit: shoppingCubit)),
          body: content(state)),
    );
  }

  Widget centeredText(String text) {
    return Expanded(
      child: Center(
        child: Text(text, style: TextStyles.mainTextBigDark),
      ),
    );
  }

  Widget content(ShoppingState state) {
    switch (state.userState) {
      case UserState.loadedPairedUser:
        return Row(
          children: [
            Expanded(
                flex: 2,
                child: ItemList(
                  shoppingCubit: shoppingCubit,
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 10,
                      child: CheckoutPreview(
                        shoppingCubit: shoppingCubit,
                      )),
                ],
              ),
            )
          ],
        );
      case UserState.loadingUser:
        return centeredText("Loading user...");
      case UserState.loadingUserFailed:
        return centeredText("Failed to load user. Please try again.");
      case UserState.missingUser:
        return centeredText(
            "Transpoder needs to be paired first. A QR code should appear shortly.");
    }
  }
}
