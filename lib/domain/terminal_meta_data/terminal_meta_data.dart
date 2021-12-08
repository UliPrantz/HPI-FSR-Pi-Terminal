import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';

class TerminalMetaData with EquatableMixin {
  final String uuid;
  final String name;
  final String permission;
  final UnmodifiableListView<Item> items;

  TerminalMetaData({
    required this.uuid, 
    required this.name, 
    required this.permission, 
    required this.items
  });

  TerminalMetaData.empty() : this(
    uuid: "",
    name: "",
    permission: "",
    items: UnmodifiableListView([]),
  );

  @override
  List<Object?> get props => [uuid, name, permission, items];
}