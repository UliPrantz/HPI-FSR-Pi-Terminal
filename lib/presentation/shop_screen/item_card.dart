import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final int itemId;

  const ItemCard({ Key? key, required this.itemId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Center(
          child: Text(
            "The $itemId Item",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}