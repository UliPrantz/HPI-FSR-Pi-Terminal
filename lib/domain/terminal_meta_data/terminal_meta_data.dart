import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';

class TerminalMetaData with EquatableMixin {
  final UnmodifiableListView<Item> items;

  TerminalMetaData({required this.items});

  TerminalMetaData.empty()
      : this(
          items: UnmodifiableListView([]),
        );

  @override
  List<Object?> get props => [items];
}
