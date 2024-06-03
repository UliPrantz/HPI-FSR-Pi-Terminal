import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import 'package:terminal_frontend/domain/shopping/shopping_data.dart';

part 'shopping_dto.g.dart';

// Just a quick and dirty Random-String-Generator
const String _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

// declaring the default tag
const String defaultTag = "purchase";

@JsonSerializable(explicitToJson: true, createFactory: false)
class ShoppingDto {
  @JsonKey(name: 'products')
  final List<int> selectedItems;

  @JsonKey(name: 'idempotency_key')
  final String idempotencyKey;

  ShoppingDto({
    required this.selectedItems,
    required this.idempotencyKey,
  });

  /// When [isPurchase] is set to true the purchaseCost will be transformed to be negative
  factory ShoppingDto.fromDomain(
      {required ShoppingData shoppingData, bool isPurchase = true}) {
    // generate new idempotencyKey if none is set already
    String newIdempotencyKey = shoppingData.idempotencyKey;
    if (newIdempotencyKey.isEmpty) {
      newIdempotencyKey = getRandomString(20);
    }

    // make the purchaseCost negative if isPurchase
    int newPurchaseCost = shoppingData.purchaseCost;
    if (isPurchase) {
      if (!newPurchaseCost.isNegative) {
        newPurchaseCost = -newPurchaseCost;
      }
    }

    // Duplicate each key in the selectedItems map by the value

    List<int> itemIdList = shoppingData.selectedItems.entries
        .map((entry) => List.filled(entry.value, entry.key.itemId))
        .expand((element) => element)
        .toList();

    return ShoppingDto(
        selectedItems: itemIdList, idempotencyKey: newIdempotencyKey);
  }

  Map<String, dynamic> toJson() => _$ShoppingDtoToJson(this);
}
