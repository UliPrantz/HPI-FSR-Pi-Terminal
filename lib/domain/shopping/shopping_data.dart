import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/shopping/item.dart';


class ShoppingData with EquatableMixin {
  final UnmodifiableMapView<Item, int> selectedItemsMap;
  final double purchaseCost;
  final int overallItemCount;

  ShoppingData({
    required this.selectedItemsMap, 
    required this.purchaseCost, 
    required this.overallItemCount
  });

  ShoppingData.empty() : this(
    selectedItemsMap : UnmodifiableMapView(<Item, int>{}), 
    purchaseCost: 0, 
    overallItemCount: 0
  );

  @override
  List<Object?> get props => [selectedItemsMap, purchaseCost, overallItemCount];
}