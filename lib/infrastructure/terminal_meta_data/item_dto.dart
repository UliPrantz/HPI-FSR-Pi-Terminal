import 'package:json_annotation/json_annotation.dart';

import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';

part 'item_dto.g.dart';

@JsonSerializable()
class ItemDto {
  @JsonKey(name: 'id')
  final String uuid;
  
  @JsonKey(name: 'friendly_name')
  final String name;

  final int price;

  ItemDto({required this.name, required this.price, required this.uuid});

  Item toDomain() => Item(
    name: name,
    price: price,
    uuid: uuid
  );

  factory ItemDto.fromJson(Map<String, dynamic> json) {
    return _$ItemDtoFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ItemDtoToJson(this);
}