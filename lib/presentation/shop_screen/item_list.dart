import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/presentation/shop_screen/item_card.dart';

class ItemList extends StatelessWidget {
  final ShoppingCubit shoppingCubit;

  const ItemList({super.key, required this.shoppingCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
        bloc: shoppingCubit,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
                itemCount: state.shoppingData.selectedItems.length,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 2),
                itemBuilder: (BuildContext context, int itemCount) => ItemCard(
                      shoppingCubit: shoppingCubit,
                      item: state.shoppingData.selectedItems.keys
                          .elementAt(itemCount),
                    )),
          );
        });
  }
}
