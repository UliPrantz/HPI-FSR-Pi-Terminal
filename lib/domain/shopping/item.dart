import 'package:equatable/equatable.dart';

class Item with EquatableMixin {
  final String name;
  final double price;
  final String uuid;
  final int selectionCount;

  Item({required this.name, required this.price, required this.uuid, required this.selectionCount});
  Item.empty() : this(name: "", price: 0, uuid: "", selectionCount : 0);

  @override
  List<Object?> get props => [name, uuid, selectionCount];
}