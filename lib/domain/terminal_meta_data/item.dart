import 'package:equatable/equatable.dart';

class Item with EquatableMixin {
  final String name;
  final int price;
  final int itemId;

  Item({required this.name, required this.price, required this.itemId});
  Item.empty() : this(name: "", price: 0, itemId: 0);

  @override
  List<Object?> get props => [name, price, itemId];
}
