import 'package:equatable/equatable.dart';

class Item with EquatableMixin {
  final String name;
  final int price;
  final String uuid;

  Item({required this.name, required this.price, required this.uuid});
  Item.empty() : this(name: "", price: 0, uuid: "");

  @override
  List<Object?> get props => [name, price, uuid];
}