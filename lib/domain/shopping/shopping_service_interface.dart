import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/domain/shopping/shopping_data.dart';

abstract class ShoppingServiceInterface {
  Future<Either<Failure, ShoppingData>> getShoppingData();
  Future<Either<Failure, Union>> sendCheckoutTransaction();
}