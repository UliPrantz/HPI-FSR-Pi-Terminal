import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';
import 'package:terminal_frontend/presentation/shop_screen/checkout_preview_button.dart';

class CheckoutPreview extends StatelessWidget {
  final ShoppingCubit shoppingCubit;

  const CheckoutPreview({Key? key, required this.shoppingCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      bloc: shoppingCubit,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 15.0
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Summe",
                    ),
                    Text(
                      state.shoppingData.purchaseCost.toEuroString()
                    )
                  ],
                ),
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CheckoutPreviewButton(
                      callback: _clearShoppingCart, 
                      child: const Icon(
                        Icons.clear
                      )
                    ),

                    CheckoutPreviewButton(
                      callback: () => _checkout(context), 
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Checkout",
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  void _checkout(BuildContext context) {
    int newBalance = shoppingCubit.checkout();
    shoppingCubit.showCheckoutScreen(context, newBalance);
  }

  void _clearShoppingCart() {
    shoppingCubit.clearShoppingCart();
  }
}