import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class CheckoutPreview extends StatelessWidget {
  final ShoppingCubit shoppingCubit;

  const CheckoutPreview({super.key, required this.shoppingCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
        bloc: shoppingCubit,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 7.5),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (state.shoppingData.overallItemCount == 0) _helperText(),
                  if (state.shoppingData.overallItemCount > 0)
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: _cartTiles(state),
                      ),
                    ),
                  const Divider(
                    height: 1,
                    color: AppColors.lightGrey,
                    indent: 12,
                    endIndent: 12,
                  ),
                  ListTile(
                    trailing: Text(
                        state.shoppingData.purchaseCost.toEuroString(),
                        style: TextStyles.boldTextMediumDark),
                    title: const Text('Total'),
                    subtitle: Text(
                        '${state.shoppingData.overallItemCount} item${state.shoppingData.overallItemCount != 1 ? 's' : ''}'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _clearButton(shoppingCubit),
                        _checkoutButton(shoppingCubit, context)
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _checkout(BuildContext context) {
    int newBalance = shoppingCubit.checkout();
    shoppingCubit.showCheckoutScreen(context, newBalance);
  }

  void _clearShoppingCart() {
    shoppingCubit.clearShoppingCart();
  }

  _cartTiles(ShoppingState state) {
    return state.shoppingData.selectedItems.entries
        .where((element) => element.value != 0)
        .map((e) => ListTile(
              title: Text(e.key.name),
              subtitle: Text("${e.value} x ${e.key.price.toEuroString()}"),
              trailing: Text(
                (e.value * e.key.price).toEuroString(),
                style: TextStyles.priceText,
              ),
            ))
        .toList();
  }

  _helperText() {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(12),
            child: const Center(
                child: Text(
              "Tap an item on the left to add it to the cart",
              textAlign: TextAlign.center,
            ))));
  }

  _clearButton(ShoppingCubit cubit) {
    return FloatingActionButton(
      onPressed: cubit.canCheckout() ? _clearShoppingCart : null,
      disabledElevation: 0,
      backgroundColor: cubit.canCheckout()
          ? AppColors.errorColor
          : AppColors.errorColor.withAlpha(80),
      child: const Icon(
        Icons.clear,
        color: AppColors.white,
      ),
    );
  }

  _checkoutButton(ShoppingCubit cubit, BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: cubit.canCheckout()
          ? AppColors.mainColor
          : AppColors.mainColor.withAlpha(80),
      onPressed: cubit.canCheckout() ? () => _checkout(context) : null,
      disabledElevation: 0,
      label: const Text(
        "Buy",
        style: TextStyles.normalTextWhite,
      ),
      icon: const Icon(
        Icons.payment,
        color: AppColors.brightTextColor,
      ),
    );
  }
}
