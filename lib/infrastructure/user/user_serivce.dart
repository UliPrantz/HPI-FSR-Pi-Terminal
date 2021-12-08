import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/user/user_service_interface.dart';
import 'package:terminal_frontend/infrastructure/core/http_client/http_client.dart';
import 'package:terminal_frontend/infrastructure/user/user_dto.dart';

class UserService extends UserServiceInterface {
  // actual endpoint: /pos/wallets/token/<TOKEN_ID>
  static const String endpoint = "/pos/wallets/token/"; //GET

  final CachedHttpClient httpClient;

  UserService({required this.httpClient});

  @override
  Future<Either<HttpFailure, User>> getUserInfo(String tokenId) async {
    final String uri = "$endpoint$tokenId";

    Response response;
    try {
      response = await httpClient.get(uri);
    } catch (e) {
      return Either.left(ConnectionFailure());
    }

    switch (response.statusCode) {
      case 401:
        return Either.left(AuthFailure());
      case 404:
        return Either.left(UserNotFound());
    }

    final UserDto userDto = UserDto.fromJson(response.bodyAsMap);
    return Either.right(userDto.toDomain());
  }
}