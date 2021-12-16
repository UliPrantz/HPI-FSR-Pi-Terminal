import 'package:flutter/material.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';
import 'package:terminal_frontend/presentation/shop_screen/item_count.dart';

class ItemCard extends StatelessWidget {
  final ShoppingCubit shoppingCubit;
  final Item item;

  const ItemCard({
    Key? key, 
    required this.shoppingCubit, 
    required this.item
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onItemClicked,
        child: Card(
          child: Stack(
            children: [
              Positioned(
                top: 5.0,
                right: 5.0,
                // accessing the item map and giving default value 0
                child: ItemCount(count: shoppingCubit.state.shoppingData.selectedItems[item] ?? 0),
              ),
              
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox.square(
                      dimension: 100.0,
                      child: Placeholder(),
                    ),

                    const Padding(padding: EdgeInsets.only(bottom: 12.0)),

                    Text(
                      "${item.name}: ${item.price.toEuroString()}",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemClicked() {
    shoppingCubit.addItemToCart(item);
  }
}