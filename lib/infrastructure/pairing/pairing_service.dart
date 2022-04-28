import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/domain/pairing/pairing_data.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/pairing/pairing_service_interface.dart';
import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/infrastructure/core/http_client/http_client.dart';
import 'package:terminal_frontend/infrastructure/pairing/pairing_dto.dart';
import 'package:terminal_frontend/infrastructure/user/user_dto.dart';

class PairingService extends PairingServiceInterface {
  // actual endpoint: /pos/wallets/token/<TOKEN_ID> //PUT
  static const String endpoint = "/pos/wallets/token/";

  final CachedHttpClient httpClient;

  PairingService({required this.httpClient});

  @override
  Future<Either<HttpFailure, User>> pairUser(PairingData pairingData) async {
    final String uri = "$endpoint${pairingData.tokenId}";
    final String body = jsonEncode(PairingDto.fromDomain(pairingData: pairingData));

    final Response response;
    try {
      response = await httpClient.put(uri, body: body);
    } catch (e) {
      return Either.left(ConnectionFailure());
    }

    switch (response.statusCode) {
      case 400: 
        return Either.left(InvalidRequest());
      case 401: 
        return Either.left(AuthFailure());
      case 404:
        return Either.left(PairingTokenNotFound());
    }
    
    final UserDto userDto = UserDto.fromJson(response.bodyAsMap);
    return Either.right(userDto.toDomain());
  }
}