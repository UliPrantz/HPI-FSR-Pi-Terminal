import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/domain/shopping/shopping_data.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/shopping/shopping_service_interface.dart';
import 'package:terminal_frontend/infrastructure/core/http_client/http_client.dart';
import 'package:terminal_frontend/infrastructure/shopping/shopping_dto.dart';

class ShoppingService extends ShoppingServiceInterface {
  // actual endpoint: POST(method) '/pos/wallets/token/<TOKEN_ID>/transactions'
  static const String endpointStart = "/pos/wallets/token/";
  static const String endpointEnd = "/transactions/";

  final CachedHttpClient httpClient;

  ShoppingService({required this.httpClient});

  @override
  Future<Either<HttpFailure, Unit>> sendCheckoutTransaction(
      ShoppingData shoppingData, String tokenId) async {
    final String uri = "$endpointStart$tokenId$endpointEnd";
    final String body =
        jsonEncode(ShoppingDto.fromDomain(shoppingData: shoppingData));

    Response response;
    try {
      response = await httpClient.post(uri, body: body, retry: true);
    } catch (e) {
      return Either.left(ConnectionFailure());
    }

    switch (response.statusCode) {
      case 400:
        return Either.left(InvalidRequest());
      case 401:
        return Either.left(AuthFailure());
    }

    return Either.right(unit);
  }
}
