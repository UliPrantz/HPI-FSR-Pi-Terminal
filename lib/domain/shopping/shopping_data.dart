import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';

class ShoppingData with EquatableMixin {
  final int purchaseCost;
  final int overallItemCount;
  final UnmodifiableMapView<Item, int> selectedItems;
  final String transactionDescription;
  final String tag;
  final String idempotencyKey;

  ShoppingData({
    required this.purchaseCost, 
    required this.overallItemCount,
    required this.selectedItems,
    required this.transactionDescription,
    required this.tag,
    required this.idempotencyKey,
  });

  factory ShoppingData.empty({
    List<Item>? items,
    String? transactionDescription,
    String? tag,
  }) {
    UnmodifiableMapView<Item, int> itemMap = UnmodifiableMapView({});
    if (items != null) {
      itemMap = UnmodifiableMapView(
        Map.fromEntries(
          items.map((item) => MapEntry(item, 0))
        )
      );
    }

    return ShoppingData(
      purchaseCost: 0, 
      overallItemCount: 0,
      selectedItems: itemMap,
      transactionDescription: transactionDescription ?? "",
      tag: tag ?? "",
      idempotencyKey: "",
    );
  }

  ShoppingData copyWith({
    int? purchaseCost,
    int? overallItemCount,
    UnmodifiableMapView<Item, int>? selectedItems,
    String? transactionDescription,
    String? tag,
    String? idempotencyKey,
  }) {
    return ShoppingData(
      purchaseCost: purchaseCost ?? this.purchaseCost,
      overallItemCount: overallItemCount ?? this.overallItemCount,
      selectedItems: selectedItems ?? this.selectedItems,
      transactionDescription:  transactionDescription ?? this.transactionDescription,
      tag: tag ?? this.tag,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    );
  }

  @override
  List<Object?> get props => [purchaseCost, overallItemCount, selectedItems, transactionDescription];
}