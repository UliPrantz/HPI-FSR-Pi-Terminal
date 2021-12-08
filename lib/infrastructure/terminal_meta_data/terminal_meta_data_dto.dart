import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'package:terminal_frontend/infrastructure/terminal_meta_data/item_dto.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';

part 'terminal_meta_data_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class TerminalMetaDataDto {
  final String uuid;
  final String name;
  final String permission;
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