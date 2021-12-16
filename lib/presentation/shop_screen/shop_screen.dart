import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/infrastructure/shopping/shopping_service.dart';
import 'package:terminal_frontend/infrastructure/user/user_serivce.dart';
import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/shop_screen/balance_view.dart';
import 'package:terminal_frontend/presentation/shop_screen/checkout_preview.dart';
import 'package:terminal_frontend/presentation/shop_screen/item_list.dart';

class ShopScreen extends StatelessWidget {
  final ShoppingCubit shoppingCubit;

  ShopScreen({
    Key? key, 
    required String tokenId, 
    required String tag, 
    required List<Item> items
  }) : shoppingCubit = ShoppingCubit(
    shoppingService: GetIt.I<ShoppingService>(), 
    userService: GetIt.I<UserService>(), 
    tokenId: tokenId,
    tag: tag,
    items: items,
  ),
  super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppingCubit, ShoppingState>(
      bloc: shoppingCubit,
      listener: _shoppingStateChanged,
      builder: (context, state) => Scaffold(
        appBar: FsrWalletAppBar(showLogout: true, showPairing: shoppingCubit.showPairingButton),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: ItemList(shoppingCubit: shoppingCubit,)
            ),
      
            Container(
              color: AppColors.darkGrey,
              width: 1,  
            ),
      
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 10,
                    child: BalanceView(shoppingCubit: shoppingCubit,),
                  ),
                  const Divider(color: AppColors.darkGrey,),
                  Expanded(
                    flex: 5,
                    child: CheckoutPreview(shoppingCubit: shoppingCubit,)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _shoppingStateChanged(BuildContext context, ShoppingState state) {
  
  }
}