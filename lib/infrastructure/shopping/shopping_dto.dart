import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import 'package:terminal_frontend/domain/shopping/shopping_data.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';

part 'shopping_dto.g.dart';

// Just a quick and dirty Random-String-Generator
const String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


// declaring the default tag
const String defaultTag = "purchase";

@JsonSerializable(explicitToJson: true, createFactory: false)
class ShoppingDto {
  @JsonKey(name: 'amount')
  final int purchaseCost;

  @JsonKey(ignore: true)
  final int overallItemCount;

  @JsonKey(ignore: true)
  final List<Item> selectedItems;

  @JsonKey(name: 'description')
  final String transactionDescription;

  final String tag;

  @JsonKey(name: 'idempotency_key')
  final String idempotencyKey;

  ShoppingDto({
    required this.purchaseCost, 
    required this.overallItemCount,
    required this.selectedItems,
    required this.transactionDescription,
    required this.tag,
    required this.idempotencyKey,
  });

  /// When [isPurchase] is set to true the purchaseCost will be transformed to be negative
  factory ShoppingDto.fromDomain({required ShoppingData shoppingData, bool isPurchase=true}) {
    // generate new idempotencyKey if none is set already
    String newIdempotencyKey = shoppingData.idempotencyKey;
    if (newIdempotencyKey.isEmpty) {
      newIdempotencyKey = getRandomString(20);
    }

    // set default tag is none is set already
    String newTag = shoppingData.tag;
    if (newTag.isEmpty) {
      newTag = defaultTag;
    }

    // make the purchaseCost negative if isPurchase
    int newPurchaseCost = shoppingData.purchaseCost;
    if (isPurchase) {
      if (!newPurchaseCost.isNegative) {
        newPurchaseCost = -newPurchaseCost;
      }
    }

    return ShoppingDto(
      purchaseCost: newPurchaseCost, 
      overallItemCount: shoppingData.overallItemCount, 
      selectedItems: shoppingData.selectedItems.keys.toList(), 
      transactionDescription: shoppingData.transactionDescription, 
      tag: newTag, 
      idempotencyKey: newIdempotencyKey
    );
  }

  Map<String, dynamic> toJson() => _$ShoppingDtoToJson(this);
}