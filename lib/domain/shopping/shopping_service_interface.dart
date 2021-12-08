import 'dart:ffi';

import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/shopping/shopping_data.dart';

abstract class ShoppingServiceInterface {
  Future<Either<HttpFailure, Unit>> sendCheckoutTransaction(ShoppingData shoppingData, String tokenId);
}