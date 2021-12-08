import 'package:equatable/equatable.dart';

class ShoppingData with EquatableMixin {
  final double purchaseCost;
  final int overallItemCount;

  ShoppingData({
    required this.purchaseCost, 
    required this.overallItemCount
  });

  ShoppingData.empty() : this(
    purchaseCost: 0, 
    overallItemCount: 0
  );

  @override
  List<Object?> get props => [purchaseCost, overallItemCount];
}