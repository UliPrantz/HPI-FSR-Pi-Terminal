import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'package:terminal_frontend/infrastructure/terminal_meta_data/item_dto.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';

part 'terminal_meta_data_dto.g.dart';

@JsonSerializable()
class TerminalMetaDataDto {
  @JsonKey(name: 'id')
  final String uuid;

  @JsonKey(name: 'friendly_name')
  final String name;

  @JsonKey(name: 'permission')
  final String permission;

  @JsonKey(name: 'products')
  final List<ItemDto> itemDtos;

  TerminalMetaDataDto({
    required this.uuid, 
    required this.name, 
    required this.permission,
    required this.itemDtos,
  });

  TerminalMetaData toDomain() => TerminalMetaData(
    name: name,
    uuid: uuid,
    permission: permission,
    items: UnmodifiableListView(itemDtos.map((itemDto) => itemDto.toDomain())),
  );

  factory TerminalMetaDataDto.fromJson(Map<String, dynamic> json) {
    // remove the data wrapper
    json = json['data'];
    return _$TerminalMetaDataDtoFromJson(json);
  }
  Map<String, dynamic> toJson() => _$TerminalMetaDataDtoToJson(this);
}