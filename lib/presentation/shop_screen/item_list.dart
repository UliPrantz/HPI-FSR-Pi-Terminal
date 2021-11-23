import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/shop_screen/item_card.dart';

class ItemList extends StatelessWidget {
  const ItemList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: 15,
        
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
        ), 
        itemBuilder: (BuildContext context, int itemCount) => ItemCard(
          itemId: itemCount
        )
      ),
    );
  }
}